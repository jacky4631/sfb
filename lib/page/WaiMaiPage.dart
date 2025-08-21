/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/global.dart';

import '../service.dart';
import '../widget/loading.dart';

///外卖红包
class WaiMaiPage extends StatefulWidget {
  final Map? data;

  const WaiMaiPage(this.data, {Key? key}) : super(key: key);

  @override
  _AliRedPageState createState() => _AliRedPageState();
}

class _AliRedPageState extends State<WaiMaiPage> {
  List data = [];
  
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    var res = await BService.waimaiActivityList();
    if (res != null) {
      data = res;
    }
    setState(() {});
  }

  AppBar buildTitle(BuildContext context, {
    required String title,
    required Color widgetColor,
    Widget? leftIcon,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: widgetColor),
      ),
      leading: leftIcon != null
          ? IconButton(
              icon: leftIcon,
              onPressed: () => Navigator.pop(context),
            )
          : null,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTitle(
        context,
        title: '外卖红包',
        widgetColor: Colors.black,
        leftIcon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFEE5D2), Color(0xFFFED9BB)],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    var activity = data[index];
                    var image = activity['activity_image'];
                    var imageRatio = 69 / 39;
                    if (index == 0) {
                      imageRatio = 162 / 70;
                      image = 'https://img.meituan.net/adunion/c0f09c49aff944fc0fd0caeb6f9ec56e54897.png@0_0_0_340a';
                    }
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              int type = activity['type'];
                              Loading.show(context);
                              var res = await BService.waimaiActivityWord(
                                  activity['activity_id'], type);
                              Loading.hide(context);
                              if (type == 1) {
                                Global.launchMeituanWechat(context,
                                    url: res['url']);
                              } else {
                                Global.openEle(res['wx_path']);
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: imageRatio,
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            bottom: 5,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/share/wx.png',
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '微信小程序',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
