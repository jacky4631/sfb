/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/photo_widget.dart';
import 'package:maixs_utils/widget/route.dart';
import 'package:sufenbao/util/paixs_fun.dart';

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

  const LunboWidget(this.list, {Key? key, this.fun, this.value,
    this.radius, this.margin, this.padding, this.aspectRatio, this.loop = true, this.swiperPagination}) : super(key: key);
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
                if(data is List) {
                  return SizedBox();
                }
                return GestureDetector(
                  child: PWidget.wrapperImage(widget.fun == null ? data : data[widget.value],
                      {'br': widget.radius, 'pd': widget.padding??widget.margin}),
                  onTap: () {
                    if (widget.fun == null) return jumpPage(PhotoView(images: widget.list, index: i), isMoveBtm: true);
                    widget.fun!(data);
                  },
                );
              },
            ),
          ),
        ),
        if (widget.fun == null)
          PWidget.positioned(
            PWidget.container(
              PWidget.text('$index/${widget.list.length}', [Colors.white]),
              [null, null, Colors.black26],
              {'br': 56, 'pd': PFun.lg(4, 4, 12, 12)},
            ),
            [null, 16, null, 16],
          ),
      ],
    );
  }
}
