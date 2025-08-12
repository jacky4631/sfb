import 'package:flutter/material.dart';

class RoundedBackgroundTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double horizontalPadding;
  final double verticalPadding;

  RoundedBackgroundTabIndicator({
    required this.color,
    this.radius = 20,
    this.horizontalPadding = 0,
    this.verticalPadding = 2,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedIndicatorPainter(this, onChanged);
  }
}

class _RoundedIndicatorPainter extends BoxPainter {
  final RoundedBackgroundTabIndicator decoration;

  _RoundedIndicatorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final rect = offset & configuration.size!;

    // 缩小左右边距和上下边距，使背景比文字宽高大一些
    final indicatorRect = Rect.fromLTWH(
      rect.left + decoration.horizontalPadding,
      rect.top + decoration.verticalPadding,
      rect.width - 2 * decoration.horizontalPadding,
      rect.height - 2 * decoration.verticalPadding,
    );

    final rrect = RRect.fromRectAndRadius(
      indicatorRect,
      Radius.circular(decoration.radius),
    );

    final paint = Paint()..color = decoration.color;

    canvas.drawRRect(rrect, paint);
  }
}
