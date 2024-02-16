import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maixs_utils/widget/mytext.dart';
import 'package:maixs_utils/widget/route.dart';
import '../util/utils.dart';
import '../widget/photo_widget.dart';
import '../widget/views.dart';

import 'image.dart';

class WrapImgWidget extends StatefulWidget {
  final List<String> imgs;
  final double spacing;
  final double remove;
  final EdgeInsets margin;
  final double? radius;
  final double? height;
  final int count;
  final int w;
  final bool isUpload;
  final String? uploadTips;
  final Widget? uploadView;
  final Color? bgColor;
  final int maxCount;
  final void Function(List<String>)? callback;

  const WrapImgWidget({
    Key? key,
    required this.imgs,
    this.spacing = 8,
    this.count = 3,
    required this.remove,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.w = 300,
    this.isUpload = false,
    this.uploadTips,
    this.uploadView,
    this.maxCount = 1,
    this.callback,
    this.radius,
    this.height,
    this.bgColor,
  }) : super(key: key);

  @override
  _WrapImgWidgetState createState() => _WrapImgWidgetState();
}

class _WrapImgWidgetState extends State<WrapImgWidget> {
  var imgs = <String>[];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    imgs = widget.imgs.sublist(0);
  }

  @override
  Widget build(BuildContext context) {
    var random = Random().nextInt(9999);
    var wh = size(context).width / widget.count - (widget.remove + (widget.spacing * (widget.count - 1))) / widget.count;
    if ((widget.imgs == null || widget.imgs.isEmpty) && !widget.isUpload) {
      return SizedBox();
    } else {
      return Container(
        margin: widget.margin,
        child: Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          children: List.generate(widget.imgs.length + (widget.imgs.length == widget.maxCount ? 0 : (widget.isUpload ? 1 : 0)), (i) {
            if (i == widget.imgs.length) {
              return GestureDetector(
                onTap: () async {
                  if (imgs.length < widget.maxCount) {
                    // Navigator.pop(context);
                    // await Future.delayed(Duration(milliseconds: 500));
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
                    if (1 != 1)
                      showSheet(builder: (v) {
                        return Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                          ),
                        );
                      });
                  } else {
                    showToast('最多只能上传${widget.maxCount}张');
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius ?? 8),
                  child: Container(
                    height: widget.height ?? wh,
                    width: wh,
                    color: widget.bgColor ?? Colors.black.withOpacity(0.05),
                    alignment: Alignment.center,
                    child: widget.uploadView ??
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded, color: Colors.black45),
                            MyText(
                              widget.uploadTips ?? '照片/视频',
                              color: Colors.black45,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  jumpPage(
                    PhotoView(images: imgs, index: i, flag: widget.isUpload ? 1.0 : 0.0),
                    isMoveBtm: true,
                    callback: !widget.isUpload
                        ? (v) {}
                        : (v) {
                            setState(() {});
                            widget.callback!(imgs);
                          },
                  );
                },
                child: Hero(
                  tag: '${widget.imgs[i]}$random',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius ?? 8),
                    child: WrapperImage(
                      url: widget.imgs[i],
                      width: wh,
                      height: widget.height ?? wh,
                      w: widget.w,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      );
    }
  }
}
