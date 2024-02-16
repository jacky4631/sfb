/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/util/colors.dart';
import 'package:sufenbao/util/global.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../service.dart';

class AvatarHelper{

  static Future<String?> selectAvatar(BuildContext context) async {
    try{
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(context,
          pickerConfig: AssetPickerConfig(maxAssets: 1, textDelegate: AssetPickerTextDelegate()));
      if (assets != null && assets.isNotEmpty) {
        File file = await assets[0].file ??File('a');

        CroppedFile? croppedFile = await ImageCropper().cropImage(
          cropStyle: CropStyle.circle,
          compressQuality: 30,
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: '裁剪头像',
                toolbarColor: Colours.app_main,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                // hideBottomControls: true,
                lockAspectRatio: true),
            IOSUiSettings(
              title: '裁剪头像',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );
        if(croppedFile != null) {

          var formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(croppedFile.path)
          });
          String avatarUrl = await BService.uploadAvatar(formData);

          await BService.userEdit({'avatar': avatarUrl});
          return avatarUrl;
        }
      }
    }catch(e) {
      flog(e);
      Global.showPhotoDialog((){
        openAppSettings();
      });
    }
    return null;
  }


}