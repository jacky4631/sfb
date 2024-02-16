import 'package:flutter/material.dart';
import '../util/utils.dart';
import '../widget/views.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class RefresherWidget extends StatefulWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final bool isShuaxin;
  final bool isGengduo;
  final int flag;
  final Future<int> Function()? onLoading;
  final Future<int> Function()? onRefresh;

  const RefresherWidget({
    Key? key,
    this.header,
    this.footer,
    this.isShuaxin = true,
    this.isGengduo = false,
    this.onLoading,
    this.onRefresh,
    required this.child,
    this.flag = 0,
  }) : super(key: key);

  @override
  _RefresherWidgetState createState() => _RefresherWidgetState();
}

class _RefresherWidgetState extends State<RefresherWidget> {
  var reCon = RefreshController();
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: handleGlowNotification,
      child: SmartRefresher(
        controller: reCon,
        enablePullDown: widget.isShuaxin,
        // physics: MyBouncingScrollPhysics(),
        enablePullUp: widget.isGengduo,
        onRefresh: () async {
          var flag = await widget.onRefresh!();
          if (flag == -1 || flag == 1) {
            reCon.refreshFailed();
          } else {
            reCon.refreshCompleted();
          }
        },
        onLoading: () async {
          var flag = await widget.onLoading!();
          if (flag == -1 || flag == 1) {
            reCon.loadFailed();
          } else {
            reCon.loadComplete();
          }
        },
        header: widget.header ?? buildClassicHeader(),
        footer: widget.footer ?? buildCustomFooter(),
        child: widget.child,
      ),
    );
  }
}
