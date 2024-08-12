/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/me/fee/fee_page.dart';
import 'package:sufenbao/util/global.dart';

import '../../dialog/income_rule_dialog.dart';
import '../../util/colors.dart';
import '../../util/paixs_fun.dart';
import '../../widget/order_tab_widget.dart';
import '../../widget/rise_number_text.dart';
import '../styles.dart';

//订单明细
class FeeTabPage extends StatefulWidget {
  final Map data;
  const FeeTabPage(this.data, {Key? key,}) : super(key: key);

  @override
  _FeeTabPageState createState() => _FeeTabPageState();
}

class _FeeTabPageState extends State<FeeTabPage> {
  @override
  void initState() {
    mockDetail();
    initData();
    super.initState();
  }

  ///tab数据
  var tabDm = DataModel();
  ///初始化函数
  Future<int> initData() async {
    List list = [];
    list.addAll([
      {'title':'总览','cid': 1},
      {'title':'自购','cid': 2},
      {'title':'热度订单','cid': 7}
    ]);
    if(Global.appInfo.spreadLevel == 3) {
      list.add({'title':'金客','cid': 4});
      list.add({'title':'银客','cid': 5});
    } else {
      list.add({'title':'用户','cid': 4});
    }
    list.add({'title':'已结算','cid': 6});
    tabDm.addList(list, true, 0);

    setState(() {});
    return tabDm.flag;
  }
  var mockDm = DataModel();
  Future<int> mockDetail() async {

    mockDm.addList([{'name':'1'}], true, 20);
    setState(() {});
    return mockDm.flag;
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity], {'gd': PFun.cl2crGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            bgColor: Colours.app_main,
            brightness: Brightness.light,
            appBar: buildTitle(context, title: widget.data['showName']!=null ? '${widget.data['showName']}的收益'
                : '我的收益', widgetColor: Colors.white,
                leftIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
                rightWidget: PWidget.textNormal('收益规则',[Colors.white], {'pd':[0,0,0,8]}), rightCallback: (){
                  showGeneralDialog(
                      context: context,
                      barrierDismissible:false,
                      barrierLabel: '',
                      transitionDuration: Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
                        return Scaffold(backgroundColor: Colors.transparent, body:IncomeRuleDialog(
                            {}, (){

                        }));
                      });
                }),
            body: createGoodsList(),
          ),
        ],
      ),
    );
  }

  Widget createGoodsList() {
    return MyCustomScroll(
      isGengduo: false,
      isShuaxin: false,
      onRefresh: () => this.mockDetail(),
      refHeader: buildClassicHeader(color: Colors.white),
      refFooter: buildCustomFooter(color: Colors.grey),
      itemModel: mockDm,
      headers: [
        if(widget.data['showName'] ==null)
          createIntegralPanel(),
      ],
      itemModelBuilder: (i, v) {
        return PWidget.container(
            AnimatedSwitchBuilder(
              value: tabDm,
              errorOnTap: () => this.initData(),
              initialState: buildLoad(color: Colors.white),
              listBuilder: (list, _, __) {
                var tabList = list.map<Map>((m) => m).toList();
                return OrderTabWidget(
                  color: Colours.app_main,
                  unselectedColor: Colors.black.withOpacity(0.5),
                  fontSize: 16,
                  tabList: tabList,
                  padding: EdgeInsets.only(bottom: 8),
                  indicatorColor: Colours.jd_main,
                  indicatorWeight: 2,
                  tabPage: List.generate(list.length, (i) {

                    Map data = tabDm.list[i];
                    data['user'] = widget.data;
                    return FeePage(data);
                  }),
                );
              },
            ),[null, 1000, Colors.white],{'pd':[10, 0,0,0]});
      },
    );


  }
  createIntegralPanel() {
    List<Widget> widgets = [];
    widgets.add(PWidget.container(
      PWidget.column([
        PWidget.row([
          PWidget.column([
            PWidget.text('余额 (元)', [Colors.white]),
            PWidget.boxh(5),
            RiseNumberText(Global.userinfo!.nowMoney + Global.userinfo!.unlockMoney, prefixTxt: '￥', style: TextStyles.ts(fontSize: 18)),
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
        {'pd':[0, 0, 20, 20]});
  }
}