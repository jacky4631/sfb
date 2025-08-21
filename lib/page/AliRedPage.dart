/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:sufenbao/util/global.dart';

import '../util/toast_utils.dart';

///支付宝红包
class AliRedPage extends StatefulWidget {
  final Map? data;

  const AliRedPage(this.data, {Key? key}) : super(key: key);

  @override
  _AliRedPageState createState() => _AliRedPageState();
}

class _AliRedPageState extends State<AliRedPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7AB4FE), Color(0xFF7AB4FE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // 背景图片
          Container(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/alired.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 标题栏
          titleBarView(),
          // 文字说明
          Positioned(
            top: 360,
            left: 110,
            right: 110,
            child: Container(
              width: 200,
              height: 60,
              color: Colors.transparent,
              child: Text(
                '复制 ${Global.appInfo.alired} 打开支付宝去搜索，红包拿来，实惠优享',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // 底部按钮
          btmBarView(),
        ],
      ),
    );
  }

  ///标题栏视图
  Widget titleBarView() {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        8,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView() {
    return Positioned(
      top: 500,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          FlutterClipboard.copy(Global.appInfo.alired).then((value) {
            ToastUtils.showToast('复制成功', bgColor: Color(0xFF4283D5));
          });
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(
            70,
            8,
            70,
            MediaQuery.of(context).padding.bottom + 8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: AspectRatio(
              aspectRatio: 460 / 95,
              child: Image.network(
                'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/aliredbtn.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
