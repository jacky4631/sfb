import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // 用于判断平台

import 'package:dart_date/dart_date.dart';

/// Map Json扩展方法
extension WidgetExtension on Widget {
  Widget icon(Widget icon, {double padding = 8, CrossAxisAlignment alignment = CrossAxisAlignment.center}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [icon, Container(width: padding), Flexible(child: this)],
    );
  }

  Widget flexible({bool enable = true, int flex = 1}) {
    return enable
        ? Flexible(
            flex: flex,
            child: this,
          )
        : this;
  }

  Widget endWith(List<Widget> widgets) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        this,
        Expanded(child: Container()),
        ...widgets,
      ],
    );
  }

  Widget rowWith(List<Widget> widgets) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this,
        ...widgets,
      ],
    );
  }

  Widget showBy(bool show) {
    if (show) {
      return this;
    } else {
      return Container();
    }
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget keyListener({ValueChanged<RawKeyEvent>? onkey}) {
    return RawKeyboardListener(
      focusNode: FocusNode(canRequestFocus: false),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.select) {
            // print('>>>>>>>>>点击了确定>>>>>>>>>');
          } else {
            // print('>>>>>>>>>点击了>>${event.logicalKey}>>>>>>>');
          }

          onkey?.call(event);
        }
      },
      child: this,
    );
  }

  Widget width(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget size({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget clipRRect({double radius = 5}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: this,
    );
  }
}

extension mapExt on Map<String, dynamic>? {
  Map<String, dynamic> page({int? page, int? size}) {
    var params = this ?? {};
    params["page"] = page ?? 0;
    params["size"] = size ?? 20;

    return params;
  }
}

extension intExt on int? {
  String date([String format = "yyyy-MM-dd"]) {
    return DateTime.fromMillisecondsSinceEpoch(this ?? DateTime.now().millisecondsSinceEpoch).format(format);
  }

  String date2([String format = "yyyy-MM-dd HH:mm:ss"]) {
    return DateTime.fromMillisecondsSinceEpoch(this ?? DateTime.now().millisecondsSinceEpoch).format(format);
  }

  String diff() {
    int minutes = (this ?? 0) ~/ (1000 * 60);

    if (minutes > 60 * 24) {
      var d = minutes ~/ (60 * 24);
      var d_m = minutes % (60 * 24);
      var h = d_m ~/ 60;
      return '$d天$h小时';
    } else if (minutes > 60) {
      var h = minutes ~/ 60;
      var m = minutes % 60;
      return '$h小时$m分钟';
    } else {
      return '$minutes分钟';
    }
  }
// String diff(int longTime) {
//   var now = DateTime.fromMillisecondsSinceEpoch(this ?? 0);
//   var time = DateTime.fromMillisecondsSinceEpoch(longTime);
//   var difference = now.difference(time);
//   int days = difference.inDays;
//   int hours = difference.inHours;
//   int minutes = difference.inMinutes;
//   String result = '';
//   if (days > 3) {
//     bool isNowYear = now.year == time.year;
//     var pattern = isNowYear ? 'MM-dd' : 'yyyy-MM-dd';
//     result = time.format(pattern);
//   } else if (days > 0) {
//     result = '$days天前';
//   } else if (hours > 0) {
//     result = '$hours小时前';
//   } else if (minutes > 0) {
//     result = '$minutes分钟前';
//   } else {
//     result = '刚刚';
//   }
//   return result;
// }
}

extension TExt on Object {
  T isMobile<T>({required T def}) {
    if (Platform.isAndroid || Platform.isIOS) {
      return def;
    } else {
      return this as T;
    }
  }

  T autoValue<T>({required bool condition, required T def}) {
    if (condition) {
      return def;
    } else {
      return this as T;
    }
  }

  String json2({bool ignoreNullMembers = true}) {
    return '';
  }

  Map<String, dynamic>? jsonMap2({bool ignoreNullMembers = true}) {
    return <String, dynamic>{};
  }
}
