/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 查券弹窗弹窗
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';

class ContentParseDialog extends Dialog {
  final int code;
  final Map data;
  ContentParseDialog(this.code, this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //名字为空或者 code!=200 拼多多商品说明是无券商品，弹出全网搜索
    String itemName = data['item_title']??'';
    if(code != 200 || data['plat_type'] == 3 || itemName.isEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
        child: Column(
          children: [
            PWidget.boxh(20),
            Center(
              child: Text(
                itemName.isEmpty ? data['originContent']??'' : itemName,
                style: TextStyle(),
              ),
            ),
            PWidget.boxh(20),
            Center(
              child: Text(
                '该商品不存在优惠券，点击全网搜索',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            PWidget.boxh(20),
            Column(
              children: [
                _createSearchButton(context, true),
                PWidget.boxh(8),
              ],
            )
          ],
        ),
      );
    }
    data['platType'] = getPlatType(data['plat_type']);
    return Container(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      child: Column(
        children: [
          Center(
            child: Text(
              '已为您找到',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          PWidget.boxh(8),
          _createContent(context),
          PWidget.boxh(8),
          Column(
            children: [
              PWidget.row([_createSearchButton(context, false),PWidget.boxw(10),_createButton(context, true)],
              '221'
              ),
              PWidget.boxh(8),
            ],
          )
        ],
      ),
    );
  }
  _createContent(BuildContext context) {
    String platType = data['platType'];
    String iconPath = getIconPath(platType);
    num itemPrice = num.parse(data['item_price']);
    num itemEndPrice = num.parse(data['item_end_price']);
    num couponPrice = itemPrice - itemEndPrice;

    num amount;
    if(Global.isEmpty(data['rates'])) {
      amount = 0;
    } else {
      amount = num.parse(data['rates']) * itemEndPrice/100;
    }
    return PWidget.container(
      PWidget.row(
        [
          Stack(children: [
            PWidget.wrapperImage(data['item_pic'], [100, 100], {'br': 8}),
            Stack(children: [
              PWidget.image(iconPath, [14, 14]),

            ]),
          ]),
          PWidget.boxw(8),
          PWidget.column([
            PWidget.row([
              PWidget.text(data['item_title'], [Colors.black.withOpacity(0.75), 14], {'max':2, 'exp': true}),
            ]),
            PWidget.boxh(8),
            if(couponPrice > 0)
              PWidget.row([
                PWidget.container(
                  PWidget.text('补贴', [Colors.white, 12]),
                  [null, null, Colors.red],
                  {'bd': PFun.bdAllLg(Colors.red, 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(4, 0, 4, 0)},
                ),
                PWidget.container(
                  PWidget.text('', [Colors.red, 12],{},[
                    PWidget.textIs(' ${couponPrice.toStringAsFixed(2)}元', [Colors.red, 12]),
                  ]),
                  {'bd': PFun.bdAllLg(Colors.red, 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(0, 4, 0, 4)},
                ),
              ]),
            PWidget.boxh(2),
            PWidget.row([
              getMoneyWidget(context, amount, platType),
            ]),
            PWidget.spacer(),
            getPriceWidget(itemEndPrice, itemPrice, endTextColor: Colors.red,endPrefix: ' 到手约 ')
          ], {
            'exp': 1,
          }),
        ],
        '001',
        {'fill': true},
      ),
      [null, null, Colors.white],
      {'pd': 3, },
    );
  }


  _createButton(BuildContext context, bool agree) {
    return TextButton (
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(agree ? Colours.app_main : Colors.white),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                )
            )
        ),
        onPressed: () {
          Navigator.pop(context);
          if (agree) {
            String url = '/detail';
            if(data['platType'] == 'jd') {
              url = '/detailJD';
            } else if(data['platType'] == 'pdd') {
              url = '/detailPDD';
            }else if(data['platType'] == 'dy') {
              url = '/detailDY';
            }else if(data['platType'] == 'vip') {
              url = '/detailVIP';
              data['category'] = 'vip';
            }
            Navigator.pushNamed(context, url, arguments: data);
          } else {
            SystemNavigator.pop();

          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: agree
                ? [
              Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              Text(
                '领取优惠',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ]
                : [
              Text(
                '不同意',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ));
  }
  _createSearchButton(BuildContext context, bool dark) {
    return TextButton (
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(dark ? Colours.app_main : Colors.white),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(color: dark ? Colors.white : Colours.app_main),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                )
            ),
        ),
        onPressed: () {
          Navigator.pop(context);
          data['showArrowBack'] = true;
          Navigator.pushNamed(context, '/searchResult', arguments: data);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              Text(
                '全网搜索',
                style: TextStyle(
                  color: dark ? Colors.white : Colours.app_main,
                  fontSize: 14,
                ),
              ),
            ]
          ),
        ));
  }

  String getIconPath(platType) {
    switch (platType){
      case 'jd':
        return 'assets/images/mall/jd.png';
      case 'pdd':
        return 'assets/images/mall/pdd.png';
      case 'dy':
        return 'assets/images/mall/dy.png';
      case 'vip':
        return 'assets/images/mall/vip.png';
    }
    return 'assets/images/mall/tm.png';
  }
  String getPlatType(platType) {
    switch (platType){
      case 2:
        return 'jd';
      case 3:
        return 'pdd';
      case 4:
        return 'dy';
      case 5:
        return 'vip';
    }
    return 'tb';
  }
}
