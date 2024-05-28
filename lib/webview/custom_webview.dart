/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:sufenbao/util/global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/colors.dart';
import '../util/launchApp.dart';

class CustomWebView extends StatefulWidget {
  final Map data;

  const CustomWebView(this.data, {Key? key,}) : super(key: key);

  @override
  _CustomWebViewState createState() => new _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  bool loading = true;

  late PullToRefreshController pullToRefreshController;
  String url = "";
  static const SCRIPT = "javascript:(function(){" +
      "var topNavBacks=document.getElementsByClassName('nav-back');" +
      "for(let i=0; i<topNavBacks.length; i++){" +
      "topNavBacks[i].style.display='none';" +
      "}" +
      "var footerShare=document.getElementsByClassName('footer-share');" +
      "for(let i=0; i<footerShare.length; i++){" +
      "footerShare[i].style.display='none';" +
      "}" +
      "var freeShare=document.getElementsByClassName('free-share');" +
      "for(let i=0; i<freeShare.length; i++){" +
      "freeShare[i].style.display='none';" +
      "}" +
      "})();";


  double progress = 0;
  final urlController = TextEditingController();
  @override
  void initState() {
    super.initState();

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool refresh = widget.data['refresh'] == null || widget.data['refresh'];
    bool check = widget.data['check']!=null && widget.data['check'];
    return ScaffoldWidget(
        appBar: widget.data['appBar']??AppBar(title: Text(widget.data['title']),backgroundColor: widget.data['color'] !=null ? widget.data['color']: Colours.app_main,),
        body: PWidget.container(PWidget.column([
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                      URLRequest(url: WebUri(widget.data['url'])),
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
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                        Uri uri = navigationAction.request.url!;
                        String mainUrl = widget.data['url'];
                        //如果是隐私政策的相关链接时，再次打开webview
                        if(mainUrl.contains(Global.privacyProtocolUrl) && mainUrl != uri.toString()) {
                            Global.showProtocolPage(uri.toString(), '隐私政策');
                            return NavigationActionPolicy.CANCEL;
                        }
                    if(check) {
                      String parsedUrl = LaunchApp.parseUrl(uri.toString())??'';
                      if (parsedUrl != null && parsedUrl != '') {
                        LaunchApp.launchFromWebView(parsedUrl);
                        return NavigationActionPolicy.CANCEL;
                      }
                    } else {
                      String url = uri.toString();
                      //在不检查url的情况下，阻止抖音商品连接加载，只显示抖音下载页面
                      if(url.startsWith('snssdk1128://ec_goods_detail') || url.startsWith('pinduoduo') || url.startsWith('weixin://')) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      if(url.startsWith('https://itunes.apple.com')) {
                        launchUrl(uri);
                      }
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    await webViewController?.evaluateJavascript(source: SCRIPT);
                    setState((){

                      this.url = url.toString();
                      urlController.text = this.url;
                      loading = false;
                    });

                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    setState((){
                      loading = false;
                    });

                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });

                    }
                    // setState(() {
                    //   this.progress = progress / 100;
                    //   urlController.text = this.url;
                    // });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress,backgroundColor: Colors.blue,minHeight: 1,)
                    : SizedBox(),
                // loading ? Global.showLoading2() : SizedBox()
              ],
            ),
          ),
        ],),{'pd': [0,MediaQuery.of(context).padding.bottom,0,0], }));
  }
}
