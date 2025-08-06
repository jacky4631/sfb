/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/util/toast_utils.dart';

import 'global.dart';

//全局key-截图key
GlobalKey boundaryKey = GlobalKey();

class RepaintBoundaryUtils {
  //生成截图
  //截屏图片生成图片流ByteData
  Future<String> captureImage() async {
    RenderRepaintBoundary? boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
    var image = await boundary!.toImage(pixelRatio: dpr);
    // 将image转化成byte
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    var filePath = "";

    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // 获取手机存储（getTemporaryDirectory临时存储路径）
    Directory applicationDir = await getTemporaryDirectory();
    // getApplicationDocumentsDirectory();
    // 判断路径是否存在
    bool isDirExist = await Directory(applicationDir.path).exists();
    if (!isDirExist) Directory(applicationDir.path).create();
    // 直接保存，返回的就是保存后的文件
    File saveFile = await File(applicationDir.path + "${DateTime.now().toIso8601String()}.jpg").writeAsBytes(pngBytes);
    filePath = saveFile.path;
    return filePath;
  }

//申请存本地相册权限
  Future<bool> getPormiation() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
        ].request();
        // saveImage(globalKey);
      }
      return status.isGranted;
    } else {
      int version = await Global.getAndroidVersion();
      PermissionStatus status;
      if (version >= 33) {
        status = await Permission.photos.status;
        if (status.isDenied) {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.photos,
          ].request();
        }
      } else {
        status = await Permission.storage.status;
        if (status.isDenied) {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
          ].request();
        }
      }
      return status.isGranted;
    }
  }

//保存到相册
  Future savePhoto() async {
    RenderRepaintBoundary? boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;

    double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
    var image = await boundary!.toImage(pixelRatio: dpr);
    // 将image转化成byte
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await getPormiation();

    if (permition) {
      if (Platform.isIOS) {
        var status = await Permission.photos.status;
        if (status.isGranted) {
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaver.saveImage(images, quality: 60, name: "dianliubao");
          ToastUtils.showToastBOTTOM("保存成功");
        }
        if (status.isDenied) {
          print("IOS拒绝");
        }
      } else {
        //安卓
        int version = await Global.getAndroidVersion();
        PermissionStatus status;
        if (version >= 33) {
          status = await Permission.photos.status;
        } else {
          status = await Permission.storage.status;
        }
        if (status.isGranted) {
          print("Android已授权");
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaver.saveImage(images, quality: 60);
          if (result != null) {
            ToastUtils.showToastBOTTOM("保存成功");
          } else {
            print('error');
          }
        }
      }
    } else {
      //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
      savePhoto();
    }
  }
}
