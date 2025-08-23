/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sufenbao/service.dart';

import '../util/global.dart';

///自定义 PagePhysics 类
class PagePhysics extends PageScrollPhysics {
  const PagePhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  PagePhysics applyTo(ScrollPhysics? ancestor) {
    return PagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring {
    return SpringDescription.withDampingRatio(
      mass: 0.1,
      stiffness: 50.0,
      ratio: 1,
    );
  }
}

///PhotoView 组件
class PhotoViewWidget extends StatefulWidget {
  final List images;
  final int index;

  const PhotoViewWidget({Key? key, required this.images, this.index = 0})
      : super(key: key);

  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  int currentIndex = 0;
  PageController? controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191919),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: PhotoViewGallery.builder(
                scrollPhysics: PagePhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    maxScale: 3.0,
                    minScale: 0.1,
                    filterQuality: FilterQuality.high,
                    imageProvider: NetworkImage(widget.images[index]),
                  );
                },
                itemCount: widget.images.length,
                backgroundDecoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                pageController: controller,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
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
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Container(
                      height: 72,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: 48), // 占位
                          Text(
                            "${currentIndex + 1}/${widget.images.length}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded),
                            color: Colors.white,
                            onPressed: () => Navigator.pop(context),
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
    );
  }
}

///详情页轮播图组件
class DetailLunboWidget extends StatefulWidget {
  final List list;
  const DetailLunboWidget(this.list, {Key? key}) : super(key: key);
  @override
  _DetailLunboWidgetState createState() => _DetailLunboWidgetState();
}

class _DetailLunboWidgetState extends State<DetailLunboWidget> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            child: Swiper(
              autoplay: true,
              autoplayDelay: 10000,
              curve: Curves.easeOutCubic,
              duration: 500,
              onIndexChanged: (i) => setState(() => index = i + 1),
              itemCount: widget.list.length,
              physics: PagePhysics(),
              itemBuilder: (_, i) {
                String img = widget.list[i];
                if (!img.startsWith('http')) {
                  img = BService.formatUrl(img);
                }
                return Global.openFadeContainer(
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          img,
                          fit: BoxFit.cover,
                          width: 600,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    PhotoViewWidget(images: widget.list, index: i));
              },
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.fromLTRB(4, 4, 12, 12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(56),
            ),
            child: Text(
              '$index/${widget.list.length}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
