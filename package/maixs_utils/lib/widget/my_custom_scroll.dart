import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/mytext.dart';
import 'package:maixs_utils/widget/refresher_widget.dart';
import 'package:maixs_utils/widget/shimmer_widget.dart';
import 'package:maixs_utils/widget/tween_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'my_bouncing_scroll_physics.dart';
import 'mylistview.dart';

///动画类型
enum AnimationType {
  ///打开动画
  open,

  ///关闭动画
  close,

  ///垂直
  vertical,
}

class MyCustomScroll extends StatefulWidget {
  final List<Widget> headers;
  final Widget Function(int, dynamic) itemModelBuilder;
  final int? itemCount;
  final DataModel itemModel;
  final int? crossAxisCount;
  final int? expandedCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? cacheExtent;
  final Divider? divider;
  final EdgeInsetsGeometry? headPadding;
  final EdgeInsetsGeometry? itemPadding;
  final Widget? btmWidget;
  final bool isGengduo;
  final bool isShuaxin;
  final Widget? refFooter;
  final Widget? refHeader;
  final Future<int> Function(int)? onLoading;
  final Future<int> Function()? onRefresh;
  final Widget Function(double)? onTapWidget;
  final String? btmText;
  final String? noDataText;
  final Widget? noDataView;
  final ScrollController? controller;
  final Widget Function()? maskWidget;
  final double? maskHeight;
  final void Function(bool, double)? onScrollToList;
  final bool shrinkWrap;
  final AnimationType animationType;
  final Alignment animationDirection;
  final int? animationDelayed;
  final int? animationTime;
  final bool isCloseTouchBottomAnimation;
  final bool isCloseTopTouchBottomAnimation;
  final double touchBottomAnimationValue;
  final int touchBottomAnimationAnimaTime;
  final ScrollPhysics? physics;

  ///异常的点击事件
  final void Function()? errorOnTap;

  const MyCustomScroll({
    Key? key,
    this.headers = const <Widget>[],
    required this.itemModelBuilder,
    this.itemCount,
    required this.itemModel,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.divider,
    this.headPadding,
    this.itemPadding,
    this.btmWidget,
    required this.isGengduo,
    required this.isShuaxin,
    this.refFooter,
    this.refHeader,
    this.onLoading,
    this.onRefresh,
    this.expandedCount,
    this.btmText,
    this.controller,
    this.onTapWidget,
    this.cacheExtent,
    this.maskWidget,
    this.onScrollToList,
    this.maskHeight,
    this.shrinkWrap = false,
    this.noDataText = '暂无数据',
    this.noDataView,
    this.errorOnTap,
    this.animationType = AnimationType.open,
    this.animationDelayed,
    this.animationDirection = Alignment.centerRight,
    this.animationTime,
    this.isCloseTouchBottomAnimation = false,
    this.touchBottomAnimationValue = 0.25,
    this.isCloseTopTouchBottomAnimation = false,
    this.touchBottomAnimationAnimaTime = 100,
    this.physics,
  }) : super(key: key);
  @override
  _MyCustomScrollState createState() => _MyCustomScrollState();
}

class _MyCustomScrollState extends State<MyCustomScroll> {
  ///首页列表头key
  GlobalKey homeListViewHeadKey = GlobalKey();

  bool isShowMask = false;

  late ScrollController con;

  ///是否靠近顶部
  // var isNearTheTop = false;

  ///底部条
  Widget get btmWidget {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 1,
            width: 56,
            color: Colors.black26,
          ),
          SizedBox(width: 8),
          MyText(widget.btmText ?? '我是有底线的', color: Colors.black54),
          SizedBox(width: 8),
          Container(
            height: 1,
            width: 56,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }

  ///用户滑动方向
  ScrollDirection userScrollDirection = ScrollDirection.reverse;

  ///列表创建时间
  DateTime listViewBuildTime = DateTime.now();

  @override
  void initState() {
    listViewBuildTime = DateTime.now();
    con = widget.controller ?? ScrollController();
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    // isNearTheTop = widget.isShuaxin;
    con.addListener(() {
      userScrollDirection = con.position.userScrollDirection;

      if (widget.maskWidget == null || homeListViewHeadKey.currentContext ==null) return;
      var s = homeListViewHeadKey.currentContext?.findRenderObject()?.parentData.toString();
      double group;
      var firstMatch = RegExp('\\(.*?, (.*?)\\)').firstMatch(s!);
      if (widget.isShuaxin) {
        group = double.parse(firstMatch!.group(1)!);
      } else {
        group = double.parse(s.split('=')[1].replaceAll('Offset', '').replaceAll('(', '').replaceAll(')', '').split(',').last);
      }
      if (group <= (widget.maskHeight ?? 0.0)) {

        widget.onScrollToList!(true, group);

      } else {

        widget.onScrollToList!(false, group);

      }
    });
  }

  var view;

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_) {
      switch (widget.itemModel.flag) {
        case 0:
          view = SliverToBoxAdapter(
            key: homeListViewHeadKey,
            child: BottomTouchAnimation(
              index: widget.headers.length,
              length: widget.itemModel.list.length + widget.headers.length,
              scrollController: con,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: TweenWidget(
                axis: Axis.vertical,
                value: -50,
                key: ValueKey(10),
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: buildLoad(),
                ),
              ),
            ),
          );
          break;
        case 1:
          view = SliverToBoxAdapter(
            key: homeListViewHeadKey,
            child: BottomTouchAnimation(
              index: widget.headers.length,
              length: widget.itemModel.list.length + widget.headers.length,
              scrollController: con,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: TweenWidget(
                axis: Axis.vertical,
                value: 50,
                key: ValueKey(11),
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: ShimmerWidget(
                    text: widget.itemModel.msg!,
                    key: ValueKey(1),
                    color: Colors.transparent,
                    callBack: () {
                      setState(() => widget.itemModel.flag = 0);
                      widget.onRefresh!();
                    },
                  ),
                ),
              ),
            ),
          );
          break;
        case 2:
          view = SliverToBoxAdapter(
            key: homeListViewHeadKey,
            child: BottomTouchAnimation(
              index: widget.headers.length,
              length: widget.itemModel.list.length + widget.headers.length,
              scrollController: con,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: widget.noDataView ??
                  TweenWidget(
                    axis: Axis.vertical,
                    value: 50,
                    key: ValueKey(12),
                    child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: ShimmerWidget(
                        key: ValueKey(2),
                        text: widget.noDataText!,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
            ),
          );
          break;
        default:
          view = SliverPadding(
            key: homeListViewHeadKey,
            padding: widget.itemPadding ?? EdgeInsets.zero,
            sliver: SliverWaterfallFlow(
              delegate: SliverChildBuilderDelegate(
                (_, i) => tweenView(i),

                childCount: widget.itemModel.list.length,
              ),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount ?? 1,
                crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
              ),
            ),
          );
          break;
      }

      if (widget.isShuaxin)
        return Stack(
          children: [
            ClipRect(
              child: RefresherWidget(
                isShuaxin: widget.isShuaxin ?? true,
                isGengduo: widget.isGengduo ?? widget.itemModel.hasNext,
                footer: widget.refFooter ?? buildCustomFooter(text: widget.itemModel?.msg),
                header: widget.refHeader ?? buildClassicHeader(text: widget.itemModel?.msg),
                onLoading: () => widget.onLoading!(widget.itemModel.page),
                onRefresh: widget.onRefresh,
                child: CustomScrollView(
                  controller: con,
                  // physics: MyBouncingScrollPhysics(),
                  physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: MyBouncingScrollPhysics()),
                  cacheExtent: widget.cacheExtent,
                  shrinkWrap: widget.shrinkWrap,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: widget.headPadding ?? EdgeInsets.zero,
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) {
                            // flog('=======$i');
                            return BottomTouchAnimation(
                              index: i,
                              length: widget.headers.length,
                              scrollController: con,
                              isRef: widget.isShuaxin,
                              isMore: widget.isGengduo,
                              isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
                              isCloseTop: widget.isCloseTopTouchBottomAnimation,
                              value: widget.touchBottomAnimationValue,
                              animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
                              child: widget.headers[i],
                            );
                          },
                          childCount: widget.headers.length,
                        ),
                      ),
                    ),
                    view,

                    if (!widget.itemModel.hasNext)
                      if (widget.itemModel.list.length > (widget.expandedCount ?? 10))
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              return BottomTouchAnimation(
                                index: widget.itemModel.list.length + widget.headers.length,
                                length: widget.itemModel.list.length + widget.headers.length,
                                scrollController: con,
                                isRef: widget.isShuaxin,
                                isMore: widget.isGengduo,
                                isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
                                isCloseTop: widget.isCloseTopTouchBottomAnimation,
                                value: widget.touchBottomAnimationValue,
                                animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
                                child: i != 0 ? widget.btmWidget ?? btmWidget : SizedBox(),
                              );
                            },
                            childCount: 2,
                          ),
                        ),
                  ],
                ),
              ),
            ),
            if (widget.maskWidget != null)
              if (widget.onScrollToList == null) isShowMask ? widget.maskWidget!()
                  : SizedBox() else widget.maskWidget!(),
          ],
        );
      else
        return Stack(
          children: [
            ClipRect(
              child: CustomScrollView(
                controller: con,
                // physics: MyBouncingScrollPhysics(),
                physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: MyBouncingScrollPhysics()),
                cacheExtent: widget.cacheExtent,
                shrinkWrap: widget.shrinkWrap,
                slivers: <Widget>[
                  SliverPadding(
                    padding: widget.headPadding ?? EdgeInsets.zero,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          // flog('=======$i');
                          return BottomTouchAnimation(
                            index: i,
                            length: widget.headers.length,
                            scrollController: con,
                            isRef: widget.isShuaxin,
                            isMore: widget.isGengduo,
                            isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
                            isCloseTop: widget.isCloseTopTouchBottomAnimation,
                            value: widget.touchBottomAnimationValue,
                            animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
                            child: widget.headers[i],
                          );
                        },
                        childCount: widget.headers.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    key: homeListViewHeadKey,
                    padding: widget.itemPadding ?? EdgeInsets.zero,
                    sliver: SliverWaterfallFlow(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final int i = index ~/ 2;
                          Widget view;
                          if (index.isEven) {
                            view = (widget.divider == null
                                ? tweenView(i)
                                : widget.crossAxisCount != null
                                    ? tweenView(i)
                                    : Column(
                                        children: [
                                          tweenView(i),
                                          if (i != widget.itemModel.list.length - 1) widget.divider!,
                                        ],
                                      ));
                          } else {
                            view = SizedBox();
                          }
                          return view;
                        },
                        childCount: _computeActualChildCount(widget.itemModel.list.length),
                      ),
                      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.crossAxisCount ?? 1,
                        crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
                        mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
                      ),
                    ),
                  ),
                  if (!widget.itemModel.hasNext)
                    if (widget.itemModel.list.length > (widget.expandedCount ?? 10))
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) {
                            return BottomTouchAnimation(
                              index: widget.itemModel.list.length + widget.headers.length,
                              length: widget.itemModel.list.length + widget.headers.length,
                              scrollController: con,
                              isRef: widget.isShuaxin,
                              isMore: widget.isGengduo,
                              isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
                              isCloseTop: widget.isCloseTopTouchBottomAnimation,
                              value: widget.touchBottomAnimationValue,
                              animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
                              child: i != 0 ? widget.btmWidget ?? btmWidget : SizedBox(),
                            );
                          },
                          childCount: 2,
                        ),
                      ),
                ],
              ),
            ),
            if (widget.maskWidget != null)
              if (widget.onScrollToList == null) isShowMask ? widget.maskWidget!()
                  : SizedBox() else widget.maskWidget!(),
          ],
        );
    });
  }

  Widget tweenView(int i) {
    return BottomTouchAnimation(
      index: i + widget.headers.length,
      length: widget.itemModel.list.length + widget.headers.length,
      scrollController: con,
      isRef: widget.isShuaxin,
      isMore: widget.isGengduo,
      isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
      isCloseTop: widget.isCloseTopTouchBottomAnimation,
      value: widget.touchBottomAnimationValue,
      animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
      child: Builder(
        builder: (_) {
          return widget.itemModelBuilder(i, widget.itemModel.list[i]);
        },
      ),
    );
  }
}
