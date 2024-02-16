/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sufenbao/widget/camera/result.dart';

import 'crop_image.dart';
import 'inside_line.dart';

CameraController? _cameraController;
late List<CameraDescription> _cameras;
final GlobalKey _stickyKey = GlobalKey();

double? _screenWidth;
double? _screenHeight;
double? _boxWidthForCrop;
double? _boxHeightForCrop;
FlashMode _flashMode = FlashMode.auto;

class MaskForCameraView extends StatefulWidget {
  MaskForCameraView({
    super.key,
    required this.ocrType,
    this.title = "",
    required this.boxWidth,
    required this.boxHeight,
    this.boxBorderWidth = 1.8,
    this.boxBorderRadius = 3.2,
    required this.onTake,
    this.cameraDescription = MaskForCameraViewCameraDescription.rear,
    this.borderType = MaskForCameraViewBorderType.dotted,
    this.insideLine,
    this.visiblePopButton = true,
    this.appBarColor = Colors.transparent,
    this.titleStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
    this.boxBorderColor = Colors.white,
    this.bottomBarColor = Colors.black,
    this.takeButtonColor = Colors.white,
    this.takeButtonActionColor = Colors.black,
    this.iconsColor = Colors.black,
  });

  String ocrType;
  String title;
  double boxWidth;
  double boxHeight;
  double boxBorderWidth;
  double boxBorderRadius;
  bool visiblePopButton;
  MaskForCameraViewCameraDescription cameraDescription;
  MaskForCameraViewInsideLine? insideLine;
  Color appBarColor;
  TextStyle titleStyle;
  Color boxBorderColor;
  Color bottomBarColor;
  Color takeButtonColor;
  Color takeButtonActionColor;
  Color iconsColor;
  ValueSetter<MaskForCameraViewResult> onTake;
  MaskForCameraViewBorderType borderType;
  @override
  State<StatefulWidget> createState() => _MaskForCameraViewState();

  static Future<void> initialize() async {
    _cameras = await availableCameras();
  }
}

class _MaskForCameraViewState extends State<MaskForCameraView> {
  bool isRunning = false;

  @override
  void initState() {
    _cameraController = CameraController(
      widget.cameraDescription == MaskForCameraViewCameraDescription.rear
          ? _cameras.first
          : _cameras.last,
      ResolutionPreset.high,
      enableAudio: false,
    );
    super.initState();
    _cameraController!.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    _boxWidthForCrop = widget.boxWidth;
    _boxHeightForCrop = widget.boxHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: !_cameraController!.value.isInitialized
                ? Container()
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          key: _stickyKey,
                          color: widget.appBarColor,
                        ),
                      ),
                      CameraPreview(
                        _cameraController!,
                      ),
                      Expanded(
                        child: Container(
                          color: widget.bottomBarColor,
                        ),
                      )
                    ],
                  ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 54.0,
                  child: Row(
                    children: [
                      widget.visiblePopButton
                          ? _IconButton(
                              Icons.arrow_back_ios_rounded,
                              color: widget.iconsColor,
                              onTap: () => Navigator.pop(context),
                            )
                          : Container(),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: widget.titleStyle,
                        ),
                      ),
                      _IconButton(
                        _flashMode == FlashMode.auto
                            ? Icons.flash_auto_outlined
                            : _flashMode == FlashMode.torch
                                ? Icons.flash_on_outlined
                                : Icons.flash_off_outlined,
                        color: widget.iconsColor,
                        onTap: () {
                          if (_flashMode == FlashMode.auto) {
                            _cameraController!.setFlashMode(FlashMode.torch);
                            _flashMode = FlashMode.torch;
                          } else if (_flashMode == FlashMode.torch) {
                            _cameraController!.setFlashMode(FlashMode.off);
                            _flashMode = FlashMode.off;
                          } else {
                            _cameraController!.setFlashMode(FlashMode.auto);
                            _flashMode = FlashMode.auto;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.takeButtonColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor:
                                widget.takeButtonActionColor.withOpacity(0.26),
                            onTap: () async {
                              if (isRunning) {
                                return;
                              }
                              setState(() {
                                isRunning = true;
                              });
                              MaskForCameraViewResult? res = await _cropPicture(
                                  widget.ocrType, widget.insideLine);

                              if (res == null) {
                                throw "Camera expansion is very small";
                              }

                              widget.onTake(res);
                              setState(() {
                                isRunning = false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(1.8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2.0,
                                  color: widget.takeButtonActionColor,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: widget.takeButtonActionColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: DottedBorder(
                borderType: BorderType.RRect,
                strokeWidth:
                    widget.borderType == MaskForCameraViewBorderType.dotted
                        ? widget.boxBorderWidth
                        : 0.0,
                color: widget.borderType == MaskForCameraViewBorderType.dotted
                    ? widget.boxBorderColor
                    : Colors.transparent,
                dashPattern: const [4, 3],
                radius: Radius.circular(
                  widget.boxBorderRadius,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isRunning ? Colors.white60 : Colors.transparent,
                    borderRadius: BorderRadius.circular(widget.boxBorderRadius),
                  ),
                  child: Container(
                    width:
                        widget.borderType == MaskForCameraViewBorderType.solid
                            ? widget.boxWidth + widget.boxBorderWidth * 2
                            : widget.boxWidth,
                    height:
                        widget.borderType == MaskForCameraViewBorderType.solid
                            ? widget.boxHeight + widget.boxBorderWidth * 2
                            : widget.boxHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: widget.borderType ==
                                MaskForCameraViewBorderType.solid
                            ? widget.boxBorderWidth
                            : 0.0,
                        color: widget.borderType ==
                                MaskForCameraViewBorderType.solid
                            ? widget.boxBorderColor
                            : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(
                        widget.boxBorderRadius,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          child:
                              _IsCropping(isRunning: isRunning, widget: widget),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<MaskForCameraViewResult?> _cropPicture(
    String ocrType, MaskForCameraViewInsideLine? insideLine) async {
  XFile xFile = await _cameraController!.takePicture();
  File imageFile = File(xFile.path);

  RenderBox box = _stickyKey.currentContext!.findRenderObject() as RenderBox;
  double size = box.size.height * 2;
  MaskForCameraViewResult? result = await cropImage(
    ocrType,
    imageFile.path,
    _boxHeightForCrop!.toInt(),
    _boxWidthForCrop!.toInt(),
    _screenHeight! - size,
    _screenWidth!,
    insideLine,
  );
  return result;
}

class _IconButton extends StatelessWidget {
  const _IconButton(this.icon,
      {Key? key, required this.color, required this.onTap})
      : super(key: key);
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22.0),
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}

class _IsCropping extends StatelessWidget {
  const _IsCropping({Key? key, required this.isRunning, required this.widget})
      : super(key: key);
  final bool isRunning;
  final MaskForCameraView widget;

  @override
  Widget build(BuildContext context) {
    return isRunning && widget.boxWidth >= 50.0 && widget.boxHeight >= 50.0
        ? const Center(
            child: CupertinoActivityIndicator(
              radius: 12.8,
            ),
          )
        : Container();
  }
}