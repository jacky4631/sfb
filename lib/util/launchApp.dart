/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
//打开第三方app
import 'dart:convert';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alibc/alibc_const_key.dart';
import 'package:flutter_alibc/flutter_alibc.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'global.dart';

class LaunchApp {
  static const taobao = 'com.taobao.taobao';
  static const jd = 'com.jingdong.app.mall';
  static const pdd = 'com.xunmeng.pinduoduo';
  static const dy = 'com.ss.android.ugc.aweme';
  static const ele = 'me.ele';
  static const vip = 'com.achievo.vipshop';
  static const wechat = 'com.tencent.mm';

  static Future launchTb(
    context,
    url,
  ) async {
    launch(context, url, LaunchApp.taobao, color: Color(0XFFFF5E00));
  }

  static Future launchPdd(context, url, webUrl, {fun}) async {
    launch(context, url, LaunchApp.pdd, webUrl: webUrl, color: Color(0XFFFF5E00), fun: fun);
  }

  static Future launchJd(context, url) async {
    launch(context, url, LaunchApp.jd, color: Colors.red);
  }

  static Future launchVip(context, url, webUrl, {fun}) async {
    launch(context, url, LaunchApp.vip, webUrl: webUrl, color: Color(0xFFFB008D), fun: fun, comp: true);
  }

  static Future launchDy(context, url, webUrl) async {
    launch(context, url, LaunchApp.dy, webUrl: webUrl, color: Color(0xFF000000));
  }

  static Future launch(context, url, package, {webUrl, color, fun, comp, title}) async {
    try {
      if (Global.isWeb()) {
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } else if (Global.isIOS()) {
        try {
          await launchAppComp(comp, url);
        } catch (e) {
          if (fun != null) {
            fun();
          } else {
            launchWebView(context, webUrl ?? url, color: color, title: title);
          }
        }
      } else if (Global.isAndroid()) {
        var packageAva = await checkPackage(package);
        if (packageAva == null) {
          if (fun != null) {
            fun();
          } else {
            launchWebView(context, webUrl ?? url, color: color, title: title);
          }
        } else {
          await launchAppComp(comp, url);
        }
      } else {
        await launchAppComp(comp, url);
      }
    } catch (e) {
      await launchAppComp(comp, url);
    }
  }

  static Future launchAppComp(comp, url) async {
    if (comp != null && comp) {
      await launchInBrowser(url);
    } else {
      await launchApp(url);
    }
  }

  static UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

  static launchWebView(context, url, {color, title}) {
    var data = getPackageName(url);
    String t = '';
    if (data != null && data.isNotEmpty) {
      t = data['name'];
    } else if (title != null) {
      t = title;
    }
    Navigator.pushNamed(context, '/webview', arguments: {'url': url, 'title': t, 'check': false, 'color': color});
  }

  //打开app
  static Future launchApp(url) async {
    if (!Global.isWeb()) {
      var data = getPackageName(url);
      var packageAva = await checkPackage(data['package']);
      if (packageAva == null) {
        ToastUtils.showToast('${data['name']}APP未安装');
        return;
      }
      String parsedUrl = parseUrl(url) ?? '';
      if (Global.isIOS()) {
        //如果是淘宝调用百川，不是继续愿流程
        if (data['package'] == taobao) {
          FlutterAlibc.openByUrl(
            url: url,
            schemeType: AlibcSchemeType.AlibcSchemeTaoBao,
          );
        } else {
          await launchInBrowser(parsedUrl);
        }
      } else {
        Uri uri = Uri.parse(parsedUrl);
        if (await canLaunchUrl(uri)) {
          if (Global.isIOS()) {
            await launchInBrowser(parsedUrl);
          } else {
            await launchUrl(uri);
          }
        }
      }
    } else {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    return true;
  }

  static launchInBrowser(String url) async {
    if (!await launcher.launch(
      url,
      useSafariVC: false,
      useWebView: false,
      enableJavaScript: false,
      enableDomStorage: false,
      universalLinksOnly: false,
      headers: <String, String>{},
    )) {
      throw 'Could not launch $url';
    }
  }

  //打开app
  static launchFromWebView(url) async {
    var data = getPackageName(url);
    var packageAva = await checkPackage(data['package']);

    if (packageAva == null) {
      ToastUtils.showToast('${data['name']}APP未安装');
      return;
    }
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    return true;
  }

  static Future<AppInfo?> checkPackage(package) async {
    try {
      if (Global.isAndroid()) {
        return await AppCheck().checkAvailability(package);
      } else if (Global.isIOS()) {
        return await AppCheck().checkAvailability("calshow://");
      }
    } catch (e) {
      return null;
    }
  }

  //当返回空时 不阻止网页继续加载
  static String? parseUrl(String url) {
    if (url.contains("taobao.com") || url.contains("tb.cn")) {
      return parseTaoBaoUrl(url);
    } else if (url.contains("jd.com") || url.startsWith("openapp.jdmobile://")) {
      //如果是京粉连接不阻止
      if (url.startsWith('https://jingfen.jd.com') || url.startsWith('https://h5.m.jd.com')) {
        return null;
      }
      return parseJDUrl(url);
    } else if (url.contains('pinduoduo.com') || url.contains('yangkeduo.com')) {
      if (Global.isAndroid()) {
        return 'pinduoduo://com.xunmeng.pinduoduo/$url';
      }
      return url.replaceFirst("https", "pinduoduo");
    } else if (url.contains('snssdk1128')) {
      return url;
    } else if (url.contains('ele.me')) {
      return url;
    } else if (url.contains('vipshop') || url.contains('vip.com')) {
      return url;
    }
    return null;
  }

  //当返回空时 不阻止网页继续加载
  static Map getPackageName(String url) {
    if (url.contains("taobao.com") || url.contains('tb.cn')) {
      return {'name': '淘宝', 'package': taobao};
    } else if (url.contains("jd.com") || url.startsWith("openapp.jdmobile://")) {
      return {'name': '京东', 'package': jd};
    } else if (url.contains("mobile.yangkeduo.com") || url.contains("pinduoduo.com")) {
      return {'name': '拼多多', 'package': pdd};
    } else if (url.contains("snssdk1128") || url.contains("douyin")) {
      return {'name': '抖音', 'package': dy};
    } else if (url.contains("ele.me")) {
      return {'name': '饿了么', 'package': ele};
    } else if (url.contains("vipshop") || url.contains('vip.com')) {
      return {'name': '唯品会', 'package': vip};
    }
    return {};
  }

  static String parseTaoBaoUrl(String url) {
    if (url.startsWith("https://")) {
      url = url.replaceFirst("https://", "taobao://");
    }
    if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "taobao://");
    }
    if (url.startsWith("tbopen://")) {
      url = url.replaceFirst("tbopen://", "taobao://");
    }
    return url;
  }

  static parseJDUrl(String url) {
    if (url.startsWith('openapp.jdmobile://')) {
      return url;
    }
    var data = {'category': 'jump', 'des': 'getCoupon', 'url': url, 'sourceType': 'PCUBE_CHANNEL'};
    return 'openapp.jdmobile://virtual?params=${Uri.encodeComponent(jsonEncode(data))}'.replaceAll("\\/", "/");
  }
}
