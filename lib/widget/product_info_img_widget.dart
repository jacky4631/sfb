/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'aspect_ratio_image.dart';
import '../service.dart';

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

// 产品详情图片小部件
class ProductInfoImgWidget extends StatefulWidget {
  final dynamic data;
  final double? imgRatio;
  const ProductInfoImgWidget(this.data, {Key? key, this.imgRatio}) : super(key: key);
  @override
  _ProductInfoImgWidgetState createState() => _ProductInfoImgWidgetState();
}

class _ProductInfoImgWidgetState extends State<ProductInfoImgWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var dePics = widget.data['imgs'];
      var detailPics;
      if (dePics is List) {
        detailPics = dePics;
      } else {
        detailPics = jsonDecode(dePics == '' || dePics == null ? '[]' : dePics) as List;
      }
      if (detailPics.isEmpty) return SizedBox(height: 0);
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Spacer(),
                GestureDetector(
                  onTap: () => setState(() => widget.data['isExpand'] = !widget.data['isExpand']),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Text('展开'),
                      ),
                      SizedBox(width: 4),
                      Transform.rotate(
                        angle: pi * (widget.data['isExpand'] ? 1 : 2),
                        child: Icon(
                          Icons.expand_circle_down_outlined,
                          color: widget.data['expandColor'] ?? Colors.red,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (widget.data['isExpand'])
              ...List.generate(detailPics.length, (i) {
                var pic = detailPics[i];
                if (pic is String) {
                  return AspectRatioImage.network(pic, builder: (context, snapshot, url) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomPhotoView(
                              images: detailPics.map<String>((m) => BService.formatUrl(m)).toList(),
                              index: i,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: snapshot.data!.width / snapshot.data!.height,
                          child: ClipRRect(
                            child: Image.network(
                              BService.formatUrl(pic),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                } else {
                  var img = BService.formatUrl(pic['img']);
                  return AspectRatioImage.network(img, builder: (context, snapshot, url) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomPhotoView(
                              images: detailPics.map<String>((m) => BService.formatUrl('${m['img']}')).toList(),
                              index: i,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: snapshot.data!.width / snapshot.data!.height,
                          child: ClipRRect(
                            child: Image.network(
                              img,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                }
              }),
          ],
        ),
      );
    });
  }
}
