/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomPhotoView extends StatelessWidget {
  final List<String> images;
  final int index;

  const CustomPhotoView({Key? key, required this.images, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('${index + 1}/${images.length}', style: TextStyle(color: Colors.white)),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: index),
        itemCount: images.length,
        itemBuilder: (context, i) {
          return Center(
            child: InteractiveViewer(
              child: Image.network(
                images[i],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

///轮播图组件
class LunboWidget extends StatefulWidget {
  final List list;
  final Function(Map)? fun;
  final String? value;
  final double? radius;
  final double? margin;
  final List? padding;
  final double? aspectRatio;
  final bool? loop;
  final SwiperPagination? swiperPagination;

  const LunboWidget(this.list,
      {Key? key,
      this.fun,
      this.value,
      this.radius,
      this.margin,
      this.padding,
      this.aspectRatio,
      this.loop = true,
      this.swiperPagination})
      : super(key: key);
  @override
  _LunboWidgetState createState() => _LunboWidgetState();
}

class _LunboWidgetState extends State<LunboWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: widget.aspectRatio ?? 1 / 1,
          child: Container(
            child: Swiper(
              autoplay: true,
              loop: widget.loop,
              autoplayDelay: 10000,
              curve: Curves.easeOutCubic,
              duration: 500,
              onIndexChanged: (i) => setState(() => index = i),
              itemCount: widget.list.length,
              pagination: widget.swiperPagination,
              itemBuilder: (_, i) {
                var data = widget.list[i];
                if (data is List) {
                  return SizedBox();
                }
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(widget.margin ?? 0),
                    padding: widget.padding != null
                        ? EdgeInsets.fromLTRB(
                            (widget.padding![0] ?? 0).toDouble(),
                            (widget.padding![1] ?? 0).toDouble(),
                            (widget.padding![2] ?? 0).toDouble(),
                            (widget.padding![3] ?? 0).toDouble())
                        : EdgeInsets.zero,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.radius ?? 0),
                      child: Image.network(
                        widget.fun == null ? data : data[widget.value],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    if (widget.fun == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CustomPhotoView(
                            images: widget.list.cast<String>(),
                            index: i,
                          ),
                        ),
                      );
                      return;
                    }
                    widget.fun!(data);
                  },
                );
              },
            ),
          ),
        ),
        if (widget.fun == null)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(56),
              ),
              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Text(
                '${index + 1}/${widget.list.length}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
