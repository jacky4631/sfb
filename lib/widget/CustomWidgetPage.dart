/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/tao_util.dart';

import '../dialog/card_sign_dialog.dart';
import '../dy/dy_detail_page.dart';
import '../jd/jd_details_page.dart';
import '../page/product_details.dart';
import '../pdd/pdd_detail_page.dart';
import '../service.dart';
import '../util/colors.dart';
import '../hb/red_packet.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../vip/vip_detail_page.dart';

getMoneyWidget(BuildContext context, num commission, String platform,
    {canClick = true, column = true, txtColor = Colours.app_main,
      bgColor = Colours.hb_bg, priceTxtColor = Colours.app_main, txtSize=11,
    pd, br}) {

  if(pd == null) {
    pd= PFun.lg(3, 3, 8, 8);
  }
  if(br == null) {
    br= PFun.lg(16, 0, 0, 16);
  }
  Map data = getHbData(commission, platform);
  String min = data['min'];
  String max = data['max'];
  Widget hbWidget = PWidget.text('可拆', [txtColor, txtSize],{},[
    PWidget.textIs('$min元', [txtColor, txtSize]),
    PWidget.textIs('-', [txtColor, txtSize]),
    PWidget.textIs('$max元', [priceTxtColor, txtSize]),
    PWidget.textIs('红包', [txtColor, txtSize]),
  ]);
  List<Widget> widgets = [
    hbWidget
  ];
  return PWidget.container(column? PWidget.column(widgets) : PWidget.row(widgets),
      [null, null, bgColor],
      {
    'fun': canClick ? () {
      showRed(context, commission, platform);
    } : null,'bd': PFun.bdAllLg(bgColor), 'pd': pd, 'br': br
  }
  );
}

Future showRed(context, commission, platform) async {
  showRedPacket(context, commission, platform, () async{
      await Future.delayed(Duration(seconds: 1));
      ToastUtils.showToast('下单后，可在订单中心拆开红包！');
  });
}

getPriceWidget(endPrice, startPrice,{endTextSize=19, endPrefix='',endPrefixColor = Colours.app_main,
  startPrefix='', endTextColor = Colours.app_main, endPrefixSize = 12}) {
  return PWidget.text('', [], {}, [
    PWidget.textIs(endPrefix, [endPrefixColor, endPrefixSize, true]),
    PWidget.textIs('¥', [Colours.app_main, endPrefixSize, true]),
    PWidget.textIs('$endPrice ',
        [endTextColor, endTextSize, true]),
    if(startPrice != endPrice)
    PWidget.textIs('$startPrefix¥$startPrice',
        [Colors.black45, 12], {'td': TextDecoration.lineThrough}),
  ]);
}

getLabelWidget(label, {textSize= 12}) {
  return PWidget.container(
    PWidget.text(label, [Colors.black45, textSize]),
    [null, null, Colors.grey[100]],
    {
      'bd': PFun.bdAllLg(Colors.grey[100], 0.5),
      'pd': PFun.lg(1, 1, 4, 4),
      'br': PFun.lg(4, 4, 4, 4)
    },
  );
}

getTitleWidget(title, {size=14, max=1, isOf = true,}) {
  return PWidget.text(title,
      [Colors.black.withOpacity(0.75), size, true], {'max': max,'exp': true, 'isOf': isOf, });
}

getSalesWidget(sales) {
  return PWidget.row([
    PWidget.icon(Icons.local_fire_department_outlined, [Colors.black45, 14]),
    PWidget.text('$sales', [Colors.black45, 12], {'ali':0},),
  ]);
}

Widget rainbowText(String text, {onTap, colors, fontSize = 14.0, fontWeight = FontWeight.bold}) {
  var colorizeColors = colors??[
    Colors.blue,
    Colors.yellow,
    Colors.white,
  ];

  return Padding(padding: EdgeInsets.only(top: 0, bottom: 0, left: 4, right: 4,), child: SizedBox(
    child: AnimatedTextKit(
      animatedTexts: [text]
          .map((e) => ColorizeAnimatedText(
        e,
        textAlign: TextAlign.end,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        colors: colorizeColors,
      ))
          .toList(),
      isRepeatingAnimation: true,
      repeatForever: true,
      onTap: onTap,
    ),
  ));
}

Widget shimmerWidget(Widget child, {color= Colors.red, highlightColor= Colors.yellow}) {
  return Shimmer.fromColors(
    baseColor: color,
    highlightColor: highlightColor,
    child: child,
  );
}

Widget createTbItem(context, i, v) {
  int max = 1;
  if(i%3 == 0) {
    max =2;
  }
  num fee = v['commissionRate'] * v['actualPrice'] / 100;
  String shopType = v['shopType']==1?'天猫':'淘宝';

  String sales = BService.formatNum(v['monthSales']);
  return PWidget.container(
    PWidget.column([
      PWidget.wrapperImage(getTbMainPic(v), {'ar': 1 / 1}),
      PWidget.container(
        PWidget.column([
          PWidget.row([
            getTitleWidget(v['title'], max: max),
          ]),
          PWidget.boxh(8),
          PWidget.row([
            getPriceWidget(v['actualPrice'], v['originalPrice']),
            PWidget.spacer(),
            getSalesWidget(sales)
          ]),
          fee == 0 ? SizedBox() : PWidget.boxh(8),
          fee == 0 ? SizedBox() : getMoneyWidget(context, fee, TB),
          PWidget.boxh(8),
          PWidget.text('$shopType | ${v['shopName']}', [Colors.black45, 12]),
        ]),
        {'pd': 8},
      ),
    ]),
    [null, null, Colors.white],
  );
}


Widget createJdItem(context, i, v) {
  var xiaoliangStr = '';
  var xiaoliang = v['inOrderCount30Days'] as int;
  xiaoliangStr = BService.formatNum(xiaoliang);
  int max = 1;
  if(i%3 == 0) {
    max =2;
  }
  num actPrice = v['actualPrice'];
  if(actPrice == null) {
    actPrice = v['lowestCouponPrice'];
  }
  num startPrice = v['originPrice'] != null ? v['originPrice'] : v['price'];
  num fee = v['commissionShare']*actPrice/100;
  List labels = v['promotionLabelList'];
  bool showLabel = labels != null && labels.isNotEmpty;
  String label = '';
  if(showLabel) {
    label = labels[0]['promotionLabel'];
  }
  String pic = v['picMain'] != null ? v['picMain'] : v['whiteImage'];
  return PWidget.container(
    PWidget.column([
      PWidget.wrapperImage(pic, {'ar': 1 / 1, 'br': 8}),
      PWidget.boxh(8),
      PWidget.container(
        PWidget.column([
          PWidget.row([
            v['isOwner'] == 1
                ? PWidget.container(
              PWidget.text('自营', [Colors.white, 11]),
              [null, null, Colours.jd_main],
              {
                'bd': PFun.bdAllLg(Colours.jd_main, 0.5),
                'pd': PFun.lg(1, 1, 4, 4),
                'br': PFun.lg(4, 4, 4, 4)
              },
            ) : SizedBox(),
            PWidget.boxw(2),

            getTitleWidget(v['skuName'], max: max),
          ],['0','1','1']),
          PWidget.boxh(8),
          PWidget.row([
            getPriceWidget(actPrice, startPrice, endTextColor: Colours.jd_main),
            PWidget.spacer(),
            getSalesWidget(xiaoliangStr)
          ]),
          if(showLabel)
            PWidget.boxh(8),
          if(showLabel)
            getLabelWidget(label),
          fee == 0 ? SizedBox() : PWidget.boxh(8),
          fee == 0 ? SizedBox() : getMoneyWidget(context, fee, JD),
          PWidget.boxh(8),
          PWidget.text(v['shopName'], [Colors.black45, 12]),
        ]),
      ),
    ]),
    [null, null, Colors.white],
    {
      'pd': 8,
      'sd': PFun.sdLg(Colors.black12),
      'br': 8,
    },
  );
}

Widget createPddItem(context, i, v) {
  //todo 详情页积分和列表不一致 暂时关闭
  num fee = v['promotionRate']*v['minGroupPrice']/100;

  return PWidget.container(
    PWidget.column([
      PWidget.wrapperImage('${v['goodsImageUrl']}', {'ar': 1 / 1}),
      PWidget.container(
        PWidget.column([
          PWidget.row([
            PWidget.image('assets/images/mall/pdd.png', [14, 14],{'pd':[3,0,0,0]}),
            PWidget.boxw(4),
            getTitleWidget(v['goodsName']),
          ]),
          // PWidget.text('${v['dtitle']}'),
          PWidget.boxh(8),
          getPriceWidget(v['minGroupPrice'], v['minNormalPrice'], endTextColor: Colours.pdd_main,
              endPrefix: '抢购价 ', endPrefixColor: Colors.black54),
          fee == 0 ? SizedBox() : PWidget.boxh(8),
          fee == 0 ? SizedBox() : getMoneyWidget(context, fee, PDD,priceTxtColor: Colours.pdd_main),
          PWidget.boxh(8),
          PWidget.text(v['mallName'], [Colors.black45, 12]),
          PWidget.boxh(8),
          getSalesWidget(v['salesTip'])
        ]),
        {'pd': 8},
      ),
    ]),
    [null, null, Colors.white],
  );
}

Widget createDyItem(context, i, v) {
  String sale = BService.formatNum(v['sales']);
  num startPrice;
  num endPrice;
  String shopName;
  num fee = v['cos_fee'];
  if(fee == null) {
    fee = v['cosFee'];
    startPrice = v['price'];
    shopName = v['shopName'];
    endPrice = v['couponPrice'] > 0 ? v['couponPrice'] : startPrice;
  } else {
    fee = fee/100;
    startPrice = v['price']/100;
    shopName = v['shop_name'];
    endPrice = v['coupon_price'] != null && v['coupon_price'] > 0 ? v['coupon_price']/100 : startPrice;
  }
  return PWidget.container(
    PWidget.column([
      PWidget.wrapperImage('${v['cover']}', {'ar': 1 / 1}),
      PWidget.container(
        PWidget.column([
          PWidget.row([
            getTitleWidget(v['title'], ),
          ]),
          // PWidget.text('${v['dtitle']}'),
          PWidget.boxh(8),

          getPriceWidget(endPrice, startPrice, endTextColor: Colours.dy_main, endPrefix: '抢购价 ',
              endPrefixColor: Colors.black54),
          fee == 0 ? SizedBox() : PWidget.boxh(8),
          fee == 0 ? SizedBox() : getMoneyWidget(context, fee, DY,priceTxtColor: Colours.dy_main),
          PWidget.boxh(8),
          PWidget.text(shopName, [Colors.black45, 12]),
          PWidget.boxh(8),
          getSalesWidget(sale)
        ]),
        {'pd': 8},
      ),
    ]),
    [null, null, Colors.white],
  );
}


Widget createVipItem(context, data) {
  var endPrice = double.parse(data['vipPrice']).toStringAsFixed(0);
  var price = double.parse(data['marketPrice']).toStringAsFixed(0);
  double fee = double.parse(data['commission']);
  return PWidget.container(
    PWidget.row(
      [
        PWidget.wrapperImage(data['goodsMainPicture'], [134, 134], {'br': 8}),
        PWidget.boxw(8),
        PWidget.column([
          getTitleWidget(data['goodsName']),
          PWidget.boxh(8),
          ClipRRect(
              borderRadius: BorderRadius.circular(12), //设置圆角
              child: PWidget.container(
                PWidget.row([
                  PWidget.image('assets/images/mall/mini.png', [12, 12]),
                  PWidget.boxw(4),
                  PWidget.text('', [], {}, [
                    PWidget.textIs('${data['storeInfo']['storeName']}',
                        [Colours.vip_main, 12]),
                  ])
                ]),
                [double.infinity, 32, Colours.bg_light],
                {'pd': PFun.lg(0, 0, 8, 8), 'ali': PFun.lg(-1, 0)},
              )),
          PWidget.boxh(8),
          Stack(alignment: Alignment.centerRight, children: [
            PWidget.container(
              getPriceWidget(endPrice, price, endTextColor: Colours.vip_main,),
              {
                'pd': PFun.lg(0, 0, 8, 8),
                'mg': PFun.lg(0, 0, 0, 15),
                'ali': PFun.lg(-1, 0)
              },
            ),

          ]),
          PWidget.boxh(8),
          getMoneyWidget(context, fee, VIP,priceTxtColor: Colours.vip_main),
        ], {
          'exp': 1,
        }),
      ],
      '001',
      {'fill': true},
    ),
    [null, null, Colors.white],
    {
      'pd': 12,
    },
  );
}
Widget createTbFadeContainer(context, i, v) {
  return PWidget.container(
    Global.openFadeContainer(createTbItem(context, i, v), ProductDetails(v)),
    [null, null, Colors.white],
    {
      'crr': 8,'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 8)
    },
  );
}

Widget createJdFadeContainer(context, i, v) {
  return PWidget.container(
    Global.openFadeContainer(createJdItem(context, i, v), JDDetailsPage(v)),
    [null, null, Colors.white],
    {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 8)},
  );
}
Widget createPddFadeContainer(context, i, v) {
  return PWidget.container(
    Global.openFadeContainer(createPddItem(context, i, v), PddDetailPage(v)),
    [null, null, Colors.white],
    {
      'crr': 8,'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 8)
    },
  );
}
Widget createDyFadeContainer(context, i, v) {
  return PWidget.container(
    Global.openFadeContainer(createDyItem(context, i, v), DyDetailPage(v)),
    [null, null, Colors.white],
    {
      'crr': 8,'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 10)
    },
  );
}
Widget createVipFadeContainer(context, data) {
  return PWidget.column(
    [
      ClipRRect(
        borderRadius: BorderRadius.circular(15), //设置圆角
        child: Global.openFadeContainer(
            createVipItem(context, data), VipDetailPage(data)),
      ),
      PWidget.boxh(15)
    ],
  );
}

const List<Map> SHOP_TABS = [
  {'name':'淘星选', 'platform':'tb'},
  {'name':'京星选', 'platform':'jd'},
  {'name':'多星选', 'platform':'pdd'},
  {'name':'抖星选', 'platform':'dy'},
  {'name':'唯星选', 'platform':'vip'},];

showSignDialog(context, fun, {
  title='实名认证',
  desc='需要实名认证签署合同后方可加盟',
  okTxt='去认证',
  cancelTxt = '取消',forceUpdate=false}) {
  AwesomeDialog(
    context: context,
    dismissOnTouchOutside: !forceUpdate,
    dialogType: DialogType.noHeader,
    body: CardSignDialog(title, desc, okTxt: okTxt, cancelTxt: cancelTxt,forceUpdate: forceUpdate,fun:fun),
  )..show().then((value) {
    if (value && fun != null) {
      fun();
    }
  });
}

Widget getLevelWidget(level, platform){
  return PWidget.stack([
    PWidget.image(getVipBgImage(level), [18, 12]),
    PWidget.image('assets/images/mall/$platform.png', [8, 8]),
  ]);
}
getVipBgImage(level){
  return 'assets/images/lv/vip_bg.png';
}
Widget createBottomBackArrow(context) {
  return PWidget.container(
    PWidget.icon(Icons.arrow_back_ios,
        [Colors.black45, 24]),
    [32, 32],
    {'br': 56, 'fun': () => Navigator.pop(context)},
  );
}
Widget getBuyTipWidget({color = Colors.red}) {
  return
    PWidget.container(PWidget.row([
      PWidget.icon(CupertinoIcons.exclamationmark_circle,[color]),
      PWidget.boxw(5),
      Column(
        children: [
          Text(
            '购买前需移除购物车商品',
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
          ),
          Text(
            '可多个商品加购同时购买',
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
          ),
          Text(
            '支付时不要使用活动红包',
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
          )
        ],
      )
    ]
    ),
      {'pd': [8,12,12,8]},
    );
}


Widget btmBtnView(name, icon, fun, collect) {
  return PWidget.column(
    [
      PWidget.icon(icon ?? Icons.star_rate_rounded, PFun.lg1(Colours.getCollectColor(name, collect))),
      PWidget.boxh(4),
      PWidget.textNormal(name ?? '收藏', [Colors.black45, 12])
    ],
    '220',
    {'fun': fun},
  );
}