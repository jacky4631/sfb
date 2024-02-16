/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';

import '../util/colors.dart';

class PayWebView extends StatefulWidget {
  final Map data;

  const PayWebView(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _PayWebViewState createState() => new _PayWebViewState();
}

class _PayWebViewState extends State<PayWebView> with WidgetsBindingObserver {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  bool loading = true;

  late PullToRefreshController pullToRefreshController;
  String url = "";
  bool isKeyboardOpen = false;
  double progress = 0;
  bool scrollBottom = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colours.app_main,
      ),
      onRefresh: () async {
        if (Global.isAndroid()) {
          webViewController?.reload();
        } else if (Global.isIOS()) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
      scroll();

    });
  }
  scroll() async {
    if(isKeyboardOpen) {
      if(scrollBottom){
        return;
      }
      scrollBottom = true;
      int x = await webViewController?.getScrollX()??0;
      int y = await webViewController?.getScrollY()??0;

        Future.delayed(Duration(milliseconds: 100), (){
          webViewController?.scrollTo(x: x, y: y+220);
        });
      // setState(() {});
    } else {
      scrollBottom = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    bool refresh = widget.data['refresh'] == null || widget.data['refresh'];
    return ScaffoldWidget(
        brightness: Brightness.dark,
        appBar: widget.data['appBar'] ??
            AppBar(
              title: Text(widget.data['title']),
              backgroundColor: widget.data['color'] != null
                  ? widget.data['color']
                  : Colours.app_main,
            ),
        body: PWidget.container(PWidget.column(
              [
                Expanded(
                  child: Stack(
                    children: [
                      createWebview(refresh),
                      progress < 1.0
                          ? LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.blue,
                              minHeight: 1,
                            )
                          : SizedBox(),
                      // loading ? Global.showLoading2() : SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            {
              'pd': [0, MediaQuery.of(context).padding.bottom, 0, 0],
            }));
  }

  Widget createWebview(refresh) {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: Uri.parse(widget.data['url'])),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
              //开启混合模式
              mixedContentMode:
                  AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          )),
      pullToRefreshController: refresh ? pullToRefreshController : null,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          this.url = url.toString();
        });
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) async {
        pullToRefreshController.endRefreshing();
        setState(() {
          this.url = url.toString();
          loading = false;
        });
      },
      onLoadError: (controller, url, code, message) {
        pullToRefreshController.endRefreshing();
        setState(() {
          loading = false;
        });
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          pullToRefreshController.endRefreshing();
          setState(() {
            this.progress = progress / 100;
          });
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        String urlStr = url.toString();
        if (urlStr.startsWith(Global.homeUrl['yeePaySuccUrl'])||urlStr.startsWith(Global.homeUrl['yeePayFailUrl'])) {
          //记录订单成功失败情况
          BService.rechargeResult(widget.data['orderId'], url.toString());
          Future.delayed(new Duration(seconds: 2), () {
            Navigator.pop(context, true);
          });
        }
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
      },
    );
  }
}
