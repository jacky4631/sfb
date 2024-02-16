/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/me/styles.dart';
import 'package:sufenbao/service.dart';

import '../../util/colors.dart';
import '../../util/paixs_fun.dart';
import '../../widget/rise_number_text.dart';
import '../../widget/tab_widget.dart';

//我的收益
class FeePage extends StatefulWidget {
  final Map data;
  const FeePage(this.data, {Key? key,}) : super(key: key);

  @override
  _FeePageState createState() => _FeePageState();
}

class _FeePageState extends State<FeePage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initData();
  }

  var tabDm = DataModel();

  ///初始化函数
  Future<int> initData() async {
    Map user = widget.data['user'];
    tabDm.addList([
      {'name':'今日', 'type':1, 'user': user},
      {'name':'近7日', 'type':6, 'user': user},
      {'name':'本月', 'type':3, 'user': user},
      {'name':'上月', 'type':4, 'user': user}], true, 0);

    return getTime();
  }

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
        AnimatedSwitchBuilder(
          value: tabDm,
          errorOnTap: () => this.initData(),
          initialState: buildLoad(color: Colors.white),
          listBuilder: (list, _, __) {
            var tabList = list.map<String>((m) => (m! as Map)['name']).toList();

            return TabWidget(
              color: Colours.app_main,
              unselectedColor: Colors.black.withOpacity(0.5),
              indicatorColor: Colours.jd_main,
              fontSize: 15,
              tabList: tabList,
              indicatorWeight: 2,
              tabPage: List.generate(list.length, (i) {
                Map data = list[i];
                data['cid'] = widget.data['cid'];
                return FeeDetailPage(list[i]);
              }),
            );
          },
        ),[null, 1000, Colors.white]);

  }
}

class FeeDetailPage extends StatefulWidget {
  final Map data;
  const FeeDetailPage(this.data, {Key? key,}) : super(key: key);

  @override
  _FeeDetailPageState createState() => _FeeDetailPageState();
}

class _FeeDetailPageState extends State<FeeDetailPage> {
  static const num defC = 0;
  static const String defP = '￥0';
  static const String keyC = 'count';
  static const String keyF = 'fee';
  num totalCount = defC;
  String totalFee = '￥0';
  num upCount = defC;
  String upFee = defP;
  num tbCount = defC;
  String tbFee = defP;
  num jdCount = defC;
  String jdFee = defP;
  num pddCount = defC;
  String pddFee = defP;
  num dyCount = defC;
  String dyFee = defP;
  num vipCount = defC;
  String vipFee = defP;
  @override
  void initState() {
    super.initState();
    initData();
  }
  List<DataRow> rows = [];
  var tabDm = DataModel();

  ///初始化函数
  Future initData() async {
    initFeeDetail(widget.data['type'], widget.data['cid']);
  }

  onclick(page, pageTwo, platform) {
    //如果是已结算，打开结算列表
    if(widget.data['cid'] == 6) {
      Navigator.pushNamed(context, '/moneyList', arguments: {'platform': platform});
      return;
    }

    Map vdData = widget.data['user'];
    if(vdData != null) {
      vdData['page'] = page;
      vdData['pageTwo'] = pageTwo;
    }
    Navigator.pushNamed(context, '/orderList', arguments: vdData);
  }
  void initFeeDetail(type, cid) async {
    num uid = 0;
    if(widget.data['user'] != null && widget.data['user']['uid'] != null) {
      uid = widget.data['user']['uid'];
    }
    Map detail = await BService.userFeeDetail(type: type, uid: uid, cid: cid);

    Map tb = detail['tb']??{};
    Map jd = detail['jd']??{};
    Map pdd = detail['pdd']??{};
    Map dy = detail['dy']??{};
    Map vip = detail['vip']??{};
    Map up = detail['up']??{};

    upCount = up[keyC]??defC;
    upFee = up[keyF]??defP;
    tbCount = tb[keyC]??defC;
    tbFee = tb[keyF]??defP;
    jdCount = jd[keyC]??defC;
    jdFee = jd[keyF]??defP;
    pddCount = pdd[keyC]??defC;
    pddFee = pdd[keyF]??defP;
    dyCount = dy[keyC]??defC;
    dyFee = dy[keyF]??defP;
    vipCount = vip[keyC]??defC;
    vipFee = vip[keyF]??defP;

    Color chColor = Colors.black;
    Color sColor = Colors.grey[600]!;
    double ts = 14;
    bool clickable = (widget.data['user'] == null || widget.data['user']['clickable'] == null) ? false : widget.data['user']['clickable'];
    //总览不允许查看
    if(cid == 1) {
      clickable = false;
    }
    Widget arrowWidget = clickable ? PWidget.icon(Icons.arrow_forward_ios, [sColor, ts]) : SizedBox();
    bool showUpgrade = (cid == 2 || cid == 3 || cid == 7) ? false : true;

    int pageOne = cid - 1;
    if(cid == 3) {
      pageOne = 1;
    } else if(cid == 4 || cid == 5) {
      pageOne = cid - 1;
    }  else if (cid == 7) {
      pageOne = 2;
    } else if (cid > 1) {
      pageOne = cid -2;
    }
    rows = [
      if(showUpgrade)
        DataRow2(cells: [
          DataCell(PWidget.text('加盟星选', [chColor, ts])),
          DataCell(PWidget.text(upCount, [sColor, ts])),
          DataCell(PWidget.text(upFee, [sColor, ts])),
          DataCell(arrowWidget)
        ],onTap: clickable ? (){
          if(cid == 6) {
            onclick(pageOne, 6, 'up');
          } else {
            Navigator.pushNamed(context, '/moneyList', arguments: {'type':'upgrade','title':'加盟星选明细'});
          }
        } : null),
      DataRow2(cells: [
        DataCell(PWidget.text('淘宝', [chColor, ts])),
        DataCell(PWidget.text(tbCount, [sColor, ts])),
        DataCell(SingleChildScrollView(scrollDirection: Axis.horizontal,child: PWidget.text(tbFee, [sColor, ts]))),
        DataCell(arrowWidget)
      ],onTap: clickable ? (){
        onclick(pageOne, 0, 'tb');
      } : null),
      DataRow2(cells: [
        DataCell(PWidget.text('京东', [chColor, ts])),
        DataCell(PWidget.text(jdCount, [sColor, ts])),
        DataCell(SingleChildScrollView(scrollDirection: Axis.horizontal,child: PWidget.text(jdFee, [sColor, ts]))),
        DataCell(arrowWidget)
      ],onTap: clickable ? (){
        onclick(pageOne, 1, 'jd');
      } : null),
      DataRow2(cells: [
        DataCell(PWidget.text('拼多多', [chColor, ts])),
        DataCell(PWidget.text(pddCount, [sColor, ts])),
        DataCell(SingleChildScrollView(scrollDirection: Axis.horizontal,child: PWidget.text(pddFee, [sColor, ts]))),
        DataCell(arrowWidget)
      ],onTap: clickable ? (){
        onclick(pageOne, 2, 'pdd');
      } : null),
      DataRow2(cells: [
        DataCell(PWidget.text('抖音', [chColor, ts])),
        DataCell(PWidget.text(dyCount, [sColor, ts])),
        DataCell(SingleChildScrollView(scrollDirection: Axis.horizontal,child: PWidget.text(dyFee, [sColor, ts]))),
        DataCell(arrowWidget)
      ],onTap: clickable ? (){
        onclick(pageOne, 3, 'dy');
      } : null),
      DataRow2(cells: [
        DataCell(PWidget.text('唯品会', [chColor, ts])),
        DataCell(PWidget.text(vipCount, [sColor, ts])),
        DataCell(SingleChildScrollView(scrollDirection: Axis.horizontal,child: PWidget.text(vipFee, [sColor, ts]))),
        DataCell(arrowWidget)
      ],onTap: clickable ? (){
        onclick(pageOne, 4, 'vip');
      } : null),
    ];
    double min = 0;
    double max = 0;
    if(tb != null) {
      totalCount += tbCount;
      List<String> feeSplit = splitFee(tbFee);
      min += double.parse(feeSplit[0]);
      if(feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if(jd != null) {
      totalCount += jdCount;
      List<String> feeSplit = splitFee(jdFee);
      min += double.parse(feeSplit[0]);
      if(feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if(pdd != null) {
      totalCount += pddCount;
      List<String> feeSplit = splitFee(pddFee);
      min += double.parse(feeSplit[0]);
      if(feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if(dy != null) {
      totalCount += dyCount;
      List<String> feeSplit = splitFee(dyFee);
      min += double.parse(feeSplit[0]);
      if(feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if(vip != null) {
      totalCount += vipCount;
      List<String> feeSplit = splitFee(vipFee);
      min += double.parse(feeSplit[0]);
      if(feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if(showUpgrade && up != null) {
      totalCount += upCount;
      List<String> feeSplit = splitFee(upFee);
      if(feeSplit.length > 1) {
        min += double.parse(feeSplit[0]);
        max += double.parse(feeSplit[1]);
      } else {
        min += double.parse(feeSplit[0]);
        max += double.parse(feeSplit[0]);
      }
    }
    if(cid == 6){
      totalFee = '￥${min.toStringAsFixed(2)}';
    }else if(max == 0) {
      totalFee = '￥0';
    }else {
      totalFee = '￥${min.toStringAsFixed(2)}-￥${max.toStringAsFixed(2)}';
    }

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return createMyItems();
  }

  List<String> splitFee(String fee) {
    return fee.replaceAll('￥', '').split('-');
  }

  Widget createMyItems() {
    List<Widget> widgets = <Widget>[
      PWidget.container(
          PWidget.row([
            PWidget.text('预估收入存在一定延时，以订单中心为准！',[Colors.grey, 13]),
          ],'251'),[null, null, Colors.white],{'pd':[10,0,10,10],
        'mg': PFun.lg(20, 0, 10, 10),'br': [20, 20, 0, 0],}
      ),
      PWidget.container(
          PWidget.row([
            PWidget.column([
              PWidget.text('总销售笔数',[Colors.black, 15]),
              PWidget.boxh(5),
              PWidget.text('$totalCount',[Colors.grey[600], 15]),
            ],'221'),
            PWidget.column([
              PWidget.text('总${widget.data['cid'] == 6 ? '结算' : '预估'}收入',[Colors.black, 15]),
              PWidget.boxh(5),
              PWidget.text(totalFee,[Colors.grey[600], 15]),
            ],'221'),
          ],'251'),[null, null, Colors.white],{'pd':[20,20,0,0],
        'mg': PFun.lg(0, 10, 10, 10),'br': [0, 0, 20, 20],}
      ),
      PWidget.container(
          DataTable2(
              columnSpacing: 1,
              horizontalMargin: 16,
              columns: [
                DataColumn2(
                  label: PWidget.text('渠道',[Colors.grey[600], 14]),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: PWidget.text('销售笔数',[Colors.grey[600], 14]),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: PWidget.text('${widget.data['cid'] == 6 ? '结算' : '预估'}收入',[Colors.grey[600], 14]),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(''),
                  fixedWidth: 1,
                    numeric: true
                ),
              ],
              rows: rows),

          [null, 500, Colors.white],
          {'pd':[10,10,0,0], 'mg': PFun.lg(10, 10, 10, 10),'br': 20,}
      )

    ];
    return PWidget.container(
        PWidget.column(widgets),
        [null, null, Color(0xffF4F5F6)], {
    });
  }
  createIntegralPanel() {
    List<Widget> widgets = [];
    widgets.add(PWidget.container(
      PWidget.column([
        PWidget.row([
          PWidget.column([
            PWidget.text('账户余额 (元)', [Colors.white]),
            PWidget.boxh(5),
            RiseNumberText(widget.data['nowMoney'], prefixTxt: '￥', style: TextStyles.ts(fontSize: 18)),
          ]),
          PWidget.spacer(),
          PWidget.container(PWidget.text('立即提现', [Colours.app_main]),
            [null, null, Colors.white],
            {'bd': PFun.bdAllLg(Colors.white), 'pd': PFun.lg(4, 4, 8, 8),
              'mg': PFun.lg(4, 4, 8, 8),'br': PFun.lg(16, 16, 16, 16),'fun':(){
              Navigator.pushNamed(context, '/cashIndex', arguments: widget.data);
            }},

          )
        ],{'pd':[0,0,10,10]}),

      ]),
      [null, null, Colors.transparent],
      {'pd': PFun.lg(30, 15, 8, 8),
        'br': PFun.lg(16, 16, 16, 16)},));
    widgets.add(PWidget.boxh(10));
    return PWidget.container(PWidget.column(
        widgets
    ),
        [null, 120, Colours.app_main],
        {'pd':[0, 0, 10, 10]});
  }
}

