/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
library base;

import 'dart:core';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/dialog/simple_text_dialog.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/swipe_to_dismiss_wrap.dart';

import '../dialog/channel_auth_dialog.dart';
import '../dialog/contet_parse_dialog.dart';
import '../dialog/huodong_dialog.dart';
import '../dialog/pdd_auth_dialog.dart';
import '../httpUrl.dart';
import '../me/model/activity_info.dart';
import '../me/model/app_info.dart';
import '../me/model/commission_info.dart';
import '../me/model/userinfo.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/loading.dart';
import 'launchApp.dart';
import 'login_util.dart';

const String APP_NAME = '苏分宝';
const String COMPANY_NAME = '';
//todo 闪验appid
const String SY_ANDROID_APP_ID = '';
const String SY_IOS_APP_ID = '';

//todo 隐私协议地址 例如www.xxx.com
const baseDomain = '';

//todo 好单库cms的地址前半部分，生成地址https://user.cms.haodanku.com/record
const BROWSER_BASE_URL = "https://xxx.xxx.com/?cid=";

//订单隐私
const bool isBlur = true;
//隐藏积分商城
const bool hidePonitsMall = false;
//注册跳过邀请码
const bool skipCode = false;
//显示转卖和口令购买
const bool showShareBuy = true;
//是否已阅读协议
bool Seen = false;

const int BASE_SCALE=70;
const int TB_SCALE=90;
//APP显示店长比例300% 就设置4
const double TIMES = 1;

const PREFS_INVITE_CODE = 'inviteCode';
const PREFS_GOODS_CODE = 'goodsCode';

const int EXPIRED_LEVEL = 99;
Fluwx fluwx = new Fluwx();
// 所有Widget继承的抽象类
class Global {
  //ios产品id
  static List<String> iosProductIds = ['00005','10005','20005','30005','40005','00003'];

  static const baseUrl = 'https://$baseDomain';
  static const privacyUrl = '$baseUrl/protocol/privacy.html';
  static const userUrl = '$baseUrl/protocol/user.html';
  static const vipUrl = '$baseUrl/protocol/vip.html';
  static const shareUrl = '$baseUrl/protocol/share.html';
  static const collectUrl = '$baseUrl/protocol/collect.html';
  //！！！上面的html记得放到该目录下
  static const privacyProtocolUrl = '$baseDomain/protocol';
  //todo 微信开放平台app id
  static const wxAppId = 'wx139d763ebb9a29e0';
  static const wxUniversalLink = 'https://sufenbao.mailvor.cn/';

  //todo 极光推送app key
  static const jpushAppKey = 'f4b96adeec4eb2a41d831551';
  // todo 企业微信客服相关
  static const qiyeWechatServiceWebUrl = 'https://work.weixin.qq.com/kfid/kfccb35048d17a49efd';
  static const qiyeWechatServiceUrl = 'https://work.weixin.qq.com/kfid/kfccb35048d17a49efd';
  static const qiyeWechatServiceCropId = 'ww99c2dedd45f997f9';

  //活动弹窗和查券弹窗共用，优先显示查券弹窗
  static bool dialogShowing = false;

  static bool showPrivacy = false;
  static SharedPreferences? _prefs;
  static bool login = false;
  static int loginMustCode = 2;
  static Userinfo? userinfo;
  static CommissionInfo? commissionInfo;
  static AppInfo appInfo = AppInfo();
  static Future initPrefs() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
    //初始化全局信息，会在APP启动时执行
  static Future init() async {
    String token = await getToken();
    if (token.isNotEmpty) {
      login = true;
    }
    Map<String, dynamic> data = await BService.homeUrl();

    appInfo = AppInfo.fromJson(data);
  }

  static getDynamicCommission(num commission) {
    double minTimes = 0.1;
    double maxTimes = 10.0;
    if(Global.commissionInfo != null) {
      minTimes = Global.commissionInfo!.hbMinTimes;
      maxTimes = Global.commissionInfo!.hbMaxTimes;
    }
    String min = (commission* minTimes).toStringAsFixed(2);
    double maxD = commission* maxTimes;
    //0.0-0.5元， 直接给到1元-1.5元之间
    // if(maxD <= 0.5) {
    //   maxD = 1.5;
    // }
    String max = maxD.toStringAsFixed(2);
    return {'min':min, 'max':max};
  }

  static showProtocolPage(url, title) {
    Navigator.pushNamed(context, '/webview', arguments: {
      'url': url,
      'refresh': false,
      'appBar': buildTitle(context,
          title: title,
          widgetColor: Colors.black,
          leftIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ))
    });
  }

  static Future saveUser(token, expiresTime) async {
    login = true;
    await initPrefs();
    await _prefs?.setString("token", token);
    await _prefs?.setString("expires_time", expiresTime);
  }

  static Future<String?> getTodayString() async {
    await initPrefs();
    DateTime dateTime= DateTime.now();
    return _prefs?.getString('${dateTime.year}${dateTime.month}${dateTime.day}');
  }

  static Future setTodayString() async {
    await initPrefs();
    DateTime dateTime= DateTime.now();
    return _prefs?.setString('${dateTime.year}${dateTime.month}${dateTime.day}', '1');
  }

  static Future saveUid(int uid) async {
    await initPrefs();
    await _prefs?.setString("uid", '$uid');
  }

  static Future getUid() async {
    await initPrefs();
    return _prefs?.getString("uid");
  }

  static Future clearUser() async {
    login = false;
    suClient.options.headers["Authorization"] = null;
    await initPrefs();
    await _prefs?.remove("token");
    await _prefs?.remove("expires_time");
  }

  static Future saveAgree() async {
    await initPrefs();
    await _prefs?.setBool("agree", true);
  }

  static Future getAgree() async {
    await initPrefs();
    return _prefs?.getBool("agree") ?? false;
  }

  static Future<String> getToken() async {
    await initPrefs();
    return _prefs?.getString("token")??'';
  }

  static showName(Userinfo userinfo) {
    if (userinfo == null) {
      return '';
    }
    if (userinfo.nickname == '') {
      return userinfo.phone;
    }
    return userinfo.nickname;
  }

  static List getCategory() {
    return [
      // {'cid': 1, 'name': '女装'},
      {'cid': 2, 'name': '母婴'},
      {'cid': 3, 'name': '美妆'},
      {'cid': 4, 'name': '居家日用'},
      {'cid': 5, 'name': '鞋品'},
      {'cid': 6, 'name': '美食'},
      {'cid': 7, 'name': '文娱车品'},
      {'cid': 8, 'name': '数码家电'},
      {'cid': 9, 'name': '男装'},
      {'cid': 10, 'name': '内衣'},
      {'cid': 11, 'name': '箱包'},
      {'cid': 12, 'name': '配饰'},
      {'cid': 13, 'name': '户外运动'},
      {'cid': 14, 'name': '家装家纺'},
    ];
  }

  static getFullCategory() {
    List cates = getCategory();
    cates.insert(
      0,
      {'cid': 0, 'name': '精选'},
    );
    return cates;
  }

  static String getTmLogo(shopType) {
    return shopType.toString() == '1'
        ? 'assets/images/mall/tm.png'
        : 'assets/images/mall/tb.png';
  }

  static String listToString(List<String> list) {
    if (list == null) {
      return '';
    }
    String result = '';
    list.forEach((string) =>
        {result == '' ? result = string : result = '$result,$string'});
    return result.toString();
  }
  static Widget showLoading2() {
    return WillPopScope(
        child: Material(
          //创建透明层
            type: MaterialType.transparency, //透明类型
            child: Center(
            //保证控件居中效果
            child: CupertinoActivityIndicator(
              radius: 18,
            ),
          ),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  //在web下执行Platform.isIOS会报错
  static isIOS() {
    if(isWeb()) {
      return false;
    }
    return Platform.isIOS;
  }
  static Future<bool> isHuawei() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo != null && androidInfo.manufacturer != null) {
      return androidInfo.manufacturer.toLowerCase() == 'huawei';
    }
    return false;
  }
  static isAndroid() {
    if(isWeb()) {
      return false;
    }
    return Platform.isAndroid;
  }

  static Future openEle(path) async {
    Loading.show(context, text: '正在打开饿了么小程序');
    await Future.delayed(new Duration(seconds: 1));
    Loading.hide(context);
    //唤起微信小程序
    Global.launchEleWechat(path);
  }
  static Future kuParse(BuildContext context, v) async {
    ///点击事件
    if(v['title'] == '淘宝看视频领红包') {
      Navigator.pushNamed(context, '/taoRedPage', arguments: v);
    } else if(v['title'] == '加盟') {
      onTapLogin(context, '/tabVip', args: {'index':0});
    } else if(v['title'] == '捡漏清单') {
      Navigator.pushNamed(context, '/pickLeakPage', arguments: v);
    } else if (v['link_type'] == 4) {
      Navigator.pushNamed(context, '/kuCustomPage', arguments: v);
    } else if (v['link_type'] == 6) {
      onTapDialogLogin(context, fun: () async {
        Loading.show(context);
        Map activityDetail = await BService.activityDetail(v['link']);
        int terrace = activityDetail['terrace'];
        //1=淘宝 2=京东 5=唯品会
        String url = '';
        if (terrace == 1) {
          var data =
              await BService.taoActivityParse(activityDetail['activity_id']);
          if (data != null) {
            url = data['click_url'];
          }
          Loading.hide(context);
          if(url == '') {
            ToastUtils.showToast('请稍后再试');
            return;
          }
          LaunchApp.launchTb(context, url);
          return;
        } else if (terrace == 2) {
          url = await BService.goodsWordJD(activityDetail['activity_url'], null, null);
          Loading.hide(context);
          LaunchApp.launchJd(context, url);
          return;
        }
        if (url != '') {
          LaunchApp.launchApp(url);
        }
        Loading.hide(context);
      });
    } else if (v['id'] == 380) {
      Navigator.pushNamed(context, '/miniPage');
    } else if (v['title'] == '抖音盛夏洗护') {
      Loading.show(context);
      BService.dyBannerWord().then((value) {
        LaunchApp.launchDy(context, value['deep_link'],value['deep_link']);
      });
      Loading.hide(context);
    } else if (v['link_type'] == 3) {
      String link = v['link'];
      String tag;
      switch (link) {
        case "9":
          tag = "hot_sale";
          break;
        case "35":
          tag = "gather_new";
          break;
        case "7":
          tag = "juhuasuan";
          break;
        case "31":
          tag = "signin";
          break;
        case "18":
          tag = "new_maochao";
          break;
        case "6":
          tag = "lowprice";
          break;
        case "34":
          tag = "rt_xb";
          break;
        case "12":
          tag = "fangyi";
          break;
        case "51":
          tag = "activity125";
          break;
        case "38":
          tag = "tb_subsidies";
          break;
        case "75":
          tag = "dy_special";
          break;
        case "66":
          tag = "tb_live";
          break;
        case "16":
          tag = "pdd_hotitem";
          break;
        case "76":
          tag = "activity_fresh";
          break;
        default:
          tag = "gather_new";
          break;
      }
      String url = '$BROWSER_BASE_URL${Global.appInfo.kuCid}&tmp=$tag&code=${Global.appInfo.kuCid}&sp=#/sp';
      Navigator.pushNamed(context, '/webview',
          arguments: {'url': url, 'title': v['title']});
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isBlank(s) {
    return s == null || s == '';
  }

  static launchMeituanWechat(context, {url}) {
    // Global.showLoading(context, text: '正在打开美团外卖小程序');
    Loading.show(context, text: '正在打开美团外卖小程序');
    fluwx.open(target: MiniProgram(
            username: 'gh_870576f3c6f9',
            path: Global.isEmpty(url) ?
                '/index/pages/h5/h5?f_userId=1&f_token=1&s_cps=1&weburl=https%3A%2F%2Fclick.meituan.com%2Ft%3Ft%3D1%26c%3D2%26p%3DyrY3Yr5z53F_'
                : url))
        .then((value) => Loading.hide(context));
  }

  static launchEleWechat(path) async {
    fluwx.open(target: MiniProgram(username: 'gh_6506303a12bb', path: path));
  }

  static bool isEmpty(str) {
    return str == null || str == '' || str == 'null';
  }

  static RegExp regExp = RegExp("^1(3|4|5|6|7|8|9)\\d{9}");
  static RegExp phoneExpPrefix = RegExp("^1(3|4|5|6|7|8|9)\\d{1}");
  static bool isPhone(String phone) {
    return regExp.hasMatch(phone);
  }
  static bool isPhonePrefix(String phone) {
    return phoneExpPrefix.hasMatch(phone);
  }
  static RegExp orderRegExp = RegExp(r'^[0-9-]+$');
  static bool isOrder(String order) {
    //美团订单有空格 需要清除
    order = order.replaceAll(" ", "");
    return orderRegExp.hasMatch(order);
  }

  //#e56649转换成Color
  static Color theColor(String color, {double alpha = 1}) {
    var hex = int.parse("0xFF${color.substring(1)}");
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }

  static Future initJPush() async {
    final JPushFlutterInterface jpush = JPush.newJPush();
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
      }, onOpenNotification: (Map<String, dynamic> message) async {
            String msg = message['alert']??'';
            if(msg.isEmpty && message['aps'] != null && message['aps']['alert'] != null){
              if(message['aps']['alert'] is String) {
                msg = message['aps']['alert'];
              } else {
                msg = message['aps']['alert']['body'];
              }
            };
            if(msg == null) {
              Navigator.pushNamed(context, '/orderList');
            } else if(msg.contains('拆开红包') || msg.contains('拆开') || msg.contains('用户拆开')){
              Navigator.pushNamed(context, '/moneyList');
            } else if(msg.contains('成为你的银星用户')){
              //todo 传入page
              Navigator.pushNamed(context, '/fans');
            } else if(msg.contains('成为你的金星用户')){
              //todo 传入page
              Navigator.pushNamed(context, '/fans');
            } else if(msg.contains('新的热度订单')){
              Navigator.pushNamed(context, '/orderList',arguments: {'page': 3});
            }else {
              Navigator.pushNamed(context, '/orderList');
            }

      }, onReceiveMessage: (Map<String, dynamic> message) async {
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
      });
    } on PlatformException {}

    if(!Platform.isAndroid) {
      jpush.setAuth(enable: true);
    }
    // jpush.setAuth(enable: true);
    jpush.setup(
      appKey: jpushAppKey, //你自己应用的 AppKey
      channel: "theChannel",
      production: true,
      debug: false,
    );
    //如果用户已经正常登录 设置别名为用户id
    if(Global.userinfo != null && Global.userinfo?.uid != 0) {
      jpush.setAlias('uid${Global.userinfo!.uid.toString()}').then((map) {
        print("设置别名成功");
      });
    }


    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    // jpush.isNotificationEnabled().then((bool value) {
    //     var msg = "通知授权是否打开: $value";
    //     if(!value) {
    //       jpush.openSettingsForNotification();
    //     }
    //   }).catchError((onError) {
    //     var msg = "通知授权是否打开: ${onError.toString()}";
    //   });

    // Platform messages may fail, so we use a try/catch PlatformException.
    // jpush.getRegistrationID().then((rid) {
    //   print("flutter get registration id : $rid");
    // });
  }

  static Widget openFadeContainer(Widget first, Widget second) {
    return OpenContainer(
        openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
        transitionType: ContainerTransitionType.fade,
        //初始化打开的页面
        closedBuilder: (BuildContext context, VoidCallback _) {
          return first;
        },
        transitionDuration: const Duration(milliseconds: 600),
        //点击后跳转的页面
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return SwipeToDismissWrap(child: second);
        });
  }

  static showDialog2({title, content, okText, cancelText, okPressed}) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: SimpleTextDialog(title, content, okText: okText, cancelText: cancelText,),
      // btnCancelOnPress: () {},
      // btnOkOnPress: () {},
    )..show().then((value) {
      if (value != null && value) {
        okPressed();
      }
    });
  }

  static showPhotoDialog(pressed) {
    return Global.showDialog2(title: '温馨提示',
        content: '您没有开启相册权限，开启后可用于设置头像、身份识别、保存海报', okText: '去开启', cancelText: '我再想想',
        okPressed: pressed);
  }
  static showCameraDialog(pressed) {
    return Global.showDialog2(title: '温馨提示',
        content: '您没有开启相机权限，开启后可用于设置头像、身份识别、人脸识别', okText: '去开启', cancelText: '我再想想',
        okPressed: pressed);
  }
  static Future showHuodongDialog(ActivityInfo data, {delaySeconds= 2, fun}) async {
    if(dialogShowing) {
      return;
    }
    dialogShowing = true;
    Future.delayed(Duration(seconds: delaySeconds), () {
      showGeneralDialog(
          context: context,
          barrierDismissible:false,
          barrierLabel: '',
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
            return Scaffold(backgroundColor: Colors.transparent, body:HuodongDialog(data, (){
              dialogShowing = false;
              Global.setTodayString();
              if(fun != null) {
                fun();
              }
            }));
          });
    });
  }


  static Future showContentParseDialog(data) async {
    if(dialogShowing) {
      return;
    }
    dialogShowing = true;
    Future.delayed(Duration(seconds: 1), () {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.noHeader,
        showCloseIcon: true,
        body: ContentParseDialog(data['code'], data['data']),
          onDismissCallback: (DismissType type){
            dialogShowing = false;
          }
        // btnCancelOnPress: () {},
        // btnOkOnPress: () {},
      )..show();
    });
  }

  static Future initCommissionInfo() async {

    Map<String, dynamic> json = await BService.commissionInfo();
    if (json.isEmpty) {
      return;
    }
    CommissionInfo commissionInfo = CommissionInfo.fromJson(json);
    Global.commissionInfo = commissionInfo;

  }

  static Future showChannelAuthDialog(callback) async {
      if(dialogShowing) {
        return;
      }
      dialogShowing = true;
      AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          showCloseIcon: true,
          body: ChannelAuthDialog({'callback':callback}),
          onDismissCallback: (DismissType type){
            dialogShowing = false;
          }
        // btnCancelOnPress: () {},
        // btnOkOnPress: () {},
      )..show();
  }


  static Future showPddAuthDialog(callback) async {
    if(dialogShowing) {
      return;
    }
    dialogShowing = true;
    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        showCloseIcon: true,
        body: PddAuthDialog({'callback':callback}),
        onDismissCallback: (DismissType type){
          dialogShowing = false;
        }
    )..show();
  }

  static String getHideName(String nickname) {
    if(nickname.isNotEmpty && Global.isPhone(nickname)) {
      nickname = nickname.replaceAll(nickname.substring(3,7), '****');
    }
    return nickname;
  }

  static Future savePrefs(key, value) async {
    await initPrefs();
    await _prefs?.setString(key, value);
  }
  static Future<String> getPrefsString(key) async {
    await initPrefs();
    return _prefs?.getString(key) ?? '';
  }


  static Future<String>  encodeString(String content) async {
    final publicPem = await rootBundle.loadString('assets/key/public.pem'); //key/public.pem为我上方放的公钥位置 这里不可使用encrypt文档中的parseKeyFromFile方法，会显示找不到文件
    dynamic publicKey = RSAKeyParser().parse(publicPem);

    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(content).base64; //返回加密后的base64格式文件
  }

  static Future update(PackageInfo packageInfo) async {
    if(Global.isWeb()) {
      return;
    }
    String version = packageInfo.version;
    Map res = await BService.updateConfig();
    if(res == null || res.isEmpty) {
      return;
    }
    int enable = res['enable']??'0';
    if(enable == 0) {
      return;
    }
    String url;
    String latestVersion;
    if(Global.isIOS()) {
      url = res['iosUrl'];
      latestVersion = res['iosVersion'];
    } else {
      url = res['androidUrl'];
      latestVersion = res['androidVersion'];
    }
    //1.0.15 需要判断第一个数字大于提示升级，第二个数字大于时提示升级 第三个数字大于时提示升级
    List<String> curs = version.split('.');
    List<String> las = latestVersion.split('.');
    if(curs.length != las.length) {
      return;
    }
    if(num.parse(las[0])>num.parse(curs[0])
        || (num.parse(las[0])==num.parse(curs[0]) && num.parse(las[1])>num.parse(curs[1]))
        || (curs.length > 2 && num.parse(las[0])==num.parse(curs[0]) &&
            num.parse(las[1])==num.parse(curs[1]) &&
            num.parse(las[2])>num.parse(curs[2]))) {
      int forceUpdate = res['forceUpdate'];
      showSignDialog(context, title:'新版本上线啦', desc: '立即更新', okTxt: '去更新',
          forceUpdate: forceUpdate==1, (){
            LaunchApp.launchInBrowser(url);
            // launchUrl(Uri.parse(url));
          });
    }
  }

  static Future<int> getAndroidVersion() async {
    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    return androidDeviceInfo.version.sdkInt;
  }
}