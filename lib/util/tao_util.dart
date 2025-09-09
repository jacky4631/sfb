/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';

import 'global.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

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
// 从文件路径压缩图片
Future<Uint8List?> compressImageFromFile(String filePath, {
  int maxWidth = 1080,
  int maxHeight = 1920,
  int quality = 85,
}) async {
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  return compressImage(bytes, maxWidth: maxWidth, maxHeight: maxHeight, quality: quality);
}

// 压缩图片并调整尺寸
Future<Uint8List> compressImage(Uint8List imageBytes, {
  int maxWidth = 1280,
  int maxHeight = 1280,
  int quality = 85,
}) async {
  // 解码图片
  final image = img.decodeImage(imageBytes);
  if (image == null) return imageBytes;

  // 调整尺寸
  img.Image resizedImage;
  if (image.width > maxWidth || image.height > maxHeight) {
    resizedImage = img.copyResize(
      image,
      width: maxWidth,
      height: maxHeight,
    );
  } else {
    resizedImage = image;
  }

  // 压缩图片
  return img.encodeJpg(resizedImage, quality: quality);
}