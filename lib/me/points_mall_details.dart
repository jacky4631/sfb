/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/me/points_detail_img_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../widget/custom_button.dart';
import '../widget/detail_lunbo_widget.dart';
import '../util/paixs_fun.dart';

class ValueChange extends ValueNotifier {
  ValueChange() : super(null);
  var value = 0.0;
  var tabIndex = 0;
  void changeValue(v) {
    value = v;
    notifyListeners();
  }

  void changeTabIndex(v) {
    tabIndex = v;
    notifyListeners();
  }
}

ValueChange valueChange = ValueChange();

///产品详情
class PointsMallDetail extends StatefulWidget {
  final Map data;
  const PointsMallDetail(this.data, {Key? key}) : super(key: key);
  @override
  _PointsMallDetailState createState() => _PointsMallDetailState();
}

class _PointsMallDetailState extends State<PointsMallDetail> {
  ScrollController controller = ScrollController();
  List tabList = ['商品', '详情'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    valueChange.changeTabIndex(0);
    this.controllerListener();
    await this.getDetailData();
  }

  ///监听列表滚动
  void controllerListener() {
    controller.addListener(() {
      valueChange.changeValue(controller.offset);
      var key1H = (key1.currentContext?.size?.height ?? 0.0);
      var key2H = (key2.currentContext?.size?.height ?? 0.0);
      if (controller.offset > key1H + key2H - 56 - pmPadd.top) {
        valueChange.changeTabIndex(2);
      } else if (controller.offset > key1H - 56 - pmPadd.top) {
        valueChange.changeTabIndex(1);
      } else {
        valueChange.changeTabIndex(0);
      }
    });
  }

  ///详情数据
  var detailDm = DataModel<Map>(object: {'storeInfo':{'price':0}});
  Future<int> getDetailData() async {
    var res = await http.get(Uri.parse(BService.getMePointsMallDetailUrl(widget.data['id']))).catchError((v) {
      detailDm.toError('网络异常');
    });
    if (res != null) detailDm.addObject(jsonDecode(res.body)['data']);

    setState(() {});
    return detailDm.flag;
  }
  var listSimilerGoodsByOpenDm = DataModel();
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      // brightness: Brightness.light,
      bgColor: Color(0xffF3F3F3),
      body: Stack(children: [
        MyCustomScroll(
          isGengduo: false,
          isShuaxin: false,
          headers: headers,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          controller: controller,
          itemPadding: EdgeInsets.all(16).copyWith(bottom: 72),
          itemModel: listSimilerGoodsByOpenDm, itemModelBuilder: (i, v) {
          return SizedBox();
        },
        ),
        titleBarView(),
        btmBarView(),
      ]),
    );
  }

  ///底部操作栏
  Widget btmBarView() {
    return PWidget.positioned(
      PWidget.container(
        CustomButton(
          bgColor: Colours.app_main,
          showIcon: false,
          textColor: Colors.white,
          text: '立即兑换',
          onPressed: () {
            if(Global.login) {
              BService.integralConfirm(context, '${detailDm.object!['storeInfo']['id']}').then((value) => {
                if(value['success']) {
                  //积分足够 todo跳转订单页面
                  Navigator.pushNamed(context, '/createOrder', arguments: detailDm.object?['storeInfo'])
                } else {
                  ToastUtils.showToast('积分不足，去购物获得积分吧')
                }
              });

            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
        ),
        [null, null, Colors.white],
        {'pd': [8,MediaQuery.of(context).padding.bottom+8,8,8], },
      ),
      [null, detailDm.object!.isEmpty ? -64 : 0, 0, 0],
    );
  }
  Widget btmBtnView(name, icon, fun) {
    return PWidget.column(
      [PWidget.icon(icon ?? Icons.star_rate_rounded, PFun.lg1(Colors.black45)), PWidget.boxh(4), PWidget.text(name ?? '收藏', PFun.lg1(Colors.black45))],
      '000',
      {'fun': fun},
    );
  }

  void animateTo(offset) {
    return controller.jumpTo(offset ?? 0.0);
    // return controller.animateTo(offset ?? 0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
  }

  ///标题栏视图
  Widget titleBarView() {
    return ValueListenableBuilder(
      valueListenable: valueChange,
      builder: (_, __, ___) {
        var isGo = valueChange.value >= 100;
        return PWidget.container(
          PWidget.row([
            PWidget.container(
              PWidget.icon(Icons.keyboard_arrow_left_rounded, [isGo ? Colors.black : Colors.white]),
              [32, 32, if (!isGo) Colors.black26],
              {'br': 56, 'fun': () => close()},
            ),
            if (isGo) PWidget.spacer(),
            if (isGo)
              PWidget.row(
                List.generate(tabList.length, (i) {
                  if (i == 1 && ['', null].contains(detailDm.object?['detailPics'])) {
                    return PWidget.boxh(0);
                  }
                  return PWidget.container(
                    PWidget.column([
                      PWidget.text(tabList[i]),
                      PWidget.boxh(4),
                      PWidget.container(null, [24, 2, Colors.red.withOpacity((valueChange.tabIndex == i) ? 1 : 0)]),
                    ], '221'),
                    {
                      'pd': PFun.lg(0, 0, 16, 16),
                      'fun': () {
                        valueChange.changeTabIndex(i);
                        switch (tabList[i]) {
                          case '商品':
                            this.animateTo(0.0);
                            break;
                          case '详情':
                            this.animateTo((key1.currentContext?.size?.height ?? 0.0) - 48 - pmPadd.top);
                            break;
                        }
                      },
                    },
                  );
                }),
              ),
            if (isGo) PWidget.spacer(),
            if (isGo) PWidget.container(null, [32, 32]),
          ]),
          [null, 56 + pmPadd.top, if (isGo) Colors.white],
          {
            'pd': PFun.lg(pmPadd.top + 8, 8, 16, 16),
          },
        );
      },
    );
  }

  List<Widget> get headers {
    var imgs = '${detailDm.object!['storeInfo']['sliderImage'] ?? ''}'.trim().split(',');
    var price = '${detailDm.object!['storeInfo']['price']}';
    var priceInt = double.parse(price).toInt();
    return [
      PWidget.column([
        Stack(children: [
          AnimatedSwitchBuilder(
            value: detailDm,
            errorOnTap: () => this.getDetailData(),
            isAnimatedSize: false,
            initialState: PWidget.container(null, [double.infinity, 200]),
            objectBuilder: (v) {
              return DetailLunboWidget(['${detailDm.object!['storeInfo']['image'] ?? ''}']);
            },
          ),
        ]),
        PWidget.container(
          PWidget.column([
            PWidget.container(
              PWidget.row([
                PWidget.text('', [], {}, [
                  PWidget.textIs('积分', [Colors.red, 16, true]),
                  PWidget.textIs('$priceInt ', [Colors.red, 24, true]),
                  PWidget.textIs('原价 ¥${detailDm.object!['storeInfo']['otPrice']}', [Colors.black45, 12], {'td': TextDecoration.lineThrough}),
                ]),
                PWidget.spacer(),
                PWidget.text('', [], {}, [
                  PWidget.textIs('已兑', [Colors.black45, 12]),
                  PWidget.textIs('${detailDm.object!['storeInfo']['sales']}', [Colors.red, 12]),
                  PWidget.textIs('件', [Colors.black45, 12]),
                ]),
              ]),
              {'pd': 8},
            ),
            PWidget.container(
              PWidget.row([
                PWidget.text(detailDm.object!['storeInfo']['storeName'], [Colors.black.withOpacity(0.75), 18, true], {'exp': true,'max':2}),
              ]),
              {'pd': 8},
            ),

          ]),
          [null, null, Colors.white],
        ),
      ], null, null, key1),
      PointsDetailImgWidget(imgs, key: key2),
    ];
  }
}
