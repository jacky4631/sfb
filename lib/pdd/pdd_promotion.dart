import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import '../util/global.dart';
import '../util/launchApp.dart';

class PddPromotion {
  static Future<void> open(BuildContext context, Map word) async {
    final link = word['link']?.toString() ?? '';
    if (link.isEmpty) throw StateError('拼多多转链失败');
    await LaunchApp.launchPdd(
      context,
      word['longLink'] ?? link,
      link,
      fun: () async {
        final username = word['wechatId']?.toString() ?? '';
        final path = word['wechatPath']?.toString() ?? '';
        if (username.isNotEmpty &&
            path.isNotEmpty &&
            await fluwx.isWeChatInstalled) {
          await fluwx.open(
            target: MiniProgram(username: username, path: path),
          );
        } else {
          await LaunchApp.launchPdd(context, link, link);
        }
      },
    );
  }
}
