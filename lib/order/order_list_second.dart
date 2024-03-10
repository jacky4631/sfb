/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/dy/dy_detail_page.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/vip/vip_detail_page.dart';

import '../hb/red_packet.dart';
import '../httpUrl.dart';
import '../jd/jd_details_page.dart';
import '../me/listener/PersonalNotifier.dart';
import '../page/product_details.dart';
import '../pdd/pdd_detail_page.dart';
import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/order_tab_widget.dart';
//订单明细
class OrderListSecond extends StatefulWidget {
  final Map data;
  const OrderListSecond(this.data, {Key? key,}) : super(key: key);

  @override
  _OrderListSecondState createState() => _OrderListSecondState();
}

class _OrderListSecondState extends State<OrderListSecond> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future<int> initData() async {

    var res = await BService.orderTab(widget.data['level'], widget.data['innerType']);
    if (res != null) {
      tabDm.addList(res, true, 0);
    };
    setState(() {});
    return tabDm.flag;
  }

  ///tab数据
  var tabDm = DataModel();

  getTabList(m) {
      Map map = m! as Map;
      return map['title'];
  }

  @override
  Widget build(BuildContext context) {
    int page = 0;
    if(widget.data != null && widget.data['page'] != null) {
      page = widget.data['page'];
    }
    return AnimatedSwitchBuilder(
      value: tabDm,
      errorOnTap: () => this.initData(),
      initialState: buildLoad(color: Colors.white),
      listBuilder: (list, _, __) {
        var tabList = list.map<Map>((m) => m).toList();
        return OrderTabWidget(
          color: Colours.app_main,
          unselectedColor: Colors.black.withOpacity(0.5),
          indicatorColor: Colours.app_main,
          page: page,
          fontSize: 15,
          tabList: tabList,
          indicatorWeight: 2,
          padding: EdgeInsets.only(top:10),
          labelBgColor: Colours.app_main,
          tabPage: List.generate(list.length, (i) {
            return TopChild(i, widget.data);
          }),
        );
      },
    );
  }
}

class TopChild extends StatefulWidget {
  final int index;
  final Map data;
  const TopChild(this.index, this.data, {Key? key}) : super(key: key);

  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    int innerType = widget.data['innerType'];
    Map param = getPlatformData(widget.index, 0);
    var res = await BService.taoOrders(page, param, level: widget.data['level'],
        innerType: innerType);
    if (res != null) listDm.addList(res['content'], isRef, res['totalElements']);
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colours.app_main),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          header: buildClassicHeader(color: Colors.grey),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          padding: EdgeInsets.all(8),
          divider: const Divider(height: 4, color: Colors.transparent),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            Map data = list[i] as Map;
            return getPlatformData(widget.index, 1, i: i, data: data);

          },
        );
      },
    );
  }

  /**
   * type=0是接口数据， type = 1是组件数据
   * */
  getPlatformData(int index, int type,{i, data}) {
    switch(index){
      case 0:
        if(type == 0) {
          return { "api": API.taoOrders, "sort": 'tk_create_time'};
        } else {
          return getTaoWidget(i, data);
        }
      case 1:
        if(type == 0) {
          return { "api": API.jdOrders, "sort": 'order_time'};
        } else {
          return getJdWidget(i, data);
        }
      case 2:
        if(type == 0) {
          return { "api": API.pddOrders, "sort": 'order_create_time'};
        } else {
          return getPddWidget(i, data);
        }
      case 3:
        if(type == 0) {
          return { "api": API.dyOrders, "sort": 'pay_success_time'};
        } else {
          return getDyWidget(i, data);
        }
      case 4:
        if(type == 0) {
          return { "api": API.vipOrders, "sort": 'order_time'};
        } else {
          return getVipWidget(i, data);
        }
      case 5:
        if(type == 0) {
          return { "api": API.mtOrders, "sort": 'order_pay_time'};
        } else {
          return getMtWidget(i, data);
        }
    }
  }

  Widget getTaoWidget(i, data) {
    String img = BService.formatUrl(data['itemImg']);
    num fee = data['pubSharePreFee'];
    return PWidget.container(
      createGoodsDesc(data, data['itemTitle'],
          data['tradeParentId'],
          data['alipayTotalPrice']??0,
          fee,
          data['tkCreateTime'], 'tb',
          img, data['orderType'] == '天猫'?'assets/images/mall/tm.png':'assets/images/mall/tb.png'),
      [null, null, Colors.white],
      {'pd': [4,4,4,4], 'br':8, 'fun': () {
        showRed(data, data['tradeParentId'], fee, 'tb');
      }},
    );
  }

  Widget getJdWidget(i, data) {
    num price = data['estimateCosPrice'];
    num fee = data['estimateFee'];
    if(price == 0) {
      fee = 0;
    }
    return PWidget.container(
      createGoodsDesc(data, data['skuName'],
          data['orderId'],
          price,
          fee,
          data['orderTime'], 'jd',data['goodsInfo']['imageUrl'], 'assets/images/mall/jd.png'),
      [null, null, Colors.white],
      {'pd': [4,4,4,4], 'br':8,  'fun': () {
        showRed(data, data['orderId'], fee, 'jd');
      }},
    );
  }


  Widget getPddWidget(i, data) {
    num fee = data['promotionAmount']/100;
    return PWidget.container(
      createGoodsDesc(data, data['goodsName'],
          data['orderSn'],
          data['orderAmount']!=null ? data['orderAmount']/100 : 0,
          fee,
          data['orderCreateTime'], 'pdd',data['goodsThumbnailUrl'], 'assets/images/mall/pdd.png'),
      [null, null, Colors.white],
      {'pd': [4,4,4,4], 'br':8,  'fun': () {
        showRed(data, data['orderSn'], fee, 'pdd');
      }},
    );
  }


  Widget getDyWidget(i, data) {
    num fee = data['estimatedTotalCommission'];
    return PWidget.container(
      createGoodsDesc(data, data['productName'],
          data['orderId'],
          data['totalPayAmount'],
          fee,
          data['paySuccessTime'], 'dy',data['productImg'], 'assets/images/mall/dy.png'),
      [null, null, Colors.white],
      {'pd': [4,4,4,4], 'br':8, 'fun': () {
        showRed(data, data['orderId'], fee, 'dy');
      }},
    );
  }

  Widget getVipWidget(i, data) {
    num fee = double.parse(data['commission']);
    return PWidget.container(
      createGoodsDesc(data, data['detailList'][0]['goodsName'],
          data['orderSn'],
          data['totalCost'],
          fee,
          data['orderTime'],
          'vip',
          data['detailList'][0]['goodsThumb'],
          'assets/images/mall/vip.png'
      ),
      [null, null, Colors.white],
      {'pd': [4,4,4,4], 'br':8, 'fun': () {
        showRed(data, data['orderSn'], fee, 'vip');
      }},
    );
  }

  Widget getMtWidget(i, data) {
    num price = data['actualItemAmount'];
    num fee = data['balanceAmount'];
    String orderType = data['orderType'];


    return PWidget.container(
      createGoodsDesc(data, data['shopName'],
          data['orderId'],
          price,
          fee,
          data['orderPayTime'], 'mt',
          orderType == '外卖' ? 'assets/images/mall/mtwm_bg.png' : 'assets/images/mall/mt_bg.png',
          'assets/images/mall/mt.png'),
      [null, null, Colors.white],
      {'pd': [4,4,4,4], 'br':8,  'fun': () {
        showRed(data, data['uniqueItemId'], fee, 'jd');
      }},
    );
  }
  Future showRed(data, orderId, num fee, type) async {
    var remain = data['remain'];
    if(remain == 'err') {
      ToastUtils.showToast('红包已失效');
      return;
    }
    if(data['bind'] == 1) {
      ToastUtils.showToast('红包已领取');
      return;
    }
    int index = widget.data['index'];
    if(index == 1 || index == 2 || index == 3) {
      ToastUtils.showToast('这不是您的订单哦');
      return;
    }
    showRedPacket(context, fee, type, () async{
      if(remain != 'ok') {
        await Future.delayed(Duration(seconds: 1));
        ToastUtils.showToast('红包尚未解锁');
        return;
      }
      await Future.delayed(Duration(milliseconds: 400));
      //京东订单可能相同订单号，商品不同，使用skuId做区分
      int skuId = 0;
      if(type=='jd'){
        skuId = data['skuId'];
      }
      Map res = await BService.spreadHb(orderId, type, skuId: skuId);
      if(!res['success']) {
        ToastUtils.showToast(res['msg']);
        return;
      }
      num hb = res['data']['hb'];
      String desc = '\n￥$hb';

      AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: context,
        dialogType: DialogType.noHeader,
        title: '恭喜您获得',
        titleTextStyle: TextStyle(color: Colors.white),
        desc: desc,
        dialogBackgroundColor: Colors.redAccent,
        descTextStyle: TextStyle(color: Colors.white,fontSize: 24),
        btnOkColor: Color(0xFFE5CDA8),
        btnOkText: '确定',
        btnOkOnPress: () async {
          data['bind'] = 1;
          data['hb'] = res['data']['hb'];
          data['baseHb'] = res['data']['baseHb'];
          data['shopHb'] = res['data']['shopHb'];
          personalNotifier.value = true;
          setState(() {

          });
        },
      )..show();
    });
  }

  Widget createImageWidget(img, logo, data, type) {
    Widget imgWidget;
    if(widget.data['level'] > 0 && isBlur){
      imgWidget =
          ClipRRect(
              child: ImageFiltered(
                // 设置模糊过滤器
                  imageFilter: ImageFilter.blur(
                    sigmaX: 7,
                    sigmaY: 7,
                  ),child:type== 'mt' ? PWidget.image(img, [124, 124]): PWidget.wrapperImage(img, [124, 124])),
              borderRadius: BorderRadius.all(Radius.circular(8))
          );
    } else {
      if(type == 'mt') {
        imgWidget = PWidget.image(img, [124, 124]);
      } else {
        Widget detailPage = SizedBox();
        switch(type){
          case 'tb':
            detailPage = ProductDetails(data);
            break;
          case 'jd':
            detailPage = JDDetailsPage(data);
            break;
          case 'pdd':
            detailPage = PddDetailPage(data);
            break;
          case 'dy':
            detailPage = DyDetailPage(data);
            break;
          case 'vip':
            data['category'] = 'vip';
            detailPage = VipDetailPage(data);
            break;
        }

        imgWidget = Global.openFadeContainer(PWidget.wrapperImage(img, [124, 124], {'br': 8}), detailPage);
      }
    }

    return Stack(children: [
      imgWidget,
      PWidget.image(logo, [16, 16, null, BoxFit.fill]),
    ]);
  }

  Widget createGoodsDesc(data, title, orderSn, price, num fee, createTime, type,
      img, imgTag) {
    var remain = data['remain'];
    var bind = data['bind'];
    var hb = data['baseHb'];
    if(hb == null || hb == 0) {
      hb = data['hb'];
    }

    var unlockText = '红包解锁时间$remain';
    var okText = '待解锁';
    var okBg = 'ljq.jpg';
    bool notValid = remain == 'err';
    //如果已经绑定说明用户领过红包，直接显示红包数量
    if(bind == 1) {
      unlockText = '奖励$hb元';
      var shopHb = data['shopHb'];
      if(shopHb != null && shopHb > 0) {
        unlockText = '$unlockText,星选奖励$shopHb元';
      }
      okText = '已拆';
      okBg = 'ljq_disabled.png';
    } else if(remain == 'ok') {
      okText = '拆红包';
      unlockText = '红包已解锁';
    } else if( bind==3 || notValid) {
      okText = '已失效';
      unlockText = '红包失效';
      okBg = 'ljq_disabled.png';
    }

    String orderNo = orderSn.toString();
    //下级订单 热度订单 隐藏订单后6位
    if(widget.data['level'] > 0 || widget.data['innerType'] == 2) {
      orderNo = orderNo.substring(0, orderNo.length-6) + '******';
    }

    if(widget.data['level'] > 0 && isBlur) {
      title = '********************';
    }

    return PWidget.column([
      PWidget.row([
        createImageWidget(img, imgTag, data, type),
        PWidget.boxw(8),
        PWidget.column([
          PWidget.row([
            PWidget.text(title, [Colors.black.withOpacity(0.75), 16], {'exp': true,'max':2}),
          ]),
          PWidget.boxh(8),
          PWidget.text('', [], {}, [
            PWidget.textIs('订单号  ', [Colors.black45, 12]),
            PWidget.textIs('$orderNo', [Colors.black45, 12], {}),
          ]),

          PWidget.boxh(4),
          PWidget.text('', [], {}, [
            PWidget.textIs('付款时间  ', [Colors.black45, 12]),
            PWidget.textIs('$createTime', [Colors.black45, 12], {}),
          ]),
          if(!notValid && bind==0)
            PWidget.boxh(4),
          if(!notValid && bind==0)
            PWidget.row([
              getMoneyWidget(context, fee, type, canClick: false, column: false, txtSize: 14,
                  br: PFun.lg(8, 8, 0, 0)),
            ]),
          PWidget.spacer(),
          PWidget.row([
            PWidget.text('', [], {}, [
              PWidget.textIs('实付￥', [Colors.black45, 12]),
              PWidget.textIs('$price', [Colors.red, 16], {}),
            ]),
          ],
              {'pd':[0,0,0,8]}),

        ], {
          'exp': 1,
        }),
      ],
        '001',
        {'fill': true},
      ),
      Stack(alignment: Alignment.centerRight, children: [
        PWidget.container(
          PWidget.text('', [], {'max':2}, [
            PWidget.textIs('', [Color(0xff793E1B), 14]),
            PWidget.textIs(unlockText, [Color(0xffDF5C12), 14]),
          ]),
          [double.infinity, 32, Color(0xffFAEDE6)],
          {'pd': PFun.lg(0, 0, 8, 8), 'mg': PFun.lg(0, 0, 0, 45), 'ali': PFun.lg(-1, 0),
            'br': [0,0,8,0]},
        ),
        Stack(alignment: Alignment.center, children: [
          PWidget.image('assets/images/mall/$okBg', [90, 39]),
          okText=='拆红包' ? rainbowText(okText, onTap: (){
            showRed(data, orderSn, fee, type);
          })
              :PWidget.text(okText, [Colors.white, 14, true], {'pd': PFun.lg(0, 4)}),
        ]),
      ]),
    ],

    );
  }
}
