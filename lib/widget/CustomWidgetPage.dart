/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/value_util.dart';

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

import '../vip/vip_detail_page.dart';

getMoneyWidget(BuildContext context, num commission, String platform,
    {canClick = true,
    column = true,
    txtColor = Colours.app_main,
    bgColor = Colours.hb_bg,
    priceTxtColor = Colours.app_main,
    txtSize = 11,
    pd,
    br}) {
  EdgeInsets padding;
  BorderRadius borderRadius;

  if (pd == null) {
    padding = EdgeInsets.fromLTRB(3, 3, 8, 8);
  } else {
    padding = pd;
  }

  if (br == null) {
    borderRadius = BorderRadius.only(
      topLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );
  } else {
    borderRadius = br;
  }

  Map data = getHbData(commission, platform);
  String min = data['min'];
  String max = data['max'];

  Widget hbWidget = RichText(
    text: TextSpan(
      style: TextStyle(color: txtColor, fontSize: txtSize.toDouble()),
      children: [
        TextSpan(text: '可拆'),
        TextSpan(
            text: '$min元',
            style: TextStyle(color: txtColor, fontSize: txtSize.toDouble())),
        TextSpan(
            text: '-',
            style: TextStyle(color: txtColor, fontSize: txtSize.toDouble())),
        TextSpan(
            text: '$max元',
            style:
                TextStyle(color: priceTxtColor, fontSize: txtSize.toDouble())),
        TextSpan(
            text: '红包',
            style: TextStyle(color: txtColor, fontSize: txtSize.toDouble())),
      ],
    ),
  );

  List<Widget> widgets = [hbWidget];

  return GestureDetector(
    onTap: canClick
        ? () {
            showRed(context, commission, platform);
          }
        : null,
    child: Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: bgColor),
        borderRadius: borderRadius,
      ),
      child: column
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
    ),
  );
}

Future showRed(context, commission, platform) async {
  showRedPacket(context, commission, platform, () async {
    await Future.delayed(Duration(seconds: 1));
    ToastUtils.showToast('下单后，可在订单中心拆开红包！');
  });
}

getPriceWidget(endPrice, startPrice,
    {endTextSize = 19,
    endPrefix = '',
    endPrefixColor = Colours.app_main,
    startPrefix = '',
    endTextColor = Colours.app_main,
    endPrefixSize = 12}) {
  return RichText(
    text: TextSpan(
      children: [
        if (endPrefix.isNotEmpty)
          TextSpan(
            text: endPrefix,
            style: TextStyle(
              color: endPrefixColor,
              fontSize: endPrefixSize.toDouble(),
              fontWeight: FontWeight.bold,
            ),
          ),
        TextSpan(
          text: '¥',
          style: TextStyle(
            color: Colours.app_main,
            fontSize: endPrefixSize.toDouble(),
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: '$endPrice ',
          style: TextStyle(
            color: endTextColor,
            fontSize: endTextSize.toDouble(),
            fontWeight: FontWeight.bold,
          ),
        ),
        if (startPrice != endPrice)
          TextSpan(
            text: '$startPrefix¥$startPrice',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    ),
  );
}

getLabelWidget(label, {textSize = 12}) {
  return Container(
    padding: EdgeInsets.fromLTRB(1, 1, 4, 4),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      border: Border.all(color: Colors.grey[100]!, width: 0.5),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.black45,
        fontSize: textSize.toDouble(),
      ),
    ),
  );
}

Widget getTitleWidget(
  String title, {
  double size = 14,
  int max = 1,
  bool isOf = true,
}) {
  return Text(
    title,
    style: TextStyle(
      color: Colors.black.withValues(alpha: 0.75),
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
    maxLines: max,
    overflow: isOf ? TextOverflow.ellipsis : TextOverflow.visible,
  );
}

getSalesWidget(sales) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.local_fire_department_outlined,
        color: Colors.black45,
        size: 12,
      ),
      Text(
        '$sales',
        style: TextStyle(
          color: Colors.black45,
          fontSize: 10,
        ),
        textAlign: TextAlign.start,
      ),
    ],
  );
}

Widget rainbowText(String text,
    {onTap, colors, fontSize = 14.0, fontWeight = FontWeight.bold}) {
  var colorizeColors = colors ??
      [
        Colors.blue,
        Colors.yellow,
        Colors.white,
      ];

  return Padding(
      padding: EdgeInsets.only(
        top: 0,
        bottom: 0,
        left: 4,
        right: 4,
      ),
      child: SizedBox(
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

Widget shimmerWidget(Widget child,
    {color = Colors.red, highlightColor = Colors.yellow}) {
  return Shimmer.fromColors(
    baseColor: color,
    highlightColor: highlightColor,
    child: child,
  );
}

Widget createTbItem(context, i, v) {
  int max = 1;
  if (i % 3 == 0) {
    max = 2;
  }
  num fee = v['commissionRate'] * v['actualPrice'] / 100;
  String shopType = v['shopType'] == 1 ? '天猫' : '淘宝';

  String sales = BService.formatNum(v['monthSales']);
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(
              getTbMainPic(v),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: getTitleWidget(v['title'], max: max)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  getPriceWidget(v['actualPrice'], v['originalPrice']),
                  Spacer(),
                  getSalesWidget(sales)
                ],
              ),
              if (fee > 0) SizedBox(height: 8),
              if (fee > 0) getMoneyWidget(context, fee, TB),
              SizedBox(height: 8),
              Text(
                '$shopType | ${v['shopName']}',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget createJdItem(context, i, v) {
  var xiaoliangStr = '';
  var xiaoliang = v['inOrderCount30Days'] as int;
  xiaoliangStr = BService.formatNum(xiaoliang);
  int max = 1;
  if (i % 3 == 0) {
    max = 2;
  }
  num? actPrice = v['actualPrice'];
  actPrice ??= v['lowestCouponPrice'];
  num? startPrice = v['originPrice'] ?? v['price'];
  num fee = v['commissionShare'] * actPrice / 100;
  List? labels = v['promotionLabelList'];
  bool showLabel = labels?.isNotEmpty ?? false;
  String label = '';
  if (showLabel && labels != null) {
    label = labels[0]['promotionLabel'];
  }
  String pic = v['picMain'] ?? v['whiteImage'];

  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              pic,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (v['isOwner'] == 1)
                  Container(
                    padding: EdgeInsets.fromLTRB(1, 1, 4, 4),
                    decoration: BoxDecoration(
                      color: Colours.jd_main,
                      border: Border.all(color: Colours.jd_main, width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '自营',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                if (v['isOwner'] == 1) SizedBox(width: 2),
                Expanded(
                  child: getTitleWidget(v['skuName'], max: max),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                getPriceWidget(actPrice, startPrice,
                    endTextColor: Colours.jd_main),
                Spacer(),
                getSalesWidget(xiaoliangStr)
              ],
            ),
            if (showLabel) SizedBox(height: 8),
            if (showLabel) getLabelWidget(label),
            if (fee > 0) SizedBox(height: 8),
            if (fee > 0) getMoneyWidget(context, fee, JD),
            SizedBox(height: 8),
            Text(
              v['shopName'],
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget createPddItem(context, i, v) {
  //todo 详情页积分和列表不一致 暂时关闭
  num fee = v['promotionRate'] * v['minGroupPrice'] / 100;

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(
              '${v['goodsImageUrl']}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/mall/pdd.png',
                    width: 14,
                    height: 14,
                  ),
                  SizedBox(width: 4),
                  Expanded(child: getTitleWidget(v['goodsName'])),
                ],
              ),
              // Text('${v['dtitle']}'),
              SizedBox(height: 8),
              getPriceWidget(v['minGroupPrice'], v['minNormalPrice'],
                  endTextColor: Colours.pdd_main,
                  endPrefix: '抢购价 ',
                  endPrefixColor: Colors.black54),
              if (fee > 0) SizedBox(height: 8),
              if (fee > 0)
                getMoneyWidget(context, fee, PDD,
                    priceTxtColor: Colours.pdd_main),
              SizedBox(height: 8),
              Text(
                v['mallName'],
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              getSalesWidget(v['salesTip'])
            ],
          ),
        ),
      ],
    ),
  );
}

Widget createDyItem(context, i, v) {
  String sale = BService.formatNum(ValueUtil.toInt(v['sales']));
  num startPrice = 0;
  num endPrice = 0;
  String shopName = '';
  num fee = 0;

  var feeTemp = v['cos_fee'];
  if (feeTemp != null) {
    fee = ValueUtil.toNum(feeTemp) / 100;
    startPrice = ValueUtil.toNum(v['price']) / 100;
    shopName = v['shop_name'] ?? '';
    var couponPriceTemp = v['coupon_price'];
    endPrice = couponPriceTemp != null && couponPriceTemp > 0
        ? couponPriceTemp / 100
        : startPrice;
  } else {
    fee = v['cosFee'] ?? 0;
    startPrice = v['price'] ?? 0;
    shopName = v['shopName'] ?? '';
    var couponPrice = v['couponPrice'] ?? 0;
    endPrice = couponPrice > 0 ? couponPrice : startPrice;
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(
              '${v['item_pic']}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: getTitleWidget(
                      ValueUtil.toStr(v['title']),
                    ),
                  ),
                ],
              ),
              // Text('${v['dtitle']}'),
              SizedBox(height: 8),
              getPriceWidget(endPrice, startPrice,
                  endTextColor: Colours.dy_main,
                  endPrefix: '抢购价 ',
                  endPrefixColor: Colors.black54),
              if (fee > 0) SizedBox(height: 8),
              if (fee > 0)
                getMoneyWidget(context, fee, DY,
                    priceTxtColor: Colours.dy_main),
              SizedBox(height: 8),
              Text(
                shopName,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              getSalesWidget(sale)
            ],
          ),
        ),
      ],
    ),
  );
}

Widget createVipItem(context, data) {
  var endPrice = double.parse(data['vipPrice']).toStringAsFixed(0);
  var price = double.parse(data['marketPrice']).toStringAsFixed(0);
  double fee = double.parse(data['commission']);

  return Container(
    color: Colors.white,
    padding: EdgeInsets.all(12),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            data['goodsMainPicture'],
            width: 134,
            height: 134,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 134,
                height: 134,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported, color: Colors.grey),
              );
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitleWidget(data['goodsName']),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 32,
                  color: Colours.bg_light,
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/mall/mini.png',
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${data['storeInfo']['storeName']}',
                        style: TextStyle(
                          color: Colours.vip_main,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    alignment: Alignment.centerLeft,
                    child: getPriceWidget(
                      endPrice,
                      price,
                      endTextColor: Colours.vip_main,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              getMoneyWidget(context, fee, VIP,
                  priceTxtColor: Colours.vip_main),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget createTbFadeContainer(context, i, v) {
  return Container(
    margin: EdgeInsets.all([0, 1].contains(i) ? 0 : 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Global.openFadeContainer(
        createTbItem(context, i, v), ProductDetails(v)),
  );
}

Widget createJdFadeContainer(context, i, v) {
  return Container(
    margin: EdgeInsets.all([0, 1].contains(i) ? 0 : 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child:
        Global.openFadeContainer(createJdItem(context, i, v), JDDetailsPage(v)),
  );
}

Widget createPddFadeContainer(context, i, v) {
  return Container(
    margin: EdgeInsets.all([0, 1].contains(i) ? 0 : 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Global.openFadeContainer(
        createPddItem(context, i, v), PddDetailPage(v)),
  );
}

Widget createDyFadeContainer(context, i, v) {
  return Container(
    margin: EdgeInsets.all([0, 1].contains(i) ? 0 : 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child:
        Global.openFadeContainer(createDyItem(context, i, v), DyDetailPage(v)),
  );
}

Widget createVipFadeContainer(context, data) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Global.openFadeContainer(
            createVipItem(context, data), VipDetailPage(data)),
      ),
      SizedBox(height: 15)
    ],
  );
}

const List<Map> SHOP_TABS = [
  {'name': '淘星选', 'platform': 'tb'},
  {'name': '京星选', 'platform': 'jd'},
  {'name': '多星选', 'platform': 'pdd'},
  {'name': '抖星选', 'platform': 'dy'},
  {'name': '唯星选', 'platform': 'vip'},
];

showSignDialog(context, fun,
    {title = '实名认证',
    desc = '需要实名认证签署合同后方可加盟',
    okTxt = '去认证',
    cancelTxt = '取消',
    forceUpdate = false}) {
  AwesomeDialog(
    context: context,
    dismissOnTouchOutside: !forceUpdate,
    dialogType: DialogType.noHeader,
    body: CardSignDialog(title, desc,
        okTxt: okTxt, cancelTxt: cancelTxt, forceUpdate: forceUpdate, fun: fun),
  )..show().then((value) {
      if (value && fun != null) {
        fun();
      }
    });
}

Widget getLevelWidget(level, platform) {
  return Stack(
    children: [
      Image.asset(
        getVipBgImage(level),
        width: 18,
        height: 12,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/mall/$platform.png',
        width: 8,
        height: 8,
        fit: BoxFit.cover,
      ),
    ],
  );
}

getVipBgImage(level) {
  return 'assets/images/lv/vip_bg.png';
}

Widget createBottomBackArrow(context) {
  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(56),
      ),
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black45,
        size: 24,
      ),
    ),
  );
}

Widget getBuyTipWidget({color = Colors.red}) {
  return Container(
    padding: EdgeInsets.fromLTRB(8, 12, 12, 8),
    child: Row(
      children: [
        Icon(
          CupertinoIcons.exclamationmark_circle,
          color: color,
        ),
        SizedBox(width: 5),
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
      ],
    ),
  );
}

Widget btmBtnView(name, icon, fun, collect) {
  return GestureDetector(
    onTap: fun,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon ?? Icons.star_rate_rounded,
          color: Colours.getCollectColor(name, collect),
        ),
        SizedBox(height: 4),
        Text(
          name ?? '收藏',
          style: TextStyle(
            color: Colors.black45,
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}
