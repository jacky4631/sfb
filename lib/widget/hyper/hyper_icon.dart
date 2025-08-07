import 'package:flutter/material.dart';
class HyperIcon extends StatelessWidget {
  const HyperIcon({
    super.key,
    this.color,
    this.iconColor = Colors.white,
    this.size = 30,
    this.iconSize = 20,
    this.borderRadius = 9,
    this.icon,
  });

  final double? size;
  final double? iconSize;
  final double borderRadius;
  final Color? color;
  final Color? iconColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color, // 背景颜色
        borderRadius: BorderRadius.circular(borderRadius), // 设置圆角半径
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
