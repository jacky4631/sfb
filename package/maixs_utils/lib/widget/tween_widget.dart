import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maixs_utils/widget/views.dart';

class TweenWidget extends StatefulWidget {
  final Widget child;
  final bool isScale;
  final bool isOnlyTransparent;
  final bool isReverseScale;
  final bool isOpacity;
  final Axis axis;
  final int? time;
  final double value;
  final Curve curve;
  final int? delayed;
  final int? alphaTime;
  final double scaleX;
  final double scaleY;

  const TweenWidget({
    Key? key,
    required this.child,
    this.isScale = false,
    this.axis = Axis.horizontal,
    this.time,
    this.value = 100,
    this.curve = Curves.easeOutCubic,
    this.delayed,
    this.isOpacity = true,
    this.isReverseScale = false,
    this.alphaTime,
    this.scaleX = 3.0,
    this.scaleY = 9.0,
    this.isOnlyTransparent = false,
  }) : super(key: key);
  @override
  _TweenWidgetState createState() => _TweenWidgetState();
}

class _TweenWidgetState extends State<TweenWidget> {
  ///是否延迟
  bool flag = false;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  Future initData() async {
    if (widget.delayed != null) {
      await Future.delayed(Duration(milliseconds: widget.delayed!));
      Future(() {
        if (mounted) setState(() => flag = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var view;
    if (kIsWeb) return widget.child;
    if (Platform.isAndroid || Platform.isMacOS) {
      switch (widget.axis) {
        case Axis.vertical:
          view = TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset(0, widget.value ?? size(context).width),
              end: Offset(0, 0),
            ),
            duration: Duration(milliseconds: widget.time ?? 400),
            curve: widget.curve,
            child: widget.child,
            builder: (_, t, v) {
              return TransformWidget.scale(
                scaleX: widget.isScale
                    ? widget.isReverseScale
                        ? (1 + (t.dy * widget.scaleX / widget.value ?? size(context).width))
                        : (1 - (t.dy / widget.value ?? size(context).width))
                    : 1,
                scaleY: widget.isScale
                    ? widget.isReverseScale
                        ? (1 + (t.dy * widget.scaleY / widget.value ?? size(context).width))
                        : (1 - (t.dy / widget.value ?? size(context).width))
                    : 1,
                child: Transform.translate(offset: t, child: v),
              );
            },
          );
          break;
        case Axis.horizontal:
          view = TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset(widget.value ?? size(context).width, 0),
              end: Offset(0, 0),
            ),
            duration: Duration(milliseconds: widget.time ?? 400),
            curve: widget.curve,
            child: widget.child,
            builder: (_, t, v) {
              return TransformWidget.scale(
                scaleX: widget.isScale
                    ? widget.isReverseScale
                        ? (1 + (t.dx * widget.scaleX / widget.value ?? size(context).width))
                        : (1 - (t.dx / widget.value ?? size(context).width))
                    : 1,
                scaleY: widget.isScale
                    ? widget.isReverseScale
                        ? (1 + (t.dx * widget.scaleY / widget.value ?? size(context).width))
                        : (1 - (t.dx / widget.value ?? size(context).width))
                    : 1,
                child: Transform.translate(offset: t, child: v),
              );
            },
          );
          break;
      }
      if (widget.isOnlyTransparent) {
        return TweenAnimationBuilder(
          child: widget.child,
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.ease,
          duration: Duration(milliseconds: (widget.alphaTime ?? 400)),
          builder: (_, t, v) {
            return Opacity(opacity: t, child: v);
          },
        );
      } else {
        if (widget.delayed == null) {
          return TweenAnimationBuilder(
            child: view,
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.ease,
            duration: Duration(milliseconds: (widget.alphaTime ?? 400)),
            builder: (_, t, v) {
              return Opacity(opacity: t, child: v);
            },
          );
        } else {
          if (flag) {
            if (widget.isOpacity) {
              return TweenAnimationBuilder(
                child: view,
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.ease,
                duration: Duration(milliseconds: widget.alphaTime ?? 400),
                builder: (_, t, v) {
                  return Opacity(opacity: t, child: v);
                },
              );
            } else {
              return view;
            }
          } else {
            return Opacity(opacity: 0, child: widget.child);
          }
        }
      }
    } else {
      return widget.child;
    }
  }
}

class TransformWidget extends SingleChildRenderObjectWidget {
  const TransformWidget({Key? key, this.transform, this.origin,
    this.alignment, this.transformHitTests = true, Widget? child})
      : assert(transform != null),
        super(key: key, child: child);
  TransformWidget.scale({Key? key, double? scaleX, double? scaleY, this.origin,
    this.alignment = Alignment.center, this.transformHitTests = true, Widget? child})
      : transform = Matrix4.diagonal3Values(scaleX!, scaleY!, 1.0),
        super(key: key, child: child);
  final Matrix4? transform;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final bool transformHitTests;
  @override
  RenderTransform createRenderObject(BuildContext context) {
    return RenderTransform(
      transform: transform!,
      origin: origin,
      alignment: alignment,
      textDirection: Directionality.maybeOf(context),
      transformHitTests: transformHitTests,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTransform renderObject) {
    renderObject
      ..transform = transform!
      ..origin = origin
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..transformHitTests = transformHitTests;
  }
}
