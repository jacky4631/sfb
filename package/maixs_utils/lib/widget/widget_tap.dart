import 'package:flutter/material.dart';

class WidgetTap extends StatefulWidget {
  final Widget child;
  final bool isElastic;
  final bool isRipple;
  final Color? rippleColor;
  final Duration jumpTime;
  final HitTestBehavior? behavior;
  final void Function()? onTap;

  const WidgetTap({
    Key? key,
    required this.child,
    this.onTap,
    this.isElastic = false,
    this.isRipple = true,
    this.rippleColor,
    this.jumpTime = Duration.zero,
    this.behavior,
  }) : super(key: key);

  @override
  _WidgetTapState createState() => _WidgetTapState();
}

class _WidgetTapState extends State<WidgetTap> with TickerProviderStateMixin {
  AnimationController? animac, animac1;
  Animation? anima, anima1, anima2, anima3;
  bool flag = true;

  //var _lastPressedAdt;

  @override
  void dispose() {
    animac?.dispose();
    animac1?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animac = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animac1 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    var curvedAnimation = CurvedAnimation(parent: animac!, curve: ElasticOutCurve(0.75));
    anima = Tween(begin: 1.0, end: 1.1).animate(curvedAnimation);
    anima1 = Tween(begin: 1.1, end: 1.0).animate(curvedAnimation);
    anima2 = Tween(begin: 0.0, end: 200.0).animate(animac1!);
    anima3 = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animac1!,
        curve: Curves.easeOutCubic,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: widget.behavior ?? HitTestBehavior.translucent,
            child: AnimatedBuilder(
              animation: animac!,
              child: widget.child,
              builder: (_, v) {
                return Transform.scale(
                  child: v,
                  scale: widget.isElastic
                      ? flag
                          ? anima!.value!
                          : anima1!.value
                      : 1,
                );
              },
            ),
            onTapDown: (v) => animaStart(true),
            onTapCancel: () => animaStart(false),
            onTapUp: (v) async {
              animaStart(false);
              if (widget.isRipple) animac1?.forward(from: 0.0);
              if (widget.isElastic || widget.isRipple) await Future.delayed(widget.jumpTime);
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onTap!();
            },
          ),
        ),
      ],
    );
  }

  ///执行动画
  Future animaStart(bool f) async {
    if (widget.isElastic) {
      if (f) {
        flag = f;
        await animac?.forward(from: 0.0);
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        flag = f;
        await animac?.forward(from: 0.0);
      }
    }
  }
}
