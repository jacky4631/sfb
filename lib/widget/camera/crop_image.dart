/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

import 'inside_line.dart';
import 'result.dart';

Future<MaskForCameraViewResult?> cropImage(
    String ocrType,
    String imagePath,
    int cropHeight,
    int cropWeight,
    double screenHeight,
    double screenWidth,
    MaskForCameraViewInsideLine? insideLine) async {
  Uint8List imageBytes = await File(imagePath).readAsBytes();

  Image? image = decodeImage(imageBytes);

  double? increasedTimesW;
  double? increasedTimesH;
  if (image!.width > screenWidth) {
    increasedTimesW = image.width / screenWidth;
    increasedTimesH = image.height / screenHeight;
  } else {
    return null;
  }

  double sX = (screenWidth - cropWeight) / 2;
  double sY = (screenHeight - cropHeight) / 2;

  double x = sX * increasedTimesW;
  double y = sY * increasedTimesH;

  double w = cropWeight * increasedTimesW;
  double h = cropHeight * increasedTimesH;

  Image croppedImage = copyCrop(image,
      x: x.toInt(), y: y.toInt(), width: w.toInt(), height: h.toInt());
  MaskForCameraViewResult res = MaskForCameraViewResult();
  List<int> croppedList = encodeJpg(croppedImage);
  Uint8List croppedBytes = Uint8List.fromList(croppedList);
  res.croppedImage = croppedBytes;
  return res;
}