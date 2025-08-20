/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import 'package:sufenbao/widget/aspect_ratio_image.dart';



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
      if (detailPics.isEmpty) return SizedBox.shrink();
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffDD4953), Color(0xffF0C3C7)],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '商品详情',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...List.generate(detailPics.length, (i) {
              var pic = detailPics[i];
              return AspectRatioImage.network(pic, builder: (context, snapshot, url) {
                 return AspectRatio(
                   aspectRatio: snapshot.data!.width / snapshot.data!.height,
                   child: Image.network(
                     pic,
                     fit: BoxFit.cover,
                   ),
                 );
               });
            }),
          ],
        ),
      );
    });
  }
}
