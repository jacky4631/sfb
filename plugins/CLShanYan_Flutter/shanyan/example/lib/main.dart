import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shanyan/shanYanResult.dart';
import 'package:shanyan/shanYanUIConfig.dart';
import 'package:shanyan/shanyan.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String shanyan_code = "code";
  final String shanyan_result = "result";
  final String shanyan_operator = "operator";
  final String shanyan_widgetLayoutId = "widgetLayoutId";
  final String shanyan_widgetId = "widgetId";
  var controllerPHone = new TextEditingController();

  bool _loading = false;

  String _result = "result=";
  int _code = 0;
  String _content = "content=";

  var ios_uiConfigure;

  final OneKeyLoginManager oneKeyLoginManager = new OneKeyLoginManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('shanyan_flutter demo'),
        ),
        // body: ModalProgressHUD(child: _buildContent(), inAsyncCall: _loading),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          color: Colors.amber[600],
          // width: 48.0,
          // height: 48.0,
          child: _buildContent(),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    String appId = "mchC0cTk";
    if (Platform.isIOS) {
      appId = "7I5nJT7h";
    } else if (Platform.isAndroid) {
      appId = "mchC0cTk";
    }
    //闪验SDK 初始化
    oneKeyLoginManager.init(appId: appId).then((shanYanResult) {
      setState(() {
        _code = shanYanResult.code ?? 0;
        _result = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
      });

      if (1000 == shanYanResult.code) {
        //初始化成功
      } else {
        //初始化失败
      }
    });

    if (Platform.isAndroid) {
      oneKeyLoginManager.setDebug(true);
      oneKeyLoginManager
          .getOperatorType()
          .then((value) => print("getOperatorType===" + value));
      oneKeyLoginManager
          .getOperatorInfo()
          .then((value) => print("getOperatorInfo===" + value));
      oneKeyLoginManager
          .setPrivacyOnClickListener((PrivacyOnClickEvent privacyOnclickEvent) {
        Map map = privacyOnclickEvent.toMap();
        print("setPrivacyOnClickListener===" + map.toString());
      });
    }
  }

  Future<void> getPhoneInfoPlatformState() async {
    //闪验SDK 预取号
    oneKeyLoginManager.getPhoneInfo().then((ShanYanResult shanYanResult) {
      setState(() {
        _code = shanYanResult.code ?? 0;
        _result = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
      });

      if (1000 == shanYanResult.code) {
        //预取号成功
      } else {
        //预取号失败
      }
    });
  }

  Future<void> openLoginAuthPlatformState() async {
    ///闪验SDK 设置授权页一键登录回调（“一键登录按钮”、返回按钮（包括物理返回键））
    oneKeyLoginManager.setOneKeyLoginListener((ShanYanResult shanYanResult) {
      setState(() {
        _code = shanYanResult.code ?? 0;
        _result = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
      });

      oneKeyLoginManager.setLoadingVisibility(true);

      if (1000 == shanYanResult.code) {
        ///一键登录获取token成功

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
      setState(() {
        _code = shanYanResult.code ?? 0;
        _result = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
      });

      if (1000 == shanYanResult.code) {
        //拉起授权页成功
      } else {
        //拉起授权页失败
      }
    });
  }

  Future<void> startAuthenticationState() async {
//    RegExp exp = RegExp(
//        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
//    bool matched = exp.hasMatch(controllerPHone.text);
//    if (controllerPHone.text == null || controllerPHone.text == "") {
//      setState(() {
//        _result = "手机号码不能为空";
//        _content = " code===0" + "\n result===" + _result;
//      });
//      _toast("手机号码不能为空");
//      return;
//    } else if (!matched) {
//      setState(() {
//        _result = "请输入正确的手机号";
//        _content = " code===0" + "\n result===" + _result;
//      });
//      _toast("请输入正确的手机号");
//      return;
//    }

//    //闪验SDK 本机认证获取token
    oneKeyLoginManager.startAuthentication().then((shanYanResult) {
      setState(() {
        _code = shanYanResult.code ?? 0;
        _result = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
      });

      if (1000 == shanYanResult.code) {
        //初始化成功
      } else {
        //初始化失败
      }
    });
  }

  void setAuthThemeConfig() {
    double screenWidthPortrait =
        window.physicalSize.width / window.devicePixelRatio; //竖屏宽

    ShanYanUIConfig shanYanUIConfig = ShanYanUIConfig();

    /*iOS 页面样式设置*/
    shanYanUIConfig.ios.isFinish = true;
    shanYanUIConfig.ios.setAuthBGImgPath = "sy_login_test_bg";
    shanYanUIConfig.ios.setAuthBGVedioPath = "login_demo_test_vedio";

    shanYanUIConfig.ios.setPreferredStatusBarStyle =
        iOSStatusBarStyle.styleLightContent;
    shanYanUIConfig.ios.setStatusBarHidden = false;
    shanYanUIConfig.ios.setAuthNavHidden = false;
    shanYanUIConfig.ios.setNavigationBarStyle = iOSBarStyle.styleBlack;
    shanYanUIConfig.ios.setAuthNavTransparent = true;

    shanYanUIConfig.ios.setNavText = "测试";
    shanYanUIConfig.ios.setNavTextColor = "#80ADFF";
    shanYanUIConfig.ios.setNavTextSize = 18;

    shanYanUIConfig.ios.setNavReturnImgPath = "nav_button_white";
    shanYanUIConfig.ios.setNavReturnImgHidden = false;

//    shanYanUIConfig.ios.setNavBackBtnAlimentRight = true;

    shanYanUIConfig.ios.setNavigationBottomLineHidden = false;

    shanYanUIConfig.ios.setNavigationTintColor = "#FF6659";
    shanYanUIConfig.ios.setNavigationBarTintColor = "#BAFF8C";
    shanYanUIConfig.ios.setNavigationBackgroundImage = "圆角矩形 2 拷贝@2x";

//    shanYanUIConfig.ios.setNavigationShadowImage =

    shanYanUIConfig.ios.setLogoImgPath = "logo_shanyan_text";
    shanYanUIConfig.ios.setLogoCornerRadius = 30;
    shanYanUIConfig.ios.setLogoHidden = false;

    shanYanUIConfig.ios.setNumberColor = "#499191";
    shanYanUIConfig.ios.setNumberSize = 20;
    shanYanUIConfig.ios.setNumberBold = true;
    shanYanUIConfig.ios.setNumberTextAlignment = iOSTextAlignment.right;

    shanYanUIConfig.ios.setLogBtnText = "测试一键登录";
    shanYanUIConfig.ios.setLogBtnTextColor = "#ffffff";
    shanYanUIConfig.ios.setLoginBtnTextSize = 16;
    shanYanUIConfig.ios.setLoginBtnTextBold = false;
    shanYanUIConfig.ios.setLoginBtnBgColor = "#0000ff";

//    shanYanUIConfig.ios.setLoginBtnNormalBgImage = "2-0btn_15";
//    shanYanUIConfig.ios.setLoginBtnHightLightBgImage = "圆角矩形 2 拷贝";
//    shanYanUIConfig.ios.setLoginBtnDisabledBgImage = "login_btn_normal";

//    shanYanUIConfig.ios.setLoginBtnBorderColor = "#FF7666";
    shanYanUIConfig.ios.setLoginBtnCornerRadius = 20;
//    shanYanUIConfig.ios.setLoginBtnBorderWidth = 2;

    shanYanUIConfig.ios.setPrivacyTextSize = 10;
    shanYanUIConfig.ios.setPrivacyTextBold = false;

    shanYanUIConfig.ios.setAppPrivacyTextAlignment = iOSTextAlignment.center;
    shanYanUIConfig.ios.setPrivacySmhHidden = true;
    shanYanUIConfig.ios.setAppPrivacyLineSpacing = 5;
    shanYanUIConfig.ios.setAppPrivacyNeedSizeToFit = false;
//    shanYanUIConfig.ios.setAppPrivacyLineFragmentPadding = 10;
    shanYanUIConfig.ios.setAppPrivacyAbbreviatedName = "666";
    shanYanUIConfig.ios.setAppPrivacyColor = ["#808080", "#00cc00"];

    shanYanUIConfig.ios.setAppPrivacyNormalDesTextFirst = "Accept";
//    shanYanUIConfig.ios.setAppPrivacyTelecom = "中国移动服务协议";
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextSecond = "and";
    shanYanUIConfig.ios.setAppPrivacyFirst = ["测试连接A", "https://www.baidu.com"];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextThird = "&";
    shanYanUIConfig.ios.setAppPrivacySecond = ["测试连接X", "https://www.sina.com"];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextFourth = "、";
    shanYanUIConfig.ios.setAppPrivacyThird = ["测试连接C", "https://www.sina.com"];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextLast = "to login";

//    shanYanUIConfig.ios.setOperatorPrivacyAtLast = true;
//    shanYanUIConfig.ios.setPrivacyNavText = "闪验运营商协议";
//    shanYanUIConfig.ios.setPrivacyNavTextColor = "#7BC1E8";
//    shanYanUIConfig.ios.setPrivacyNavTextSize = 15;
//    shanYanUIConfig.ios.setPrivacyNavReturnImgPath = "close-black";

    shanYanUIConfig.ios.setAppPrivacyWebPreferredStatusBarStyle =
        iOSStatusBarStyle.styleDefault;
    shanYanUIConfig.ios.setAppPrivacyWebNavigationBarStyle =
        iOSBarStyle.styleDefault;

//运营商品牌标签("中国**提供认证服务")
    shanYanUIConfig.ios.setSloganTextSize = 11;
    shanYanUIConfig.ios.setSloganTextBold = false;
    shanYanUIConfig.ios.setSloganTextColor = "#CEBFFF";
    shanYanUIConfig.ios.setSloganTextAlignment = iOSTextAlignment.center;

//供应商品牌标签("创蓝253提供认技术支持")
    shanYanUIConfig.ios.setShanYanSloganTextSize = 11;
    shanYanUIConfig.ios.setShanYanSloganTextBold = true;
    shanYanUIConfig.ios.setShanYanSloganTextColor = "#7BC1E8";
    shanYanUIConfig.ios.setShanYanSloganTextAlignment = iOSTextAlignment.center;
    shanYanUIConfig.ios.setShanYanSloganHidden = false;

    shanYanUIConfig.ios.setCheckBoxHidden = false;
    shanYanUIConfig.ios.setPrivacyState = false;
//    shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyTop = true;
    shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyCenterY = true;
    shanYanUIConfig.ios.setUncheckedImgPath = "checkBoxNor";
    shanYanUIConfig.ios.setCheckedImgPath = "checkBoxSEL";
    shanYanUIConfig.ios.setCheckBoxWH = [40, 40];
//    shanYanUIConfig.ios.setCheckBoxImageEdgeInsets = [5,10,5,0];

    shanYanUIConfig.ios.setLoadingCornerRadius = 10;
    shanYanUIConfig.ios.setLoadingBackgroundColor = "#E68147";
    shanYanUIConfig.ios.setLoadingTintColor = "#1C7EFF";

    shanYanUIConfig.ios.setShouldAutorotate = false;
    shanYanUIConfig.ios.supportedInterfaceOrientations =
        iOSInterfaceOrientationMask.all;
    shanYanUIConfig.ios.preferredInterfaceOrientationForPresentation =
        iOSInterfaceOrientation.portrait;

//    shanYanUIConfig.ios.setAuthTypeUseWindow = false;
//    shanYanUIConfig.ios.setAuthWindowCornerRadius = 10;

    shanYanUIConfig.ios.setAuthWindowModalTransitionStyle =
        iOSModalTransitionStyle.flipHorizontal;
    shanYanUIConfig.ios.setAuthWindowModalPresentationStyle =
        iOSModalPresentationStyle.fullScreen;
    shanYanUIConfig.ios.setAppPrivacyWebModalPresentationStyle =
        iOSModalPresentationStyle.fullScreen;
    shanYanUIConfig.ios.setAuthWindowOverrideUserInterfaceStyle =
        iOSUserInterfaceStyle.unspecified;

    shanYanUIConfig.ios.setAuthWindowPresentingAnimate = true;

    //logo
    shanYanUIConfig.ios.layOutPortrait.setLogoTop = 120;
    shanYanUIConfig.ios.layOutPortrait.setLogoWidth = 120;
    shanYanUIConfig.ios.layOutPortrait.setLogoHeight = 120;
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
    shanYanUIConfig.ios.layOutPortrait.setLogBtnWidth =
        screenWidthPortrait * 0.67;

    //授权页 创蓝slogan（创蓝253提供认证服务）
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight = 15;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganLeft = 0;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganRight = 0;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom = 15;

    //授权页 slogan（***提供认证服务）
    shanYanUIConfig.ios.layOutPortrait.setSloganHeight = 15;
    shanYanUIConfig.ios.layOutPortrait.setSloganLeft = 0;
    shanYanUIConfig.ios.layOutPortrait.setSloganRight = 0;
    shanYanUIConfig.ios.layOutPortrait.setSloganBottom =
        shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom! +
            shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight!;

    //隐私协议
//    shanYanUIConfig.ios.layOutPortrait.setPrivacyHeight = 50;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyLeft = 60;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyRight = 60;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyBottom =
        shanYanUIConfig.ios.layOutPortrait.setSloganBottom! +
            shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight! +
            5;

    List<ShanYanCustomWidgetIOS> shanyanCustomWidgetIOS = [];

    final String btnWidgetId = "other_custom_button"; // 标识控件 id
    ShanYanCustomWidgetIOS buttonWidgetiOS =
        ShanYanCustomWidgetIOS(btnWidgetId, ShanYanCustomWidgetType.Button);
    buttonWidgetiOS.textContent = "其他方式登录 >1";
    buttonWidgetiOS.centerY = 100;
    buttonWidgetiOS.centerX = 0;
    buttonWidgetiOS.width = 150;
//    buttonWidgetiOS.left = 50;
//    buttonWidgetiOS.right = 50;
    buttonWidgetiOS.height = 40;
    buttonWidgetiOS.backgroundColor = "#330000";
    buttonWidgetiOS.isFinish = true;
    buttonWidgetiOS.textAlignment = iOSTextAlignment.center;
    buttonWidgetiOS.borderWidth = 2;
    buttonWidgetiOS.borderColor = "#ff0000";

    shanyanCustomWidgetIOS.add(buttonWidgetiOS);

    final String navRightBtnWidgetId =
        "other_custom_nav_right_button"; // 标识控件 id
    ShanYanCustomWidgetIOS navRightButtonWidgetiOS = ShanYanCustomWidgetIOS(
        navRightBtnWidgetId, ShanYanCustomWidgetType.Button);
    navRightButtonWidgetiOS.navPosition =
        ShanYanCustomWidgetiOSNavPosition.navright;
    navRightButtonWidgetiOS.textContent = "联系客服";
    navRightButtonWidgetiOS.width = 60;
    navRightButtonWidgetiOS.height = 40;
    navRightButtonWidgetiOS.textColor = "#11EF33";
    navRightButtonWidgetiOS.backgroundColor = "#FDECA3";
    navRightButtonWidgetiOS.isFinish = true;
    navRightButtonWidgetiOS.textAlignment = iOSTextAlignment.center;

    shanyanCustomWidgetIOS.add(navRightButtonWidgetiOS);

    shanYanUIConfig.ios.widgets = shanyanCustomWidgetIOS;

    /*Android 页面样式具体设置*/
    shanYanUIConfig.androidPortrait.isFinish = true;
    shanYanUIConfig.androidPortrait.setAuthBgVideoPath =
        "login_demo_test_vedio";
    //shanYanUIConfig.androidPortrait.setFitsSystemWindows = false;
    //shanYanUIConfig.androidPortrait.setCheckBoxTipDisable = true;
    shanYanUIConfig.androidPortrait.setLogoImgPath = "sy_logo";
    shanYanUIConfig.androidPortrait.setPrivacyNavColor = "#aa00cc";
    shanYanUIConfig.androidPortrait.setPrivacyNavTextColor = "#00aacc";
    shanYanUIConfig.androidPortrait.setCheckBoxOffsetXY = [10, 5];
    shanYanUIConfig.androidPortrait.setLogBtnBackgroundColor = "#ff0000";
    List<ShanYanCustomWidgetLayout> shanYanCustomWidgetLayout = [];
    String layoutName = "relative_item_view";
    ConfigPrivacyBean configPrivacyBean1 = ConfigPrivacyBean("闪验测试1",
        "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html");
    configPrivacyBean1.color = "#aa00cc";
    configPrivacyBean1.midStr = "和";
    configPrivacyBean1.title = "闪验测试1协议标题";
    ConfigPrivacyBean configPrivacyBean2 = ConfigPrivacyBean("闪验测试协议2",
        "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html");
    configPrivacyBean2.color = "#aacc00";
    configPrivacyBean2.midStr = "＆";
    configPrivacyBean2.title = "闪验测试2协议标题";
    ConfigPrivacyBean configPrivacyBean3 = ConfigPrivacyBean("闪验测试协议3",
        "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html");
    ConfigPrivacyBean configPrivacyBean4 = ConfigPrivacyBean("闪验测试协议4",
        "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html");
    List<ConfigPrivacyBean> setMorePrivacy = [];
    setMorePrivacy.add(configPrivacyBean1);
    setMorePrivacy.add(configPrivacyBean2);
    setMorePrivacy.add(configPrivacyBean3);
    setMorePrivacy.add(configPrivacyBean4);
    shanYanUIConfig.androidPortrait.morePrivacy = setMorePrivacy;
    shanYanUIConfig.androidPortrait.setPrivacyText = [
      "登录即同意",
      "and",
      "、",
      "和",
      "授权"
    ];
    ShanYanCustomWidgetLayout relativeLayoutWidget = ShanYanCustomWidgetLayout(
        layoutName, ShanYanCustomWidgetLayoutType.RelativeLayout);
    relativeLayoutWidget.top = 380;
    relativeLayoutWidget.widgetLayoutId = ["weixin", "qq", "weibo"];
    shanYanCustomWidgetLayout.add(relativeLayoutWidget);
    List<ShanYanCustomWidget> shanyanCustomWidgetAndroid = [];
    ShanYanCustomWidget buttonWidgetAndroid =
        ShanYanCustomWidget(btnWidgetId, ShanYanCustomWidgetType.Button);
    buttonWidgetAndroid.textContent = "其他方式登录 >";
    buttonWidgetAndroid.top = 300;
    buttonWidgetAndroid.width = 150;
//    buttonWidgetAndroid.left = 50;
//    buttonWidgetAndroid.right = 50;
    buttonWidgetAndroid.height = 40;
    buttonWidgetAndroid.backgroundColor = "#330000";
    buttonWidgetAndroid.isFinish = true;
    buttonWidgetAndroid.textAlignment = ShanYanCustomWidgetGravityType.center;
    shanyanCustomWidgetAndroid.add(buttonWidgetAndroid);
    shanYanUIConfig.androidPortrait.widgetLayouts = shanYanCustomWidgetLayout;
    shanYanUIConfig.androidPortrait.widgets = shanyanCustomWidgetAndroid;

    shanYanUIConfig.androidPortrait.setActivityTranslateAnim = [
      "activity_anim_bottom_in",
      "activity_anim_bottom_out"
    ];
    //oneKeyLoginManager.setAuthThemeConfig(uiConfig: shanYanUIConfig);
    oneKeyLoginManager.addClikWidgetEventListener((eventId) {
      _toast("点击了：" + eventId);
    });
    oneKeyLoginManager
        .setAuthPageActionListener((AuthPageActionEvent authPageActionEvent) {
      Map map = authPageActionEvent.toMap();
      print("setActionListener" + map.toString());
      _toast("点击：${map.toString()}");
    });

    shanYanUIConfig.androidLandscape.isFinish = true;
    shanYanUIConfig.androidLandscape.setAuthBGImgPath = "sy_login_test_bg";
    shanYanUIConfig.androidLandscape.setLogoImgPath = "sy_logo";
    shanYanUIConfig.androidLandscape.setAuthNavHidden = true;
    shanYanUIConfig.androidLandscape.setLogoOffsetY = 14;
    shanYanUIConfig.androidLandscape.setNumFieldOffsetY = 65;
    shanYanUIConfig.androidLandscape.setSloganOffsetY = 100;
    shanYanUIConfig.androidLandscape.setLogBtnOffsetY = 120;

    List<ShanYanCustomWidgetLayout> shanYanCustomWidgetLayoutLand = [];
    String layoutNameLand = "relative_item_view";
    ShanYanCustomWidgetLayout relativeLayoutWidgetLand =
        ShanYanCustomWidgetLayout(
            layoutNameLand, ShanYanCustomWidgetLayoutType.RelativeLayout);
    relativeLayoutWidgetLand.top = 200;
    relativeLayoutWidgetLand.widgetLayoutId = ["weixin", "qq", "weibo"];
    shanYanCustomWidgetLayoutLand.add(relativeLayoutWidgetLand);

    shanYanUIConfig.androidLandscape.widgetLayouts =
        shanYanCustomWidgetLayoutLand;
    oneKeyLoginManager.setAuthThemeConfig(uiConfig: shanYanUIConfig);

    setState(() {
      _content = "界面配置成功";
    });
  }

  void setAuthPopupThemeConfig() {
    double screenWidthPortrait =
        window.physicalSize.width / window.devicePixelRatio; //竖屏宽
    double screenHeightPortrait =
        window.physicalSize.height / window.devicePixelRatio; //竖屏宽

    ShanYanUIConfig shanYanUIConfig = ShanYanUIConfig();

    /*iOS 页面样式设置*/
    shanYanUIConfig.ios.isFinish = false;
    shanYanUIConfig.ios.setAuthBGImgPath = "sy_login_test_bg";
    shanYanUIConfig.ios.setAuthBGVedioPath = "login_demo_test_vedio";

    shanYanUIConfig.ios.setPreferredStatusBarStyle =
        iOSStatusBarStyle.styleLightContent;
    shanYanUIConfig.ios.setStatusBarHidden = false;
    shanYanUIConfig.ios.setAuthNavHidden = false;
    shanYanUIConfig.ios.setNavigationBarStyle = iOSBarStyle.styleBlack;
    shanYanUIConfig.ios.setAuthNavTransparent = true;

    shanYanUIConfig.ios.setNavText = "测试";
    shanYanUIConfig.ios.setNavTextColor = "#80ADFF";
    shanYanUIConfig.ios.setNavTextSize = 18;

    shanYanUIConfig.ios.setNavReturnImgPath = "nav_button_white";
    shanYanUIConfig.ios.setNavReturnImgHidden = false;

//    shanYanUIConfig.ios.setNavBackBtnAlimentRight = true;

    shanYanUIConfig.ios.setNavigationBottomLineHidden = false;

    shanYanUIConfig.ios.setNavigationTintColor = "#FF6659";
    shanYanUIConfig.ios.setNavigationBarTintColor = "#BAFF8C";
    shanYanUIConfig.ios.setNavigationBackgroundImage = "圆角矩形 2 拷贝";

//    shanYanUIConfig.ios.setNavigationShadowImage =

    shanYanUIConfig.ios.setLogoImgPath = "logo_shanyan_text";
//    shanYanUIConfig.ios.setLogoCornerRadius = 30;
    shanYanUIConfig.ios.setLogoHidden = false;

    shanYanUIConfig.ios.setNumberColor = "#499191";
    shanYanUIConfig.ios.setNumberSize = 20;
    shanYanUIConfig.ios.setNumberBold = true;
    shanYanUIConfig.ios.setNumberTextAlignment = iOSTextAlignment.right;

    shanYanUIConfig.ios.setLogBtnText = "测试一键登录";
    shanYanUIConfig.ios.setLogBtnTextColor = "#FFFFFF";
    shanYanUIConfig.ios.setLoginBtnTextSize = 16;
    shanYanUIConfig.ios.setLoginBtnTextBold = false;
    shanYanUIConfig.ios.setLoginBtnBgColor = "#0000FF";

//    shanYanUIConfig.ios.setLoginBtnNormalBgImage = "2-0btn_15";
//    shanYanUIConfig.ios.setLoginBtnHightLightBgImage = "圆角矩形 2 拷贝";
//    shanYanUIConfig.ios.setLoginBtnDisabledBgImage = "login_btn_normal";

//    shanYanUIConfig.ios.setLoginBtnBorderColor = "#FF7666";
    shanYanUIConfig.ios.setLoginBtnCornerRadius = 20;
//    shanYanUIConfig.ios.setLoginBtnBorderWidth = 2;

    shanYanUIConfig.ios.setPrivacyTextSize = 10;
    shanYanUIConfig.ios.setPrivacyTextBold = false;

    shanYanUIConfig.ios.setAppPrivacyTextAlignment = iOSTextAlignment.center;
    shanYanUIConfig.ios.setPrivacySmhHidden = true;
    shanYanUIConfig.ios.setAppPrivacyLineSpacing = 5;
    shanYanUIConfig.ios.setAppPrivacyNeedSizeToFit = false;
//    shanYanUIConfig.ios.setAppPrivacyLineFragmentPadding = 10; 属性已失效
    shanYanUIConfig.ios.setAppPrivacyAbbreviatedName = "666";
    shanYanUIConfig.ios.setAppPrivacyColor = ["#808080", "#00cc00"];

    shanYanUIConfig.ios.setAppPrivacyNormalDesTextFirst = "Accept";
//    shanYanUIConfig.ios.setAppPrivacyTelecom = "中国移动服务协议";
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextSecond = "and";
    shanYanUIConfig.ios.setAppPrivacyFirst = ["测试连接A", "https://www.baidu.com"];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextThird = "&";
    shanYanUIConfig.ios.setAppPrivacySecond = ["测试连接X", "https://www.sina.com"];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextFourth = "、";
    shanYanUIConfig.ios.setAppPrivacyThird = ["测试连接C", "https://www.sina.com"];
    shanYanUIConfig.ios.setAppPrivacyNormalDesTextLast = "to login";

//    shanYanUIConfig.ios.setOperatorPrivacyAtLast = true;
//    shanYanUIConfig.ios.setPrivacyNavText = "闪验运营商协议";
//    shanYanUIConfig.ios.setPrivacyNavTextColor = "#7BC1E8";
//    shanYanUIConfig.ios.setPrivacyNavTextSize = 15;
//    shanYanUIConfig.ios.setPrivacyNavReturnImgPath = "close-black";

    shanYanUIConfig.ios.setAppPrivacyWebPreferredStatusBarStyle =
        iOSStatusBarStyle.styleDefault;
    shanYanUIConfig.ios.setAppPrivacyWebNavigationBarStyle =
        iOSBarStyle.styleDefault;

//运营商品牌标签("中国**提供认证服务")，不得隐藏
    shanYanUIConfig.ios.setSloganTextSize = 11;
    shanYanUIConfig.ios.setSloganTextBold = false;
    shanYanUIConfig.ios.setSloganTextColor = "#CEBFFF";
    shanYanUIConfig.ios.setSloganTextAlignment = iOSTextAlignment.center;

//供应商品牌标签("创蓝253提供认技术支持")
    shanYanUIConfig.ios.setShanYanSloganTextSize = 11;
    shanYanUIConfig.ios.setShanYanSloganTextBold = true;
    shanYanUIConfig.ios.setShanYanSloganTextColor = "#7BC1E8";
    shanYanUIConfig.ios.setShanYanSloganTextAlignment = iOSTextAlignment.center;
    shanYanUIConfig.ios.setShanYanSloganHidden = false;

    shanYanUIConfig.ios.setCheckBoxHidden = false;
    shanYanUIConfig.ios.setPrivacyState = false;
//    shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyTop = true;
    shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyCenterY = true;
    shanYanUIConfig.ios.setUncheckedImgPath = "checkBoxNor";
    shanYanUIConfig.ios.setCheckedImgPath = "checkBoxSEL";
    shanYanUIConfig.ios.setCheckBoxWH = [40, 40];
    shanYanUIConfig.ios.setCheckBoxImageEdgeInsets = [0, 12, 12, 0];

    shanYanUIConfig.ios.setLoadingCornerRadius = 10;
    shanYanUIConfig.ios.setLoadingBackgroundColor = "#E68147";
    shanYanUIConfig.ios.setLoadingTintColor = "#1C7EFF";

    shanYanUIConfig.ios.setShouldAutorotate = false;
    shanYanUIConfig.ios.supportedInterfaceOrientations =
        iOSInterfaceOrientationMask.all;
    shanYanUIConfig.ios.preferredInterfaceOrientationForPresentation =
        iOSInterfaceOrientation.portrait;

    shanYanUIConfig.ios.setAuthTypeUseWindow = true;
    shanYanUIConfig.ios.setAuthWindowCornerRadius = 10;

    shanYanUIConfig.ios.setAuthWindowModalTransitionStyle =
        iOSModalTransitionStyle.flipHorizontal;
//    shanYanUIConfig.ios.setAuthWindowModalPresentationStyle = iOSModalPresentationStyle.fullScreen;
    shanYanUIConfig.ios.setAppPrivacyWebModalPresentationStyle =
        iOSModalPresentationStyle.fullScreen;
    shanYanUIConfig.ios.setAuthWindowOverrideUserInterfaceStyle =
        iOSUserInterfaceStyle.unspecified;

    shanYanUIConfig.ios.setAuthWindowPresentingAnimate = true;

    //弹窗中心位置
    shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationCenterX =
        screenWidthPortrait * 0.5;
    shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationCenterY =
        screenHeightPortrait * 0.5;

    shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationWidth = 300;
    shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationHeight =
        screenWidthPortrait * 0.7;

    //logo
    shanYanUIConfig.ios.layOutPortrait.setLogoTop = 40;
    shanYanUIConfig.ios.layOutPortrait.setLogoWidth = 80;
    shanYanUIConfig.ios.layOutPortrait.setLogoHeight = 40;
    shanYanUIConfig.ios.layOutPortrait.setLogoCenterX = 0;
    //手机号控件
    shanYanUIConfig.ios.layOutPortrait.setNumFieldTop = 40 + 40;
    shanYanUIConfig.ios.layOutPortrait.setNumFieldCenterX = 0;
    shanYanUIConfig.ios.layOutPortrait.setNumFieldHeight = 30;
    shanYanUIConfig.ios.layOutPortrait.setNumFieldWidth = 150;
    //一键登录按钮
    shanYanUIConfig.ios.layOutPortrait.setLogBtnTop = 80 + 20 + 20;
    shanYanUIConfig.ios.layOutPortrait.setLogBtnCenterX = 0;
    shanYanUIConfig.ios.layOutPortrait.setLogBtnHeight = 40;
    shanYanUIConfig.ios.layOutPortrait.setLogBtnWidth = 200;

    //授权页 创蓝slogan（创蓝253提供认证服务）
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight = 15;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganLeft = 0;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganRight = 0;
    shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom = 15;

    //授权页 slogan（***提供认证服务）
    shanYanUIConfig.ios.layOutPortrait.setSloganHeight = 15;
    shanYanUIConfig.ios.layOutPortrait.setSloganLeft = 0;
    shanYanUIConfig.ios.layOutPortrait.setSloganRight = 0;
    shanYanUIConfig.ios.layOutPortrait.setSloganBottom =
        shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom! +
            shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight!;

    //隐私协议
//    shanYanUIConfig.ios.layOutPortrait.setPrivacyHeight = 50;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyLeft = 30;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyRight = 30;
    shanYanUIConfig.ios.layOutPortrait.setPrivacyBottom =
        shanYanUIConfig.ios.layOutPortrait.setSloganBottom! +
            shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight!;

    List<ShanYanCustomWidgetIOS> shanyanCustomWidgetIOS = [];

    final String btnWidgetId = "other_custom_button"; // 标识控件 id
    ShanYanCustomWidgetIOS buttonWidgetiOS =
        ShanYanCustomWidgetIOS(btnWidgetId, ShanYanCustomWidgetType.Button);
    buttonWidgetiOS.textContent = "其他方式登录 >";
    buttonWidgetiOS.top = 140 + 20 + 10;
    buttonWidgetiOS.centerX = 0;
    buttonWidgetiOS.width = 150;
//    buttonWidgetiOS.left = 50;
//    buttonWidgetiOS.right = 50;
    buttonWidgetiOS.height = 30;
    buttonWidgetiOS.backgroundColor = "#330000";
    buttonWidgetiOS.isFinish = true;
    buttonWidgetiOS.textAlignment = iOSTextAlignment.center;

    shanyanCustomWidgetIOS.add(buttonWidgetiOS);

    final String navRightBtnWidgetId =
        "other_custom_nav_right_button"; // 标识控件 id
    ShanYanCustomWidgetIOS navRightButtonWidgetiOS = ShanYanCustomWidgetIOS(
        navRightBtnWidgetId, ShanYanCustomWidgetType.Button);
    navRightButtonWidgetiOS.navPosition =
        ShanYanCustomWidgetiOSNavPosition.navright;
    navRightButtonWidgetiOS.textContent = "联系客服";
    navRightButtonWidgetiOS.width = 60;
    navRightButtonWidgetiOS.height = 40;
    navRightButtonWidgetiOS.textColor = "#11EF33";
    navRightButtonWidgetiOS.backgroundColor = "#FDECA3";
    navRightButtonWidgetiOS.isFinish = true;
    navRightButtonWidgetiOS.textAlignment = iOSTextAlignment.center;

    shanyanCustomWidgetIOS.add(navRightButtonWidgetiOS);

    shanYanUIConfig.ios.widgets = shanyanCustomWidgetIOS;

    /*Android 页面样式具体设置*/
    shanYanUIConfig.androidPortrait.isFinish = true;
    shanYanUIConfig.androidPortrait.setLogoImgPath = "sy_logo";
    shanYanUIConfig.androidPortrait.setDialogTheme = [
      "300",
      "500",
      "0",
      "0",
      "false"
    ];
    shanYanUIConfig.androidPortrait.setBackPressedAvailable = false;
    shanYanUIConfig.androidPortrait.setLogoOffsetY = 20;
    shanYanUIConfig.androidPortrait.setNumFieldOffsetY = 85;
    shanYanUIConfig.androidPortrait.setSloganOffsetY = 110;
    shanYanUIConfig.androidPortrait.setLogBtnOffsetY = 130;
    shanYanUIConfig.androidPortrait.setAuthBGImgPath = "sysdk_login_bg";
    List<ShanYanCustomWidgetLayout> shanYanCustomWidgetLayout = [];
    String layoutName = "relative_item_view";
    ShanYanCustomWidgetLayout relativeLayoutWidget = ShanYanCustomWidgetLayout(
        layoutName, ShanYanCustomWidgetLayoutType.RelativeLayout);
    relativeLayoutWidget.top = 270;
    relativeLayoutWidget.widgetLayoutId = ["weixin", "qq", "weibo"];
    shanYanCustomWidgetLayout.add(relativeLayoutWidget);
    List<ShanYanCustomWidget> shanyanCustomWidgetAndroid = [];
    ShanYanCustomWidget buttonWidgetAndroid =
        ShanYanCustomWidget(btnWidgetId, ShanYanCustomWidgetType.Button);
    buttonWidgetAndroid.textContent = "其他方式登录 >";
    buttonWidgetAndroid.top = 200;
    buttonWidgetAndroid.width = 150;
//    buttonWidgetAndroid.left = 50;
//    buttonWidgetAndroid.right = 50;
    buttonWidgetAndroid.height = 40;
    buttonWidgetAndroid.backgroundColor = "#330000";
    buttonWidgetAndroid.isFinish = true;
    buttonWidgetAndroid.textAlignment = ShanYanCustomWidgetGravityType.center;
    shanyanCustomWidgetAndroid.add(buttonWidgetAndroid);
    shanYanUIConfig.androidPortrait.widgetLayouts = shanYanCustomWidgetLayout;
    shanYanUIConfig.androidPortrait.widgets = shanyanCustomWidgetAndroid;

    shanYanUIConfig.androidLandscape.isFinish = true;
    shanYanUIConfig.androidLandscape.setDialogTheme = [
      "420",
      "300",
      "0",
      "0",
      "false"
    ];
    shanYanUIConfig.androidLandscape.setLogoImgPath = "sy_logo";
    shanYanUIConfig.androidLandscape.setAuthNavHidden = true;
    shanYanUIConfig.androidLandscape.setLogoOffsetY = 14;
    shanYanUIConfig.androidLandscape.setNumFieldOffsetY = 65;
    shanYanUIConfig.androidLandscape.setSloganOffsetY = 100;
    shanYanUIConfig.androidLandscape.setLogBtnOffsetY = 120;

    List<ShanYanCustomWidgetLayout> shanYanCustomWidgetLayoutLand = [];
    String layoutNameLand = "relative_item_view";
    ShanYanCustomWidgetLayout relativeLayoutWidgetLand =
        ShanYanCustomWidgetLayout(
            layoutNameLand, ShanYanCustomWidgetLayoutType.RelativeLayout);
    relativeLayoutWidgetLand.top = 200;
    relativeLayoutWidgetLand.widgetLayoutId = ["weixin", "qq", "weibo"];
    shanYanCustomWidgetLayoutLand.add(relativeLayoutWidgetLand);

    shanYanUIConfig.androidLandscape.widgetLayouts =
        shanYanCustomWidgetLayoutLand;
    oneKeyLoginManager.setAuthThemeConfig(uiConfig: shanYanUIConfig);

    oneKeyLoginManager.addClikWidgetEventListener((eventId) {
      _toast("点击了：" + eventId);
    });
    oneKeyLoginManager
        .setAuthPageActionListener((AuthPageActionEvent authPageActionEvent) {
      Map map = authPageActionEvent.toMap();
      print("setActionListener" + map.toString());
      _toast("点击：${map.toString()}");
    });

    setState(() {
      _content = "界面配置成功";
    });
  }

  Widget _buildContent() {
    return Center(
      widthFactor: 2,
      child: new Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            color: Colors.greenAccent,
            child: Text(_content),
            width: 300,
            height: 180,
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CustomButton(
                          onPressed: () {
                            initPlatformState();
                          },
                          title: "闪验SDK  初始化"),
                      new Text("   "),
                      new CustomButton(
                        onPressed: () {
                          getPhoneInfoPlatformState();
                        },
                        title: "闪验SDK  预取号",
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CustomButton(
                          onPressed: () {
                            setAuthThemeConfig();
                          },
                          title: "授权页  沉浸样式"),
                      new Text("   "),
                      new CustomButton(
                        onPressed: () {
                          setAuthPopupThemeConfig();
                        },
                        title: "授权页  弹窗样式",
                      ),
                    ],
                  ),
                ),
                new Container(
                  child: SizedBox(
                    child: new CustomButton(
                      onPressed: () {
                        openLoginAuthPlatformState();
                      },
                      title: "闪验SDK 拉起授权页",
                    ),
                    width: double.infinity,
                  ),
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                ),
                new Container(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "请输入手机号码",
                        hintStyle: TextStyle(color: Colors.black)),
                    controller: controllerPHone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, //只输入数字
                      LengthLimitingTextInputFormatter(11) //限制长度
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                ),
                new Container(
                  child: SizedBox(
                    child: new CustomButton(
                      onPressed: () {
                        initPlatformState();
                      },
                      title: "本机认证 初始化",
                    ),
                    width: double.infinity,
                  ),
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                ),
                new Container(
                  child: SizedBox(
                    child: new CustomButton(
                      onPressed: () {
                        startAuthenticationState();
                      },
                      title: "本机认证 获取token",
                    ),
                    width: double.infinity,
                  ),
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                )
              ],
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}

void _toast(String str) {
  // Fluttertoast.showToast(
  //     msg: str,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.redAccent,
  //     textColor: Colors.white,
  //     fontSize: 16.0);
}

/// 封装 按钮
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;

  const CustomButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text("$title"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Color(0xff888888);
          }
          return Color(0xff585858);
        }),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(10, 5, 10, 5)),
      ),
    );
  }
}
