import 'dart:async';
import 'package:flutter/material.dart';

const Duration _bottomSheetDuration = Duration(milliseconds: 300);
const Duration _bottomSheetreverseDuration = Duration(milliseconds: 300);
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

class BottomSheet extends StatefulWidget {
  const BottomSheet({
    Key? key,
    this.animationController,
    this.enableDrag = true,
    this.backgroundColor,
    this.elevation,
    this.isElastic,
    this.shape,
    this.clipBehavior,
    required this.onClosing,
    required this.builder,
  })  : assert(enableDrag != null),
        assert(onClosing != null),
        assert(builder != null),
        assert(elevation == null || elevation >= 0.0),
        super(key: key);
  final AnimationController? animationController;
  final VoidCallback onClosing;
  final WidgetBuilder builder;
  final bool enableDrag;
  final bool? isElastic;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;

  @override
  _BottomSheetState createState() => _BottomSheetState();
  static AnimationController createAnimationController(TickerProvider vsync, bool isE) {
    return AnimationController(
      duration: Duration(milliseconds: 300),
      reverseDuration: _bottomSheetreverseDuration,
      debugLabel: 'BottomSheet',
      vsync: vsync,
    );
  }
}

class _BottomSheetState extends State<BottomSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  double? get _childHeight {
    final RenderBox renderBox = _childKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway => widget.animationController?.status == AnimationStatus.reverse;

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(widget.enableDrag);
    if (_dismissUnderway) return;
    widget.animationController!.value -= details.primaryDelta! / (_childHeight ?? details.primaryDelta)!;
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(widget.enableDrag);
    if (_dismissUnderway) return;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight!;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        widget.onClosing();
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) widget.animationController!.fling(velocity: -1.0);
      widget.onClosing();
    } else {
      widget.animationController!.forward();
    }
  }

  bool extentChanged(DraggableScrollableNotification notification) {
    if (notification.extent == notification.minExtent) {
      widget.onClosing();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    final Color? color = widget.backgroundColor ?? bottomSheetTheme.backgroundColor;
    final double elevation = widget.elevation ?? bottomSheetTheme.elevation ?? 0;
    final ShapeBorder? shape = widget.shape ?? bottomSheetTheme.shape;
    final Clip clipBehavior = widget.clipBehavior ?? bottomSheetTheme.clipBehavior ?? Clip.none;

    final Widget bottomSheet = Material(
      key: _childKey,
      color: color,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: extentChanged,
        child: widget.builder(context),
      ),
    );
    return !widget.enableDrag
        ? bottomSheet
        : GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: bottomSheet,
            excludeFromSemantics: true,
          );
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.isScrollControlled);

  final double progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: isScrollControlled ? constraints.maxHeight : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({
    Key? key,
    this.route,
    this.backgroundColor,
    this.isElastic = true,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.isScrollControlled = false,
  })  : assert(isScrollControlled != null),
        super(key: key);

  final _ModalBottomSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final bool isElastic;
  final ShapeBorder? shape;
  final Clip? clipBehavior;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  String _getRouteLabel(MaterialLocalizations localizations) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return localizations.dialogLabel;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String routeLabel = _getRouteLabel(localizations);
    return AnimatedBuilder(
      animation: widget.route!.animation!,
      builder: (BuildContext context, Widget? child) {
        var value2 = Tween(begin: 0.0, end: 1.0).animate(widget.route!._animationController);
        var animation = CurvedAnimation(
          parent: value2,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
              delegate: _ModalBottomSheetLayout(animation.value, widget.isScrollControlled),
              child: BottomSheet(
                isElastic: widget.isElastic,
                animationController: widget.route?._animationController,
                onClosing: () {
                  if (widget.route!.isCurrent) {
                    Navigator.pop(context);
                  }
                },
                builder: widget.route!.builder!,
                backgroundColor: widget.backgroundColor,
                elevation: widget.elevation,
                shape: widget.shape,
                clipBehavior: widget.clipBehavior,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute(
    this.isElastic, {
    this.builder,
    this.theme,
    this.barrierLabel,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.isDismissible = true,
    required this.isScrollControlled,
    RouteSettings? settings,
  })  : assert(isScrollControlled != null),
        assert(isDismissible != null),
        super(settings: settings);

  final WidgetBuilder? builder;
  final ThemeData? theme;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final bool isElastic;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool isDismissible;

  @override
  Duration get transitionDuration => _bottomSheetDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  late AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator?.overlay as TickerProvider, isElastic);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final BottomSheetThemeData sheetTheme = theme?.bottomSheetTheme ?? Theme.of(context).bottomSheetTheme;
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(
        route: this,
        isElastic: isElastic,
        backgroundColor: backgroundColor ?? sheetTheme?.modalBackgroundColor ?? sheetTheme?.backgroundColor,
        elevation: elevation ?? sheetTheme?.modalElevation ?? sheetTheme?.elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        isScrollControlled: isScrollControlled,
      ),
    );
    if (theme != null) bottomSheet = Theme(data: theme!, child: bottomSheet);
    return bottomSheet;
  }
}

Future<T?> showSheetWidget<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  bool isElastic = true,
  ShapeBorder? shape,
  Clip? clipBehavior,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
}) {
  assert(context != null);
  assert(builder != null);
  assert(isScrollControlled != null);
  assert(useRootNavigator != null);
  assert(isDismissible != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  return Navigator.of(context, rootNavigator: useRootNavigator).push(_ModalBottomSheetRoute<T>(
    isElastic,
    builder: builder,
    theme: Theme.of(context),
    isScrollControlled: isScrollControlled,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    isDismissible: isDismissible,
  ));
}
