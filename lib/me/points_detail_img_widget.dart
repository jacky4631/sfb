/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/widget/aspect_ratio_image.dart';

import '../util/paixs_fun.dart';

// 积分商品详情图片小部件
class PointsDetailImgWidget extends StatefulWidget {
  final dynamic data;
  const PointsDetailImgWidget(this.data, {Key? key}) : super(key: key);
  @override
  _PointsDetailImgWidgetState createState() => _PointsDetailImgWidgetState();
}

class _PointsDetailImgWidgetState extends State<PointsDetailImgWidget> {
  ///是否展开

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var detailPics = widget.data;
      if (detailPics.isEmpty) return PWidget.boxh(0);
      return PWidget.container(
        PWidget.ccolumn([
          PWidget.row([
            PWidget.container(null, [4, 20], {'br': 4, 'gd': PFun.tbGd(Color(0xffDD4953), Color(0xffF0C3C7))}),
            PWidget.boxw(8),
            PWidget.text('商品详情', [Colors.black, 16, true]),
          ]),
          PWidget.boxh(8),
            ...List.generate(detailPics.length, (i) {
              var pic = detailPics[i];
              return AspectRatioImage.network(pic,  builder: (context, snapshot, url){
                return PWidget.wrapperImage(
                  pic,
                  {'ar': snapshot.data!.width/snapshot.data!.height},
                );
              });
            }),
        ]),
        [null, null, Colors.white],
        {'mg': PFun.lg(10, 10), 'br': 12, 'pd': 16},
      );
    });
  }
}
