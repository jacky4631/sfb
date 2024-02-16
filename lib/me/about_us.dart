/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../util/launchApp.dart';
import '../util/toast_utils.dart';
import '../service.dart';
import '../util/global.dart';
import '../generated/l10n.dart';
import '../widget/CustomWidgetPage.dart';
//关于我们
class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context,
          title: S.of(context).aboutUs,
          widgetColor: Colors.black,
          leftIcon: Icon(Icons.arrow_back_ios)),
      body: PWidget.container(
          Column(
            children: [
              Expanded(
                  child: PWidget.ccolumn([
                PWidget.image(
                    'assets/images/logo.png', [100, 100], {'crr': 25}),
                PWidget.boxh(10),
                Text('— $APP_NAME 全场宝贝都有券 外卖红包天天有 —'),
                PWidget.boxh(10),
                Text('V$version'),
                Padding(padding: EdgeInsets.only(top: 50)),
              ])),
              //按钮
              RawMaterialButton(
                //宽高
                constraints: BoxConstraints(minHeight: 44),
                //背景颜色
                // fillColor: Colors.redAccent,
                //圆角
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(25)),
                // ),
                //点击事件
                onPressed: () {
                  _update();
                },
                child: Row(
                  //此时主轴 Column 纵向 字体居中
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '检查更新',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Divider(),
                    RichText(
                        text: TextSpan(
                      text: '',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '《用户服务协议》',
                          style: TextStyle(color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Global.showProtocolPage(Global.userUrl, '用户服务协议');
                            },
                        ),
                        TextSpan(
                          text: '  ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: '《$APP_NAME隐私政策》',
                          style: TextStyle(color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Global.showProtocolPage(
                                  Global.privacyUrl, '$APP_NAME隐私政策');
                            },
                        ),
                      ],
                    )),
                    PWidget.boxh(10),
                    Text(COMPANY_NAME),
                    PWidget.boxh(20),
                  ],
                ),
              )
            ],
          ),
          {
            'pd': [80, MediaQuery.of(context).padding.bottom + 20, 20, 20]
          }),
    );
  }

  void _update() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Global.isWeb()) {
      return;
    }
    String version = packageInfo.version;
    Map res = await BService.updateConfig();
    if (res != null) {
      String enable = res['enable'];
      if (enable == '0') {
        return;
      }
      String url;
      String latestVersion;
      if (Global.isIOS()) {
        url = res['iosUrl'];
        latestVersion = res['iosVersion'];
      } else {
        url = res['androidUrl'];
        latestVersion = res['androidVersion'];
      }
      //1.0.15 需要判断第一个数字大于提示升级，第二个数字大于时提示升级 第三个数字大于时提示升级
      List<String> curs = version.split('.');
      List<String> las = latestVersion.split('.');
      if (curs.length != las.length) {
        return;
      }
      if(num.parse(las[0])>num.parse(curs[0])
          || (num.parse(las[0])==num.parse(curs[0]) && num.parse(las[1])>num.parse(curs[1]))
          || (curs.length > 2 && num.parse(las[0])==num.parse(curs[0]) &&
              num.parse(las[1])==num.parse(curs[1]) &&
              num.parse(las[2])>num.parse(curs[2]))) {
        showSignDialog(context, title: '新版本上线啦', desc: '立即更新', okTxt: '去更新',
            () {
          LaunchApp.launchInBrowser(url);
          // launchUrl(Uri.parse(url));
        });
      } else {
        ToastUtils.showToast('暂无更新');
        return;
      }
    }
  }
}
