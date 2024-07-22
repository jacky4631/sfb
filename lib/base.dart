/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
library base;

import 'package:flutter/foundation.dart';
/*
 * @discripe: 全局公共类管理
 */
export 'httpUrl.dart';
export 'io.dart';

mixin class BBase {
  //通用链接 打包会自动使用线上链接
  // static final baseHost = kDebugMode ? 'http://192.168.0.108:8008' : 'https://demo.admin.mailvor.com';
  //调试用
  // static final baseHost = 'http://192.168.0.108:8008';
  //线上地址
  static final baseHost = 'http://demo.admin.mailvor.com';

  static final suUrl = '${BBase.baseHost}/api';
}