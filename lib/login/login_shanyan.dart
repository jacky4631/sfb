/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shanyan/shanYanResult.dart';
import 'package:shanyan/shanYanUIConfig.dart';
import 'package:shanyan/shanyan.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/login_util.dart';

import '../util/global.dart';

class LoginShanyan {
  static LoginShanyan? _instance;

  // 私有的命名构造函数
  LoginShanyan._internal();

  static LoginShanyan getInstance() {
    if (_instance == null) {
      _instance = LoginShanyan._internal();
    }

    return _instance!;
  }

  OneKeyLoginManager oneKeyLoginManager = new OneKeyLoginManager();
  String btnOtherLogin = "otherLogin";
  static bool initSuc = false;

  //1 闪验SDK  初始化
  Future<bool> init() async {
    if (Global.isWeb()) {
      return false;
    }
    String appId = SY_IOS_APP_ID;

    if (Platform.isAndroid) {
      appId = SY_ANDROID_APP_ID;
    }

    //闪验SDK 初始化
    ShanYanResult shanYanResult = await oneKeyLoginManager.init(appId: appId);
    bool initSuc = 1000 == shanYanResult.code;
    debugPrint("-----闪验SDK 初始化---${shanYanResult.toJson()}");

    if (initSuc) {
      //初始化成功
      initSuc = await _getPhoneInfoPlatformState();
    }

    if (Platform.isAndroid) {
      oneKeyLoginManager.setDebug(true);
      oneKeyLoginManager.getOperatorType().then((value) => print("getOperatorType===" + value));
      oneKeyLoginManager.getOperatorInfo().then((value) => print("getOperatorInfo===" + value));
      oneKeyLoginManager.setPrivacyOnClickListener((PrivacyOnClickEvent privacyOnclickEvent) {
        Map map = privacyOnclickEvent.toMap();
        print("setPrivacyOnClickListener===" + map.toString());
      });
    }
    LoginShanyan.initSuc = initSuc;
    return initSuc;
  }

  //2 闪验SDK  预取号
  Future<bool> _getPhoneInfoPlatformState() async {
    //闪验SDK 预取号
    ShanYanResult shanYanResult = await oneKeyLoginManager.getPhoneInfo();
    debugPrint("-----/闪验SDK 预取号---${shanYanResult.toJson()}");

    return 1000 == shanYanResult.code;
  }

  //3 设置授权页  沉浸样式
  void _setAuthThemeConfig(BuildContext context) {
    double screenWidthPortrait = MediaQuery.of(context).size.width; //竖屏宽

    ShanYanUIConfig shanYanUIConfig = ShanYanUIConfig();

    /*iOS 页面样式设置*/
    shanYanUIConfig.ios.isFinish = true;

    shanYanUIConfig.ios.setPreferredStatusBarStyle = iOSStatusBarStyle.styleDefault;
    shanYanUIConfig.ios.setStatusBarHidden = false;
    shanYanUIConfig.ios.setAuthNavHidden = false;
    shanYanUIConfig.ios.setNavigationBarStyle = iOSBarStyle.styleBlack;
    shanYanUIConfig.ios.setAuthNavTransparent = false;

    shanYanUIConfig.ios.setNavText = "登录统一认证";
    shanYanUIConfig.ios.setNavTextColor = "#000000";
    shanYanUIConfig.ios.setNavTextSize = 18;

    shanYanUIConfig.ios.setNavReturnImgPath = "nav_button_black";
    shanYanUIConfig.ios.setNavReturnImgHidden = false;

//    shanYanUIConfig.ios.setNavBackBtnAlimentRight = true;

    shanYanUIConfig.ios.setNavigationBottomLineHidden = false;

//    shanYanUIConfig.ios.setNavigationShadowImage =

    shanYanUIConfig.ios.setLogoImgPath = "logo_shanyan_text";
    shanYanUIConfig.ios.setLogoHidden = false;

    shanYanUIConfig.ios.setNumberColor = "#000000";
    shanYanUIConfig.ios.setNumberSize = 20;
    shanYanUIConfig.ios.setNumberBold = true;
    shanYanUIConfig.ios.setNumberTextAlignment = iOSTextAlignment.right;

    shanYanUIConfig.ios.setLogBtnText = "本机号码一键登录";
    shanYanUIConfig.ios.setLogBtnTextColor = "#ffffff";
    shanYanUIConfig.ios.setLoginBtnTextSize = 16;
    shanYanUIConfig.ios.setLoginBtnTextBold = false;
    shanYanUIConfig.ios.setLoginBtnBgColor = "#ff0000";

//    shanYanUIConfig.ios.setLoginBtnNormalBgImage = "2-0btn_15";
//    shanYanUIConfig.ios.setLoginBtnHightLightBgImage = "圆角矩形 2 拷贝";
//    shanYanUIConfig.ios.setLoginBtnDisabledBgImage = "login_btn_normal";

//    shanYanUIConfig.ios.setLoginBtnBorderColor = "#FF7666";
    shanYanUIConfig.ios.setLoginBtnCornerRadius = 20;
//    shanYanUIConfig.ios.setLoginBtnBorderWidth = 2;

    shanYanUIConfig.ios.setPrivacyTextSize = 11;
    shanYanUIConfig.ios.setPrivacyTextBold = false;

    shanYanUIConfig.ios.setAppPrivacyTextAlignment = iOSTextAlignment.center;
    shanYanUIConfig.ios.setPrivacySmhHidden = true;
    shanYanUIConfig.ios.setAppPrivacyLineSpacing = 5;
    shanYanUIConfig.ios.setAppPrivacyNeedSizeToFit = false;
//    shanYanUIConfig.ios.setAppPrivacyLineFragmentPadding = 10;
    shanYanUIConfig.ios.setAppPrivacyColor = ['#9E9E9E', '#FC5434'];

    shanYanUIConfig.ios.setCheckBoxTipMsg = '请阅读并勾选用户服务协议和$APP_NAME隐私政策';
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextFirst = "我已阅读并同意";
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextSecond = "和";
    shanYanUIConfig.ios.setAppPrivacyFirst = ["《用户服务协议》", Global.userUrl];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextThird = "和";
    shanYanUIConfig.ios.setAppPrivacySecond = ["《$APP_NAME隐私政策》", Global.privacyUrl];
    shanYanUIConfig.ios.setAppPrivacyAbbreviatedName = '$APP_NAME';
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextLast = '';

    shanYanUIConfig.ios.setAppPrivacyWebPreferredStatusBarStyle = iOSStatusBarStyle.styleDarkContent;
    shanYanUIConfig.ios.setAppPrivacyWebNavigationBarStyle = iOSBarStyle.styleDefault;

//运营商品牌标签("中国**提供认证服务")
    shanYanUIConfig.ios.setSloganTextSize = 11;
    shanYanUIConfig.ios.setSloganTextBold = false;
    shanYanUIConfig.ios.setSloganTextColor = "#9E9E9E";
    shanYanUIConfig.ios.setSloganTextAlignment = iOSTextAlignment.center;

    shanYanUIConfig.ios.setShanYanSloganHidden = true;

    shanYanUIConfig.ios.setCheckBoxHidden = false;
    shanYanUIConfig.ios.setPrivacyState = false;
    shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyTop = true;
    // shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyCenterY = true;
    shanYanUIConfig.ios.setUncheckedImgPath = "checkBoxNor";
    shanYanUIConfig.ios.setCheckedImgPath = "checkBoxSEL";
    shanYanUIConfig.ios.setCheckBoxWH = [32, 32];
    shanYanUIConfig.ios.setCheckBoxImageEdgeInsets = [5, 10, 5, 0];

    // shanYanUIConfig.ios.setLoadingCornerRadius = 10;
    // shanYanUIConfig.ios.setLoadingBackgroundColor = "#ffffff";
    // shanYanUIConfig.ios.setLoadingTintColor = "#9E9E9E";

    shanYanUIConfig.ios.setShouldAutorotate = false;
    shanYanUIConfig.ios.supportedInterfaceOrientations = iOSInterfaceOrientationMask.all;
    shanYanUIConfig.ios.preferredInterfaceOrientationForPresentation = iOSInterfaceOrientation.portrait;

//    shanYanUIConfig.ios.setAuthTypeUseWindow = false;
//    shanYanUIConfig.ios.setAuthWindowCornerRadius = 10;

    shanYanUIConfig.ios.setAuthWindowModalTransitionStyle = iOSModalTransitionStyle.coverVertical;
    shanYanUIConfig.ios.setAuthWindowModalPresentationStyle = iOSModalPresentationStyle.fullScreen;
    shanYanUIConfig.ios.setAppPrivacyWebModalPresentationStyle = iOSModalPresentationStyle.fullScreen;
    shanYanUIConfig.ios.setAuthWindowOverrideUserInterfaceStyle = iOSUserInterfaceStyle.unspecified;

    shanYanUIConfig.ios.setAuthWindowPresentingAnimate = true;

    //logo
    shanYanUIConfig.ios.layOutPortrait.setLogoTop = 280;
    shanYanUIConfig.ios.layOutPortrait.setLogoWidth = 64;
    shanYanUIConfig.ios.layOutPortrait.setLogoHeight = 64;
    shanYanUIConfig.ios.layOutPortrait.setLogoCenterX = 0;
    //手机号控件
    shanYanUIConfig.ios.layOutPortrait.setNumFieldCenterY = -20;
    shanYanUIConfig.ios.layOutPortrait.setNumFieldCenterX = 0;
    shanYanUIConfig.ios.layOutPortrait.setNumFieldHeight = 40;
    shanYanUIConfig.ios.layOutPortrait.setNumFieldWidth = 150;
    //一键登录按钮
    shanYanUIConfig.ios.layOutPortrait.setLogBtnCenterY = -20 + 20 + 20 + 15;
    shanYanUIConfig.ios.layOutPortrait.setLogBtnCenterX = 0;
    shanYanUIConfig.ios.layOutPortrait.setLogBtnHeight = 40;
    shanYanUIConfig.ios.layOutPortrait.setLogBtnWidth = screenWidthPortrait * 0.67;

    //授权页 创蓝slogan（创蓝253提供认证服务）
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight = 15;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganLeft = 0;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganRight = 0;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom = 15;

    //授权页 slogan（***提供认证服务）
    shanYanUIConfig.ios.layOutPortrait.setSloganHeight = 15;
    shanYanUIConfig.ios.layOutPortrait.setSloganLeft = 0;
    shanYanUIConfig.ios.layOutPortrait.setSloganRight = 0;
    shanYanUIConfig.ios.layOutPortrait.setSloganBottom = shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom! +
        shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight!;

    //隐私协议
    shanYanUIConfig.ios.layOutPortrait.setPrivacyHeight = 50;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyLeft = 60;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyRight = 60;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyBottom = shanYanUIConfig.ios.layOutPortrait.setSloganBottom! +
        shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight! +
        5;

    List<ShanYanCustomWidgetIOS> shanyanCustomWidgetIOS = [];

    ShanYanCustomWidgetIOS buttonWidgetiOS = ShanYanCustomWidgetIOS(btnOtherLogin, ShanYanCustomWidgetType.Button);
    buttonWidgetiOS.textContent = "其他方式登录 >";
    buttonWidgetiOS.centerY = 100;
    buttonWidgetiOS.centerX = 0;
    buttonWidgetiOS.width = 150;
//    buttonWidgetiOS.left = 50;
//    buttonWidgetiOS.right = 50;
    buttonWidgetiOS.height = 40;
    // buttonWidgetiOS.backgroundColor = "#330000";
    buttonWidgetiOS.isFinish = true;
    buttonWidgetiOS.textColor = '#9E9E9E';
    buttonWidgetiOS.textAlignment = iOSTextAlignment.center;
    // buttonWidgetiOS.borderWidth = 2;
    // buttonWidgetiOS.borderColor = "#ff0000";

    shanyanCustomWidgetIOS.add(buttonWidgetiOS);

    shanYanUIConfig.ios.widgets = shanyanCustomWidgetIOS;

    /*Android 页面样式具体设置*/
    shanYanUIConfig.androidPortrait.isFinish = true;
    shanYanUIConfig.androidPortrait.setNavText = '登录统一认证';
    shanYanUIConfig.androidPortrait.setNavTextBold = true;
    shanYanUIConfig.androidPortrait.setLogoImgPath = "sy_logo";
    shanYanUIConfig.androidPortrait.setLogoWidth = 64;
    shanYanUIConfig.androidPortrait.setLogoHeight = 64;
    shanYanUIConfig.androidPortrait.setPrivacyNavColor = "#FFFFFF";
    shanYanUIConfig.androidPortrait.setPrivacyNavTextColor = "#000000";
    shanYanUIConfig.androidPortrait.setCheckBoxOffsetXY = [10, 5];
    shanYanUIConfig.androidPortrait.setLogBtnBackgroundColor = "#ff0000";

    ConfigPrivacyBean configPrivacyBean1 = ConfigPrivacyBean("用户服务协议", Global.userUrl);
    configPrivacyBean1.color = "#FC5434";
    configPrivacyBean1.midStr = "和";
    configPrivacyBean1.title = "用户服务协议";
    ConfigPrivacyBean configPrivacyBean2 = ConfigPrivacyBean("$APP_NAME隐私政策", Global.privacyUrl);
    configPrivacyBean2.color = "#FC5434";
    configPrivacyBean2.midStr = " ";
    configPrivacyBean2.title = "$APP_NAME隐私政策";
    List<ConfigPrivacyBean> setMorePrivacy = [];
    setMorePrivacy.add(configPrivacyBean1);
    setMorePrivacy.add(configPrivacyBean2);
    shanYanUIConfig.androidPortrait.morePrivacy = setMorePrivacy;
    shanYanUIConfig.androidPortrait.setPrivacyText = ["我已阅读并同意", "和"];
    shanYanUIConfig.androidPortrait.setPrivacyCustomToastText = '请阅读并勾选用户服务协议和$APP_NAME隐私政策';
    shanYanUIConfig.androidPortrait.setPrivacyState = false;
    shanYanUIConfig.androidPortrait.setAppPrivacyColor = ['#9E9E9E', '#FC5434'];
    shanYanUIConfig.androidPortrait.setPrivacyTextSize = 12;
    shanYanUIConfig.androidPortrait.setCheckBoxWH = [16, 16];
    shanYanUIConfig.androidPortrait.setPrivacyOffsetGravityLeft = true;

    List<ShanYanCustomWidget> shanyanCustomWidgetAndroid = [];
    ShanYanCustomWidget buttonWidgetAndroid = ShanYanCustomWidget(btnOtherLogin, ShanYanCustomWidgetType.Button);
    buttonWidgetAndroid.textContent = "其他方式登录 >";
    buttonWidgetAndroid.top = 300;
    buttonWidgetAndroid.width = 150;
//    buttonWidgetAndroid.left = 50;
//    buttonWidgetAndroid.right = 50;
    buttonWidgetAndroid.height = 40;
    Colors.transparent;
    buttonWidgetAndroid.backgroundColor = '#00FFFFFF';
    buttonWidgetAndroid.textColor = "#9E9E9E";
    buttonWidgetAndroid.isFinish = true;
    buttonWidgetAndroid.textAlignment = ShanYanCustomWidgetGravityType.center;
    shanyanCustomWidgetAndroid.add(buttonWidgetAndroid);
    shanYanUIConfig.androidPortrait.widgets = shanyanCustomWidgetAndroid;

    shanYanUIConfig.androidPortrait.setActivityTranslateAnim = ["activity_anim_bottom_in", "activity_anim_bottom_out"];
    //oneKeyLoginManager.setAuthThemeConfig(uiConfig: shanYanUIConfig);
    oneKeyLoginManager.addClikWidgetEventListener((eventId) {
      debugPrint(eventId);
      if (btnOtherLogin == eventId) {
        Navigator.pushNamed(context, '/login');
      } else if ('weixin' == eventId) {
        oneKeyLoginManager.finishAuthControllerCompletion();
        Navigator.pushNamed(context, '/login');
      }
    });
    oneKeyLoginManager.setAuthPageActionListener((AuthPageActionEvent authPageActionEvent) {
      int type = authPageActionEvent.type;
      int code = authPageActionEvent.code;

      //     type=1 ，隐私协议点击事件
      //     type=2 ，checkbox点击事件
      //     type=3 ，"一键登录"按钮点击事件
      //     type=1 ，隐私协议点击事件，code分为0,1,2,3（协议页序号）
      // type=2 ，checkbox点击事件，code分为0,1（0为未选中，1为选中）
      // type=3 ，"一键登录"按钮点击事件，code分为0,1（0为协议勾选框未选中，1为选中）
      if (type == 3 && code == 1) {}
      Map map = authPageActionEvent.toMap();
      print("setActionListener" + map.toString());
    });

    shanYanUIConfig.androidLandscape.isFinish = true;
    shanYanUIConfig.androidLandscape.setLogoImgPath = "sy_logo";
    shanYanUIConfig.androidLandscape.setAuthNavHidden = true;
    shanYanUIConfig.androidLandscape.setLogoOffsetY = 14;
    shanYanUIConfig.androidLandscape.setNumFieldOffsetY = 65;
    shanYanUIConfig.androidLandscape.setSloganOffsetY = 100;
    shanYanUIConfig.androidLandscape.setLogBtnOffsetY = 120;
    oneKeyLoginManager.setAuthThemeConfig(uiConfig: shanYanUIConfig);
  }

  //4 拉起授权页
  Future<void> openLoginAuthPlatformState(BuildContext context) async {
    _setAuthThemeConfig(context);

    ///闪验SDK 设置授权页一键登录回调（“一键登录按钮”、返回按钮（包括物理返回键））
    oneKeyLoginManager.setOneKeyLoginListener((ShanYanResult shanYanResult) async {
      oneKeyLoginManager.setLoadingVisibility(true);

      if (1000 == shanYanResult.code) {
        ///一键登录获取token成功
        var res = await BService.loginShanyan(shanYanResult.token);
        afterLogin(res, context, close: 0);

        oneKeyLoginManager.finishAuthControllerCompletion();
      } else if (1011 == shanYanResult.code) {
        ///点击返回/取消 （强制自动销毁）
        oneKeyLoginManager.setLoadingVisibility(false);
      } else {
        ///一键登录获取token失败
        //关闭授权页
        oneKeyLoginManager.finishAuthControllerCompletion();
      }
    });

    ///闪验SDK 拉起授权页
    oneKeyLoginManager.openLoginAuth().then((ShanYanResult shanYanResult) {
      debugPrint(shanYanResult.toString());
      if (1000 == shanYanResult.code) {
        //拉起授权页成功
      } else {
        //拉起授权页失败
      }
    });
  }
}
