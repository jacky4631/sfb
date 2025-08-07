import 'package:flutter/material.dart';

class HyperTrailing extends StatelessWidget {
  const HyperTrailing({
    super.key,
    this.color = const Color(0xff999999),
    this.size = 18,
    this.icon = Icons.arrow_forward_ios_rounded,
  });

  final double? size;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
