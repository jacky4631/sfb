/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/me/points_detail_img_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/value_util.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../widget/custom_button.dart';
import '../widget/detail_lunbo_widget.dart';

// 简单的数据模型类替代 DataModel
class SimpleDataModel<T> {
  T? object;
  bool isLoading = false;
  String? error;
  int flag = 0;

  SimpleDataModel({this.object});

  void toError(String errorMsg) {
    error = errorMsg;
    flag = -1;
  }

  void addObject(T obj) {
    object = obj;
    error = null;
    flag = 1;
  }

  bool get isEmpty => object == null;
}

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
  var detailDm = SimpleDataModel<Map>(object: {
    'storeInfo': {'price': 0}
  });
  Future<int> getDetailData() async {
    try {
      var res = await http.get(Uri.parse(BService.getMePointsMallDetailUrl(widget.data['id'])));
      detailDm.addObject(jsonDecode(res.body)['data']);
    } catch (e) {
      detailDm.toError('网络异常');
    }

    setState(() {});
    return detailDm.flag;
  }

  var listSimilerGoodsByOpenDm = SimpleDataModel();
  // 获取屏幕安全区域
  EdgeInsets get pmPadd => MediaQuery.of(context).padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F3F3),
      body: Stack(children: [
        CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(headers),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16).copyWith(bottom: 72),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => SizedBox(),
                  childCount: 0,
                ),
              ),
            ),
          ],
        ),
        titleBarView(),
        btmBarView(),
      ]),
    );
  }

  // 关闭页面方法
  void close() {
    Navigator.of(context).pop();
  }

  ///底部操作栏
  Widget btmBarView() {
    return Positioned(
      bottom: detailDm.object!.isEmpty ? -64 : 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
        child: CustomButton(
          bgColor: Colours.app_main,
          showIcon: false,
          textColor: Colors.white,
          text: '立即兑换',
          onPressed: () {
            if (Global.login) {
              BService.integralConfirm(context, '${detailDm.object!['storeInfo']['id']}').then((value) => {
                    if (value['success'])
                      {
                        //积分足够 todo跳转订单页面
                        Navigator.pushNamed(context, '/createOrder', arguments: detailDm.object?['storeInfo'])
                      }
                    else
                      {ToastUtils.showToast('积分不足，去购物获得积分吧')}
                  });
            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
        ),
      ),
    );
  }

  Widget btmBtnView(name, icon, fun) {
    return GestureDetector(
      onTap: fun,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.star_rate_rounded, color: Colors.black45),
          SizedBox(height: 4),
          Text(name ?? '收藏', style: TextStyle(color: Colors.black45)),
        ],
      ),
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
        return Container(
          height: 56 + pmPadd.top,
          color: isGo ? Colors.white : null,
          padding: EdgeInsets.fromLTRB(16, pmPadd.top + 8, 16, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => close(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: !isGo ? Colors.black26 : null,
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: isGo ? Colors.black : Colors.white,
                  ),
                ),
              ),
              if (isGo) Spacer(),
              if (isGo)
                Row(
                  children: List.generate(tabList.length, (i) {
                    if (i == 1 && ['', null].contains(detailDm.object?['detailPics'])) {
                      return SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
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
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tabList[i]),
                            SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 2,
                              color: Colors.red.withValues(alpha: (valueChange.tabIndex == i) ? 1 : 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              if (isGo) Spacer(),
              if (isGo) SizedBox(width: 32, height: 32),
            ],
          ),
        );
      },
    );
  }

  List<Widget> get headers {
    final storeInfo = ValueUtil.toMap(detailDm.object!['storeInfo']);
    var imgs = '${detailDm.object!['storeInfo']['sliderImage'] ?? ''}'.trim().split(',');
    var price = '${detailDm.object!['storeInfo']['price']}';
    var priceInt = double.parse(price).toInt();
    return [
      Column(
        key: key1,
        children: [
          Stack(children: [
            detailDm.object != null
                ? DetailLunboWidget(['${detailDm.object!['storeInfo']['image'] ?? ''}'])
                : GestureDetector(
                    onTap: () => this.getDetailData(),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('点击重试', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
          ]),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '积分',
                              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '$priceInt ',
                              style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '原价 ¥${detailDm.object!['storeInfo']['otPrice']}',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '已兑',
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                            TextSpan(
                              text: '${detailDm.object!['storeInfo']['sales']}',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            TextSpan(
                              text: '件',
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ValueUtil.toStr(storeInfo['storeName']),
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.75),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      PointsDetailImgWidget(imgs, key: key2),
    ];
  }
}
