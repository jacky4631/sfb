/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
      settings: PullToRefreshSettings(
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
    return Scaffold(
        appBar: widget.data['appBar'] ??
            AppBar(
              title: Text(widget.data['title']),
              backgroundColor: widget.data['color'] != null
                  ? widget.data['color']
                  : Colours.app_main,
            ),
        body: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
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
        ));
  }

  Widget createWebview(refresh) {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri((widget.data['url']))),
      initialSettings: InAppWebViewSettings(
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true

      ),
      pullToRefreshController: refresh ? pullToRefreshController : null,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          this.url = url.toString();
        });
      },
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT);
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
      onReceivedError: (controller, request, error) {
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
        if (urlStr.startsWith(Global.appInfo.yeePaySuccUrl??'')||urlStr.startsWith(Global.appInfo.yeePayFailUrl??'')) {
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
