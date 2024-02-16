/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/widget/widget_tap.dart';

///构建文本框
Widget buildTFView(
  BuildContext context, {
  bool isExp = false,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  required String hintText,
  void Function(String)? onChanged,
  void Function()?  onTap,
  void Function(String)? onSubmitted,
  TextStyle? textStyle,
  TextStyle? hintStyle,
  FocusNode? focusNode,
  TextInputAction? textInputAction,
  double hintSize = 14,
  Color? hintColor,
  double textSize = 14,
  Color? textColor,
  EdgeInsetsGeometry? padding,
  TextEditingController? con,
  TextAlign? textAlign,
  bool isInt = false,
  bool isDouble = false,
  bool isAz = false,
  bool isEdit = true,
  bool autofocus = false,
  int maxLines = 1,
  double height = 20,
  int? maxLength,
  int doubleCount = 10000,
      bool readOnly = false
}) {
  return [
    Expanded(
      child: WidgetTap(
        onTap: onTap,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          height: height,
          child: TextField(
            focusNode: focusNode ?? null,
            controller: con,
            maxLines: maxLines,
            enabled: isEdit,
            maxLength: maxLength,
            readOnly: readOnly,
            inputFormatters: [
              // ignore: deprecated_member_use
              if (isAz) FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true), //只允许输入字母
              // ignore: deprecated_member_use
              if (isInt) FilteringTextInputFormatter.digitsOnly, //只允许输入数字
              // ignore: deprecated_member_use
              if (isDouble) FilteringTextInputFormatter(RegExp("[0-9.0-9]"), allow: true), //只允许输入小数
              if (isDouble) PrecisionLimitFormatter(doubleCount)
            ],
            style: (textStyle ?? TextStyle(fontSize: textSize, color: textColor)).copyWith(height: 1.5),
            cursorColor: Theme.of(context).primaryColor,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textAlign: textAlign ?? TextAlign.start,
            autofocus: autofocus,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: hintSize, color: hintColor ?? Color(0x80666666), height: 1.5),
              counterText: '',
              hintText: hintText,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
            onTap: onTap,
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    ),
    WidgetTap(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        height: height,
        child: TextField(
          focusNode: focusNode ?? null,
          style: (textStyle ?? TextStyle(fontSize: textSize, color: textColor)).copyWith(height: 1.5),
          cursorColor: Theme.of(context).primaryColor,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          controller: con,
          enabled: isEdit,
          autofocus: autofocus,
          readOnly: readOnly,
          inputFormatters: [
            // ignore: deprecated_member_use
            if (isAz) FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true), //只允许输入字母
            // ignore: deprecated_member_use
            if (isInt) FilteringTextInputFormatter.digitsOnly, //只允许输入数字
            // ignore: deprecated_member_use
            if (isDouble) FilteringTextInputFormatter(RegExp("[0-9.0-9]"), allow: true), //只允许输入小数
            if (isDouble) PrecisionLimitFormatter(doubleCount)
          ],
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            counterText: '',
            hintStyle: (hintStyle ??
                    TextStyle(
                      fontSize: hintSize,
                      color: hintColor ?? Color(0x80666666),
                    ))
                .copyWith(height: 1.5),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: hintText,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,
        ),
      ),
    )
  ][isExp ? 0 : 1];
}


class PrecisionLimitFormatter extends TextInputFormatter {
  int _scale;

  PrecisionLimitFormatter(this._scale);

  RegExp exp = new RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String DOUBLE_ZERO = "00";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(POINTER) && newValue.text.length == 1) {
      //第一个不能输入小数点
      return oldValue;
    }

    ///输入完全删除
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///包含多个小数
      if (newValue.text.indexOf(POINTER) != newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(POINTER);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(POINTER) || newValue.text.startsWith(DOUBLE_ZERO)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}