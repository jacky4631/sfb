import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service.dart';
import 'model/userinfo.dart';

part 'provider.g.dart';

@riverpod
class User extends _$User {
  @override
  Userinfo build() {
    BService.userinfo(baseInfo: true).then((json) {
      print(json);

      Userinfo userinfo = Userinfo.fromJson(json);
      final JPushFlutterInterface jpush = JPush.newJPush();
      jpush.setAlias('uid${userinfo.uid.toString()}').then((map) {
        print("设置别名成功$map");
      });

      state = userinfo;
    });
    return Userinfo();
  }
}

@riverpod
Future<Map> getEnergy(Ref ref) async {
  final energy = await BService.getEnergy();
  return energy;
}

@riverpod
Future<bool> hasUnlockOrder(Ref ref) async {
  final hasUnlockOrder = await BService.hasUnlockOrder();
  return hasUnlockOrder;
}

@riverpod
Future<Map> userFee(Ref ref) async {
  final hasUnlockOrder = await BService.userFee();
  return hasUnlockOrder;
}
