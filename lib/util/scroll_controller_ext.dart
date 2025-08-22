//
//  ScrollControllerExtension.dart
//  flutter_templet_project
//
//  Created by shang on 12/12/22 9:16 AM.
//  Copyright © 12/12/22 shang. All rights reserved.
//

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// Scrollable.ensureVisible(
// ensureVisibleKey.currentContext!,
// alignment: Alignment.bottomCenter.y,
// };

extension ScrollControllerExt on ScrollController {
  /// 跳转到对应位子
  Future<void> jumpTo(
    double value, {
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.ease,
  }) async {
    if (!hasClients) {
      return;
    }
    if (duration == Duration.zero) {
      jumpTo(value);
    } else {
      await animateTo(value, duration: duration, curve: curve);
    }
  }

  /// 跳转到对应位子
  Future<void> jumpToBottom({
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.ease,
  }) async {
    if (!hasClients) {
      return;
    }
    final offset = position.pixels.clamp(position.pixels, position.maxScrollExtent);
    await jumpTo(offset, duration: duration, curve: curve);
  }

  ///水平移动
  jumToHorizontal({
    required GlobalKey key,
    required double offsetX,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    try {
      var scrollController = this;
      final position = offsetX;
      // final position = (ScreenUtil().screenWidth / 2 - 12.w);
      // final position = (MediaQuery.of(context).size.width / 2);

      var animateToOffset = 0.0;
      var renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return;
      }

      final size = renderBox.paintBounds.size;
      final vector3 = renderBox.getTransformTo(null).getTranslation();
      debugPrint("scrollToItemNew vector3:$vector3");

      final offset = scrollController.offset;
      final extentAfter = scrollController.position.extentAfter;
      final needScrollPixels = vector3.x - position + size.width / 2;
      if (needScrollPixels < extentAfter) {
        animateToOffset = offset + needScrollPixels;
      } else {
        animateToOffset = offset + extentAfter;
      }
      if (animateToOffset < 0) {
        animateToOffset = 0;
      }
      if (scrollController.hasClients) {
        scrollController.animateTo(animateToOffset,
            duration: duration ?? const Duration(milliseconds: 200), curve: Curves.linear);
      }
    } catch (e) {
      debugPrint('JumToHorizontal->$e');
    }
  }

  scrollToItemNew({
    required GlobalKey itemKey,
    required GlobalKey scrollKey,
    Axis scrollDirection = Axis.vertical,
    Duration? duration = const Duration(milliseconds: 200),
  }) {
    var scrollController = this;

    var renderBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint("Please bind the key to the widget!!!");
      return;
    }

    var local = renderBox.localToGlobal(Offset.zero, ancestor: scrollKey.currentContext?.findRenderObject());
    var size = renderBox.size;

    var value = scrollDirection == Axis.horizontal ? local.dx : local.dy;

    var offset = value + scrollController.offset;
    debugPrint("scrollToItemNew local:$local, size:$size, offset: ${scrollController.offset}, offset: $offset");

    var padding = MediaQueryData.fromView(ui.window).padding;
    var paddingStart = scrollDirection == Axis.horizontal ? padding.left : padding.top;

    final extentAfter = scrollController.position.extentAfter;
    if (extentAfter <= local.dy) {
      debugPrint("scrollToItemNew extentAfter:$extentAfter local.dy:${local.dy}");
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: duration ?? const Duration(milliseconds: 200), curve: Curves.linear);
      return;
    }
    jumpTo(offset - paddingStart, duration: duration ?? const Duration(milliseconds: 200));
  }
}

extension ScrollPositionExt on ScrollPosition {}

extension ScrollMetricsExt on ScrollMetrics {
  /// 转 Map
  Map<String, dynamic> toJson() {
    return {
      "minScrollExtent": minScrollExtent,
      "maxScrollExtent": maxScrollExtent,
      "hasContentDimensions": hasContentDimensions,
      "pixels": pixels,
      "hasPixels": hasPixels,
      "viewportDimension": viewportDimension,
      "hasViewportDimension": hasViewportDimension,
      "axisDirection": axisDirection.name,
      "axis": axisDirectionToAxis(axisDirection).name,
      "outOfRange": outOfRange,
      "atEdge": atEdge,
      "extentBefore": extentBefore,
      "extentInside": extentInside,
      "extentAfter": extentAfter,
      "extentTotal": extentTotal,
      "devicePixelRatio": devicePixelRatio,
    };
  }

  printInfo() {
    const encoder = JsonEncoder.withIndent('  ');
    final result = encoder.convert(toJson());

    var info = """
ScrollMetrics:
${result}
    """;
    debugPrint(info);
  }

  //顶部
  bool get isStart => atEdge && extentBefore <= 0;
  //底部
  bool get isEnd => atEdge && extentAfter <= 0;
  //滚动进度
  double get progress {
    try {
      return pixels / maxScrollExtent;
    } catch (e) {
      debugPrint("$this $e");
    }
    return 0;
  }

  //滚动进度
  String get progressPerecent => "${(progress * 100).toInt()}%";
}
