/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';

import 'package:settings_ui/settings_ui.dart';
import 'package:sufenbao/util/global.dart';

import '../util/colors.dart';
import '../generated/l10n.dart';
import '../index/Index.dart';
import '../widget/custom_button.dart';

//个人设置页面
class Settings extends StatefulWidget {
  final Map data;
  const Settings(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('设置', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          SettingsList(
            lightTheme: SettingsThemeData(settingsListBackground: Colors.white),
            contentPadding: EdgeInsets.all(0),
            sections: [
              SettingsSection(
                margin: EdgeInsetsDirectional.only(top: 5),
                tiles: <SettingsTile>[
                  if (Global.login)
                    SettingsTile.navigation(
                      title: Text('完善个人信息'),
                      trailing: createArrowIcon(),
                      onPressed: (context) {
                        Navigator.pushNamed(context, "/personal", arguments: widget.data);
                      },
                    ),
                  if (Global.login)
                    SettingsTile.navigation(
                      title: Text('账户与安全'),
                      trailing: createArrowIcon(),
                      onPressed: (context) {
                        Navigator.pushNamed(context, "/authPage", arguments: widget.data);
                      },
                    ),
                  if (Global.login)
                    SettingsTile.navigation(
                      title: Text('地址管理'),
                      trailing: createArrowIcon(),
                      onPressed: (context) {
                        Navigator.pushNamed(context, "/addressList");
                      },
                    ),
                  SettingsTile.navigation(
                    title: Text('隐私政策'),
                    trailing: createArrowIcon(),
                    onPressed: (context) {
                      Global.showProtocolPage(Global.privacyUrl, '$APP_NAME隐私政策');
                    },
                  ),
                  if (Global.login)
                    SettingsTile.navigation(
                      title: Text('吐槽我们'),
                      trailing: createArrowIcon(),
                      onPressed: (context) {
                        Navigator.pushNamed(context, '/feedback');
                      },
                    ),
                  SettingsTile.navigation(
                    title: Text('推送设置'),
                    trailing: createArrowIcon(),
                    onPressed: (context) {
                      final JPushFlutterInterface jpush = JPush.newJPush();
                      jpush.openSettingsForNotification();
                    },
                  ),
                  SettingsTile.navigation(
                    title: Text(S.of(context).aboutUs),
                    trailing: createArrowIcon(),
                    onPressed: (context) {
                      Navigator.pushNamed(context, '/aboutUs');
                    },
                  ),
                  SettingsTile.navigation(
                    title: Text('个人信息收集清单'),
                    trailing: createArrowIcon(),
                    onPressed: (context) {
                      Global.showProtocolPage(Global.collectUrl, '个人信息收集清单');
                    },
                  ),
                  SettingsTile.navigation(
                    title: Text('个人信息共享清单'),
                    trailing: createArrowIcon(),
                    onPressed: (context) {
                      Global.showProtocolPage(Global.shareUrl, '个人信息共享清单');
                    },
                  ),
                ],
              ),
            ],
          ),
          if (Global.login) btmBarView(context)
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: SafeArea(
          child: Column(
        children: [
          CustomButton(
            bgColor: Colours.app_main,
            showIcon: false,
            textColor: Colors.white,
            text: '退出登录',
            onPressed: () {
              Global.clearUser();
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => Index()), (Route router) => false);
            },
          )
        ],
      )),
    );
  }

  createArrowIcon() {
    return Icon(
      Icons.arrow_forward_ios,
      color: Colors.grey,
      size: 16,
    );
  }
}
