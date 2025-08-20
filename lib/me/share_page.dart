/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:sufenbao/util/repaintBoundary_util.dart';
import 'package:sufenbao/widget/loading.dart';

import '../dialog/invite_rule_dialog.dart';
import '../service.dart';
import '../share/ShareDialog.dart';
import '../util/global.dart';
import '../util/toast_utils.dart';

class SharePage extends StatefulWidget {
  SharePage(Map arg);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  List<String> images = [];
  String qrImage = 'assets/images/logo.png';
  List<String> childImages = [];
  int currentIndex = 0;
  int realPosition = 0;
  late PageController _pageController;
  String sharetext = "";
  List<GlobalKey> keyList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    await initSharetext();
    await initPoster();
    initWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('分享App', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              child: Text('邀请规则', style: TextStyle(color: Colors.black)),
              onPressed: () {
                showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: '',
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder:
                        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return Scaffold(backgroundColor: Colors.transparent, body: InviteRuleDialog({}, () {}));
                    });
              },
            )
          ],
        ),
        body: createContent());
  }

  createContent() {
    return Stack(alignment: Alignment.center, children: [
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8E7CB),
        ], begin: FractionalOffset(2, 0), end: FractionalOffset(1, 1))),
      ),
      loading
          ? Global.showLoading2()
          : Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                    width: 972.w,
                    height: 600.h,
                    child: PageView.builder(
                        onPageChanged: _onPageChanged,
                        controller: _pageController,
                        itemCount: childImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                              width: 972.w,
                              height: 600.h,
                              padding: EdgeInsets.all(4),
                              child: Material(
                                color: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                // elevation: 5.0,
                                borderRadius: BorderRadius.circular(12.0.r),
                                child: RepaintBoundary(
                                    key: keyList[index],
                                    child: Stack(
                                      // fit: StackFit.expand,
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Image.network(
                                          childImages[index],
                                          width: 972.w,
                                          height: 600.h,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 972.w,
                                              height: 600.h,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.error),
                                            );
                                          },
                                        ),
                                        Positioned(
                                            top: 450.h,
                                            child: QrImageView(
                                              data: Global.appInfo.share,
                                              version: QrVersions.auto,
                                              size: 105,
                                              gapless: true,
                                              // embeddedImage: AssetImage(qrImage),
                                            )),
                                        Positioned(
                                            top: 573.h,
                                            child: Container(
                                              child: Text(
                                                Global.userinfo!.code,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            )),
                                      ],
                                    )),
                              ));
                        })),
              ],
            ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: EdgeInsets.fromLTRB(30, 35, 30, 30),
            child: Row(
              children: [
                TextButton.icon(
                    style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.black12)),
                    icon: Icon(Icons.share, color: Colors.grey, size: 15),
                    onPressed: () {
                      copyLink();
                    },
                    label: Text("复制链接", style: TextStyle(color: Colors.grey, fontSize: 14))),
                Expanded(child: Text("")),
                TextButton.icon(
                    style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.black12)),
                    icon: Icon(Icons.file_download, color: Colors.grey, size: 15),
                    onPressed: () {
                      savePhoto();
                    },
                    label: Text("保存图片", style: TextStyle(color: Colors.grey, fontSize: 14))),
                Expanded(child: Text("")),
                TextButton.icon(
                    style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.black12)),
                    icon: Icon(Icons.ios_share_outlined, color: Colors.grey, size: 15),
                    onPressed: () {
                      shareImage();
                    },
                    label: Text("分享海报", style: TextStyle(color: Colors.grey, fontSize: 14))),
              ],
            )),
      )
    ]);
  }

  initWidget() {
    if (images.isEmpty) {
      return;
    }
    if (images.length == 1) {
      childImages.addAll(images);
    } else {
      childImages.add(images[images.length - 1]);
      childImages.addAll(images);
      childImages.add(images[0]);
    }
    for (int i = 0; i < childImages.length; i++) {
      keyList.add(new GlobalKey());
    }
    _pageController = PageController(viewportFraction: 0.9);
    loading = false;
    setState(() {});
  }

  _onPageChanged(index) async {
    if (index == 0) {
      // 当前选中的是第一个位置，自动选中倒数第二个位置
      currentIndex = childImages.length - 2;
      await Future.delayed(Duration(milliseconds: 400));
      _pageController.jumpToPage(currentIndex);
      realPosition = currentIndex - 1;
    } else if (index == childImages.length - 1) {
      // 当前选中的是倒数第一个位置，自动选中第二个索引
      currentIndex = 1;
      await Future.delayed(Duration(milliseconds: 400));
      _pageController.jumpToPage(currentIndex);
      realPosition = 0;
    } else {
      currentIndex = index;
      realPosition = index - 1;
      if (realPosition < 0) realPosition = 0;
    }
    setState(() {});
  }

  void copyLink() {
    if (!Global.login) {
      return;
    }
    FlutterClipboard.copy(sharetext).then((value) => ToastUtils.showToastBOTTOM('复制链接成功'));
  }

  Future<void> shareImage() async {
    if (!Global.login) {
      return;
    }
    Loading.show(context);
    boundaryKey = keyList[currentIndex];
    String filePath = await RepaintBoundaryUtils().captureImage();
    Loading.hide(context);
    if (filePath.isNotEmpty) {
      ShareDialog.showShareDialog(context, filePath);
    }
  }

  void savePhoto() async {
    if (!Global.login) {
      return;
    }
    Loading.show(context);
    boundaryKey = keyList[currentIndex];
    await RepaintBoundaryUtils().savePhoto();
    Loading.hide(context);
  }

  initSharetext() {
    if (!Global.login) {
      return;
    }
    String shareContent = Global.appInfo.shareContent;
    shareContent = shareContent.replaceFirst("#url#", Global.appInfo.share).replaceFirst('#APPNAME#', APP_NAME);
    if (Global.userinfo != null) {
      shareContent = shareContent.replaceFirst("#code#", '邀请口令：${Global.userinfo!.code}\n━┉┉┉┉∞┉┉┉┉━\n');
    } else {
      shareContent = shareContent.replaceFirst("#code#", '');
    }
    sharetext = shareContent;
  }

  @override
  void dispose() {
    // PageController is always initialized, so no null check needed
    _pageController.dispose();
    super.dispose();
  }

  Future initPoster() async {
    List res = await BService.userShareImages();
    if (res.isNotEmpty) {
      res.forEach((element) {
        images.add(element);
      });
    }
  }
}
