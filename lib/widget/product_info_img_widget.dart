/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/photo_widget.dart';
import 'package:maixs_utils/widget/route.dart';

import 'aspect_ratio_image.dart';
import '../util/paixs_fun.dart';
import '../service.dart';

// 产品详情图片小部件
class ProductInfoImgWidget extends StatefulWidget {
  final dynamic data;
  final double? imgRatio;
  const ProductInfoImgWidget(this.data, {Key? key, this.imgRatio}) : super(key: key);
  @override
  _ProductInfoImgWidgetState createState() => _ProductInfoImgWidgetState();
}

class _ProductInfoImgWidgetState extends State<ProductInfoImgWidget>{

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var dePics = widget.data['imgs'];
      var detailPics;
      if(dePics is List) {
        detailPics = dePics;
      } else {
        detailPics = jsonDecode(dePics == '' || dePics == null ? '[]' : dePics) as List;
      }
      if (detailPics.isEmpty) return PWidget.boxh(0);
      return PWidget.container(
        PWidget.ccolumn([
          PWidget.row([
            PWidget.container(null, [4, 20], {'br': 4, 'gd': PFun.tbGd(Color(0xffDD4953), Color(0xffF0C3C7))}),
            PWidget.boxw(8),
            PWidget.text('商品详情', [Colors.black, 16, true]),
            PWidget.spacer(),
            PWidget.row([
              PWidget.text('展开', {'pd': PFun.lg(0, 2)}),
              PWidget.boxw(4),
              Transform.rotate(
                angle: pi * (widget.data['isExpand'] ? 1 : 2),
                child: PWidget.icon(Icons.expand_circle_down_outlined, [widget.data['expandColor']??Colors.red, 16]),
              ),
            ], {
              'fun': () => setState(() => widget.data['isExpand'] = !widget.data['isExpand'])
            }),
          ]),
          PWidget.boxh(8),
          if (widget.data['isExpand'])
            ...List.generate(detailPics.length, (i) {
              var pic = detailPics[i];
              if(pic is String) {
                // return PWidget.wrapperImage(
                //   BService.formatUrl(pic),
                //   {'ar': widget.imgRatio??0.7, 'fun': () => jumpPage(PhotoView(index: i, images: detailPics.map((m) => BService.formatUrl(m)).toList()), isMoveBtm: true)},
                // );
                return AspectRatioImage.network(pic,  builder: (context, snapshot, url){
                  return PWidget.wrapperImage(
                    BService.formatUrl(pic),
                    {'ar': snapshot.data!.width/snapshot.data!.height, 'fun': () => jumpPage(PhotoView(index: i, images: detailPics.map((m) => BService.formatUrl(m)).toList()), isMoveBtm: true)},
                  );
                });
              } else {
                // var h = double.parse(pic['height']);
                // var w = double.parse(pic['width']);
                var img = BService.formatUrl(pic['img']);
                return AspectRatioImage.network(img,  builder: (context, snapshot, url){
                  return PWidget.wrapperImage(
                    img,
                    {'ar': snapshot.data!.width/snapshot.data!.height,
                      'fun': () => jumpPage(PhotoView(index: i, images: detailPics.map((m) => BService.formatUrl('${m['img']}')).toList()), isMoveBtm: true)
                    },
                  );
                });
              }

            }),
        ]),
        [null, null, Colors.white],
        {'pd': 16},
      );
    });
  }
}
