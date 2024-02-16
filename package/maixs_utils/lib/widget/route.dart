import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/bg_page.dart';
import 'package:maixs_utils/widget/mytext.dart';
import 'package:maixs_utils/widget/pages.dart' as p;

///手势宽度
const double _kBackGestureWidth = 20.0;
const double _kMinFlingVelocity = 1.0;
bool isSlide = false;
bool isSliding = true;

final Animatable<Offset> _kRightMiddleTween = Tween<Offset>(
  begin: const Offset(1.0, 0.0),
  end: Offset.zero,
);

final Animatable<Offset> _kRightMiddleTween1 = Tween<Offset>(
  begin: const Offset(0.0, 1.0),
  end: Offset.zero,
);

final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(-1.0 / 2, 0.0),
);

final Animatable<Offset> _kMiddleLeftTween1 = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(0.0, -1.0 / 4),
);

final DecorationTween _kGradientShadowTween1 = DecorationTween(
  begin: BoxDecoration(
    boxShadow: [
      BoxShadow(
        blurRadius: 8,
        color: Colors.black.withOpacity(0.0),
      ),
    ],
  ),
  end: BoxDecoration(
    boxShadow: [
      BoxShadow(
        blurRadius: 8,
        color: Colors.black.withOpacity(0.25),
      ),
    ],
  ),
);

final DecorationTween _kGradientShadowTween = DecorationTween(
  begin: BoxDecoration(
    boxShadow: [
      BoxShadow(
        blurRadius: 8,
        color: Colors.black.withOpacity(0.0),
      ),
    ],
  ),
  end: BoxDecoration(
    boxShadow: [
      BoxShadow(
        blurRadius: 8,
        color: Colors.black.withOpacity(0.5),
      ),
    ],
  ),
);

mixin CupertinoRouteTransitionMixin<T> on p.PageRoute<T> {
  WidgetBuilder get builder;

  String? get title;

  bool? isMoveBtm;

  ValueNotifier<String>? _previousTitle;

  ValueNotifier<String>? get previousTitle {
    assert(
      _previousTitle != null,
      'Cannot read the previousTitle for a route that has not yet been installed',
    );
    return _previousTitle;
  }

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    final String? previousTitleString = previousRoute is CupertinoRouteTransitionMixin ? previousRoute.title : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String>(previousTitleString!);
    } else {
      _previousTitle?.value = previousTitleString!;
    }
    super.didChangePrevious(previousRoute);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: RouteState.routeAnimationTime);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is CupertinoRouteTransitionMixin && !nextRoute.fullscreenDialog;
  }

  static bool isPopGestureInProgress(p.PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  bool get popGestureInProgress => isPopGestureInProgress(this);

  bool get popGestureEnabled => _isPopGestureEnabled(this);

  static bool _isPopGestureEnabled<T>(p.PageRoute<T> route) {
    if (route.isFirst) return false;

    if (route.willHandlePopInternally) return false;

    if (route.hasScopedWillPopCallback) return false;

    if (route.fullscreenDialog) return false;

    if (route.animation?.status != AnimationStatus.completed) return false;

    if (route.secondaryAnimation?.status != AnimationStatus.dismissed) return false;

    if (isPopGestureInProgress(route)) return false;

    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Widget child = builder(context);
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
    assert(() {
      if (child == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('The builder for route "${settings.name}" returned null.'),
          ErrorDescription('Route builders must never return null.'),
        ]);
      }
      return true;
    }());
    return result;
  }

  static _CupertinoBackGestureController<T> _startPopGesture<T>(p.PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return _CupertinoBackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!,
    );
  }

  static Widget buildPageTransitions<T>(
    p.PageRoute<T> route,
    bool isMoveBtm,
    String? title,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final bool linearTransition = isPopGestureInProgress(route);

    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      isMoveBtm: isMoveBtm,
      title: title!,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: linearTransition,
      child: _CupertinoBackGestureDetector<T>(
        enabledCallback: () => _isPopGestureEnabled<T>(route),
        onStartPopGesture: () => _startPopGesture<T>(route),
        child: child,
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions<T>(
      this,
      isMoveBtm!,
      title,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

class CupertinoPageRoute<T> extends p.PageRoute<T> with CupertinoRouteTransitionMixin<T> {
  CupertinoPageRoute({
    required this.builder,
    this.title,
    this.isMoveBtm = false,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(isMoveBtm != null),
        super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  final WidgetBuilder builder;

  @override
  final String? title;

  @override
  final bool isMoveBtm;

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

class CupertinoPageTransition extends StatelessWidget {
  CupertinoPageTransition({
    Key? key,

    required this.child,
    required this.linearTransition,
    required this.isMoveBtm,
    required this.title,
    required this.primaryRouteAnimation,
    required this.secondaryRouteAnimation,
  })  : assert(linearTransition != null),
        _primaryPositionAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: RouteState.animationCurve,
                    reverseCurve: RouteState.animationReverseCurve,
                  ))
            .drive(RouteState.isFromDown ? _kRightMiddleTween1 : _kRightMiddleTween),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: RouteState.animationCurve,
                    reverseCurve: RouteState.animationReverseCurve,
                  ))
            .drive(RouteState.isFromDown ? _kMiddleLeftTween1 : _kMiddleLeftTween),
        _primaryShadowAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linear,
                  ))
            .drive(RouteState.isFromDown ? _kGradientShadowTween1 : _kGradientShadowTween),
        super(key: key);

  final Animation<Offset> _primaryPositionAnimation;
  final Animation<Offset> _secondaryPositionAnimation;
  final Animation<Decoration> _primaryShadowAnimation;

  final Animation<double> primaryRouteAnimation;
  final Animation<double> secondaryRouteAnimation;
  final bool linearTransition;

  final Widget child;

  final bool isMoveBtm;
  final String title;
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    if (RouteState.isTransparent) {
      return FadeTransition(
        opacity: (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linear,
                    reverseCurve: Curves.linear,
                  ))
            .drive(Tween(begin: 1, end: 1)),
        child: FadeTransition(
          opacity: (linearTransition
                  ? primaryRouteAnimation
                  : CurvedAnimation(
                      parent: primaryRouteAnimation,
                      curve: Curves.linear,
                      reverseCurve: Curves.linear,
                    ))
              .drive(Tween(begin: 0, end: 1)),
          child: FadeTransition(
            opacity: (linearTransition
                    ? primaryRouteAnimation
                    : CurvedAnimation(
                        parent: primaryRouteAnimation,
                        curve: Curves.linear,
                        reverseCurve: Curves.linear,
                      ))
                .drive(Tween(begin: 0, end: 1)),
            child: child,
          ),
        ),
      );
    } else if (RouteState.isMove) {
      if (RouteState.isScale) {
        if (RouteState.isDrawer) {
          return ScaleTransition(
            scale: (linearTransition
                    ? secondaryRouteAnimation
                    : CurvedAnimation(
                        parent: secondaryRouteAnimation,
                        curve: RouteState.animationCurve,
                        reverseCurve: RouteState.animationReverseCurve,
                      ))
                .drive(Tween(begin: 1.0, end: RouteState.scaleValue ?? 0.9)),
            child: SlideTransition(
              position: (linearTransition
                      ? secondaryRouteAnimation
                      : CurvedAnimation(
                          parent: secondaryRouteAnimation,
                          curve: RouteState.animationCurve,
                          reverseCurve: RouteState.animationReverseCurve,
                        ))
                  .drive(
                Tween(
                  begin: Offset(0, 0),
                  end: Offset(RouteState.isFromDown ? 0 : -0.15, RouteState.isFromDown ? -0.1 : 0),
                ),
              ),
              child: Stack(
                children: [
                  FadeTransition(
                    opacity: (linearTransition
                            ? primaryRouteAnimation
                            : CurvedAnimation(
                                parent: primaryRouteAnimation,
                                curve: RouteState.animationCurve,
                                reverseCurve: RouteState.animationReverseCurve,
                              ))
                        .drive(Tween(begin: 0.0, end: 0.5)),
                    child: Container(color: Colors.black),
                  ),
                  SlideTransition(
                    position: (linearTransition
                            ? primaryRouteAnimation
                            : CurvedAnimation(
                                parent: primaryRouteAnimation,
                                curve: RouteState.animationCurve,
                                reverseCurve: RouteState.animationReverseCurve,
                              ))
                        .drive(
                      Tween(
                        begin: RouteState.isFromDown ? Offset(0, 1) : Offset(1, 0),
                        end: Offset(0, 0),
                      ),
                    ),
                    child: RouteState.radiusValue == 0.0
                        ? RouteState.isRecycle
                            ? Stack(
                                children: [
                                  Visibility(
                                    visible: secondaryRouteAnimation.value <= 0.0,
                                    child: child,
                                    maintainState: true,
                                  ),
                                  Visibility(
                                    visible: secondaryRouteAnimation.value > 0.0,
                                    child: Container(
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      child: Opacity(
                                        opacity: secondaryRouteAnimation.value,
                                        child: RouteState.recycleStr == null ? CupertinoActivityIndicator() : MyText(RouteState.recycleStr),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : child
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(RouteState.radiusValue),
                            child: child,
                          ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return ScaleTransition(
            scale: (linearTransition
                    ? secondaryRouteAnimation
                    : CurvedAnimation(
                        parent: secondaryRouteAnimation,
                        curve: RouteState.animationCurve,
                        reverseCurve: RouteState.animationReverseCurve,
                      ))
                .drive(Tween(begin: 1.0, end: RouteState.scaleValue ?? 0.9)),
            child: Stack(
              children: [
                FadeTransition(
                  opacity: (linearTransition
                          ? primaryRouteAnimation
                          : CurvedAnimation(
                              parent: primaryRouteAnimation,
                              curve: RouteState.animationCurve,
                              reverseCurve: RouteState.animationReverseCurve,
                            ))
                      .drive(Tween(begin: 0.0, end: 0.5)),
                  child: Container(color: Colors.black),
                ),
                SlideTransition(
                  position: (linearTransition
                          ? primaryRouteAnimation
                          : CurvedAnimation(
                              parent: primaryRouteAnimation,
                              curve: RouteState.animationCurve,
                              reverseCurve: RouteState.animationReverseCurve,
                            ))
                      .drive(
                    Tween(
                      begin: RouteState.isFromDown ? Offset(0, 1) : Offset(1, 0),
                      end: Offset(0, 0),
                    ),
                  ),
                  child: RouteState.radiusValue == 0.0
                      ? DecoratedBoxTransition(
                          decoration: _primaryShadowAnimation,

                          child: RouteState.isRecycle
                              ? Stack(
                                  children: [
                                    Visibility(
                                      visible: secondaryRouteAnimation.value <= 0.0,
                                      child: child,
                                      maintainState: true,
                                    ),
                                    Visibility(
                                      visible: secondaryRouteAnimation.value > 0.0,
                                      child: Container(
                                        color: Colors.white,
                                        alignment: Alignment.center,
                                        child: Opacity(
                                          opacity: secondaryRouteAnimation.value,
                                          child: RouteState.recycleStr == null ? CupertinoActivityIndicator() : MyText(RouteState.recycleStr),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : child,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(RouteState.radiusValue),
                          child: child,
                        ),
                ),
              ],
            ),
          );
        }
      } else if (RouteState.isOffset) {
        return SlideTransition(
          position: _secondaryPositionAnimation,
          textDirection: textDirection,
          transformHitTests: false,
          child: RouteState.isHm
              ? RouteState.isFromDown
                  ? Stack(
                      children: [
                        FadeTransition(
                          opacity: (linearTransition
                                  ? primaryRouteAnimation
                                  : CurvedAnimation(
                                      parent: primaryRouteAnimation,
                                      curve: RouteState.animationCurve,
                                      reverseCurve: RouteState.animationReverseCurve,
                                    ))
                              .drive(Tween(begin: 0.0, end: 0.5)),
                          child: Container(color: Colors.black),
                        ),
                        SlideTransition(
                          position: _primaryPositionAnimation,
                          textDirection: textDirection,
                          child: RouteState.isShadow
                              ? DecoratedBoxTransition(
                                  decoration: _primaryShadowAnimation,
                                  child: child,
                                )
                              : child,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        FadeTransition(
                          opacity: (linearTransition
                                  ? primaryRouteAnimation
                                  : CurvedAnimation(
                                      parent: primaryRouteAnimation,
                                      curve: RouteState.animationCurve,
                                      reverseCurve: RouteState.animationReverseCurve,
                                    ))
                              .drive(Tween(begin: 0.0, end: 0.5)),
                          child: Container(color: Colors.black),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: DecoratedBoxTransition(
                            decoration: _primaryShadowAnimation,
                            child: ClipRect(
                              child: Align(
                                alignment: RouteState.isHmMove ? Alignment.center : Alignment.centerRight,
                                widthFactor: ((linearTransition
                                            ? primaryRouteAnimation
                                            : CurvedAnimation(
                                                parent: primaryRouteAnimation,
                                                curve: RouteState.animationCurve,
                                                reverseCurve: RouteState.animationReverseCurve,
                                              ))
                                        .drive(Tween(begin: 0.0, end: 1.0)))
                                    .value,
                                heightFactor: 1.0,
                                child: child,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
              : RouteState.isMask
                  ? Stack(
                      children: [
                        FadeTransition(
                          opacity: (linearTransition
                                  ? primaryRouteAnimation
                                  : CurvedAnimation(
                                      parent: primaryRouteAnimation,
                                      curve: RouteState.animationCurve,
                                      reverseCurve: RouteState.animationReverseCurve,
                                    ))
                              .drive(Tween(begin: 0.0, end: 0.5)),
                          child: Container(color: Colors.black),
                        ),
                        SlideTransition(
                          position: _primaryPositionAnimation,
                          textDirection: textDirection,
                          child: RouteState.isShadow
                              ? DecoratedBoxTransition(
                                  decoration: _primaryShadowAnimation,
                                  child: child,
                                )
                              : child,
                        ),
                      ],
                    )
                  : SlideTransition(
                      position: _primaryPositionAnimation,
                      textDirection: textDirection,
                      child: RouteState.isShadow
                          ? DecoratedBoxTransition(
                              decoration: _primaryShadowAnimation,
                              child: child,
                            )
                          : child,
                    ),
        );
      } else {
        return ScaleTransition(
          scale: (linearTransition
                  ? secondaryRouteAnimation
                  : CurvedAnimation(
                      parent: secondaryRouteAnimation,
                      curve: RouteState.animationCurve,
                      reverseCurve: RouteState.animationReverseCurve,
                    ))
              .drive(Tween(begin: 1.0, end: 1.1)),
          child: ScaleTransition(
            scale: (linearTransition
                    ? primaryRouteAnimation
                    : CurvedAnimation(
                        parent: primaryRouteAnimation,
                        curve: RouteState.animationCurve,
                        reverseCurve: RouteState.animationReverseCurve,
                      ))
                .drive(Tween(begin: 0.9, end: 1)),
            child: FadeTransition(
              opacity: (linearTransition
                      ? primaryRouteAnimation
                      : CurvedAnimation(
                          parent: primaryRouteAnimation,
                          curve: Curves.easeOutExpo,
                          reverseCurve: Curves.easeInExpo,
                        ))
                  .drive(Tween(begin: 0, end: 1)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RouteState.radiusValue),
                child: child,
              ),
            ),
          ),
        );
      }
    } else {
      return ScaleTransition(
        scale: (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: RouteState.animationCurve,
                    reverseCurve: RouteState.animationReverseCurve,
                  ))
            .drive(Tween(begin: 1.0, end: 1.1)),
        child: ScaleTransition(
          scale: (linearTransition
                  ? primaryRouteAnimation
                  : CurvedAnimation(
                      parent: primaryRouteAnimation,
                      curve: RouteState.animationCurve,
                      reverseCurve: RouteState.animationReverseCurve,
                    ))
              .drive(Tween(begin: 0.9, end: 1)),
          child: FadeTransition(
            opacity: (linearTransition
                    ? primaryRouteAnimation
                    : CurvedAnimation(
                        parent: primaryRouteAnimation,
                        curve: Curves.easeOutExpo,
                        reverseCurve: Curves.easeInExpo,
                      ))
                .drive(Tween(begin: 0, end: 1)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RouteState.radiusValue),
              child: child,
            ),
          ),
        ),
      );
    }
  }
}

///手势
class _CupertinoBackGestureDetector<T> extends StatefulWidget {
  const _CupertinoBackGestureDetector({
    Key? key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  })  : assert(enabledCallback != null),
        assert(onStartPopGesture != null),
        assert(child != null),
        super(key: key);

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_CupertinoBackGestureController<T>> onStartPopGesture;

  @override
  _CupertinoBackGestureDetectorState<T> createState() => _CupertinoBackGestureDetectorState<T>();
}

class _CupertinoBackGestureDetectorState<T> extends State<_CupertinoBackGestureDetector<T>> {
  _CupertinoBackGestureController<T>? _backGestureController;

  HorizontalDragGestureRecognizer? _recognizer1;
  HorizontalDragGestureRecognizer? _recognizer2;

  var localPosition = Offset.zero;
  var localPosition1 = Offset.zero;
  var localPosition2 = Offset.zero;
  DateTime? dateTime;
  double a1 = 0.0;
  var left = 0.0;

  @override
  void initState() {
    super.initState();
    _recognizer1 = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate1
      ..onEnd = _handleDragEnd1
      ..onCancel = _handleDragCancel;
    _recognizer2 = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate2
      ..onEnd = _handleDragEnd2
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer1?.dispose();
    _recognizer2?.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    dateTime = DateTime.now();
    localPosition = details.localPosition;
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate1(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    var d = details.localPosition.dx - localPosition.dx;
    if (isSlide || isSliding) {
      _backGestureController?.dragUpdate(_convertToLogical(
        details.primaryDelta! / context.size!.width,
      ));
    }
    localPosition1 = details.localPosition;
    localPosition2 = Offset(localPosition1.dx, localPosition.dy);
    double d1 = (localPosition1 - localPosition2).distance;
    double d2 = (localPosition - localPosition2).distance;
    double d3 = (localPosition - localPosition1).distance;
    double cons1 = (d2 * d2 + d3 * d3 - d1 * d1) / (2 * d2 * d3);
    a1 = acos(cons1);
    if (a1 < 0) {
      a1 = (a1 + pi) * 180 / pi;
    }
    a1 = a1 * 180 / pi;
    if (d >= 0) {
      if (DateTime.now().difference(dateTime!).inMilliseconds <= 250) {
        if (a1 < 10) {
          isSlide = true;
        }
      }
    }
  }

  void _handleDragEnd1(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    // if (isSlide) {
    _backGestureController?.dragEnd(
      _convertToLogical(details.velocity.pixelsPerSecond.dx / context.size!.width),
    );
    _backGestureController = null;
    // }
  }

  ///右手
  void _handleDragUpdate2(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController?.dragUpdate(-_convertToLogical(
      details.primaryDelta! / context.size!.width,
    ));
  }

  void _handleDragEnd2(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController?.dragEnd(
      -_convertToLogical(details.velocity.pixelsPerSecond.dx / context.size!.width),
    );
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown1(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer1?.addPointer(event);
  }

  void _handlePointerDown2(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer2?.addPointer(event);
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr ? MediaQuery.of(context).padding.left : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, _kBackGestureWidth);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        // if ((RouteState.isScale && RouteState.isFromDown) || (RouteState.isOffset && RouteState.isFromDown) || RouteState.isNative)
        if (RouteState.isSlideRight)
          PositionedDirectional(
            end: 0.0,
            width: dragAreaWidth,
            top: 0.0,
            bottom: 0.0,
            child: Listener(
              onPointerDown: _handlePointerDown2,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        PositionedDirectional(
          start: 0.0,
          width: isSliding ? dragAreaWidth : MediaQuery.of(context).size.width,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown1,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class _CupertinoBackGestureController<T> {
  _CupertinoBackGestureController({
    required this.navigator,
    required this.controller,
  })  : assert(navigator != null),
        assert(controller != null) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    ///滑动返回的物理效果
    // const Curve animationCurve = RouteState.animationCurve;
    bool animateForward;

    if (velocity.abs() >= _kMinFlingVelocity)
      animateForward = velocity <= 0;
    else
      animateForward = controller.value > 0.5;

    if (animateForward) {
      controller.animateTo(1.0, duration: Duration(milliseconds: RouteState.routeAnimationTime), curve: RouteState.animationCurve);
    } else {
      navigator.pop();
      if (controller.isAnimating) {
        // final int droppedPageBackAnimationTime = lerpDouble(0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value).floor();
        controller.animateBack(0.0, duration: Duration(milliseconds: RouteState.routeAnimationTime), curve: RouteState.animationCurve);
      }
    }

    if (controller.isAnimating) {
      AnimationStatusListener? animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        isSlide = false;

        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback!);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

///自定义路由状态
class RouteState {
  ///是否显示菜单动画
  static bool isShowMenuAnimation = true;
  static void changeMenuAnimationState(bool v) => isShowMenuAnimation = v;
  static bool isPop = true;
  static bool isMove = false;
  static bool isTransparent = false;

  ///是否从底部弹出
  static bool isFromDown = false;

  static bool isScale = false;

  ///是否偏移
  static bool isOffset = true;

  ///是否需要阴影
  static bool isShadow = true;

  ///是否需要遮罩
  static bool isMask = true;

  ///是否仿生鸿蒙效果
  static bool isHm = false;

  ///鸿蒙效果是否移动
  static bool isHmMove = true;

  ///整体动画过渡曲线
  static Curve animationCurve = Curves.easeOut;
  static Curve animationReverseCurve = Curves.easeIn;

  ///整体动画时间 250
  static int animationTime = 250;

  ///路由动画时间 500
  static int routeAnimationTime = 500;

  ///标题箭头从下往下的动画时间 200
  static int fromToDownAnimationTime = (200 * (animationTime / 400)).toInt() + 50;

  ///标题箭头从右向左动画时间 150
  static int rightToLeftAnimationTime = (150 * (animationTime / 400)).toInt() + 50;

  ///从下到下列出动画时间 150
  static int listFromToDownAnimationTime = (150 * (animationTime / 400)).toInt() + 50;
  // static int listFromToDownAnimationTime = 150;

  ///从右向左列出动画时间 100
  static int listRightToLeftAnimationTime = (100 * (animationTime / 400)).toInt() + 50;
  // static int listRightToLeftAnimationTime = 100;

  ///列出垂直动画时间 200
  static int listVerticalAnimationTime = (200 * (animationTime / 400)).toInt() + 50;
  // static int listVerticalAnimationTime = 200;

  ///列出动画时间 400
  static int listAnimationTime = (400 * (animationTime / 400)).toInt();
  // static int listAnimationTime = 250;

  static bool isSlideRight = true;

  ///是否原生效果
  static bool isNative = false;

  ///缩放时是否有抽屉效果
  static bool isDrawer = false;

  ///圆角度
  static double radiusValue = 16;

  ///缩放值
  static double? scaleValue;

  static bool isRecycle = false;
  static String? recycleStr;

  ///状态列表
  static List<bool> stateList = [];

  static DateTime? dateTime;
  static double desktopLeftMenuWidth = 0.0;

  ///设置路由为原生状态
  static setNativeState([double value = 16.0]) {
    radiusValue = value;
    isNative = true;
    isScale = false;
    isOffset = false;
  }

  ///设置路由为缩放偏移状态
  static setScaleState([double value = 16.0]) {
    radiusValue = value;
    isScale = true;
    isNative = false;
    isOffset = false;
  }

  ///设置路由为缩放状态
  static setOffsetState([bool value = true]) {
    isShadow = value;
    isOffset = true;
    isScale = false;
    isNative = false;
  }
}

///页面跳转
jumpPage(
  Widget p, {

  ///是否底部
  bool isMoveBtm = false,

  ///是否静默跳转
  bool isStatic = false,

  ///是否关闭之前的页面
  bool isClose = false,

  ///是否移动
  bool isMove = true,

  ///是否回收
  bool isRecycle = false,

  ///鸿蒙效果是否移动
  bool isHmMove = true,

  ///回收提示文字
  String? recycleStr,

  ///回调函数
  Function(dynamic)? callback,
  bool isPadd = false,
  BuildContext? c,
}) async {
  // if (!isMove) {
  // isMove = false;
  //   isMoveBtm = true;
  // }
  // if (isStatic) isMove = false;
  FocusScope.of(context).requestFocus(FocusNode());
  isPadd = false;
  // RouteState.isHmMove = isHmMove;
  RouteState.isFromDown = isMoveBtm;
  RouteState.stateList.insert(0, isMoveBtm);
  RouteState.isRecycle = isRecycle;
  RouteState.recycleStr = recycleStr;

  if (isMove) {
    if (isClose) {
      return Navigator.pushAndRemoveUntil(
        c ?? (isMobile ? context : context1)!,
        CupertinoPageRoute(
          builder: (_) => BgPage(SafeArea(top: false, child: p, bottom: false)),
        ),
        (v) => v == null,
      );
    } else {
      return Navigator.push(
        c ?? (isMobile ? context : context1)!,
        CupertinoPageRoute(
          builder: (_) {
            return BgPage(SafeArea(top: false, child: p, bottom: false));
          },
        ),
      ).then((v) async {
        if (callback != null) await callback(v);
        if (RouteState.isPop) {
          await Future.delayed(Duration(milliseconds: RouteState.routeAnimationTime));
          RouteState.isRecycle = false;
          RouteState.recycleStr = null;
          if (RouteState.stateList.length > 1) {
            RouteState.isFromDown = RouteState.stateList[1];
            RouteState.stateList.removeAt(0);
          }
        }
      });
    }
  } else {
    if (isClose) {
      RouteState.isTransparent = true;
      Future(() async {
        await Future.delayed(Duration(milliseconds: RouteState.routeAnimationTime));
        RouteState.isMove = true;
        RouteState.isTransparent = false;
      });
      return Navigator.pushAndRemoveUntil(
        c ?? (isMobile ? context : context1)!,
        CupertinoPageRoute(
          builder: (_) => BgPage(SafeArea(top: false, child: p, bottom: false)),
        ),

        (v) => v == null,
      );
    } else {
      return Navigator.push(
        c ?? (isMobile ? context : context1)!,

        CupertinoPageRoute(
          builder: (_) => BgPage(SafeArea(top: false, child: p, bottom: false)),
        ),
      ).then((v) async {
        if (callback != null) await callback(v);
        if (RouteState.isPop) {
          await Future.delayed(Duration(milliseconds: 250));
          RouteState.isRecycle = false;
          RouteState.recycleStr = null;
          if (RouteState.stateList.length > 1) {
            RouteState.isFromDown = RouteState.stateList[1];
            RouteState.stateList.removeAt(0);
          }
        }
      });
    }
  }
}

/// 页面关闭
void closePage({
  ///关闭的页面个数
  int count = 1,

  ///回传的数据
  dynamic data,
}) {
  switch (count) {
    case 1:
      Navigator.pop(context, data);
      break;
    case 2:
      RouteState.isPop = false;
      RouteState.isFromDown = RouteState.stateList[1];
      Navigator.pop(context);
      Navigator.pop(context, data);
      Future(() => RouteState.isPop = true);
      break;
    case 3:
      RouteState.isPop = false;
      RouteState.isFromDown = RouteState.stateList[2];
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context, data);
      Future(() => RouteState.isPop = true);
      break;
    default:
  }
}
