import 'package:flutter/material.dart';

///动画路由跳转

class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  final Object? arguments;
  final Duration duration;
  final bool? isMove;
  final bool? isMoveBtm;
  final bool opaque;

  CustomRoute(
    this.widget, {
    this.opaque = false,
    this.arguments,
    this.isMove,
    this.isMoveBtm,
    this.duration = const Duration(milliseconds: 500),
  }) : super(
          transitionDuration: duration, //过渡时间
          opaque: opaque ?? false, //禁止路由跳转时Rebuild页面
          settings: RouteSettings(
            name: '${widget.runtimeType}',
            arguments: arguments,
          ),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
          ) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
            Widget child,
          ) {
            if (isMove!)
              return SlideTransition(
                position: Tween<Offset>(
                  begin: isMoveBtm! ? Offset(0, 1) : Offset(1, 0),
                  end: Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: animation1,
                    curve: Curves.easeOutSine,
                    reverseCurve: isMoveBtm! ? Curves.ease : Curves.easeInSine,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 24,
                        color: Colors.black.withOpacity(animation1.value * 0.5),
                      ),
                    ],
                  ),
                  child: child,
                ),
              );
            else
              return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn),
                ),
                child: child,
              );
          },
        );
}
