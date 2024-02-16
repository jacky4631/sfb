import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/utils.dart';
import '../widget/views.dart';

class ScaffoldWidget extends StatefulWidget {
  final Widget? appBar;
  final String? title;
  final Widget body;
  final Widget? btnBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Brightness? brightness;
  final Color? bgColor;
  final bool resizeToAvoidBottomInset;
  final Key? scaffoldKey;
  final FloatingActionButton? floatingActionButton;

  const ScaffoldWidget({
    Key? key,
    this.appBar,
    required this.body,
    this.btnBar,
    this.brightness,
    this.title,
    this.bgColor,
    this.resizeToAvoidBottomInset = true,
    this.drawer,
    this.bottomSheet,
    this.endDrawer,
    this.scaffoldKey,
    this.floatingActionButton
  }) : super(key: key);
  @override
  _ScaffoldWidgetState createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: widget.brightness ?? Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.values[(widget.brightness ?? Theme.of(context).brightness).index == 1 ? 0 : 1],
        // systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: handleGlowNotification,
        child: Scaffold(
          floatingActionButton: widget.floatingActionButton,
          // resizeToAvoidBottomInset: true,
          key: widget.scaffoldKey,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          backgroundColor: widget.bgColor ?? Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: <Widget>[
              if (widget.appBar == null) widget.title != null ? buildTitle(context, title: widget.title!,
                  isNoShowLeft: true) : SizedBox() else widget.appBar!,
              Expanded(child: widget.body ?? SizedBox()),
            ],
          ),
          drawer: widget.drawer,
          endDrawer: widget.endDrawer,
          bottomSheet: widget.bottomSheet,
          bottomNavigationBar: widget.btnBar,
        ),
      ),
    );
  }
}
