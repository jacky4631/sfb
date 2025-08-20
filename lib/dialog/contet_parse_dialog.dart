/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 查券弹窗弹窗
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/colors.dart';
import '../util/global.dart';
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
            SizedBox(height: 20),
            Center(
              child: Text(
                itemName.isEmpty ? data['originContent']??'' : itemName,
                style: TextStyle(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '该商品不存在优惠券，点击全网搜索',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                _createSearchButton(context, true),
                SizedBox(height: 8),
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
          SizedBox(height: 8),
          _createContent(context),
          SizedBox(height: 8),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _createSearchButton(context, false),
                  SizedBox(width: 8),
                  _createButton(context, true)
                ],
              ),
              SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }
  Widget _createContent(BuildContext context) {
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
    return Container(
      padding: EdgeInsets.all(3),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['item_pic'] ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            Stack(children: [
              Image.asset(
                iconPath,
                width: 14,
                height: 14,
              ),
            ]),
          ]),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['item_title'] ?? '',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                if(couponPrice > 0)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          '补贴',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          ' ${couponPrice.toStringAsFixed(2)}元',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 2),
                Row(
                  children: [
                    getMoneyWidget(context, amount, platType),
                  ],
                ),
                Spacer(),
                getPriceWidget(itemEndPrice, itemPrice, endTextColor: Colors.red,endPrefix: ' 到手约 ')
              ],
            ),
          ),
        ],
      ),
    );
  }


  _createButton(BuildContext context, bool agree) {
    return TextButton (
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(agree ? Colours.app_main : Colors.white),
            shape: WidgetStateProperty.all(
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
          padding: EdgeInsets.only(left: 25, right: 25),
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
            backgroundColor: WidgetStateProperty.all(dark ? Colours.app_main : Colors.white),
            shape: WidgetStateProperty.all(
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
