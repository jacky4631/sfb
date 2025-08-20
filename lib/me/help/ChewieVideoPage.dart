/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
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
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/video/${widget.data['url']}'));
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.data['title']),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 0,
          right: MediaQuery.of(context).padding.bottom + 8,
          bottom: 0,
          left: 0,
        ),
        child: Center(
          child: Chewie(
            controller: chewieController,
          ),
        ),
      ),
    );
  }
}

