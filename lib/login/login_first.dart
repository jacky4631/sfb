// import 'dart:html';

/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sufenbao/service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dialog/simple_privacy_dialog.dart';
import '../me/listener/WxPayNotifier.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/toast_utils.dart';
import '../widget/custom_button.dart';

class LoginFirst extends StatefulWidget {
  final Map data;
  const LoginFirst(this.data, {Key? key,}) : super(key: key);

  @override
  _LoginFirstState createState() => _LoginFirstState();
}

class _LoginFirstState extends State<LoginFirst> {
  bool checkboxSelected = false;
  double height = 33;
  double fontSize = 0;

  bool showWechatLogin = false;
  bool inWebWechat = false;

  @override
  void initState() {
    initData();
    fontSize = height*0.44;
    super.initState();
    wxPayNotifier.addListener(_wechatLoginCallback);
  }

  @override
  void dispose() {
    wxPayNotifier.removeListener(_wechatLoginCallback);
    super.dispose();
  }
  void _wechatLoginCallback() {
    WeChatResponse res = wxPayNotifier.value;
    if (res != null && res is WeChatAuthResponse) {
      //返回的res.code就是授权code
      WeChatAuthResponse authResponse = res;
      if (authResponse.state == 'sufenbao_login' &&
          authResponse.errCode == 0 && authResponse.code != null) {
          wechatAppLogin(authResponse.code);
      }
    }
  }

  Future wechatAppLogin(code) async {
    var data = await BService.wechatAppLogin(code);
    if(data['data']['openId'] != null) {
      Navigator.pushNamed(context, "/loginSecond", arguments: data['data']);
    } else {
      afterLogin(data, context);
    }
  }
  Future appleLogin(AuthorizationCredentialAppleID credential) async {
    var data = await BService.appleLogin(credential);
    afterLogin(data, context);
  }

  ///初始化函数
  Future initData() async {
    if(Global.isWeb() && isWeChatBrowser()) {
      inWebWechat = true;
      showWechatLogin = true;
    } else {
      var weChatInstalled = await fluwx.isWeChatInstalled;
      showWechatLogin = weChatInstalled;
    }
    setState(() {

    });
    //校验登录是否强制邀请码
    await BService.loginMustCode();

  }

  _createButton(bool wechat) {
    if(wechat) {
      return CustomButton(
        icon: Icon(
          Icons.wechat,
          color: Colors.white,
        ),
        leftTextSize: 5,
        text:'微信登录', style:CustomButtonStyle.wechat, onPressed: () {
        if (checkboxSelected) {
          getCode();
        } else {
          //弹出选择框，todo
          AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            body: SimplePrivacyDialog(),
            // btnCancelOnPress: () {},
            // btnOkOnPress: () {},
          )..show().then((value) {
            if (value) {
              checkboxSelected = true;
              setState(() {});
              getCode();
            }
          });
        }
      },);
    }
    return TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            backgroundColor: Colors.white),
        onPressed: () {
          // _login(context);
          Navigator.pushNamed(context, "/loginSecond");

        },
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
          child: SizedBox(height: height, child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                    Text(
                      '手机号码注册/登录',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
          )),
        ));
  }
  _createIOSButton() {
    return SignInWithAppleButton(
      text: '使用Apple登录',
      onPressed: () async {
        if (checkboxSelected) {
          loginApple();
        } else {
          //弹出选择框，todo
          AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            body: SimplePrivacyDialog(),
            // btnCancelOnPress: () {},
            // btnOkOnPress: () {},
          )..show().then((value) {
            if (value) {
              checkboxSelected = true;
              setState(() {});
              loginApple();
            }
          });
        }
        // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
        // after they have been validated with Apple (see `Integration` section for more information on how to do this)
      },
    );
  }
  Future loginApple() async {
    AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential != null) {
      //获取的信息
      appleLogin(credential);

    }
  }
  Future getCode() async {
    //微信公众号登录
    if(inWebWechat) {
      String wechatId = await BService.getWechatId();
      // String url = window.location.href;
      String url = '';
      String redirectUrl = '${url.substring(0, url.lastIndexOf('/'))}/blankPage';

      String requestUrl =
          "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" +
              wechatId +
              "&redirect_uri=" +
              redirectUrl +
              "&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
      Uri uri = Uri.parse(requestUrl);
      bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {

        bool launch = await launchUrl(uri);
      } else {
        ToastUtils.showToast('could not open link $requestUrl');
      }
    } else {
      //微信app登录
      await fluwx.authBy(which: NormalAuth(scope: "snsapi_userinfo", state: "sufenbao_login"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      bgColor: Colors.white,
      appBar: buildTitle(context,
          widgetColor: Colors.white, leftIcon: Icon(Icons.arrow_back)),
      body: PWidget.container(
          Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10), //设置圆角
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 64,
                  )),
              PWidget.boxh(10),
              Text('$APP_NAME，购物拆红包'),
              PWidget.boxh(50),
              Center(
                child: Column(
                  children: [
                    showWechatLogin ?
                    _createButton(true) : SizedBox(),
                    showWechatLogin ? Padding(padding: EdgeInsets.only(top: 20)) : SizedBox(),
                    Global.isIOS() ? _createIOSButton() : SizedBox(),
                    Global.isIOS() ? Padding(padding: EdgeInsets.only(top: 20)) : SizedBox(),
                    _createButton(false),
                  ],
                ),
              ),
              PWidget.row(
                [
                  Checkbox(
                    value: checkboxSelected,
                    onChanged: (value) {
                      checkboxSelected = !checkboxSelected;
                      setState(() {});
                    },
                    shape: CircleBorder(),
                    activeColor: Colours.app_main,
                  ),
                  Expanded(
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                            text: '我已阅读并同意',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            children: [
                              TextSpan(
                                text: '《用户服务协议》',
                                style: TextStyle(color: Colours.app_main),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Global.showProtocolPage(Global.userUrl,'用户服务协议');
                                  },
                              ),
                              TextSpan(
                                text: '和',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: '《$APP_NAME隐私政策》',
                                style: TextStyle(color: Colours.app_main),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Global.showProtocolPage(Global.privacyUrl,'$APP_NAME隐私政策');
                                  },
                              ),
                            ],
                          )))
                ],
              ),
            ],
          ),
          {
            'pd': [80, 20, 20, 20]
          }),
    );
  }
}
