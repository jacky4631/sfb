import 'dart:developer' as f;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/net/pgyer_api.dart';
import '../widget/custom_route.dart';
import 'package:url_launcher/url_launcher.dart';

///上传file
Future<String?> uploadFile(PickedFile file) async {
  List<int> byteData = await file.readAsBytes();
  List paths = file.path.split("/");
  MultipartFile multipartFile = MultipartFile.fromBytes(
    byteData,
    filename: paths[paths.length - 1],
  );
  FormData formData = FormData.fromMap({"file": multipartFile});
  var response = await http.post<String>('/app/common/addImage', data: formData);
  return response.data;
}

///ios风格-路由跳转
///
///isBtm ： 是否从底部弹出，默认右边
///
///page : 跳转的页面
Future push(
  BuildContext context,
  Widget page, {
  bool isMove = true,
  bool isMoveBtm = false,
  bool isNoClose = true,
  bool isSlideBack = true,
  bool isDelay = true,
  int duration = 400,
  bool opaque = false,
}) async {
  if (isNoClose) {
    return Navigator.push(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
    );
  } else {
    return Navigator.pushAndRemoveUntil(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
      (v) => v == null,
    );
  }
}

Future toPage(
  Widget page, {
  bool isMove = true,
  bool isMoveBtm = false,
  bool isNoClose = true,
  bool isSlideBack = true,
  bool isDelay = true,
  int duration = 400,
  bool opaque = false,
}) async {
  if (isNoClose) {
    return Navigator.push(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
    );
  } else {
    return Navigator.pushAndRemoveUntil(
      context,
      CustomRoute(
        isSlideBack ? page : WillPopScope(onWillPop: () async => await Future.value(false), child: page),
        opaque: opaque,
        isMove: isMove,
        isMoveBtm: isMoveBtm,
        duration: Duration(milliseconds: duration),
      ),
      (v) => v == null,
    );
  }
}

/// 调起拨号页
void launchTelURL(phone) async {
  String url = 'tel:' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showToast('拨号失败！', position: StyledToastPosition.center);
  }
}

///退出当前路由栈
pop(BuildContext _context, [map]) async {
  return Navigator.pop(context, map);
}

///退出当前路由栈
close([map]) async {
  return Navigator.pop(context, map);
}

///异常处理
error(e, Function(dynamic, int, int) callback) {
  var error = e as DioException;
  switch (error.type) {
    case DioExceptionType.badResponse:
      flog(error.response?.data);
      try {
        if (error.response?.data['message'] == null || error.response?.data['message'] == '') {
          callback('系统繁忙，请稍后重试', 1, error.response!.statusCode!);
        } else {
          callback(error.response?.data['message'], 1, error.response!.statusCode!);
        }
      } catch (e) {
        callback('系统繁忙，请稍后重试', 1, error.response!.statusCode!);
      }
      break;
    case DioExceptionType.unknown:
      var str = error.message!.contains('SocketException');
      callback(str ? '系统繁忙，请稍后重试' : '请求错误', 2, 200);
      break;
    case DioExceptionType.connectionTimeout:
      callback('连接超时', 3, 200);
      break;
    case DioExceptionType.sendTimeout:
      callback('发送超时', 4, 200);
      break;
    case DioExceptionType.receiveTimeout:
      callback('接收超时', 5, 200);
      break;
    case DioExceptionType.cancel:
      callback('连接被取消', 6, 200);
      break;
    case DioExceptionType.badCertificate:
      callback('验签失败', 6, 200);
      break;
    case DioExceptionType.connectionError:
      callback('接收错误', 5, 200);
      break;
  }
}

/// 调起拨号页
void phoneTelURL(String phone) async {
  String url = 'tel: ' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showToast('拨号失败！');
  }
}

/// 调起系统
void lunTelURL(String type, {String msg= '分享失败！'}) async {
  if (await canLaunch(type)) {
    await launch(type);
  } else {
    showToast(msg);
  }
}

///去除滑动水波纹
bool handleGlowNotification(OverscrollIndicatorNotification notification) {
  if ((notification.leading && true) || (!notification.leading && true)) {
    notification.disallowIndicator();
    return true;
  }
  return false;
}

List getTextCon(int count) {
  List textconlist = [];

  for (int a = 0; a < count; a++) {
    var textcon = TextEditingController();
    textconlist.add(textcon);
  }

  return textconlist;
}

String checkTextTrim(var text) {
  if (text != null || text != "" || text.toString() != "null") {
    return text;
  }

  return "";
}

///时间转换
String chatTime(DateTime old) {
  if (old == null) return '-';
  var minute = 1000 * 60; //把分，时，天，周，半个月，一个月用毫秒表示
  var hour = minute * 60;
  var day = hour * 24;
  var now = DateTime.now().millisecondsSinceEpoch; //获取当前时间毫秒
  var diffValue = now - old.millisecondsSinceEpoch; //时间差
  if (diffValue < 0) return "刚刚";
  var result = '';
  var minC = diffValue ~/ minute; //计算时间差的分，时，天，周，月
  var hourC = diffValue ~/ hour;
  var dayC = diffValue ~/ day;
  if (dayC >= 1 && dayC <= 6) {
    result = "${dayC.toInt()}天前";
  } else if (hourC >= 1 && hourC <= 23) {
    result = "${hourC.toInt()}小时前";
  } else if (minC >= 1 && minC <= 59) {
    result = "${minC.toInt()}分钟前";
  } else if (diffValue >= 0 && diffValue <= minute) {
    result = "刚刚";
  } else {
    var y = old.year.toString().padLeft(4, '0');
    var m = old.month.toString().padLeft(2, '0');
    var d = old.day.toString().padLeft(2, '0');

    var s = old.hour.toString().padLeft(2, '0');
    var f = old.minute.toString().padLeft(2, '0');

    result = '$y-$m-$d\t$s:$f';
  }
  return result;
}

///时间转换第二版
String toTime(date, [bool isParse = true]) {
  DateTime old;
  if (isParse)
    old = DateTime.parse(date);
  else
    old = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (old == null) return '-';
  var minute = 1000 * 60; //把分，时，天，周，半个月，一个月用毫秒表示
  var hour = minute * 60;
  var day = hour * 24;
  var week = day * 7;
  var month = day * 30;
  var now = DateTime.now().millisecondsSinceEpoch; //获取当前时间毫秒
  var diffValue = now - old.millisecondsSinceEpoch; //时间差
  if (diffValue < 0) return "刚刚";
  var result = '';
  var minC = diffValue ~/ minute; //计算时间差的分，时，天，周，月
  var hourC = diffValue ~/ hour;

  // ignore: unused_local_variable
  var dayC = diffValue ~/ day;
  // ignore: unused_local_variable
  var weekC = diffValue ~/ week;
  // ignore: unused_local_variable
  var monthC = diffValue ~/ month;

  if (hourC >= 1 && hourC <= 23) {
    result = "${hourC.toInt()}小时前";
  } else if (minC >= 1 && minC <= 59) {
    result = "${minC.toInt()}分钟前";
  } else if (diffValue >= 0 && diffValue <= minute) {
    result = "刚刚";
  } else {
    var y = old.year.toString().padLeft(4, '0');
    var m = old.month.toString().padLeft(2, '0');
    var d = old.day.toString().padLeft(2, '0');

    var s = old.hour.toString().padLeft(2, '0');
    var f = old.minute.toString().padLeft(2, '0');

    result = '$y-$m-$d\t$s:$f';
  }
  return result;
}

///获取当前时间戳
int getTime() => DateTime.now().millisecondsSinceEpoch;

///时间戳转中文
String toDate(milliseconds) {
  if (milliseconds == 0 || milliseconds == null) {
    return '';
  } else {
    return [
      DateTime.fromMillisecondsSinceEpoch(milliseconds).year,
      DateTime.fromMillisecondsSinceEpoch(milliseconds).month,
      DateTime.fromMillisecondsSinceEpoch(milliseconds).day,
    ].join('-');
  }
}

///时间戳转中文
String toTimeStr(milliseconds) {
  if (milliseconds == 0 || milliseconds == null) {
    return '';
  } else {
    return [
      DateTime.fromMillisecondsSinceEpoch(milliseconds).hour >= 10 ? DateTime.fromMillisecondsSinceEpoch(milliseconds).hour : '0${DateTime.fromMillisecondsSinceEpoch(milliseconds).hour}',
      DateTime.fromMillisecondsSinceEpoch(milliseconds).minute >= 10 ? DateTime.fromMillisecondsSinceEpoch(milliseconds).minute : '0${DateTime.fromMillisecondsSinceEpoch(milliseconds).minute}',
      // DateTime.fromMillisecondsSinceEpoch(milliseconds).second >= 10 ? DateTime.fromMillisecondsSinceEpoch(milliseconds).second : '0${DateTime.fromMillisecondsSinceEpoch(milliseconds).second}',
    ].join(':');
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
BuildContext context = navigatorKey.currentState!.overlay!.context;

final GlobalKey<NavigatorState> navigatorKey1 = new GlobalKey<NavigatorState>();
var context1 = navigatorKey.currentState?.overlay!.context;

int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
  if (ignoreTime) {
    int v = a.millisecondsSinceEpoch ~/ 86400000 - b.millisecondsSinceEpoch ~/ 86400000;
    if (v < 0) return -v;
    return v;
  } else {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ 86400000;
  }
}

int toDay(DateTime a, int millisecondsSinceEpoch) {
  return double.parse(
    ((millisecondsSinceEpoch - a.millisecondsSinceEpoch) / 86400000).toString(),
  ).toInt();
}

void flog(v, [String? name]) => f.log(v.toString(), name: name ?? 'flog');

///是否移动端
bool get isMobile {
  if (kIsWeb) {
    if (MediaQuery.of(context!).size.aspectRatio <= 1 || MediaQuery.of(context!).size.width <= 500) {
      return true;
    } else {
      return false;
    }
  } else if (Platform.isAndroid || Platform.isIOS) {
    return true;

  } else {
    return false;
  }
}

///是否深色模式
bool get isDark => (MediaQuery.platformBrightnessOf(context) == Brightness.dark);

int get isDarkIndex => isDark ? 0 : 1;

void mapFlog(data, i, {bool isSort = true}) {
  // return;
  // ignore: dead_code
  var map = data as Map;
  List<dynamic> keys = map.keys.toList();
  if (isSort) {
    keys.sort((a, b) {
      List<int> al = a.codeUnits;
      List<int> bl = b.codeUnits;
      for (int i = 0; i < al.length; i++) {
        if (bl.length <= i) return 1;
        if (al[i] > bl[i]) {
          return 1;
        } else if (al[i] < bl[i]) return -1;
      }
      return 0;
    });
  }
  var treeMap = Map();
  flog('map排序并输出===========================================');
  flog('{', '$i');
  keys.forEach((element) => treeMap[element] = map[element]);
  treeMap.forEach((f, v) => flog(' $f : $v,', '$i'));
  flog('}', '$i');
  flog('======================================================');
}
