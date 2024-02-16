/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieVideoPage extends StatefulWidget {
  final Map data;
  const ChewieVideoPage(this.data, {Key? key,}) : super(key: key);

  @override
  State<ChewieVideoPage> createState() => _ChewieVideoPageState();
}

class _ChewieVideoPageState extends State<ChewieVideoPage> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(
        'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/video/${widget.data['url']}');
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9 / 18,
      autoPlay: true,
      showControlsOnInitialize:false,

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context,
            title: widget.data['title'],
            widgetColor: Colors.black,
            leftIcon: Icon(
              Icons.arrow_back_ios,
            ))
      ,
      body: PWidget.container(Center(
        child: Chewie(
          controller: chewieController,
        ),
      ),
      {'pd': [0,MediaQuery.of(context).padding.bottom+8, 0, 0]}),
    );
  }
}

