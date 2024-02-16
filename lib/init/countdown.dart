/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 启动页右上角倒计时
 */
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/colors.dart';
import '../base.dart';

class CountdownInit extends StatefulWidget {
  final int time;
  CountdownInit({this.time = 1, Key? key}) : super(key: key);
  
  @override
  _CountdownInit createState() => _CountdownInit();
}

class _CountdownInit extends State<CountdownInit> with BBase, SingleTickerProviderStateMixin {
  late Animation<double> _animation;         // canvas转动动画函数
  late AnimationController _controller;      // canvas转动动画控制器
  int _time = 2;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    // SystemChrome.setEnabledSystemUIOverlays([]);

    _controller = AnimationController(duration: Duration(seconds: widget.time), vsync: this,);  // 倒计时动画控制器
    _animation = Tween(begin: 0.0, end: 360.0).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((AnimationStatus a) {
      if (a == AnimationStatus.completed) {
        _jumpIndex();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _jumpIndex() {
    Navigator.of(context).pushReplacementNamed('/index');
    /* Future.delayed(Duration(milliseconds: 300), () {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }); */
  }
  
  @override
  Widget build(BuildContext context) {
    var countNum = widget.time - (_animation.value * widget.time / 360).round();

    return GestureDetector(
      onTap: _jumpIndex,
      child: Container(
        margin: EdgeInsets.only(top:20),
        width: 50,
        height: 50,
        decoration: ShapeDecoration(
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
        ),
        child: CustomPaint(
          child: Center(
            child: Text(
              '${countNum}s',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          painter: CircleProgressBarPainter(_animation.value),
        ),
      ),
    );
  }

}

// 画布绘制加载倒计时
class CircleProgressBarPainter extends CustomPainter {
  // Paint _paintBackground;
  Paint? _paintFore;
  final double? rate;

  CircleProgressBarPainter(this.rate) {
    // _paintBackground = Paint()  
    //   ..color = Colors.white
    //   ..strokeCap = StrokeCap.round
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2.0
    //   ..isAntiAlias = true;
    _paintFore = Paint()
      ..color = Colours.app_main
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;
  }
  @override
  void paint(Canvas canvas, Size size) {
    /* canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        _paintBackground); */
    Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    canvas.drawArc(rect, 0.0, rate! * Math.pi / 180, false, _paintFore!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}