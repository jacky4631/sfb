import 'dart:math';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pr;

enum IconPosition { left, right, top, bottom }

typedef Widget OuterBuilder(Widget child);

class MyClassicHeader extends pr.RefreshIndicator {
  final OuterBuilder? outerBuilder;
  final String? releaseText, idleText, refreshingText, completeText, failedText, canTwoLevelText;
  final Widget? releaseIcon, idleIcon, refreshingIcon, completeIcon, failedIcon, canTwoLevelIcon, twoLevelView;
  final double spacing;
  final IconPosition iconPos;
  final TextStyle textStyle;
  const MyClassicHeader({
    Key? key,

    pr.RefreshStyle refreshStyle= pr.RefreshStyle.Follow,
    double height= 60.0,
    Duration completeDuration= const Duration(milliseconds: 600),
    this.outerBuilder,
    this.textStyle= const TextStyle(color: Colors.grey),
    this.releaseText,
    this.refreshingText,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.canTwoLevelText,
    this.completeText,
    this.failedText,
    this.idleText,
    this.iconPos= IconPosition.left,
    this.spacing= 0.0,
    this.refreshingIcon,
    this.failedIcon= const Icon(Icons.error, color: Colors.grey),
    this.completeIcon= const Icon(Icons.done, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.refresh, color: Colors.grey),
  }) : super(key: key, refreshStyle: refreshStyle, completeDuration: completeDuration, height: height);

  @override
  State createState() {
    return _MyClassicHeaderState();
  }
}

class _MyClassicHeaderState extends pr.RefreshIndicatorState<MyClassicHeader> {
  var dataModel = DataModel(flag: 3);
  Widget _buildText(mode) {
    pr.RefreshString strings = pr.RefreshLocalizations.of(context)?.currentLocalization ?? pr.EnRefreshString();
    dataModel.flag = getTime();
    return AnimatedSwitchBuilder(
      value: dataModel,
      errorOnTap: () async {return 0;},
      animationTime: 100,
      defaultBuilder: () {
        return Text(
          (mode == pr.RefreshStatus.canRefresh
              ? widget.releaseText ?? strings.canRefreshText
              : mode == pr.RefreshStatus.completed
                  ? widget.completeText ?? strings.refreshCompleteText
                  : mode == pr.RefreshStatus.failed
                      ? widget.failedText ?? strings.refreshFailedText
                      : mode == pr.RefreshStatus.refreshing
                          ? widget.refreshingText ?? ''
                          : mode == pr.RefreshStatus.idle
                              ? widget.idleText ?? strings.idleRefreshText
                              : mode == pr.RefreshStatus.canTwoLevel
                                  ? widget.canTwoLevelText ?? strings.canTwoLevelText
                                  : "")!,
          style: widget.textStyle,
          key: ValueKey(Random().nextInt(99)),
        );
      },
    );
  }

  Widget _buildIcon(mode) {
    Widget? icon = mode == pr.RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == pr.RefreshStatus.idle
            ? widget.idleIcon
            : mode == pr.RefreshStatus.completed
                ? widget.completeIcon
                : mode == pr.RefreshStatus.failed
                    ? widget.failedIcon
                    : mode == pr.RefreshStatus.canTwoLevel
                        ? widget.canTwoLevelIcon
                        : mode == pr.RefreshStatus.canTwoLevel
                            ? widget.canTwoLevelIcon
                            : mode == pr.RefreshStatus.refreshing
                                ? widget.refreshingIcon ??
                                    SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: defaultTargetPlatform == TargetPlatform.iOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator(strokeWidth: 2.0),
                                    )
                                : widget.twoLevelView;
    return icon ?? Container();
  }

  @override
  Widget buildContent(BuildContext context, pr.RefreshStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[
      iconWidget,
      textWidget,
    ];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left ? TextDirection.ltr : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom || widget.iconPos == IconPosition.top ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom ? VerticalDirection.up : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    Widget? icon = mode == pr.RefreshStatus.canRefresh
        ? Text(
            widget.releaseText!,
            style: widget.textStyle,
            key: ValueKey(Random().nextInt(99)),
          )
        : mode == pr.RefreshStatus.idle
            ? Text(
                widget.idleText!,
                style: widget.textStyle,
                key: ValueKey(Random().nextInt(99)),
              )
            : mode == pr.RefreshStatus.completed
                ? Text(
                    widget.completeText!,
                    style: widget.textStyle,
                    key: ValueKey(Random().nextInt(99)),
                  )
                : mode == pr.RefreshStatus.failed
                    ? Text(
                        widget.failedText!,
                        style: widget.textStyle,
                        key: ValueKey(Random().nextInt(99)),
                      )
                    : mode == pr.RefreshStatus.refreshing
                        ? widget.refreshingIcon ??
                            SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: defaultTargetPlatform == TargetPlatform.iOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator(strokeWidth: 2.0),
                            )
                        : widget.twoLevelView;
    return widget.outerBuilder != null
        ? widget.outerBuilder!(container)
        : Container(
            height: 56,
            child: AnimatedSwitchBuilder(
              value: dataModel,
              alignment: Alignment.center,
              defaultBuilder: () => icon!,
              errorOnTap: () async { return 0;},
            ),
          );
  }
}

class ClassicFooter extends pr.LoadIndicator {
  final String? idleText, loadingText, noDataText, failedText, canLoadingText;

  final OuterBuilder? outerBuilder;

  final Widget? idleIcon, loadingIcon, noMoreIcon, failedIcon, canLoadingIcon;

  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  final Duration completeDuration;

  const ClassicFooter({
    Key? key,
    VoidCallback? onClick,
    pr.LoadStyle loadStyle= pr.LoadStyle.ShowAlways,
    double height= 60.0,
    this.outerBuilder,
    this.textStyle= const TextStyle(color: Colors.grey),
    this.loadingText,
    this.noDataText,
    this.noMoreIcon,
    this.idleText,
    this.failedText,
    this.canLoadingText,
    this.failedIcon= const Icon(Icons.error, color: Colors.grey),
    this.iconPos= IconPosition.left,
    this.spacing= 15.0,
    this.completeDuration= const Duration(milliseconds: 300),
    this.loadingIcon,
    this.canLoadingIcon= const Icon(Icons.autorenew, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_upward, color: Colors.grey),
  }) : super(
          key: key,
          loadStyle: loadStyle,
          height: height,
          onClick: onClick,
        );

  @override
  State<StatefulWidget> createState() {
    return _ClassicFooterState();
  }
}

class _ClassicFooterState extends pr.LoadIndicatorState<ClassicFooter> {
  Widget _buildText(pr.LoadStatus mode) {
    pr.RefreshString strings = pr.RefreshLocalizations.of(context)?.currentLocalization ?? pr.EnRefreshString();
    return Text(
      (mode == pr.LoadStatus.loading
          ? widget.loadingText ?? strings.loadingText
          : pr.LoadStatus.noMore == mode
              ? widget.noDataText ?? strings.noMoreText
              : pr.LoadStatus.failed == mode
                  ? widget.failedText ?? strings.loadFailedText
                  : pr.LoadStatus.canLoading == mode
                      ? widget.canLoadingText ?? strings.canLoadingText
                      : widget.idleText ?? strings.idleLoadingText)!,
      style: widget.textStyle,
    );
  }

  Widget _buildIcon(pr.LoadStatus mode) {
    Widget? icon = mode == pr.LoadStatus.loading
        ? widget.loadingIcon ??
            SizedBox(
              width: 25.0,
              height: 25.0,
              child: defaultTargetPlatform == TargetPlatform.iOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator(strokeWidth: 2.0),
            )
        : mode == pr.LoadStatus.noMore
            ? widget.noMoreIcon
            : mode == pr.LoadStatus.failed
                ? widget.failedIcon
                : mode == pr.LoadStatus.canLoading
                    ? widget.canLoadingIcon
                    : widget.idleIcon;
    return icon ?? Container();
  }

  @override
  Future endLoading() {
    return Future.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, pr.LoadStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left ? TextDirection.ltr : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom || widget.iconPos == IconPosition.top ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom ? VerticalDirection.up : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(container)
        : Container(
            height: widget.height,
            child: Center(
              child: container,
            ),
          );
  }
}
