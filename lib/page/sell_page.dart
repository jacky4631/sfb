/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sufenbao/util/tao_util.dart';

import '../service.dart';
import '../share/ShareDialog.dart';
import '../util/colors.dart';
import '../util/custom.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../util/repaintBoundary_util.dart';
import '../util/toast_utils.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/loading.dart';
//转卖
class SellPage extends StatefulWidget {
  final Map data;

  const SellPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  var detailDm = DataModel<Map>(object: {'actualPrice': ''});
  String sale = '';
  late String title = '';
  late String startPrice = '0';
  late String endPrice = '0';
  num fee = 0.00;
  String qrImage = 'assets/images/logo.png';
  var glokey = new GlobalKey();
  var data;
  String iconPath = '';
  var pic = '';
  Map<String, String> shareMap = {};
  String shareUrl = '';

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        brightness: Brightness.dark,
        bgColor: Colors.white,
        appBar: buildTitle(context,
            title: '转卖好货',
            widgetColor: Colors.black,
            color: Colors.white,
            leftIcon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        body: Stack(
          children: [
            ScaffoldWidget(
              body: PWidget.container(
               PWidget.column([
               RepaintBoundary(
                key: glokey,
                child: PWidget.container(
                  PWidget.column([
                    PWidget.container(
                      PWidget.row([
                        PWidget.image(iconPath, [14, 14]),
                        PWidget.boxw(10),
                        getTitleWidget(title, size: 16)
                      ], '200'),
                      {
                        'pd': [18, 8, 12, 0]
                      },
                    ),
                    PWidget.container(
                      PWidget.row([
                        getPriceWidget(endPrice, startPrice,
                            endTextSize: 24,
                            startPrefix: '原价 ',
                            endPrefixSize: 16),
                        PWidget.spacer(),
                        PWidget.text(
                          '已售$sale件',
                          [Colors.black45, 12],
                          {},
                        ),
                      ]),
                      {
                        'pd': [4, 8, 12, 0]
                      },
                    ),
                    PWidget.container(
                      PWidget.row([
                        getMoneyWidget(context, fee, widget.data['platType'],
                            column: false),
                      ]),
                      {
                        'pd': [4, 4, 12, 8]
                      },
                    ),
                    PWidget.row([
                      Expanded(
                        child: PWidget.wrapperImage(pic, [100, 370]),
                        flex: 1,
                      ),
                    ], {
                      'pd': [8, 24, 10, 0]
                    }),
                    PWidget.row([
                      PWidget.column([
                        PWidget.row([
                          PWidget.image(
                              'assets/images/logo.png', [30, 30], {'crr': 5}),
                          PWidget.boxw(12),
                          PWidget.textNormal(
                              APP_NAME, [Colors.black, 20, true]),
                        ], {
                          'pd': [0, 0, 0, 0]
                        }),
                        PWidget.boxh(10),
                        PWidget.textNormal(
                            '— $APP_NAME 购物拆红包 —', [Colors.black, 14, true]),
                        PWidget.boxh(10),
                        if(Global.login)
                        PWidget.textNormal(
                            '邀请口令：${Global.userinfo!.code}', [Colors.black, 12, true]),
                      ], '200'),
                      PWidget.spacer(),
                      PWidget.column([
                        shareUrl.isNotEmpty ? QrImageView(
                          data: shareUrl,
                          version: QrVersions.auto,
                          size: 120.0,
                          gapless: false,
                          embeddedImage: AssetImage(qrImage),
                        ): SizedBox(),
                        PWidget.boxw(10),
                        PWidget.textNormal(
                            '长按二维码领券购买', [Colors.black, 11, true])
                      ], '200')
                    ], {
                      'pd': [0, 0, 12, 12]
                    }),
                  ]),
                  [null, null, Colors.white],
                  {
                    'pd': [0, 10, 0, 8]
                  },
                ),
              ),
               PWidget.spacer(),
               PWidget.container(
                  PWidget.row([
                    Expanded(child: Text("")),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colours.app_main)),
                        child: PWidget.row([
                          PWidget.icon(Icons.file_download, [Colors.white, 15]),
                          PWidget.boxw(4),
                          Text("保存图片",
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ]),
                        onPressed: () {
                          savePhoto();
                        }),
                    Expanded(child: Text("")),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colours.app_main)),
                        child: PWidget.row([
                          PWidget.icon(Icons.ios_share_outlined, [Colors.white, 15]),
                          PWidget.boxw(4),
                          Text("分享好货",
                              style: TextStyle(color: Colors.white, fontSize: 14))
                        ]),
                        onPressed: () {
                          shareGoods();
                        }),
                    Expanded(child: Text("")),
                  ]),
                  [
                    null,
                    40,
                    Colours.app_main
                  ], //宽度，高度，背景色
                  {
                    'br': PFun.lg(6, 6, 6, 6), //圆角
                    'mg': PFun.lg(0, 20, 20, 20) //margin
                  }),
               ]),
                [null, null, Colors.white])
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    data = widget.data['res'];
    detailDm.addObject(data);
    String platType = widget.data['platType'];
    iconPath = getIconPath(platType);
    getPlatTypeDetail(platType);
    initShareInfo();
  }

  Future initShareInfo() async {
    Map data = getHbData(fee, widget.data['platType']);
    String min = data['min'];
    String max = data['max'];
    shareMap['t'] = title;
    shareMap['ep'] = endPrice;
    shareMap['sp'] = startPrice;
    shareMap['s'] = sale;
    shareMap['hi'] = min;
    shareMap['hm'] = max;
    shareMap['img'] = pic;
    shareMap['al'] = 'sfb/logo/logo.png';
    shareMap['an'] = APP_NAME;
    shareMap['ad'] = '$APP_NAME 购物拆红包';
    shareMap['ku'] = widget.data['res']['klUrl'];
    shareMap['v'] = base64Encode(utf8.encode(Global.userinfo!.code));

    String vars = '';
    List<String> keys = shareMap.keys.toList();
    for(int i = 0; i < keys.length; i++) {
      String key = keys[i];
      vars += '$key=${shareMap[key]}&';
    }

    String longUrl = '${Global.homeUrl['shareGoods']}?$vars';
    //由接口做urlencode
    shareUrl = await BService.shortLink(Uri.encodeComponent(longUrl));
    setState(() {

    });
  }

  String getIconPath(String platType) {
    switch (platType) {
      case 'JD':
        shareMap['logo'] = 'jd.png';
        return 'assets/images/mall/jd.png';
      case 'PDD':
        shareMap['logo'] = 'pdd.png';
        return 'assets/images/mall/pdd.png';
      case 'DY':
        shareMap['logo'] = 'dy.png';
        return 'assets/images/mall/dy.png';
      case 'VIP':
        shareMap['logo'] = 'vip.png';
        return 'assets/images/mall/vip.png';
    }
    shareMap['logo'] = 'tb.png';
    return 'assets/images/mall/tb.png';
  }

  void getPlatTypeDetail(String platType) {
    switch (platType) {
      case 'TB':
        fee = detailDm.object?['commissionRate'] *
            detailDm.object?['actualPrice'] /
            100;
        startPrice = data['originalPrice'].toString();
        endPrice = data['actualPrice'].toString();
        title = data['dtitle'] == '' ? data['title'] : data['dtitle'];
        sale = BService.formatNum(data['monthSales']);
        pic = data['mainPic'];
        break;
      case 'JD':
        fee = detailDm.object?['commission'];
        pic = data['picMain'];
        title = data['skuName'];
        endPrice = data['actualPrice'].toString();
        startPrice = data['originPrice'].toString();
        sale = BService.formatNum(data?['inOrderCount30Days']);
        break;
      case 'PDD':
        fee = detailDm.object?['promotionRate'] *
            detailDm.object?['minGroupPrice'] /
            100;
        pic = data['goodsThumbnailUrl'];
        title = data['goodsName'];
        startPrice = detailDm.object!['minNormalPrice'].toString();
        endPrice = detailDm.object!['minGroupPrice'].toString();
        sale = data['salesTip'];
        break;
      case 'DY':
        fee = detailDm.object?['cosFee'];
        pic = data['cover'];
        title = data['title'];
        endPrice = data['couponPrice'] > 0
            ? data['couponPrice'].toString()
            : data['price'].toString();
        startPrice = data['price'].toString();
        sale = BService.formatNum(data['sales']);
        break;
      case 'VIP':
        fee = double.parse(detailDm.object?['commission']);
        pic = data['goodsMainPicture'];
        title = data['goodsName'];
        startPrice = data['marketPrice'];
        endPrice = data['vipPrice'];
        sale = data['productSales'];
        break;
    }
  }

  void copyLink() {
    if (!Global.login) {
      return;
    }
    FlutterClipboard.copy(getShareContent())
        .then((value) => ToastUtils.showToast('复制成功'));
  }
  void savePhoto() async {
    if (!Global.login) {
      return;
    }
    Loading.show(context);
    boundaryKey = glokey;
    await RepaintBoundaryUtils().savePhoto();
    Loading.hide(context);
  }
  void shareGoods() async {
    if (!Global.login) {
      return;
    }
    boundaryKey = glokey;
    String filePath = await RepaintBoundaryUtils().captureImage();
    if (filePath != null) {
      ShareDialog.showShareDialog(context, filePath);
    }
  }

}
