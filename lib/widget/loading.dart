/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../me/styles.dart';
import 'DialogRouter.dart';

class Loading {
  static void show(BuildContext context, {String text = ''}) {
    Navigator.of(context).push(DialogRouter(LoadingDialog(
      text: text,
    )));
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class LoadingDialog extends Dialog {
  final String text;
  // LoadingDialog(this.text)
  const LoadingDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Material(
            //创建透明层
            type: MaterialType.transparency, //透明类型
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text.isNotEmpty ? Text(text, style: TextStyles.loading) : SizedBox(),
                SizedBox(height: 10),
                CupertinoActivityIndicator(
                  radius: 18,
                )
              ],
            )
            // Center(
            //   //保证控件居中效果
            //   child: CupertinoActivityIndicator(
            //     radius: 18,
            //   ),
            // ),
            ));
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorState extends StatelessWidget {
  final Function()? onTap;
  const ErrorState({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('加载失败'),
          OutlinedButton(
            onPressed: onTap,
            child: const Text('重新加载'),
          )
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final Function()? onTap;

  const EmptyState({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lightbulb_outline),
          const Text('暂无数据'),
          OutlinedButton(onPressed: onTap, child: const Text('刷新')),
        ],
      ),
    );
  }
}
