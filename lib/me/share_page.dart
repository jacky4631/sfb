/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sufenbao/util/repaintBoundary_util.dart';
import 'package:sufenbao/widget/loading.dart';

import '../dialog/invite_rule_dialog.dart';
import '../service.dart';
import '../share/ShareDialog.dart';
import '../util/global.dart';
import '../util/toast_utils.dart';
import '../util/paixs_fun.dart';

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
  Future initData() async{
    await initSharetext();
    await initPoster();
    initWidget();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        brightness: Brightness.dark,
        bgColor: Colors.white,
        appBar: buildTitle(context,
            title: '分享App',
            widgetColor: Colors.black,
            color: Colors.white,
            leftIcon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            rightWidget: PWidget.textNormal('邀请规则', {'pd':[0,0,0,8]}), rightCallback: (){
              showGeneralDialog(
                  context: context,
                  barrierDismissible:false,
                  barrierLabel: '',
                  transitionDuration: Duration(milliseconds: 200),
                  pageBuilder: (BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
                    return Scaffold(backgroundColor: Colors.transparent, body:InviteRuleDialog(
                        {}, (){

                    }));
                  });
            }),
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
      loading ? Global.showLoading2() : PWidget.column([
        PWidget.boxh(20.h),
        PWidget.container(
            PageView.builder(
                onPageChanged: _onPageChanged,
                controller: _pageController,
                itemCount: childImages.length,
                itemBuilder: (context, index) {
                  return PWidget.container(
                      Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAlias ,
                        // elevation: 5.0,
                        borderRadius: BorderRadius.circular(12.0.r),
                        child: RepaintBoundary(
                            key: keyList[index],
                            child: Stack(
                              // fit: StackFit.expand,
                              alignment: Alignment.bottomCenter,
                              children: [
                                PWidget.wrapperImage(childImages[index],
                                    [972.w, 600.h]),
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
                                    child: PWidget.container(
                                      PWidget.textNormal(Global.userinfo!.code,
                                          [Colors.black, 12]),
                                    )),
                              ],
                            )),
                      ),
                      {
                        'pd': PFun.lg(0, 0, 4, 4),
                      }, [972.w, 600.h]);
                }),
            [972.w, 600.h]),
      ]),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: PWidget.container(
            PWidget.row([
              TextButton.icon(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black12)),
                  icon: PWidget.icon(Icons.share, [Colors.grey, 15]),
                  onPressed: () {
                    copyLink();
                  },
                  label: Text("复制链接",
                      style: TextStyle(color: Colors.grey, fontSize: 14))),
              Expanded(child: Text("")),
              TextButton.icon(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black12)),
                  icon: PWidget.icon(Icons.file_download, [Colors.grey, 15]),
                  onPressed: () {
                    savePhoto();
                  },
                  label: Text("保存图片",
                      style: TextStyle(color: Colors.grey, fontSize: 14))),
              Expanded(child: Text("")),
              TextButton.icon(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black12)),
                  icon:
                      PWidget.icon(Icons.ios_share_outlined, [Colors.grey, 15]),
                  onPressed: () {
                    shareImage();
                  },
                  label: Text("分享海报",
                      style: TextStyle(color: Colors.grey, fontSize: 14))),
            ]),
            [
              null,
              40,
              Colors.white
            ], //宽度，高度，背景色
            {
              'br': PFun.lg(6, 6, 6, 6), //圆角
              'mg': PFun.lg(0, 35, 30, 30) //margin
            }),
      )
    ]);
  }

  initWidget() {
    if (images == null || images.isEmpty) {
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
    setState(() {

    });
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
    FlutterClipboard.copy(sharetext)
        .then((value) => ToastUtils.showToastBOTTOM('复制链接成功'));
  }

  Future<void> shareImage() async {
    if (!Global.login) {
      return;
    }
    Loading.show(context);
    boundaryKey = keyList[currentIndex];
    String filePath = await RepaintBoundaryUtils().captureImage();
    Loading.hide(context);
    if (filePath != null) {
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
    shareContent = shareContent
        .replaceFirst("#url#", Global.appInfo.share)
        .replaceFirst('#APPNAME#', APP_NAME);
    if (Global.userinfo != null) {
      shareContent = shareContent.replaceFirst(
          "#code#", '邀请口令：${Global.userinfo!.code}\n━┉┉┉┉∞┉┉┉┉━\n');
    } else {
      shareContent = shareContent.replaceFirst("#code#", '');
    }
    sharetext = shareContent;
  }

  @override
  void dispose() {
    if(_pageController != null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  Future initPoster() async {
    List res = await BService.userShareImages();
    if (res != null) {
      res.forEach((element) {
        images.add(element);
      });
    }
  }
}
