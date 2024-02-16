/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:maixs_utils/widget/custom_scroll_physics.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/photo_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/global.dart';
import '../util/paixs_fun.dart';


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
                if(!img.startsWith('http')) {
                  img = BService.formatUrl(img);
                }
                return Global.openFadeContainer(GestureDetector(
                  child: PWidget.wrapperImage(img,{'mcw':600}),
                ), PhotoView(images: widget.list, index: i));
              },
            ),
          ),
        ),
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
