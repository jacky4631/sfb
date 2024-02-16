/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AlipayWebView extends StatefulWidget {
  final Map data;

  const AlipayWebView(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _AlipayWebViewState createState() => new _AlipayWebViewState();
}

class _AlipayWebViewState extends State<AlipayWebView> {
  final GlobalKey webViewKey = GlobalKey();

  late WebViewController controller;
  bool loading = true;

  String url = "";
  double progress = 0;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith("alipays") ||
                request.url.startsWith("alipay://")) {
              launchUrl(Uri.parse(request.url));
              Future.delayed(Duration(seconds: 1)).then((value) => Navigator.pop(context));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.data['url']));
  }

  @override
  Widget build(BuildContext context) {
    bool refresh = widget.data['refresh'] == null || widget.data['refresh'];
    return ScaffoldWidget(
            brightness: Brightness.dark,
            body: PWidget.container(
                PWidget.column(
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
                  'pd': [MediaQuery.of(context).padding.top, MediaQuery.of(context).padding.bottom, 0, 0],
                }));
  }

  Widget createWebview(refresh) {
    return WebViewWidget(controller: controller);
  }
}
