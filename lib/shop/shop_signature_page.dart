/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';

import '../service.dart';
import '../util/global.dart';
import '../util/toast_utils.dart';
import '../widget/loading.dart';

class ShopSignaturePage extends StatefulWidget {
  const ShopSignaturePage({super.key});

  @override
  State<ShopSignaturePage> createState() => _HomeState();
}

class _HomeState extends State<ShopSignaturePage> {
  // initialize the signature controller
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => log('Value changed'));
    // 强制横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes();
    if (data == null) {
      return;
    }

    if (!mounted) return;

    Loading.show(context, text: '正在生成电子合同');
    // Image image = Image.memory(data);
    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(data, filename: "signature${DateTime.now().microsecond}.png"),
    });
    Map res = await BService.uploadCard(formData, 4);
    Loading.hide(context);
    if(!res['success']) {
      ToastUtils.showToast(res['msg']);
      return;
    }
    Navigator.pop(context, 'ok');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('签字', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: Global.isAndroid() ? 28 : 56,
      ),
      body: ListView(
        children: <Widget>[
          //SIGNATURE CANVAS
          Signature(
            key: const Key('signature'),
            controller: _controller,
            height: 1024,
            backgroundColor: Colors.white,
          ),
          //OK AND CLEAR BUTTONS
        ],
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          padding: EdgeInsets.only(
            top: 0,
            bottom: MediaQuery.of(context).padding.bottom + 4,
            left: 0,
            right: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //SHOW EXPORTED IMAGE IN NEW ROUTE
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '取消',
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '重写',
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    exportImage(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '确认',
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
