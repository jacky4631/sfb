/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
/// 使用 DefaultCacheManager 类（可能无法自动引入，需要手动引入）
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 授权管理
import 'package:permission_handler/permission_handler.dart';
/// 图片缓存管理
import 'package:cached_network_image/cached_network_image.dart';
/// 保存文件或图片到本地
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:sufenbao/Util/toast_utils.dart';

class saveNetWorkImages {
  /// 保存图片到相册
  ///
  /// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
  static Future<void> saveImage(String imageUrl, {bool isAsset: false}) async {
    try {
      if (imageUrl == null) throw '保存失败，图片不存在！';

      /// 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus != PermissionStatus.granted) {
          throw '无法存储图片，请先授权！';
        }
      }

      /// 保存的图片数据
      Uint8List imageBytes;

      if (isAsset == true) {
        /// 保存资源图片
        ByteData bytes = await rootBundle.load(imageUrl);
        imageBytes = bytes.buffer.asUint8List();
      } else {
        /// 保存网络图片
        CachedNetworkImage image = CachedNetworkImage(imageUrl: imageUrl);
        BaseCacheManager manager = image.cacheManager ?? DefaultCacheManager();
        File file = await manager.getSingleFile(
          image.imageUrl,
        );
        imageBytes = await file.readAsBytes();
      }

      /// 保存图片
      final result = await ImageGallerySaver.saveImage(imageBytes);

      if (result == null || result == '') throw '图片保存失败';

      print("保存成功");
      ToastUtils.showToastBOTTOM("保存成功");
    } catch (e) {
      print(e.toString());
    }
  }
}