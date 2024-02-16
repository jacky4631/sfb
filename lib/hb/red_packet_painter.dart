/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sufenbao/hb/red_packet_controller.dart';

class RedPacketPainter extends CustomPainter{

  RedPacketController controller;

  late final Paint _paint = Paint()..isAntiAlias = true;
  final Path path = Path();

  late double height = 1.2.sw;
  late double topBezierEnd = (1.sh - height)/2 + height/8*7;
  late double topBezierStart= topBezierEnd - 0.2.sw;

  late double bottomBezierStart = topBezierEnd - 0.4.sw;

  Offset goldCenter = Offset.zero;
  final double centerWidth = 0.5.sw;

  late double left = 0.1.sw;
  late double right = 0.9.sw;
  late double top = (1.sh - height)/2;
  late double bottom = (1.sh - height)/2 + height;

  RedPacketPainter({required this.controller}) : super(repaint:controller.repaint);


  @override
  void paint(Canvas canvas, Size size) {
    drawBg(canvas);
    if(controller.showOpenBtn){
      drawGoldOpen(canvas);
    }
  }

  void drawBg(ui.Canvas canvas) {

    _paint.color = controller.colorCtrl.value ?? Colors.redAccent;
    _paint.style = PaintingStyle.fill;

    drawBottom(canvas);

    drawTop(canvas);
  }

  void drawTop(ui.Canvas canvas) {
    canvas.save();
    canvas.translate(0, topBezierEnd  * ( - controller.translateCtrl.value));

    path.reset();
    path.addRRect(RRect.fromLTRBAndCorners(left, top, right, topBezierStart, topLeft: const Radius.circular(5), topRight: const Radius.circular(5)));
    var bezierPath = getTopBezierPath();
    path.addPath(bezierPath, Offset.zero);
    path.close();

    canvas.drawShadow(path, Colors.redAccent, 2, true);
    canvas.drawPath(path, _paint);
    canvas.restore();
  }

  Path getTopBezierPath() {
    Path bezierPath = Path();
    bezierPath.moveTo(left, topBezierStart);
    bezierPath.quadraticBezierTo(centerWidth, topBezierEnd, right , topBezierStart);

    var pms = bezierPath.computeMetrics();
    var pm = pms.first;
    goldCenter = pm.getTangentForOffset(pm.length / 2)?.position ?? Offset.zero;
    return bezierPath;
  }

  void drawBottom(ui.Canvas canvas) {
    canvas.save();
    canvas.translate(0, topBezierStart * (controller.translateCtrl.value));

    path.reset();
    path.moveTo(left, bottomBezierStart );
    path.quadraticBezierTo(centerWidth, topBezierEnd, right , bottomBezierStart);
    path.lineTo(right, topBezierEnd);
    path.lineTo(left, topBezierEnd);
    path.addRRect(RRect.fromLTRBAndCorners(left, topBezierEnd, right, bottom, bottomLeft: const Radius.circular(5), bottomRight: const Radius.circular(5)));
    path.close();
    canvas.drawShadow(path, Colors.redAccent, 2, true);
    canvas.drawPath(path, _paint);

    canvas.restore();
  }

  void drawGoldOpen(ui.Canvas canvas) {
    drawGold(canvas);
    drawOpenText(canvas);
  }

  void drawOpenText(ui.Canvas canvas) {
    if(controller.showOpenText){
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: "開",
              style: TextStyle(fontSize: 34.sp, color: Colors.black87, height: 1.0, fontWeight: FontWeight.w400)
          ),
          textDirection: TextDirection.ltr,
          maxLines: 1,
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false)
      )..layout();

      canvas.save();
      canvas.translate(0.5.sw, goldCenter.dy);
      textPainter.paint(canvas, Offset(- textPainter.width / 2, -textPainter.height/2));
      canvas.restore();
    }
  }

  void drawGold(ui.Canvas canvas){
    Path path = Path();
    double angle = controller.angleCtrl.value;

    canvas.save();
    canvas.translate(0.5.sw, goldCenter.dy);

    path.reset();
    _paint.style = PaintingStyle.fill;
    path.addOval(Rect.fromLTRB(-40.w * angle, -40.w, 40.w * angle, 40.w));
    if(!controller.showOpenText){
      path.addRect(Rect.fromLTRB(-10.w * angle , -10.w, 10.w * angle , 10.w));
      path.fillType = PathFillType.evenOdd;
    }

    var frontOffset = 0.0;
    var backOffset = 0.0;
    if(controller.angleCtrl.status == AnimationStatus.reverse){
      frontOffset = 4.w;
      backOffset = -4.w;
    }else if(controller.angleCtrl.status == AnimationStatus.forward){
      frontOffset = -4.w;
      backOffset = 4.w;
    }
    var path2 = path.shift(Offset(backOffset * (1 - angle),  0));
    path = path.shift(Offset(frontOffset * (1 - angle), 0));

    controller.goldPath = path.shift(Offset(0.5.sw, goldCenter.dy));

    _paint.color = const Color(0xFFE5CDA8);
    canvas.drawPath(path2, _paint);

    drawGoldCenterRect(path, path2, canvas);

    _paint.color = const Color(0xFFFCE5BF);
    canvas.drawPath(path, _paint);

    canvas.restore();
  }

  void drawGoldCenterRect(ui.Path path, ui.Path path2, ui.Canvas canvas) {

    var pms1 = path.computeMetrics();
    var pms2 = path2.computeMetrics();

    var pathMetric1 = pms1.first;
    var pathMetric2 = pms2.first;
    var length = pathMetric1.length;
    Path centerPath = Path();
    for(int i = 0; i <length; i++){
      var position1 = pathMetric1.getTangentForOffset(i.toDouble())?.position;
      var position2 = pathMetric2.getTangentForOffset(i.toDouble())?.position;
      if(position1 == null || position2 == null){
        continue;
      }
      centerPath.moveTo(position1.dx, position1.dy);
      centerPath.lineTo(position2.dx, position2.dy);
    }

    Paint centerPaint = Paint()..color = const Color(0xFFE5CDA8)
      ..style = PaintingStyle.stroke..strokeWidth=1;
    canvas.drawPath(centerPath, centerPaint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}