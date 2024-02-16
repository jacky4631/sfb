import 'package:flutter/material.dart';

enum TextEditType { Controller, Text, Phone, List }

class TextEditUtil {
  List<Map<String, dynamic>>? controllers;
  String? text;
  // 添加文本框控制器
  void addController(List<Map<String, dynamic>> cons) {
    this.controllers = cons;
  }

  // 非空验证
  String check() {
    var texts = [];
    this.controllers!.forEach((f) {
      if (f['con'].runtimeType == TextEditingController) {
        if (f['isPhone'] != null) {
          RegExp reg = new RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
          if (!reg.hasMatch(f['con'].text)) texts.add('请输入11位手机号码');
        }
        if (f['con'].text == '') texts.add('${f['text']}${f['tips'] ?? '不能为空'}');
      } else if (f['con'].runtimeType.toString() == 'List<String>') {
        if (f['con'].length == 0) texts.add('${f['text']}${f['tips'] ?? '不能为空'}');
      } else {
        if (f['con'] == null || f['con'] == ' ') texts.add('${f['text']}${f['tips'] ?? '不能为空'}');
      }
    });
    text = texts.length >= 1 ? texts.first : null;
    return text!;
  }

  // 非空验证
  String check2() {
    var texts = [];
    this.controllers!.forEach((f) {
      switch (f['type']) {
        //1控制器  2文本
        case TextEditType.Controller:
          if (f['con'].text == '') texts.add('${f['text']}不能为空');
          break;
        case TextEditType.Text:
          if (f['con'] == null) texts.add('${f['text']}${f['tips'] ?? '不能为空'}');
          break;
        case TextEditType.Phone:
          if (f['con'].text == '') texts.add('${f['text']}不能为空');
          RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
          bool matched = exp.hasMatch(f['con'].text);
          if (!matched) {
            texts.add('请输入正确的手机号码');
          }
          break;
        case TextEditType.List:
          if (f['con'] == "0" || f['con'] == 0) texts.add('${f['text']}${f['tips'] ?? '不能为空'}');
          break;
        default:
      }
    });
    print(texts);
    text = texts.length >= 1 ? texts.first : null;
    return texts.length >= 1 ? texts.first : null;
  }
}
