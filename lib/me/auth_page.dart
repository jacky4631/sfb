/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tobias/tobias.dart';

import '../util/global.dart';
import '../util/toast_utils.dart';
import '../service.dart';
import 'listener/PersonalNotifier.dart';
import 'listener/WxPayNotifier.dart';

//账户与安全
class AuthPage extends StatefulWidget {
  final Map data;
  const AuthPage(this.data, {Key? key,}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late Map wxProfile = {};
  late String aliProfile = '';
  late String realName = '';
  late String phone = '';
  bool isSign = false;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    initData();
    wxPayNotifier.addListener(_wechatBindingCallback);
  }

  @override
  void dispose() {
    wxPayNotifier.removeListener(_wechatBindingCallback);
    super.dispose();
  }

  void _wechatBindingCallback() {
    BaseWeChatResponse res = wxPayNotifier.value;
    if (res != null && res is WeChatAuthResponse) {
      //返回的res.code就是授权code
      WeChatAuthResponse authResponse = res;
      if (authResponse.state == 'sufenbao_binding' &&
          authResponse.errCode == 0 &&
          authResponse.code != null) {
          wechatBinding(authResponse.code);
      }
    }
  }

  Future wechatBinding(code) async {
    var data = await BService.wechatBinding(code);

    if (data['success']) {
      await Global.saveUser(data['data']['token'], data['data']['expires_time']);
      await initData();
      ToastUtils.showToast('授权成功');
    } else {
      ToastUtils.showToast('该微信已被授权，请使用其他微信账号');
    }
  }
  Future initData() async {
    Map<String, dynamic> json = await BService.userinfo();

    Map wxMap = await BService.userWxProfile();

    setState(() {
      wxProfile = wxMap['wxProfile']?? {};
      aliProfile = json['aliProfile']??'';
      realName = json['realName']??'';
      phone = json['phone']??'';
    });

    Map<String, dynamic> card = await BService.userCard();
    String contractPath = card['contractPath']??'';
    if(!isEmpty(contractPath)) {
      setState(() {
        isSign = true;
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context,
          title: '账户与安全',
          widgetColor: Colors.black,
          leftIcon: Icon(Icons.arrow_back_ios)),
      body: loading ? Global.showLoading2() : SettingsList(
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
        title: Text('手机号'),
        trailing: Row(
          children: [
            Text(BService.formatPhone(phone)),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) {
          Navigator.pushNamed(context, '/phonePage').then((value){
            personalNotifier.value = true;
            initData();
          });
        },
      ),
      SettingsTile.navigation(
        title: Text('实名'),
        trailing: Row(
          children: [
            Text(BService.formatName(realName)),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) {
          Navigator.pushNamed(context, '/realName').then((value){
            personalNotifier.value = true;
            initData();
          });
        },
      ),
      SettingsTile.navigation(
        title: Text('加盟认证'),
        trailing: Row(
          children: [
            loading ? SizedBox() : (!isSign ? Text('未认证') : Text('已认证')),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) {
          Navigator.pushNamed(context, '/shopAuthPage');

        },
      ),
      SettingsTile.navigation(
        title: Text('微信授权'),
        trailing: Row(
          children: [
            wxProfile.isEmpty ? Text('未授权') : Text('已授权'),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) {
          //todo绑定微信
          if(wxProfile.isNotEmpty) {
            ToastUtils.showToast('微信已授权');
          } else {
            sendWeChatAuth(scope: "snsapi_userinfo", state: "sufenbao_binding");

          }
        },
      ),
      SettingsTile.navigation(
        title: Text('支付宝授权'),
        trailing: Row(
          children: [
            isEmpty(aliProfile) ? Text('未授权') : Text('已授权'),
            PWidget.boxw(4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            )
          ],
        ),
        onPressed: (context) {
          if(!isEmpty(aliProfile)) {
            ToastUtils.showToast('支付宝已授权');
          } else {
            alipayBinding();
          }

        },
      ),
      SettingsTile.navigation(
        title: Text('账户注销'),
        onPressed: (context) {
          Navigator.pushNamed(context, '/accountCancel');
        },
      ),
    ];
  }

  Future changePhone() async {

  }
  bool isEmpty(String str) {
    return str == null || str=='';
  }

  Future alipayBinding() async {
    //获取支付宝auth
    String authString = await BService.alipayCode();

    //唤起支付宝获取code
    Map value2 = await aliPayAuth(authString);
    //解析结果
    String result = value2['result'];
    List strs = result.split('&');
    Map<String, String> data = {};
    strs.forEach((element) {
      String ele = element as String;
      List eleSplit = ele.split('=');
      data[eleSplit[0]] = eleSplit[1];
    });
    //获取支付宝信息
    if(data['result_code'] == '200') {
      Map authRes = await BService.alipayBinding(data['auth_code']);
      if(authRes['success']) {
        initData();
        ToastUtils.showToast('授权成功');
      } else {
        ToastUtils.showToast('授权失败');
      }

    } else {
      ToastUtils.showToast('授权失败');
    }

  }

}
