import 'package:flutter/material.dart';

import 'multiple_themes_mode/theme_default.dart';

/// 多主题
Map<String, AppMultipleTheme> appMultipleThemesMode = {
  'default': AppThemeDefault(),
};

/// 当前深色模式
///
/// [mode] system(默认)：跟随系统 light：普通 dark：深色
ThemeMode darkThemeMode(String mode) => switch (mode) {
      'system' => ThemeMode.system,
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };

/// 多主题
abstract class AppMultipleTheme {
  /// 亮色
  ThemeData lightTheme();

  /// 深色
  ThemeData darkTheme();
}

/// 主题基础
class AppTheme {
  AppTheme(this.multipleThemesMode);

  String multipleThemesMode = 'default';

  /// 多主题 light
  ThemeData multipleThemesLightMode() {
    return appMultipleThemesMode[multipleThemesMode] != null
        ? appMultipleThemesMode[multipleThemesMode]!.lightTheme()
        : appMultipleThemesMode['default']!.lightTheme();
  }

  /// 多主题 dark
  ThemeData multipleThemesDarkMode() {
    return appMultipleThemesMode[multipleThemesMode] != null
        ? appMultipleThemesMode[multipleThemesMode]!.darkTheme()
        : appMultipleThemesMode['default']!.darkTheme();
  }
}
