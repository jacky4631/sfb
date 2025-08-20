/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 *
 */
/*
 * @discripe: 活动弹窗
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/launchApp.dart';

import '../me/model/activity_info.dart';

class HuodongDialog extends Dialog {
  final ActivityInfo data;
  final Function closeCallback;
  HuodongDialog(
    this.data,
      this.closeCallback,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 主要活动图片容器
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              click(context);
              closeCallback();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                data.img,
                width: 350,
                height: 350,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 350,
                    height: 350,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        // 关闭按钮
        Positioned(
          top: 150,
          right: 100,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              closeCallback();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(56),
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future click(BuildContext context) async {
    String url = data.url;
    var packageInfo = LaunchApp.getPackageName(url);
    String package = packageInfo['package'];
    await LaunchApp.launch(context, url, package,
        webUrl: data.webUrl,
        title: data.title,
        color: Color(int.parse('0xFF' + (data.color.isEmpty ? 'FFFFFF' : data.color))));
  }
}
