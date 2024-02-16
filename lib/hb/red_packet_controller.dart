/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';

class RedPacketController{

  final TickerProviderStateMixin tickerProvider;
  Listenable? repaint;

  Path? goldPath;

  late AnimationController angleController;
  late AnimationController translateController;
  late AnimationController scaleController;
  late Animation<double> translateCtrl;
  late Animation<Color?> colorCtrl;
  late Animation<double> angleCtrl;
  bool isAdd = false;
  bool showOpenText = true;
  bool showOpenBtn = true;

  Timer? timer;

  Function? onFinish;
  Function? onOpen;

  RedPacketController({required this.tickerProvider}){
    initAnimation();
  }




  void initAnimation() {
    angleController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: tickerProvider
    );
    translateController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: tickerProvider
    );
    scaleController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: tickerProvider
    )..forward();
    angleCtrl = angleController.drive(Tween(begin: 1.0, end: 0.0));


    translateCtrl = translateController.drive(Tween(begin: 0.0, end: 1.0));
    colorCtrl = translateController.drive(ColorTween(
        begin: Colors.redAccent,
        end: const Color(0x00FF5252))
    );

    translateController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        onFinish?.call();
      }
    });
    repaint = Listenable.merge([angleController, translateController]);
  }


  void stop() async{
    if(angleController.isAnimating){
      if(angleController.status == AnimationStatus.forward){
        await angleController.forward();
        angleController.reverse();
      }else if(angleController.status == AnimationStatus.reverse){
        angleController.reverse();
      }

      tickerProvider.setState(() {
        showOpenBtn = false;
      });
      translateController.forward();
      onOpen?.call();
    }
  }

  void clickGold(TapUpDetails details) {
    if(checkClickGold(details.globalPosition)){
      if(angleController.isAnimating){
        stop();
      }else{
        angleController.repeat(reverse: true);
        tickerProvider.setState(() {
          showOpenText = false;
        });
        timer = Timer(const Duration(seconds: 2), (){
          stop();
        });
      }
    }
  }

  bool checkClickGold(Offset point){
    return  goldPath?.contains(point) == true;
  }

  void handleClick(Offset point) async{
    if(checkClickGold(point)){
      return;
    }
    await scaleController.reverse();
    onFinish?.call();
  }


  void dispose(){
    angleController.dispose();
    translateController.dispose();
    timer?.cancel();
  }
}