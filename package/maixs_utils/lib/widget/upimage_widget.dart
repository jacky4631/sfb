import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../util/utils.dart';
import '../widget/photo_widget.dart';
import '../widget/views.dart';
import 'package:image_picker/image_picker.dart';
import 'image.dart';
import 'item_tap_widget.dart';
import 'mytext.dart';

class UpImageWidget extends StatefulWidget {
  const UpImageWidget({
    Key? key,
    this.callback,
    this.maxCount = 6,
    this.imgs = const [],
    this.title = "上传图片",
    this.isshowcount = true,
    this.isshowleftpad = true,
    this.isShowText = true,
  }) : super(key: key);

  final void Function(List<String>)? callback;
  final int maxCount;
  final List<String> imgs;
  final String title;
  final bool isshowcount;
  final bool isshowleftpad;
  final bool isShowText;

  @override
  _UpImageWidgetState createState() => _UpImageWidgetState();
}

class _UpImageWidgetState extends State<UpImageWidget> {
  ///图片id集
  var imgs = <String>[];

  @override
  void initState() {
    imgs.addAll(widget.imgs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      color: Colors.white.withOpacity(1),
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          if (widget.isshowleftpad) SizedBox(width: 16),
          MyText(widget.isshowcount ? '${widget.title}(${imgs.length}/${widget.maxCount})' : '${widget.title}'),
          SizedBox(width: 16),
          // if (widget.maxCount != imgs.length)
          InkWell(
            onTap: () {
              if (imgs.length < widget.maxCount) {
                showSheet(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(Platform.isMacOS ? 24 : 16),
                        ),

                        child: Text('拍照', style: TextStyle(fontSize: 16)),
                        onPressed: () async {
                          Navigator.pop(context);
                          var pickImage2 = ImagePicker().getImage(
                            source: ImageSource.camera,
                          );
                          var pickImage = pickImage2;
                          var file = await pickImage;
                          if (file == null) {
                          } else {
                            buildShowDialog(context, isClose: false);
                            var data = await uploadImage(file.path);
                            Navigator.pop(context);
                            setState(() => imgs.insert(0, data));
                            widget.callback!(imgs);
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    Container(
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(Platform.isMacOS ? 24 : 16),
                        ),
                        child: Text('从相册选择', style: TextStyle(fontSize: 16)),
                        onPressed: () async {
                          Navigator.pop(context);
                          await pickImages(
                            maxImages: 1,
                            isCrop: true,
                            cropFun: (v) async {
                              if (v != null) {
                                buildShowDialog(context, isClose: false);
                                try {
                                  var data = await uploadImage(await v.path);
                                  setState(() => imgs.insert(0, data));
                                } catch (e) {} finally {
                                  widget.callback!(imgs);
                                  Navigator.pop(context);
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 8,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    Container(
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(Platform.isMacOS ? 24 : 16),
                        ),
                        child: Text('取消', style: TextStyle(fontSize: 16)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                );
              } else {
                showToast('最多只能上传${widget.maxCount}张');
              }
            },
            child: Container(
              width: 56,
              height: 56,
              //padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.photo_camera,
                    color: Colors.white24,
                  ),
                  if (widget.isShowText) MyText('添加照片', size: 10, color: Colors.white24)
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(imgs.length, (i) {
                  return ItemTapWidget(
                    padding: 0,
                    onTap: () {
                      push(
                        context,
                        PhotoView(images: imgs, index: i, flag: 1.0),
                        isMove: false,
                      ).then((v) {
                        setState(() {});
                        widget.callback!(imgs);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 16),
                      child: Hero(
                        tag: imgs[i],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: WrapperImage(
                            url: imgs[i],
                            w: 100,
                            width: 56,
                            height: 56,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
