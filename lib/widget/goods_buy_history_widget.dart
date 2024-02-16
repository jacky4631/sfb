/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/custom_scroll_physics.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

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
        pageCon.page?.toInt() == goodsBuyHistoryDm.list.length - 1 ? 0 : (pageCon.page?.toInt()??0) + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    if(timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  ///商品购买历史记录
  var goodsBuyHistoryDm = DataModel();
  Future<int> goodsBuyHistory() async {
    var url = 'https://cmscg.dataoke.com/cms-v2/goods-buy-history';
    var res = await http.get(Uri.parse(url)).catchError((v) {
      goodsBuyHistoryDm.toError('网络异常');
    });
    if (res != null) {
      goodsBuyHistoryDm.addList(jsonDecode(res.body)['data'], true, 0);
      // flog(goodsBuyHistoryDm.toJson());
      setState(() {});
    }
    return goodsBuyHistoryDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    if (goodsBuyHistoryDm.list.isEmpty) return PWidget.boxh(0);
    return PWidget.positioned(
      PWidget.container(
        PageView.builder(
          controller: pageCon,
          scrollDirection: Axis.vertical,
          physics: PagePhysics(),
          itemCount: goodsBuyHistoryDm.list.length,
          itemBuilder: (_, i) {
            var goodsBuyHistory = goodsBuyHistoryDm.list[i];
            var userHead = goodsBuyHistory['taobao_user_head'];
            var str = '过去${Random().nextInt(20) + 1}分钟刚领券购买了这个商品~';
            var nickName = goodsBuyHistory['taobao_user_nick'].toString();
            var nickName1 = nickName.substring(0, 2);
            var nickName2 = nickName.substring(nickName.length - 2);
            return PWidget.row([
              PWidget.wrapperImage(userHead, [24, 24], {'br': 24}),
              PWidget.boxw(8),
              PWidget.text('$nickName1***$nickName2 $str', [Colors.white, 12], {'exp': true}),
            ]);
          },
        ),
        [null, 32, Colors.black54],
        {'crr': 56, 'pd': 4},
      ),
      [null, 56, 16, 72],
    );
  }
}
