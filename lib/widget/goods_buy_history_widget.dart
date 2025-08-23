/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SimpleDataModel {
  List<dynamic> list = [];
  int flag = 0;
  String error = '';

  void addList(List<dynamic> data, bool clear, int total) {
    if (clear) {
      list.clear();
    }
    list.addAll(data);
    flag = 1;
  }

  void toError(String errorMsg) {
    error = errorMsg;
    flag = -1;
  }
}

class CustomPagePhysics extends ScrollPhysics {
  const CustomPagePhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPagePhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}

///商品购买历史小部件
class GoodsBuyHistoryWidget extends StatefulWidget {
  @override
  _GoodsBuyHistoryWidgetState createState() => _GoodsBuyHistoryWidgetState();
}

class _GoodsBuyHistoryWidgetState extends State<GoodsBuyHistoryWidget> {
  late Timer timer;

  var pageCon = PageController();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.goodsBuyHistory();
    timer = Timer.periodic(Duration(seconds: 5), (t) {
      pageCon.animateToPage(
        pageCon.page?.toInt() == goodsBuyHistoryDm.list.length - 1 ? 0 : (pageCon.page?.toInt() ?? 0) + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  ///商品购买历史记录
  var goodsBuyHistoryDm = SimpleDataModel();
  Future<int> goodsBuyHistory() async {
    var url = 'https://cmscg.dataoke.com/cms-v2/goods-buy-history';
    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        goodsBuyHistoryDm.addList(jsonDecode(res.body)['data'], true, 0);
        setState(() {});
      } else {
        goodsBuyHistoryDm.toError('网络异常');
      }
    } catch (e) {
      goodsBuyHistoryDm.toError('网络异常');
    }
    return goodsBuyHistoryDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    if (goodsBuyHistoryDm.list.isEmpty) return SizedBox(height: 0);
    return Positioned(
      bottom: 56,
      left: 16,
      right: 72,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(56),
        ),
        padding: EdgeInsets.all(4),
        child: PageView.builder(
          controller: pageCon,
          scrollDirection: Axis.vertical,
          physics: CustomPagePhysics(),
          itemCount: goodsBuyHistoryDm.list.length,
          itemBuilder: (_, i) {
            var goodsBuyHistory = goodsBuyHistoryDm.list[i];
            var userHead = goodsBuyHistory['taobao_user_head'];
            var str = '过去${Random().nextInt(20) + 1}分钟刚领券购买了这个商品~';
            var nickName = goodsBuyHistory['taobao_user_nick'].toString();
            var nickName1 = nickName.substring(0, 2);
            var nickName2 = nickName.substring(nickName.length - 2);
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    userHead,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 24,
                        color: Colors.grey[200],
                        child: Icon(Icons.person, size: 16, color: Colors.grey),
                      );
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$nickName1***$nickName2 $str',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
