import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double _kScrollbarMinLength = 36.0;
const double _kScrollbarMinOverscrollLength = 8.0;
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 1200);
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 250);
const Duration _kScrollbarResizeDuration = Duration(milliseconds: 100);

const double _kScrollbarMainAxisMargin = 3.0;
const double _kScrollbarCrossAxisMargin = 3.0;

class CupertinoScrollbarWidget extends RawScrollbar {
  const CupertinoScrollbarWidget({
    Key? key,
    required Widget child,
    ScrollController? controller,
    bool isAlwaysShown = false,
    double thickness = defaultThickness,
    this.thicknessWhileDragging = defaultThicknessWhileDragging,
    Radius radius = defaultRadius,
    this.radiusWhileDragging = defaultRadiusWhileDragging,
    ScrollNotificationPredicate? notificationPredicate,
  })  : assert(thickness != null),
        assert(thickness < double.infinity),
        assert(thicknessWhileDragging != null),
        assert(thicknessWhileDragging < double.infinity),
        assert(radius != null),
        assert(radiusWhileDragging != null),
        super(
          key: key,
          child: child,
          controller: controller,
          isAlwaysShown: isAlwaysShown,
          thickness: thickness,
          radius: radius,
          fadeDuration: _kScrollbarFadeDuration,
          timeToFade: _kScrollbarTimeToFade,
          pressDuration: const Duration(milliseconds: 100),
          notificationPredicate: notificationPredicate ?? defaultScrollNotificationPredicate,
        );

  static const double defaultThickness = 3;

  static const double defaultThicknessWhileDragging = 8.0;

  static const Radius defaultRadius = Radius.circular(1.5);

  static const Radius defaultRadiusWhileDragging = Radius.circular(4.0);

  final double thicknessWhileDragging;

  final Radius? radiusWhileDragging;

  @override
  _CupertinoScrollbarWidgetState createState() => _CupertinoScrollbarWidgetState();
}

class _CupertinoScrollbarWidgetState extends RawScrollbarState<CupertinoScrollbarWidget> {
  AnimationController? _thicknessAnimationController;

  // ignore: unused_element
  double get _thickness {
    return widget.thickness! + _thicknessAnimationController!.value
        * (widget.thicknessWhileDragging! - widget.thickness!);
  }

  Radius? get _radius {
    return Radius.lerp(widget.radius, widget.radiusWhileDragging, _thicknessAnimationController!.value);
  }

  @override
  void initState() {
    super.initState();
    _thicknessAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarResizeDuration,
    );
    _thicknessAnimationController?.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  void updateScrollbarPainter() {
    scrollbarPainter
      ..color = CupertinoDynamicColor.resolve(Colors.black.withOpacity(0.1), context)
      ..textDirection = Directionality.of(context)
      ..thickness = 2
      ..mainAxisMargin = _kScrollbarMainAxisMargin
      ..crossAxisMargin = _kScrollbarCrossAxisMargin
      ..radius = _radius
      ..padding = MediaQuery.of(context).padding
      ..minLength = _kScrollbarMinLength
      ..minOverscrollLength = _kScrollbarMinOverscrollLength;
  }

  double _pressStartAxisPosition = 0.0;

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    final Axis? direction = getScrollbarDirection();
    switch (direction) {
      case Axis.vertical:
        _pressStartAxisPosition = localPosition.dy;
        break;
      case Axis.horizontal:
        _pressStartAxisPosition = localPosition.dx;
        break;
    }
  }

  @override
  void handleThumbPress() {
    if (getScrollbarDirection() == null) {
      return;
    }
    super.handleThumbPress();
    _thicknessAnimationController?.forward().then<void>(
          (_) => HapticFeedback.mediumImpact(),
        );
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    final Axis? direction = getScrollbarDirection();
    if (direction == null) {
      return;
    }
    _thicknessAnimationController?.reverse();
    super.handleThumbPressEnd(localPosition, velocity);
    switch (direction) {
      case Axis.vertical:
        if (velocity.pixelsPerSecond.dy.abs() < 10 && (localPosition.dy - _pressStartAxisPosition).abs() > 0) {
          HapticFeedback.mediumImpact();
        }
        break;
      case Axis.horizontal:
        if (velocity.pixelsPerSecond.dx.abs() < 10 && (localPosition.dx - _pressStartAxisPosition).abs() > 0) {
          HapticFeedback.mediumImpact();
        }
        break;
    }
  }

  @override
  void dispose() {
    _thicknessAnimationController?.dispose();
    super.dispose();
  }
}
