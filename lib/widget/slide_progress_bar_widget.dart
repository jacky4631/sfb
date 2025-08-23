/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

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
  const SlideProgressBarWidget(this.controller,
      {Key? key,
      this.barColor,
      this.bgBarColor,
      this.bgBarWidth,
      this.barWidth,
      this.barHeight,
      this.barRadius})
      : super(key: key);
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
  Future initData() async => widget.controller.addListener(() => setState(() =>
      d = (widget.controller.offset /
          widget.controller.position.maxScrollExtent)));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.barRadius ?? 4),
      ),
      child: Stack(children: [
        Positioned(
          left: ((widget.bgBarWidth ?? 56) - (widget.barWidth ?? 28)) * d,
          top: 0,
          child: Container(
            width: widget.barWidth ?? 28,
            height: widget.barHeight ?? 4,
            decoration: BoxDecoration(
              color: widget.barColor ?? Colours.app_main,
              borderRadius: BorderRadius.circular(widget.barRadius ?? 4),
            ),
          ),
        ),
        Container(
          width: widget.bgBarWidth ?? 56,
          height: widget.barHeight ?? 4,
          decoration: BoxDecoration(
            color: widget.bgBarColor ?? Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(widget.barRadius ?? 4),
          ),
        ),
      ]),
    );
  }
}
