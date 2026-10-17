import 'package:sufenbao/me/model/activity_info.dart';

/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
class AppInfo {
  String kuCid = '';
  /// kuCid stores the complete CMS URL; callers extract only what they need.
  Uri? get cmsUri {
    final uri = Uri.tryParse(kuCid.trim());
    return uri != null && ['http', 'https'].contains(uri.scheme) && uri.host.isNotEmpty
        ? uri : null;
  }

  String get cmsCid => cmsUri?.queryParameters['cid'] ?? '';

  String? cmsActivityUrl(String tag) {
    final uri = cmsUri;
    if (uri == null || cmsCid.isEmpty) return null;
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      'tmp': tag,
      'code': cmsCid,
      'sp': '',
    }, fragment: '/sp').toString();
  }

  String share = '';
  String shareContent = '';
  String shareGoods = '';
  String alired = '';
  String taored = '';
  String? contractPreviewUrl;
  String skipCode = '1';
  String? yeePaySuccUrl;
  String? yeePayFailUrl;
  int spreadLevel = 3;
  ActivityInfo huodong = ActivityInfo();

  AppInfo();

  AppInfo.fromJson(Map<String, dynamic> json)
      : kuCid = json['kuCid'] ?? '',
        share = json['share']??'',
        shareContent = json['shareContent'],
        shareGoods = json['shareGoods'],
        alired = json['alired'],
        taored = json['taored'],
        contractPreviewUrl = json['contractPreviewUrl'],
        skipCode = json['skipCode'],
        yeePaySuccUrl = json['yeePaySuccUrl'],
        yeePayFailUrl = json['yeePayFailUrl'],
        spreadLevel = json['spreadLevel']??3,
        huodong = ActivityInfo.fromJson(json['huodong']);

  Map<String, dynamic> toJson() => {
    'kuCid': kuCid,
    'share': share,
    'shareContent': shareContent,
    'shareGoods': shareGoods,
    'alired': alired,
    'taored': taored,
    'contractPreviewUrl': contractPreviewUrl,
    'skipCode': skipCode,
    'yeePaySuccUrl': yeePaySuccUrl,
    'yeePayFailUrl': yeePayFailUrl,
    'spreadLevel': spreadLevel,
    'huodong': huodong
  };
}
