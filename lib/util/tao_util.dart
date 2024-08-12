/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'global.dart';

String getTbMainPic(v) {
  var pic = v['mainPic'];
  if(pic != null && pic.isNotEmpty) {
    if(pic.endsWith('png')) {
      return pic;
    }
    return '${pic}_400x400';
  }
  pic = v['pic'];
  if(pic != null && pic.isNotEmpty) {
    return '${pic}_400x400';
  }
  pic = v['background_img'];
  if(pic != null && pic.isNotEmpty) {
    if((pic as String).endsWith("_.webp")) {
      return pic.replaceAll('_.webp', '');
    }
    return '${pic}_400x400';
  }

  return '';
}
String getLifeMainPic(v) {
  var pic = v['item_img'];
  if(pic != null && pic.isNotEmpty) {
    if(pic.endsWith('png')) {
      return pic;
    }
    return '${pic}_400x400';
  }
  pic = v['pic'];
  if(pic != null && pic.isNotEmpty) {
    return '${pic}_400x400';
  }
  pic = v['background_img'];
  if(pic != null && pic.isNotEmpty) {
    if((pic as String).endsWith("_.webp")) {
      return pic.replaceAll('_.webp', '');
    }
    return '${pic}_400x400';
  }

  return '';
}

String getShareContent() {
  String shareContent = Global.appInfo.shareContent;
  shareContent = shareContent.replaceFirst("#url#", Global.appInfo.share)
      .replaceFirst('#APPNAME#', APP_NAME);
  if(Global.userinfo!=null) {
    shareContent = shareContent.replaceFirst("#code#", '邀请口令：${Global.userinfo!.code}\n━┉┉┉┉∞┉┉┉┉━\n');
  } else {
    shareContent = shareContent.replaceFirst("#code#",'');
  }
  return shareContent;
}