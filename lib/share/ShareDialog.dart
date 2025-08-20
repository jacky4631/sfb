/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sufenbao/util/tao_util.dart';
import 'package:sufenbao/util/toast_utils.dart';

import '../util/global.dart';
import '../me/styles.dart';

class ShareDialog {
  static String text = '';
  final List buttonTitles = ["微信好友", "朋友圈", "新浪微博", '复制链接'];
  final List buttonImages = ["share/wx.png", "share/timeline.png", "share/weibo.webp", "share/link.png"];

  final List sharebuttonTitles = ["微信好友", "朋友圈", "新浪微博", 'QQ好友'];
  final List sharebuttonImages = ["share/wx.png", "share/timeline.png", "share/weibo.webp", "share/qq.webp"];
  static showShareDialog(BuildContext context, String path) {
    text = getShareContent();
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white.withAlpha(0),
        elevation: 2,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              height: 172,
              color: Colors.white,
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 14, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("分享到", style: TextStyles.shareTitle),
                          GestureDetector(
                            onTap: () {
                              ShareDialog()._dismiss(context);
                            },
                            child: Image.asset(
                              "assets/images/share/close.webp",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(ShareDialog().sharebuttonTitles.length, (index) {
                        return Container(
                          child: ShareDialog()._buttonWidget(context, path, ShareDialog().sharebuttonTitles[index],
                              ShareDialog().sharebuttonImages[index], index),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static show(BuildContext context, {shareText}) {
    if (Global.isEmpty(shareText)) {
      String shareContent = Global.appInfo.shareContent;
      shareContent = shareContent.replaceFirst("#url#", Global.appInfo.share).replaceFirst('#APPNAME#', APP_NAME);
      if (Global.userinfo != null) {
        shareContent = shareContent.replaceFirst("#code#", '邀请口令：${Global.userinfo!.code}\n━┉┉┉┉∞┉┉┉┉━\n');
      } else {
        shareContent = shareContent.replaceFirst("#code#", '');
      }
      text = shareContent;
    } else {
      text = shareText;
    }
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white.withAlpha(0),
        elevation: 2,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              height: 172,
              color: Colors.white,
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 14, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("分享到", style: TextStyles.shareTitle),
                          GestureDetector(
                            onTap: () {
                              ShareDialog()._dismiss(context);
                            },
                            child: Image.asset(
                              "assets/images/share/close.webp",
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(ShareDialog().buttonTitles.length, (index) {
                        return Container(
                          child: ShareDialog()._buttonWidget(
                              context, "", ShareDialog().buttonTitles[index], ShareDialog().buttonImages[index], index),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _buttonWidget(BuildContext context, String filePath, String title, String imageName, int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0: //微信好友

            fluwx.share(WeChatShareFileModel(WeChatFile.file(File(filePath)), scene: WeChatScene.session));
            _dismiss(context);
            break;
          case 1: //朋友圈
            fluwx.share(WeChatShareFileModel(WeChatFile.file(File(filePath)), scene: WeChatScene.timeline));
            _dismiss(context);
            break;
          case 2: //新浪微博
            FlutterClipboard.copy(text).then((value) => ToastUtils.showToast('复制成功，打开微博APP分享'));
            _dismiss(context);
            break;
          case 3: //复制链接
            FlutterClipboard.copy(text).then((value) {
              if (title == '复制链接') {
                ToastUtils.showToast('复制成功');
              } else {
                ToastUtils.showToast('复制成功，打开QQ分享');
              }
            });
            _dismiss(context);
            break;
          default:
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/$imageName",
            width: 48,
            height: 48,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(title, style: TextStyles.shareContent),
          )
        ],
      ),
    );
  }

  _dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
