/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sufenbao/util/avatar_helper.dart';

import '../util/toast_utils.dart';
import '../service.dart';
import '../util/global.dart';
import 'listener/PersonalNotifier.dart';

class Personal extends StatefulWidget {
  final Map data;
  const Personal(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> with TickerProviderStateMixin {
  String imgUrl = '';

  late num spreadUid = 0;
  late Map wxProfile = {};
  @override
  void initState() {
    super.initState();
    initData();
  }
  Future initData() async {
    Map<String, dynamic> json = await BService.userinfo();
    Map wxMap = await BService.userWxProfile();

    setState(() {
      imgUrl = json['avatar'];
      spreadUid = json['spreadUid'];
      wxProfile = wxMap['wxProfile']?? {};
    });

  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context,
          title: '个人信息',
          widgetColor: Colors.black,
          leftIcon: Icon(Icons.arrow_back_ios)),
      body: SettingsList(
        lightTheme: SettingsThemeData(settingsListBackground: Colors.white),
        contentPadding: EdgeInsets.all(0),
        sections: [
          SettingsSection(
            margin: EdgeInsetsDirectional.only(top: 5),
            tiles: createTiles(),
          ),
        ],
      ),
    );
  }

  createTiles() {
    return <SettingsTile>[
      SettingsTile.navigation(
        title: Text('头像'),
        trailing: Row(
          children: [
            if(!Global.isEmpty(imgUrl))
            ClipRRect(
                borderRadius: BorderRadius.circular(28), //设置圆角

                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  height: 48,
                  width: 48,
                )),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) async {
          if(await Global.isHuawei()) {
            int version = await Global.getAndroidVersion();
            PermissionStatus status;
            if(version>= 33) {
              status = await Permission.photos.status;
            } else {
              status = await Permission.storage.status;
            }
            if (!(status == PermissionStatus.granted)) {
              Global.showPhotoDialog((){
                selectAvatar();
              });
            } else {
              selectAvatar();
            }
          } else {
            selectAvatar();
          }

        },
      ),
      SettingsTile.navigation(
        title: Text('昵称'),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onPressed: (context) {
          Navigator.pushNamed(context, '/nickname').then((value){
            personalNotifier.value = true;
          });
        },
      ),
      SettingsTile.navigation(
        title: Text('邀请口令绑定'),
        trailing: Row(
          children: [
            spreadUid == 0 ? Text('未绑定') : Text('已绑定'),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) {
          if(spreadUid != 0) {
            ToastUtils.showToast('邀请口令已绑定');
          } else {
            Navigator.pushNamed(context, '/spreadPage').then((value){
              personalNotifier.value = true;
              //随机设置一个 重进后刷新
              spreadUid = 1;
              setState(() {

              });
            });
          }

        },
      ),
    ];
  }

  Future selectAvatar() async {
    String? avatar = await AvatarHelper.selectAvatar(context);
    if (avatar != null) {
      Global.userinfo?.avatar = avatar!;
      personalNotifier.value =true;
      setState(() {
        imgUrl = avatar!;
      });
    }
  }
}
