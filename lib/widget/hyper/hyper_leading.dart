import 'package:flutter/material.dart';

class HyperLeading extends StatelessWidget {
  const HyperLeading({
    super.key,
    this.size = 30,
    this.color,
    this.borderRadius = 9,
    this.child,
  });

  final double? size;
  final double borderRadius;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color, // 背景颜色
        borderRadius: BorderRadius.circular(borderRadius), // 设置圆角半径
      ),
      child: child,
    );
  }
}
