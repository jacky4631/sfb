import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';

/// 主题
class AppThemeDefault implements AppMultipleTheme {
  // Define your seed colors.

  Color primaryColor = Colors.black;

  static ThemeData dark = ThemeData.dark(useMaterial3: false).copyWith(
      scaffoldBackgroundColor: const Color(0xFF2C2C2C),
      brightness: Brightness.dark,
      iconTheme: const IconThemeData().copyWith(color: Colors.white),
      appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF2C2C2C),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          )),
      tabBarTheme: TabBarThemeData(
        
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.transparent;
          }
          return null;
        }),
      ));
  static ThemeData light = ThemeData.light(useMaterial3: false).copyWith(
      scaffoldBackgroundColor: Colors.white,
      listTileTheme: const ListTileThemeData().copyWith(iconColor: Colors.black),
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          iconTheme: const IconThemeData().copyWith(color: Colors.black),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          )),
      tabBarTheme: TabBarThemeData(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.transparent;
          }
          return null;
        }),
      ));

  @override
  ThemeData lightTheme() => FlexThemeData.light(
        useMaterial3: true,
      ).copyWith(
          primaryColor: primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: primaryColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          listTileTheme: const ListTileThemeData().copyWith(iconColor: Colors.black),
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
              titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
              iconTheme: const IconThemeData().copyWith(color: Colors.black),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
              )));

  @override
  ThemeData darkTheme() => FlexThemeData.dark(
        useMaterial3: true,
      ).copyWith(
          primaryColor: primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: primaryColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFF2C2C2C),
          brightness: Brightness.dark,
          iconTheme: const IconThemeData().copyWith(color: Colors.white),
          appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Color(0xFF2C2C2C),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
              )));
}
