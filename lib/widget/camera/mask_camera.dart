/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sufenbao/widget/camera/result.dart';

import 'inside_line.dart';
import 'main_crop.dart';

class MaskOCRCam extends StatefulWidget {
  const MaskOCRCam(
      {Key? key,
      this.ocrType = 'idCard',
      this.ocrSubType,
      required this.onCapture,
      this.showRetakeBtn = true,
      this.txtSubmit = 'Submit',
      this.btnSubmit,
      this.showPopBack = true})
      : super(key: key);

  final String ocrType;
  final String? ocrSubType;
  final Function onCapture;
  final bool showRetakeBtn;
  final Function? btnSubmit;
  final String txtSubmit;
  final bool showPopBack;

  @override
  State<MaskOCRCam> createState() => _MaskOCRCamState();
}

class _MaskOCRCamState extends State<MaskOCRCam> {
  @override
  Widget build(BuildContext context) {
    return _buildShowResultList(widget.ocrSubType ?? "");
  }

  Widget _buildShowResultList(String ocrType) {
    return MaskForCameraView(
        ocrType: ocrType,
        boxHeight: 210,
        boxWidth: 300,
        visiblePopButton: widget.showPopBack,
        insideLine: MaskForCameraViewInsideLine(
          position: MaskForCameraViewInsideLinePosition.endPartThree,
          direction: MaskForCameraViewInsideLineDirection.horizontal,
        ),
        boxBorderWidth: 2.6,
        cameraDescription: MaskForCameraViewCameraDescription.rear,
        onTake: (MaskForCameraViewResult res) => (imageToText(res))
    );
  }
  Future imageToText(MaskForCameraViewResult res) async {
    if (widget.ocrType == 'idCard') {
      Uint8List? imageInUnit8List = res.croppedImage;

      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image${DateTime.now().microsecond}.png').create();
      file.writeAsBytesSync(imageInUnit8List!);
      Navigator.pop(context, file);

    }
  }
}