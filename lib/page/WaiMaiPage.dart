/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';

import '../service.dart';
import '../util/paixs_fun.dart';
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
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      appBar: buildTitle(context,
          title: '外卖红包',
          widgetColor: Colors.black,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Color(0xFFFEE5D2), Color(0xFFFED9BB))}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            body: Stack(children: [
              ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  var activity = data[index];
                  var image = activity['activity_image'];
                  var imageRatio = 69/39;
                  if(index == 0) {
                    imageRatio = 162 / 70;
                    image = 'https://img.meituan.net/adunion/c0f09c49aff944fc0fd0caeb6f9ec56e54897.png@0_0_0_340a';
                  }
                  return PWidget.container(
                      PWidget.stack([
                        PWidget.wrapperImage(
                            image,
                            {'ar': imageRatio,'br':10,
                              'fun':() async{
                                int type = activity['type'];
                                Loading.show(context);
                                var res = await BService.waimaiActivityWord(activity['activity_id'], type);
                                Loading.hide(context);
                                if(type == 1) {
                                  Global.launchMeituanWechat(context, url: res['url']);
                                } else {
                                  Global.openEle(res['wx_path']);
                                }

                              }
                            }),
                        PWidget.positioned(
                          PWidget.row([
                            PWidget.image(
                                'assets/images/share/wx.png', [12, 12]),
                            PWidget.boxw(5),
                            PWidget.text('微信小程序', [Colors.white, 12, true]),
                      ]),
                          [null, 5, 5, null],
                        ),
                      ]),{'pd':15,'br':10}
                  );
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
