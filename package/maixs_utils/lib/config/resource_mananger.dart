import 'package:flutter/material.dart';
import 'net/Config.dart';

class ImageHelper {

  static String wrapUrl(String url, {int w = 0, String? imgUrl}) {
    if (url.startsWith('http')) {
      return url;
    }
    if (url.trim().length == 0) {
      return randomUrl(); //默认
    }
    String path = '${imgUrl ?? Config.ImgBaseUrl}$url' + (w == 0 ? '' : '?x-oss-process=image/resize,w_$w');
    return path;
  }

  static String wrapAssets(String url) {
    return url;
  }

  static Widget placeHolder(v,{required double width, double? height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
    );
  }

  static Widget error({
    required double width,
    double? height,
    double? size,
    required Color color,
  }) {

    return ColoredBox(
      color: Colors.black.withOpacity(0.05),
      child: Center(
        child: Icon(
          Icons.error_outline,
          size: size,
          color: color,
        ),
      ),
    );
  }

  static String randomUrl({int width = 100, int height = 100, String key = ''}) {
    return 'http://placeimg.com/$width/$height/${key.hashCode.toString() + key.toString()}';
  }
}

class IconFonts {
  IconFonts._();

  /// iconfont:flutter base
  static const String fontFamily = 'iconfont';

  static const IconData pageEmpty = IconData(0xe63c, fontFamily: fontFamily);
  static const IconData pageError = IconData(0xe600, fontFamily: fontFamily);
  static const IconData pageNetworkError = IconData(0xe678, fontFamily: fontFamily);
  static const IconData pageUnAuth = IconData(0xe65f, fontFamily: fontFamily);
}
