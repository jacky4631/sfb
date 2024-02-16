import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

class CropPage extends StatefulWidget {
  final File file;

  const CropPage({Key? key, required this.file}) : super(key: key);
  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final cropKey = GlobalKey<CropState>();
  File? _file;
  File? _sample;
  File? _lastCropped;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    Future.delayed(Duration(milliseconds: 500), () async {
      await this._openImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _file?.delete();
    // _sample?.delete();
    // _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Color(0xFF1A1A1A),
     
      appBar: buildTitle(
        context,
        title: '裁切图像',
        widgetColor: Colors.white,
        rightWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.check, color: Colors.white),
        ),
        rightCallback: () async {
          buildShowDialog(context);
          var file = await _cropImage();
          close();
          close(file);
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: _sample == null
            ? buildLoad(color: Colors.white)
            : Crop.file(
                _sample!,
                key: cropKey,
                // aspectRatio: 1,
                alwaysShowGrid: true,
              ),
      ),
    );
  }

  Future<void> _openImage() async {
    final sample = await ImageCrop.sampleImage(
      file: widget.file,
      preferredSize: context.size?.longestSide.ceil(),
    );
    flog(sample.lengthSync());

    // _sample?.delete();
    // _file?.delete();

    setState(() {
      _sample = sample;
      _file = widget.file;
    });
  }

  Future<File?> _cropImage() async {
    final scale = cropKey.currentState?.scale;
    final area = cropKey.currentState?.area;
    if (area == null) {
      return null;
    }
    final sample = await ImageCrop.sampleImage(
      file: _file!,
      preferredSize: (1000 / scale!).round(),
    );
    final file = await ImageCrop.cropImage(file: sample, area: area);
    sample.delete();
    _lastCropped?.delete();
    _lastCropped = file;
    return file;
  }
}
