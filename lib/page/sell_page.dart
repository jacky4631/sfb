/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sufenbao/util/tao_util.dart';

import '../me/model/userinfo.dart';
import '../service.dart';
import '../share/ShareDialog.dart';
import '../util/colors.dart';
import '../util/custom.dart';
import '../util/global.dart';
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
  Map<String, dynamic> detailData = {'actualPrice': ''};
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
  bool loading = true;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    if (Global.userinfo == null) {
      Map<String, dynamic> json = await BService.userinfo(baseInfo: true);
      if (json.isEmpty) {
        return;
      }
      Global.userinfo = Userinfo.fromJson(json);
    }
    loading = false;
    setState(() {});
    data = widget.data['res'];
    detailData = Map<String, dynamic>.from(data);
    String platType = widget.data['platType'];
    iconPath = getIconPath(platType);
    getPlatTypeDetail(platType);
    initShareInfo();
  }

  // 构建标题栏的辅助方法
  PreferredSizeWidget buildTitle(
    BuildContext context, {
    required String title,
    Color? widgetColor,
    Color? color,
    Widget? leftIcon,
  }) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: widgetColor ?? Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: leftIcon != null
          ? IconButton(
              icon: leftIcon,
              onPressed: () => Navigator.pop(context),
            )
          : null,
      backgroundColor: color ?? Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildTitle(context,
          title: '转卖好货',
          widgetColor: Colors.black,
          color: Colors.white,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: glokey,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 8),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(18, 8, 12, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(iconPath, width: 14, height: 14),
                            SizedBox(width: 10),
                            Expanded(child: getTitleWidget(title, size: 16))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 8, 12, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: getPriceWidget(endPrice, startPrice,
                                  endTextSize: 24, startPrefix: '原价 ', endPrefixSize: 16),
                            ),
                            Text(
                              '已售${sale}件',
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 4, 12, 8),
                        child: Row(
                          children: [
                            getMoneyWidget(context, fee, widget.data['platType'], column: false),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 24, 10, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildProductImage(pic),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18, 0, 12, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset('assets/images/logo.png', width: 30, height: 30),
                                      ),
                                      SizedBox(width: 12),
                                      Text(APP_NAME,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text('— $APP_NAME 购物拆红包 —',
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  if (!loading)
                                    Text('邀请口令：${Global.userinfo!.code}',
                                        style:
                                            TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                shareUrl.isNotEmpty
                                    ? QrImageView(
                                        data: shareUrl,
                                        version: QrVersions.auto,
                                        size: 120.0,
                                        gapless: false,
                                        embeddedImage: AssetImage(qrImage),
                                      )
                                    : SizedBox(),
                                SizedBox(width: 10),
                                Text('长按二维码领券购买',
                                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
              decoration: BoxDecoration(
                color: Colours.app_main,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(child: Text("")),
                  TextButton(
                      style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colours.app_main)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.file_download, color: Colors.white, size: 15),
                          SizedBox(width: 4),
                          Text("保存图片", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      onPressed: () {
                        savePhoto();
                      }),
                  Expanded(child: Text("")),
                  TextButton(
                      style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colours.app_main)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.ios_share_outlined, color: Colors.white, size: 15),
                          SizedBox(width: 4),
                          Text("分享好货", style: TextStyle(color: Colors.white, fontSize: 14))
                        ],
                      ),
                      onPressed: () {
                        shareGoods();
                      }),
                  Expanded(child: Text("")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        width: 100,
        height: 370,
        color: Colors.grey[200],
        child: Icon(Icons.image, color: Colors.grey),
      );
    }
    return Image.network(
      imageUrl,
      width: 100,
      height: 370,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 100,
          height: 370,
          color: Colors.grey[200],
          child: Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
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
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      vars += '$key=${shareMap[key]}&';
    }

    String longUrl = '${Global.appInfo.shareGoods}?$vars';
    //由接口做urlencode
    shareUrl = await BService.shortLink(Uri.encodeComponent(longUrl));
    setState(() {});
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
        fee = detailData['commissionRate'] * detailData['actualPrice'] / 100;
        startPrice = data['originalPrice'].toString();
        endPrice = data['actualPrice'].toString();
        title = data['dtitle'] == '' ? data['title'] : data['dtitle'];
        sale = BService.formatNum(data['monthSales']);
        pic = data['mainPic'];
        break;
      case 'JD':
        fee = detailData['commission'];
        pic = data['picMain'];
        title = data['skuName'];
        endPrice = data['actualPrice'].toString();
        startPrice = data['originPrice'].toString();
        sale = BService.formatNum(data['inOrderCount30Days']);
        break;
      case 'PDD':
        fee = detailData['promotionRate'] * detailData['minGroupPrice'] / 100;
        pic = data['goodsThumbnailUrl'];
        title = data['goodsName'];
        startPrice = detailData['minNormalPrice'].toString();
        endPrice = detailData['minGroupPrice'].toString();
        sale = data['salesTip'];
        break;
      case 'DY':
        fee = detailData['cosFee'];
        pic = data['cover'];
        title = data['title'];
        endPrice = data['couponPrice'] > 0 ? data['couponPrice'].toString() : data['price'].toString();
        startPrice = data['price'].toString();
        sale = BService.formatNum(data['sales']);
        break;
      case 'VIP':
        fee = double.parse(detailData['commission']);
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
    FlutterClipboard.copy(getShareContent()).then((value) => ToastUtils.showToast('复制成功'));
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
    if (filePath.isNotEmpty) {
      ShareDialog.showShareDialog(context, filePath);
    }
  }
}
