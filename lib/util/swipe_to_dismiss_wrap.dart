/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SwipeToDismissWrap extends StatefulWidget {
  final Widget child;

  const SwipeToDismissWrap({required this.child});

  @override
  State<SwipeToDismissWrap> createState() => _SwipeToDismissWrapState();
}

class _SwipeToDismissWrapState extends State<SwipeToDismissWrap> {
  bool _swipeInProgress = false;
  late double _startPosX;

  final double _swipeStartAreaWidth = 60;
  final double _swipeMinLength = 50;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        if (details.localPosition.dx < _swipeStartAreaWidth) {
          _swipeInProgress = true;
          _startPosX = details.localPosition.dx;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (_swipeInProgress && details.localPosition.dx > _startPosX + _swipeMinLength) {
          HapticFeedback.mediumImpact();
          Navigator.of(context).pop();
        }
      },
      onHorizontalDragEnd: (_) => _swipeInProgress = false,
      child: widget.child,
    );
  }
}