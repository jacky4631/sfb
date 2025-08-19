import 'package:ali_auth/ali_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

import '../util/global.dart';

/// Android 密钥
late String androidSk =
    "8cPLR6wifAJnqgZLMQKY3wlsQvPrhklK0sYymF/EoRCBUVYaaqRj6mzM1WOzjWxkLWRCzuUMkSs7JVid0dnzLHHHES4DKX+N+urfQ/vFiX1EU/+lYs6EXuYoqM+XREqKNR5gMerMOVcpZN9o4W9L2d/mUKJL/s1bHmLdAHkZgJf2IWGR0vCcppiYndNY/u/pSqloLJI81WymW8jjcEQyaCIsriGxGLgVtJwtoRiQO9JquzaFab8/mGE0ct1jDMq33lVvUox0gcPi5A/Z4hDVM+dndnREo5RdjaZDqv0D8/4=";

/// iOS 密钥
late String iosSk = "";

class LoginAliAuth {
  static LoginAliAuth? _instance;

  // 私有的命名构造函数
  LoginAliAuth._internal();

  static LoginAliAuth getInstance() {
    if (_instance == null) {
      _instance = LoginAliAuth._internal();
    }

    return _instance!;
  }

  /// 全屏正常图片背景
  static AliAuthModel getFullPortConfig({bool isDelay = false}) {
    /// 弹窗高度
    late int dialogHeight = (PlatformDispatcher.instance.views.first.physicalSize.height /
                PlatformDispatcher.instance.views.first.devicePixelRatio *
                0.65)
            .floor() -
        50;

    /// 比例
    late int unit = dialogHeight ~/ 10;

    return AliAuthModel(
      androidSk,
      iosSk,
      isDebug: true,
      autoQuitPage: true,

      isDelay: isDelay,
      pageType: PageType.fullPort,
      statusBarColor: "#ffffff",
      bottomNavColor: "#FFFFFF",
      lightColor: true,
      isStatusBarHidden: false,
      statusBarUIFlag: UIFAG.systemUiFalgFullscreen,
      navColor: "#ffffff",
      navText: "登录统一认证",
      navTextColor: "#000000",
      navReturnImgPath: "assets/images/arrow-left.png",
      navReturnImgWidth: 40,
      navReturnImgHeight: 40,
      navReturnHidden: false,
      navReturnScaleType: ScaleType.center,
      navHidden: false,
      // customReturnBtn: customReturnBtn,
      logoOffsetY: unit * 4,
      logoImgPath: "assets/images/logo.png",
      logoOffsetY_B: -1,
      logoWidth: 80,
      logoHeight: 80,
      logoHidden: false,
      logoScaleType: ScaleType.fitXy,
      //==============
      logBtnText: "本机号码一键登录",
      logBtnTextSize: 16,
      logBtnTextColor: "#FFFFFF",
      logBtnOffsetY: unit * 8,
      logBtnOffsetY_B: -1,
      logBtnHeight: 51,
      logBtnOffsetX: 0,
      logBtnMarginLeftAndRight: 28,
      logBtnLayoutGravity: Gravity.centerHorizntal,
      logBtnToastHidden: false,
      // logBtnBackgroundPath: "assets/login_btn_normal.png,assets/login_btn_unable.png,assets/login_btn_press.png",
      protocolOneName: "《隐私协议》",
      protocolOneURL: Global.privacyUrl,
      protocolTwoName: "《用户协议》",
      protocolTwoURL: Global.userUrl,
      // protocolThreeName: "《用户协议》",
      // protocolThreeURL: Global.userUrl,
      protocolCustomColor: "#026ED2",
      protocolColor: "#bfbfbf",
      protocolGravity: Gravity.centerHorizntal,
      privacyOperatorIndex: 0,
      protocolLayoutGravity: Gravity.centerHorizntal,
      sloganTextColor: "#000000",
      sloganOffsetY: unit * 6,
      sloganText: "欢迎您使用一键登录",
      sloganTextSize: 16,
      sloganHidden: false,
      loadingImgPath: "authsdk_waiting_icon",

      numberColor: "#000000",
      numberSize: 28,
      numFieldOffsetY: unit * 7,
      numFieldOffsetY_B: -1,
      numberFieldOffsetX: 0,
      numberLayoutGravity: Gravity.centerHorizntal,

      navTextSize: 18,
      switchAccTextSize: 12,
      switchAccText: "切换到其他方式",
      switchOffsetY: unit * 9 + 20,
      switchOffsetY_B: -1,
      switchAccHidden: false,
      switchAccTextColor: "#000000",

      checkBoxWidth: 18,
      checkBoxHeight: 18,
      checkboxHidden: false,
      // uncheckedImgPath: "assets/images/btn_unchecked.png",
      // checkedImgPath: "assets/images/btn_checked.png",

      privacyOffsetX: -1,
      privacyOffsetY: -1,
      privacyOffsetY_B: 28,
      privacyState: false,
      privacyTextSize: 12,
      privacyMargin: 28,
      privacyBefore: "已阅读并同意",
      privacyEnd: "",
      vendorPrivacyPrefix: "《",
      vendorPrivacySuffix: "》",
      dialogWidth: -1,
      dialogHeight: -1,
      dialogBottom: false,
      dialogOffsetX: 0,
      dialogOffsetY: 0,
      webViewStatusBarColor: "#FFFFFF",
      webNavColor: "#ffffff",
      webNavTextColor: "#000000",
      webNavTextSize: 20,
      webNavReturnImgPath: "assets/return_btn.png",
      webSupportedJavascript: true,
      authPageActIn: "in_activity",
      activityOut: "out_activity",
      authPageActOut: "in_activity",
      activityIn: "out_activity",
      screenOrientation: -1,
      dialogAlpha: 1.0,
      /**
       * "assets/background_gif.gif"
       * "assets/background_gif1.gif"
       * "assets/background_gif2.gif"
       * "assets/background_image.jpeg"
       * "assets/background_video.mp4"
       *
       * "https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-7/20187232061776607.gif"
       * "https://img.zcool.cn/community/01dda35912d7a3a801216a3e3675b3.gif",
       */
      // pageBackgroundPath: "assets/background_image.jpeg",
      // customThirdView: customThirdView,
    );
  }
}
