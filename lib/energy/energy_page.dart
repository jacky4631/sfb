/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/energy/wave_view.dart';
import 'package:sufenbao/me/styles.dart';

import '../service.dart';
import '../util/colors.dart';
import '../util/login_util.dart';
import '../util/paixs_fun.dart';
import '../widget/rise_number_text.dart';

///热度页面
class EnergyPage extends StatefulWidget {

  final Map data;
  const EnergyPage(this.data, {Key? key,}) : super(key: key);

  @override
  _EnergyPageState createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage>
    with TickerProviderStateMixin {
  late TabController tabCon;
  int index = 0;
  List tabList = [];
  Map userEnergy = {};
  bool loadingEnergy = true;
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future<int> initData() async {
    await getListData(isRef: true);
    await getEnergy();

    return 1333;
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    listDm.addList([{"test":1}], isRef, 1);
    setState(() {});
    return getTime();
  }
  Future getEnergy() async {
    userEnergy = await BService.getEnergyDetail();
    setState(() {
      loadingEnergy = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context, title: '星选会员',
          widgetColor: Colors.black, leftIcon: Icon(Icons.arrow_back_ios)),
      body: MyCustomScroll(
              isGengduo: false,
              isShuaxin: true,
              onRefresh: () => this.initData(),
              onLoading: (p) => this.getListData(page: p),
              itemModel: listDm,
              refHeader: buildClassicHeader(color: Colors.grey),
              refFooter: buildCustomFooter(color: Colors.grey),
              crossAxisCount: 1,
              crossAxisSpacing: 12,
              headers: headers,
              maskHeight: 40 + pmPadd.top,
              itemPadding: EdgeInsets.all(16),
              itemModelBuilder: (i, v) {
                return SizedBox();
              },
            ),
    );
  }
  List<Widget> get headers {
    return [
      PWidget.container(
        PWidget.column(
            [
              PWidget.row([
                PWidget.column([
                  PWidget.text('总热度', [Colors.white]),
                  PWidget.boxh(5),
                  loadingEnergy?SizedBox():RiseNumberText(userEnergy['totalEnergy'], fixed:1,
                      style: TextStyles.ts(fontSize: 24)),
                ]),
                PWidget.spacer(),
                PWidget.container(PWidget.text('热度明细', [Colours.app_main]),
                  [null, null, Colors.white],
                  {'bd': PFun.bdAllLg(Colors.white), 'pd': PFun.lg(4, 4, 8, 8),
                    'mg': PFun.lg(4, 4, 8, 8),'br': PFun.lg(16, 16, 16, 16),'fun':(){
                    Navigator.pushNamed(context, '/energyList', arguments: widget.data);
                  }},

                )
              ],{'pd':[20,0,10,10]}
              ),

              PWidget.container(
                  PWidget.column([
                    PWidget.row([
                      PWidget.column([
                        PWidget.text('淘', [Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text('京', [Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text('多', [Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text('抖', [Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text('唯', [Colors.white,14]),
                      ]),
                      PWidget.boxw(20),
                      PWidget.column([
                        PWidget.text(loadingEnergy?'赠送: ':'赠送: ${userEnergy['tbEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'赠送: ':'赠送: ${userEnergy['jdEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'赠送: ':'赠送: ${userEnergy['pddEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'赠送: ':'赠送: ${userEnergy['dyEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'赠送: ':'赠送: ${userEnergy['vipEnergy']}',[Colors.white,14]),
                      ]),
                      PWidget.boxw(10),
                      PWidget.column([
                        PWidget.text(loadingEnergy?'推广: ':'推广: ${userEnergy['tbTuiEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'推广: ':'推广: ${userEnergy['jdTuiEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'推广: ':'推广: ${userEnergy['pddTuiEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'推广: ':'推广: ${userEnergy['dyTuiEnergy']}',[Colors.white,14]),
                        PWidget.boxh(8),
                        PWidget.text(loadingEnergy?'推广: ':'推广: ${userEnergy['vipTuiEnergy']}',[Colors.white,14]),
                      ]),
                    ],),

                  ]),
                  [null, null, Colors.transparent], {'pd': PFun.lg(10, 15, 8, 8), 'br': PFun.lg(16, 16, 16, 16)}
              ),
              loadingEnergy?SizedBox():PWidget.container(
                  PWidget.row([
                    createEnergyChangeWidget('tbDay', 'tb'),

                    PWidget.boxw(20),
                    createEnergyChangeWidget('jdDay', 'jd'),
                    PWidget.boxw(20),
                    createEnergyChangeWidget('pddDay', 'pdd'),
                    PWidget.boxw(20),
                    createEnergyChangeWidget('dyDay', 'dy'),
                    PWidget.boxw(20),
                    createEnergyChangeWidget('vipDay', 'vip'),

                  ],
                    '001',
                    {'fill': true},),
                  [null, null, Colours.energy_bg], {'pd': PFun.lg(10, 15, 8, 8), 'br': PFun.lg(16, 16, 16, 16)}
              ),
              PWidget.boxh(10),
              PWidget.container(PWidget.column([
                PWidget.text(
                  '热度规则',
                  [Colors.white, 16, true],
                ),
                PWidget.row([
                  PWidget.text('\t1.赠送热度来源：加盟星选会员赠送，', [Colors.white, 14], {'max': 2}),
                  PWidget.text('去加盟>', [Colors.white, 14], {'max': 2,
                      'td': TextDecoration.underline,'fun':(){
                        onTapLogin(context, '/tabVip', args: {'index': 0});
                      }}),
                ]),
                PWidget.text('\t2.推广热度来源：自购拆红包、用户拆红包、用户加盟星选会员；', [Colors.white, 14], {'max': 2}),
                PWidget.text('\t3.热度作用：获取平台用户下单后拆红包提成；', [Colors.white, 14], {'max': 2}),
                PWidget.text('\t4.点击+-设置每日消耗的热度；', [Colors.white, 14], {'max': 2}),
                PWidget.text('\t5.热度每日消耗可设置范围50-500；', [Colors.white, 14], {'max': 2}),
                PWidget.text('\t2.热度消耗越大当日热度订单越多；', [Colors.white, 14], {'max': 2}),
                PWidget.text('\t3.热度不足时，当日不消耗；', [Colors.white, 14], {'max': 2}),
              ])),
            ]
        ), [null, 700, Colours.app_main], {'pd':[0, 0, 20, 20]}
      )
    ];
  }
  Widget createEnergyChangeWidget(key, platform) {
    return createDayWidget(userEnergy[key], platform, (){
      addEnergyFun(key, platform);
    }, () {
      removeEnergyFun(key, platform);
    });
  }

  Widget createDayWidget(energy, platform, Function addF, Function removeF) {
    return PWidget.column([
      PWidget.icon(Icons.add, [Colors.black, 24], {'fun': addF}),
      PWidget.boxh(8),
      PWidget.container(WaveView(percentageValue: energy/5,txt: '店',platform: platform),[50,160]),
      PWidget.boxh(8),
      PWidget.icon(Icons.remove, {'fun': removeF}),
    ],'221');
  }
  Future addEnergyFun(key, platform) async {
      num tbDay = userEnergy[key];
      if(tbDay + userEnergy['defaultDayEnergy'] > userEnergy['dayEnergyMax']) {
        ToastUtils.showToast('单日消耗热度不能大于${userEnergy['dayEnergyMax']}');
        return;
      }
      userEnergy = await BService.setEnergy(tbDay + userEnergy['defaultDayEnergy'], platform);
      setState(() {

      });
  }

  Future removeEnergyFun(key, platform) async {
    num tbDay = userEnergy[key];
    if(tbDay - userEnergy['defaultDayEnergy'] < userEnergy['defaultDayEnergy']) {
      ToastUtils.showToast('单日消耗热度不能小于${userEnergy['defaultDayEnergy']}');
      return;
    }
    userEnergy = await BService.setEnergy(tbDay - userEnergy['defaultDayEnergy'], platform);
    setState(() {

    });
  }
}
