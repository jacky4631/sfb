import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/route.dart';
import '../config/resource_mananger.dart';

enum ImageType {
  normal,
  random, //随机
  assets, //资源目录
}

class WrapperImage extends StatelessWidget {
  final String? url;
  final double width;
  final double? height;
  final BoxFit fit;
  final ImageType imageType;
  final int w;
  final Color? color;
  static double? _rwidth;
  final bool isBlack;
  final String? imgUrl;
  final Function? urlBuilder;
  final Alignment alignment;
  final Map<String, String>? headers;
  final int? memCacheWidth;

  WrapperImage({
    this.url,
    this.width = double.infinity,
    this.height,
    this.imageType: ImageType.normal,
    this.fit: BoxFit.cover,
    this.w = 0,
    this.color,
    this.isBlack = false,
    this.imgUrl,
    this.urlBuilder,
    this.alignment = Alignment.center,
    this.headers,
    this.memCacheWidth
  });

  @override
  Widget build(BuildContext contex) {
    try {
      _rwidth = MediaQuery.of(contex).size.width;
      if (urlBuilder == null) {
        if (url == null || url == '' || url == 'null') return buildCatchImageView();

        if (isBlack) {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            alignment: alignment,
            fadeInDuration: Duration(milliseconds: RouteState.animationTime),
            fadeOutDuration: Duration(milliseconds: RouteState.animationTime),
            placeholderFadeInDuration: Duration(milliseconds: RouteState.animationTime),
            placeholder: (_, __) => ImageHelper.placeHolder(imageUrl, width: width, height: height),
            errorWidget: (_, __, ___) => ImageHelper.error(width: width, height: height, color: color ?? Colors.black26),
            fit: fit,
            colorBlendMode: BlendMode.hue,
            color: Colors.black87,
            httpHeaders: headers,
              memCacheWidth:memCacheWidth
          );
        } else {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            alignment: alignment,
            fadeInDuration: Duration(milliseconds: RouteState.animationTime),
            fadeOutDuration: Duration(milliseconds: RouteState.animationTime),
            placeholderFadeInDuration: Duration(milliseconds: RouteState.animationTime),
            placeholder: (_, __) => ImageHelper.placeHolder(imageUrl, width: width, height: height),
            errorWidget: (_, __, ___) => ImageHelper.error(width: width, height: height, color: color ?? Colors.black26),
            fit: fit,
            httpHeaders: headers,
              memCacheWidth:memCacheWidth
          );
        }
      } else {
        if (urlBuilder?.call() == null || urlBuilder?.call() == '' || urlBuilder?.call() == 'null')
          return buildCatchImageView();
        if (isBlack) {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            alignment: alignment,
            fadeInDuration: Duration(milliseconds: RouteState.animationTime),
            fadeOutDuration: Duration(milliseconds: RouteState.animationTime),
            placeholderFadeInDuration: Duration(milliseconds: RouteState.animationTime),
            placeholder: (_, __) => ImageHelper.placeHolder(imageUrl, width: width, height: height),
            errorWidget: (_, __, ___) => ImageHelper.error(width: width, height: height, color: color ?? Colors.black26),
            fit: fit,
            colorBlendMode: BlendMode.hue,
            color: Colors.black87,
            httpHeaders: headers,
              memCacheWidth:memCacheWidth
          );
        } else {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            alignment: alignment,
            fadeInDuration: Duration(milliseconds: RouteState.animationTime),
            fadeOutDuration: Duration(milliseconds: RouteState.animationTime),
            placeholderFadeInDuration: Duration(milliseconds: RouteState.animationTime),
            placeholder: (_, __) => ImageHelper.placeHolder(imageUrl, width: width, height: height),
            errorWidget: (_, __, ___) => ImageHelper.error(width: width, height: height, color: color ?? Colors.black26),
            fit: fit,
            httpHeaders: headers,
              memCacheWidth:memCacheWidth
          );
        }
      }
    } catch (e) {
      return buildCatchImageView();
    }
  }

  Widget buildCatchImageView() {
    return Container(
      width: width,
      height: height,
      color: Colors.black12,
    );
  }

  String get imageUrl {
    switch (imageType) {
      case ImageType.random:
        return ImageHelper.randomUrl(key: url!, width: width == double.infinity
            ? _rwidth!.toInt() : width.toInt(), height: height!.toInt());
      case ImageType.assets:
        return ImageHelper.wrapAssets(url!);
      case ImageType.normal:
        return ImageHelper.wrapUrl(urlBuilder != null ? urlBuilder!.call() : url, w: w, imgUrl: imgUrl);
    }
  }
}
