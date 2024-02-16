/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/image.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/me/points_mall_details.dart';
import 'package:sufenbao/me/styles.dart';

import '../service.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../widget/rise_number_text.dart';

///积分商城
class PointsMallPage extends StatefulWidget {

  final Map data;
  const PointsMallPage(this.data, {Key? key,}) : super(key: key);

  @override
  _PointsMallPageState createState() => _PointsMallPageState();
}

class _PointsMallPageState extends State<PointsMallPage>
    with TickerProviderStateMixin {
  late TabController tabCon;
  int index = 0;
  List tabList = [];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await http
        .get(Uri.parse(BService.getMePointsMallUrl(page)))
        .catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) listDm.addList(jsonDecode(res.body)['data'], isRef, 100);
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context, title: '积分商城',
          widgetColor: Colors.black, leftIcon: Icon(Icons.arrow_back_ios)),
      body: MyCustomScroll(
              isGengduo: false,
              isShuaxin: true,
              onRefresh: () => this.getListData(isRef: true),
              onLoading: (p) => this.getListData(page: p),
              itemModel: listDm,
              refHeader: buildClassicHeader(color: Colors.grey),
              refFooter: buildCustomFooter(color: Colors.grey),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              headers: headers,
              maskHeight: 40 + pmPadd.top,
              itemPadding: EdgeInsets.all(16),
              itemModelBuilder: (i, v) {
                return PWidget.container(
                    Global.openFadeContainer(
                        createItem(i, v), PointsMallDetail(v)),
                    [null, null, Colors.white],
                    {
                      'crr': 8,
                      'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 10)
                    },
                );
              },
            ),
    );
  }
  List<Widget> get headers {
    num integral = widget.data['integral'];
    List<Widget> widgets = [];
    widgets.add(PWidget.container(
      PWidget.column([
        PWidget.row([
          PWidget.column([
            PWidget.text('当前积分', [Colors.white]),
            PWidget.boxh(5),
            RiseNumberText(integral, fixed:0, style: TextStyles.ts(fontSize: 18)),
          ]),
          PWidget.spacer(),
          PWidget.container(PWidget.text('积分明细', [Colours.app_main]),
            [null, null, Colors.white],
            {'bd': PFun.bdAllLg(Colors.white), 'pd': PFun.lg(4, 4, 8, 8),
              'mg': PFun.lg(4, 4, 8, 8),'br': PFun.lg(16, 16, 16, 16),'fun':(){
              Navigator.pushNamed(context, '/integralList', arguments: widget.data);
            }},

          )
        ],{'pd':[0,0,10,10]}),

      ]),
      [null, null, Colors.transparent],
      {'pd': PFun.lg(30, 15, 8, 8),
        'br': PFun.lg(16, 16, 16, 16)},));
    widgets.add(PWidget.boxh(10));
    return [PWidget.container(PWidget.column(
        widgets
    ),
        [null, 120, Colours.app_main],
        {'pd':[0, 0, 20, 20]})];
  }
  Widget createItem(i, v) {
    var img = v['image'];
    var xiaoliangStr = BService.formatNum(v['sales'] as int);
    var price = double.parse(v['price']).toInt();
    return PWidget.container(
      PWidget.column([
        PWidget.container(WrapperImage(url: '$img'), ),
        if (v['storeName'] != '')
          PWidget.text(
              '${v['storeName']}',
              [Colors.black.withOpacity(0.75), 14, true],
              {'isOf': false,}),
        PWidget.boxh(8),
        PWidget.row([
          PWidget.text('', [], {}, [
            PWidget.textIs('积分', [Colours.app_main, 12]),
            PWidget.textIs('$price', [Colours.app_main, 20, true]),
          ]),
          PWidget.spacer(),
          PWidget.text('已兑$xiaoliangStr', [Colors.black54, 12]),
        ]),
      ]),
      [null, null, Colors.white],
      {
        'pd': 8,
      },
    );
  }
}
