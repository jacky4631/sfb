import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/config/net/Config.dart';
import '../util/utils.dart';
import '../widget/views.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'custom_scroll_physics.dart';
import 'mytext.dart';

class PhotoView extends StatefulWidget {
  final List images;
  final int index;
  final String? tag;
  final double flag;
  final bool isUrl;
  final bool isByte;
  final String? imgUrl;

  const PhotoView({
    Key? key,
    this.images = const [],
    this.index = 0,
    this.tag,
    this.flag = 0.0,
    this.isUrl = false,
    this.isByte = false,
    this.imgUrl,
  }) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  int currentIndex = 0;
  PageController? controller;

  // var imgUrl = Config.ImgBaseUrl;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Color(0xff191919),
        body: GestureDetector(
          onTap: () => pop(context),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: handleGlowNotification,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: PagePhysics(),
                    builder: (BuildContext context, int index) {
                      ImageProvider? imageProvider;
                      if(widget.isByte) {
                        imageProvider = MemoryImage(Uint8List.
                        fromList(List.castFrom<dynamic, int>(widget.images[index])));
                      } else {
                        imageProvider = CachedNetworkImageProvider(widget.isUrl
                            ? '${widget.images[index]}'
                            : '${widget.imgUrl ?? Config.ImgBaseUrl}${widget.images[index]}',
                        );
                      }
                      return PhotoViewGalleryPageOptions(
                        heroAttributes: PhotoViewHeroAttributes(
                          tag: widget.images.length - 1 < widget.index ? '' : widget.images[widget.index].toString() + (widget.tag ?? ''),
                        ),
                        maxScale: 1.0,
                        minScale: 0.1,
                        filterQuality: FilterQuality.high,
                        imageProvider: imageProvider,
                      );
                    },
                    itemCount: widget.images.length,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    pageController: controller,
                    // enableRotation: true,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x50000000),
                        Color(0x00000000),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: padd(context).top),
                      Container(
                        height: 72,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Opacity(
                              opacity: widget.flag,
                              child: IconButton(
                                icon: Icon(Icons.delete_outline),
                                color: Colors.white,
                                onPressed: () {
                                  if (widget.flag == 1.0)
                                    showTc(
                                      title: '确定删除这张照片吗？',
                                      isClose: false,
                                      okColor: Theme.of(context).primaryColor,
                                      onPressed: () async {
                                        if (widget.images.length == 1) {
                                          widget.images.removeAt(currentIndex);
                                        } else {
                                          widget.images.removeAt(currentIndex);
                                          setState(() {});
                                        }
                                        if (widget.images.isEmpty) pop(context);
                                      },
                                    );
                                },
                              ),
                            ),
                            MyText(
                              "${currentIndex + 1}/${widget.images.length}",
                              size: 16,
                              color: Colors.white,
                            ),
                            IconButton(
                              icon: Icon(Icons.close_rounded),
                              color: Colors.white,
                              onPressed: () => pop(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
