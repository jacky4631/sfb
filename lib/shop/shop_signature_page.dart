/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';

import '../service.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
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
    return ScaffoldWidget(
      appBar: buildTitle(context,
          title: '签字',
          height: Global.isAndroid()? 28 : 56,
          widgetColor: Colors.black,
          leftIcon: Icon(Icons.arrow_back_ios)),
      body: ListView(
        children: <Widget>[
          //SIGNATURE CANVAS
          Signature(
            key: const Key('signature'),
            controller: _controller,
            height: 1024,
            backgroundColor: Colors.white!,
          ),
          //OK AND CLEAR BUTTONS
        ],
      ),
      bottomSheet: BottomAppBar(
        child: PWidget.container(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SHOW EXPORTED IMAGE IN NEW ROUTE
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: PWidget.container(
                      Text(
                        '取消',
                        style: TextStyle(color: Colors.black),
                      ),
                      {
                        'bd': PFun.bdAllLg(Colors.black, 0.5),
                        'pd': [8, 8, 12, 12],
                        'br': 8
                      },
                    )),
                TextButton(
                    onPressed: () {
                      setState(() => _controller.clear());
                    },
                    child: PWidget.container(
                      Text(
                        '重写',
                        style: TextStyle(color: Colors.black),
                      ),
                      {
                        'bd': PFun.bdAllLg(Colors.black, 0.5),
                        'pd': [8, 8, 12, 12],
                        'br': 8
                      },
                    )),
                TextButton(
                    onPressed: () {
                      exportImage(context);
                    },
                    child: PWidget.container(
                      Text(
                        '确认',
                        style: TextStyle(color: Colors.black),
                      ),
                      {
                        'bd': PFun.bdAllLg(Colors.black, 0.5),
                        'pd': [8, 8, 12, 12],
                        'br': 8
                      },
                    )),
              ],
            ),
            {
              'pd': [0, MediaQuery.of(context).padding.bottom + 4, 0, 0]
            }),
      ),
    );
  }
}
