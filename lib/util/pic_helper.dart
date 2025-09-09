/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/util/global.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PicHelper{

  static void selectPic(BuildContext context, Function callback, {maxAssets=1}) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps != PermissionState.authorized && ps != PermissionState.limited) {
      Global.showPhotoDialog((){
        openAppSettings();
      });
      return;
    }
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(maxAssets: maxAssets, textDelegate: AssetPickerTextDelegate()));
    if (assets != null && assets.isNotEmpty) {
      File file = await assets[0].file ??File('a');

      if(file != null && callback != null) {
        callback(file);
      }
    }
  }

  static void openCamera(BuildContext context,
      {required Function callback,preferredLensDirection=CameraLensDirection.back,
        cameraQuarterTurns=0,
        ForegroundBuilder? foregroundBuilder}) async {
    // 相机权限
    var isGrantedCamera = await Permission.camera.request().isGranted;
    if (!isGrantedCamera) {
      Global.showCameraDialog((){
        openAppSettings();
      });
      return;
    }
    // await MaskForCameraView.initialize();
    // Navigator.pushNamed(context, '/idCard',arguments: {'fun':(v1,v2, v3){
    //   flog(v1);
    // }}).then((file) {
    //   if(file != null && callback != null) {
    //     callback(file);
    //   }
    // });

    final AssetEntity? result = await CameraPicker.pickFromCamera(context,
      pickerConfig: CameraPickerConfig(
          preferredLensDirection: preferredLensDirection,
          cameraQuarterTurns: cameraQuarterTurns,
          foregroundBuilder: (context, controller){
            return Center(
                child: PWidget.stack([
                  RotatedBox(quarterTurns: 45, child:PWidget.text('请将身份证置于虚线框内',[Colors.grey, 18,true])),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        dashPattern: [8, 4],
                        strokeWidth: 4,
                        color: Colors.grey,
                        padding: EdgeInsets.all(8),
                        borderPadding: EdgeInsets.all(4),
                      ),
                      child: Container(
                        width: 280,
                        height: 450,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  )
                ],[0.0,0.0]),
              );
          }
      ),
    );
    File? file = await result?.file;

    if(file != null && callback != null) {
      callback(file);
    }
  }

}