/** *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';


import '../../util/colors.dart';
import '../../util/global.dart';

class HelpFanliPage extends StatefulWidget {
  @override
  _HelpFanliState createState() => _HelpFanliState();
}

class _HelpFanliState extends State<HelpFanliPage> {
  late String version = '';
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version; //读取属性
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.app_main,
      appBar: AppBar(
        title: Text(
          '开红包教程',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colours.app_main,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
        child: ListView.builder(
          itemCount: getWidgets().length,
          itemBuilder: (context, i) {
            return getWidgets()[i];
          },
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      Container(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(      
            'assets/images/logo.png',
            height: 100,
          ),
        ),
      ),
      SizedBox(height: 30),
      Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '"简单',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '四步',
                style: TextStyle(color: Colors.yellow[800], fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '，轻松领红包"',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 30),
      Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(8, 8, 15, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: RichText(
                maxLines: 2,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '【一】',
                      style: TextStyle(color: Colors.yellow[900], fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' 打开 ',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '淘宝、京东、拼多多、唯品会、抖音',
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' 任意一款你想要的商品',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/mall/tb.png', width: 32, height: 32),
                SizedBox(width: 10),
                Image.asset('assets/images/mall/jd.png', width: 32, height: 32),
                SizedBox(width: 10),
                Image.asset('assets/images/mall/pdd.png', width: 32, height: 32),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/helpVideo',
                      arguments: {'title': '唯品会领券帮助', 'url':'viphelp.mp4'}),
                  child: Image.asset('assets/images/mall/vip.png', width: 32, height: 32),
                ),
                SizedBox(width: 10),
                Image.asset('assets/images/mall/dy.png', width: 32, height: 32),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: RichText(
                maxLines: 2,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '【二】',
                      style: TextStyle(color: Colors.yellow[900], fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '点击右上角 ',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '分享',
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '，然后点击 ',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '复制链接 ',
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Image.asset('assets/images/help/copylink.png', width: 336, height: 150),
            ),
            SizedBox(height: 20),
            RichText(
              maxLines: 2,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '【三】',
                    style: TextStyle(color: Colors.yellow[900], fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '打开 ',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: APP_NAME,
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' 领取优惠',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              child: Image.asset('assets/images/help/pickcou.png', width: 600, height: 250),
            ),
            SizedBox(height: 20),
            RichText(
              maxLines: 2,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '【四】',
                    style: TextStyle(color: Colors.yellow[900], fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '成功下单，进入 ',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '我的->订单中心',
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '，等待订单解锁，拆红包',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Image.asset('assets/images/help/chb.png', width: 600, height: 600),
            ),
            SizedBox(height: 30),
          ],
        ),
      )
    ];
  }
}
