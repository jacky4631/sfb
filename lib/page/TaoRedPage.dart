import 'package:flutter/material.dart';

import '../util/global.dart';
import '../util/launchApp.dart';

///淘宝看视频领红包
class TaoRedPage extends StatefulWidget {
  final Map? data;

  const TaoRedPage(this.data, {Key? key}) : super(key: key);

  @override
  _TaoRedPageState createState() => _TaoRedPageState();
}

class _TaoRedPageState extends State<TaoRedPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
  }

  // 获取安全区域的顶部内边距
  EdgeInsets get pmPadd => MediaQuery.of(context).padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 渐变背景
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE95B4F), Color(0xFFDF462F)],
              ),
            ),
          ),
          // 主要内容
          Column(
            children: [
              SizedBox(height: 100),
              // 第一张图片
              AspectRatio(
                aspectRatio: 750 / 1029,
                child: Image.network(
                  'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhb1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // 第二张图片和文字叠加
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 750 / 123,
                    child: Image.network(
                      'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhb2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 32,
                    top: 2,
                    bottom: 4,
                    child: Text(
                      '67💲I7udWmNlxLd₴ ${Global.appInfo.taored}  CZ0002 最少0.3元，至高2500元！帮我助力，你也可以领~',
                      style: TextStyle(color: Colors.white),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // 第三张图片（可点击）
              GestureDetector(
                onTap: () {
                  LaunchApp.launchTb(context, Global.appInfo.taored);
                },
                child: AspectRatio(
                  aspectRatio: 750 / 146,
                  child: Image.network(
                    'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhb4.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          // 标题栏
          titleBarView(),
        ],
      ),
    );
  }

  ///标题栏视图
  Widget titleBarView() {
    return Container(
      height: 56 + pmPadd.top,
      padding: EdgeInsets.only(
        top: pmPadd.top + 8,
        bottom: 8,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
}
