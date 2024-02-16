/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

import '../util/colors.dart';
///滑动进度条
class SlideProgressBarWidget extends StatefulWidget {
  final ScrollController controller;
  final Color? barColor;
  final Color? bgBarColor;
  final double? bgBarWidth;
  final double? barWidth;
  final double? barHeight;
  final double? barRadius;
  const SlideProgressBarWidget(this.controller, {Key? key, this.barColor, this.bgBarColor, this.bgBarWidth, this.barWidth, this.barHeight, this.barRadius}) : super(key: key);
  @override
  _SlideProgressBarWidgetState createState() => _SlideProgressBarWidgetState();
}

class _SlideProgressBarWidgetState extends State<SlideProgressBarWidget> {
  double d = 0.0;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async => widget.controller.addListener(() => setState(() => d = (widget.controller.offset / widget.controller.position.maxScrollExtent)));

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      Stack(children: [
        PWidget.positioned(
          PWidget.container(null, [widget.barWidth ?? 28, widget.barHeight ?? 4, widget.barColor ?? Colours.app_main], {'br': widget.barRadius ?? 4}),
          // [0, 0, (widget.barWidth ?? 28) * d, null],
          [0, 0, ((widget.bgBarWidth ?? 56) - (widget.barWidth ?? 28)) * d, null],
        ),
        PWidget.container(null, [widget.bgBarWidth ?? 56, widget.barHeight ?? 4, widget.bgBarColor ?? Colors.black.withOpacity(0.05)], {'br': widget.barRadius ?? 4}),
      ]),
      {'crr': widget.barRadius ?? 4},
    );
  }
}
