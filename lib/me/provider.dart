import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service.dart';
import 'model/userinfo.dart';

part 'provider.g.dart';

@riverpod
Future<Userinfo> userinfo(Ref ref) async {
  final json = await BService.userinfo(baseInfo: true);
  print(json);

  Userinfo userinfo = Userinfo.fromJson(json);
  final JPushFlutterInterface jpush = JPush.newJPush();
  jpush.setAlias('uid${userinfo.uid.toString()}').then((map) {
    print("设置别名成功$map");
  });
  return userinfo;
}
