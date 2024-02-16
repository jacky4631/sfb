import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/mytext.dart';
import 'package:maixs_utils/widget/refresher_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import 'my_bouncing_scroll_physics.dart';

///动画类型
enum AnimationType {
  ///打开动画
  open,

  ///关闭动画
  close,

  ///垂直
  vertical,
}

///列表试图类型
enum ListViewType {
  Builder,
  BuilderExpanded,
  Separated,
  SeparatedExpanded,
}

class MyListView<T> extends StatefulWidget {
  ///列表属性
  final Function(int) item;
  final int itemCount;
  final ListViewType listViewType;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final Widget? divider;
  final Widget Function(int)? dividerBuilder;
  final bool flag;
  final bool reverse;
  final ScrollController? controller;
  final DataModel<T>? value;
  final Widget Function(T)? itemWidget;
  final int expCount;
  final Alignment animationDirection;

  ///刷新属性
  final Widget? header;
  final Widget? footer;
  final bool isShuaxin;
  final bool isGengduo;
  final bool isOnlyMore;
  final Widget? expView;
  final Future<int> Function()? onLoading;
  final Future<int> Function()? onRefresh;
  final AnimationType animationType;
  final int? animationDelayed;
  final int? animationTime;
  final bool isFillPlatform;
  final double? fillValue;
  final double? cacheExtent;
  final bool isCloseTouchBottomAnimation;
  final bool isCloseTopTouchBottomAnimation;
  final bool isClipRect;
  final double touchBottomAnimationValue;
  final int touchBottomAnimationAnimaTime;

  const MyListView({
    Key? key,
    required this.item,
    this.listViewType = ListViewType.Separated,
    required this.itemCount,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.divider,
    this.flag = true,
    this.controller,
    this.header,
    this.footer,
    required this.isShuaxin,
    this.isGengduo = false,
    this.onLoading,
    this.onRefresh,
    this.value,
    this.itemWidget,
    this.expCount = 10,
    this.isOnlyMore = false,
    this.expView,
    this.reverse = false,
    this.animationType = AnimationType.open,
    this.animationDelayed,
    this.animationDirection = Alignment.centerRight,
    this.animationTime,
    this.isFillPlatform = false,
    this.fillValue,
    this.cacheExtent,
    this.isCloseTouchBottomAnimation = false,
    this.touchBottomAnimationValue = 0.25,
    this.isCloseTopTouchBottomAnimation = false,
    this.touchBottomAnimationAnimaTime = 100,
    this.isClipRect = true,
    this.dividerBuilder,
  }) : super(key: key);
  @override
  _MyListViewState<T> createState() => _MyListViewState<T>();
}

class _MyListViewState<T> extends State<MyListView<T>> {
  ///列表map
  Map<ListViewType, Widget> listviews = {};

  late ScrollController _controller;

  ///是否靠近顶部
  var isNearTheTop = false;

  ///底部条
  Widget container = Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 1,
          width: 56,
          color: Colors.black.withOpacity(0.1),
        ),
        SizedBox(width: 8),
        MyText('暂无更多', color: Colors.black.withOpacity(0.25)),
        SizedBox(width: 8),
        Container(
          height: 1,
          width: 56,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
    ),
  );

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///用户滑动方向
  ScrollDirection userScrollDirection = ScrollDirection.reverse;

  ///列表创建时间
  DateTime listViewBuildTime = DateTime.now();

  bool flag = true;

  ///初始化函数
  Future initData() async {
    flag = widget.flag;
    // if (!widget.isShuaxin) if (flag && widget.physics == null) flag = false;
    listViewBuildTime = DateTime.now();
    _controller = widget.controller ?? ScrollController();
    // isNearTheTop = widget.isShuaxin;
    _controller.addListener(() {
      userScrollDirection = _controller.position.userScrollDirection;

    });
  }

  @override
  Widget build(BuildContext context) {
    container = widget.expView ?? container;
    listviews = {
      ListViewType.Builder: buildListViewBuilder(),
      ListViewType.BuilderExpanded: buildListViewBuilderExpanded(),
      ListViewType.Separated: buildListViewSeparated(),
      ListViewType.SeparatedExpanded: buildListViewSeparatedExpanded(),
    };
    var view;

    view = listviews[widget.listViewType];

    return view;

  }

  ///默认列表
  Widget buildListViewBuilder() {
    if (widget.isShuaxin) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
        footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
        child: ListView.builder(
          controller: _controller,
          shrinkWrap: flag,
          // physics: widget.physics,
          physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
          reverse: widget.reverse,
          padding: widget.padding,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.itemCount == null ? widget.value!.list.length + 1 : widget.itemCount + 1,
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.itemCount >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return tweenView(i);
              }
            } else {
              if (i == widget.value!.list.length) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.value!.list.length >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.itemWidget!(widget.value!.list[i]);
              }
            }
          },
        ),
      );
    } else if (widget.isOnlyMore) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
        footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
        child: ListView.builder(
          controller: _controller,
          shrinkWrap: flag,
          // physics: widget.physics,
          physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
          padding: widget.padding,
          reverse: widget.reverse,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.itemCount == null ? widget.value!.list.length + 1 : widget.itemCount + 1,
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.itemCount >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return tweenView(i);
              }
            } else {
              if (i == widget.value!.list.length) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.value!.list.length >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.itemWidget!(widget.value!.list[i]);
              }
            }
          },
        ),
      );
    } else {
      return ListView.builder(
        controller: _controller,
        shrinkWrap: flag,
        // physics: widget.physics,
        physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
        padding: widget.padding,
        cacheExtent: widget.cacheExtent,
        itemBuilder: (_, i) => tweenView(i),
        itemCount: widget.itemCount,
      );
    }
  }

  ///带有Expanded的默认列表
  Widget buildListViewBuilderExpanded() {
    return Expanded(
      child: widget.isShuaxin
          ? RefresherWidget(
              isShuaxin: widget.isShuaxin,
              isGengduo: widget.isGengduo,
              onRefresh: widget.onRefresh ?? () async => getTime(),
              onLoading: widget.onLoading ?? () async => getTime(),
              header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
              footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
              child: ListView.builder(
                controller: _controller,
                // physics: widget.physics,
                physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
                padding: widget.padding,
                reverse: widget.reverse,
                cacheExtent: widget.cacheExtent,
                itemCount: widget.itemCount == null ? widget.value!.list.length + 1 : widget.itemCount + 1,
                itemBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    if (i == widget.itemCount) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.itemCount >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return tweenView(i);
                    }
                  } else {
                    if (i == widget.value!.list.length) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.value!.list.length >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return widget.itemWidget!(widget.value!.list[i]);
                    }
                  }
                },
              ),
            )
          : ListView.builder(
              controller: _controller,
              // physics: widget.physics,
              physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
              padding: widget.padding,
              reverse: widget.reverse,
              cacheExtent: widget.cacheExtent,
              itemBuilder: (_, i) => tweenView(i),
              itemCount: widget.itemCount,
            ),
    );
  }

  ///带分割线的列表
  Widget buildListViewSeparated() {
    if (widget.isShuaxin || widget.isOnlyMore) {
      return RefresherWidget(
        isShuaxin: widget.isShuaxin,
        isGengduo: widget.isGengduo,
        onRefresh: widget.onRefresh ?? () async => getTime(),
        onLoading: widget.onLoading ?? () async => getTime(),
        header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
        footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
        child: ListView.separated(
          shrinkWrap: flag,
          padding: widget.padding,
          controller: _controller,
          // physics: widget.physics,
          physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
          reverse: widget.reverse,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.itemCount == null ? widget.value!.list.length + 1 : widget.itemCount + 1,
          separatorBuilder: (_, i) {
            return BottomTouchAnimation(
              index: i,
              length: widget.itemCount,
              scrollController: _controller,
              isRef: widget.isShuaxin,
              isMore: widget.isGengduo,
              isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
              isCloseTop: widget.isCloseTopTouchBottomAnimation,
              value: widget.touchBottomAnimationValue,
              animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
              child: Builder(
                builder: (_) {
                  if (widget.itemCount != null) {
                    return i == widget.itemCount - 1
                        ? SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ?? SizedBox())
                            : widget.dividerBuilder!(i);
                  } else {
                    return i == widget.value!.list.length - 1
                        ? SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ?? SizedBox())
                            : widget.dividerBuilder!(i);
                  }
                },
              ),
            );
          },
          itemBuilder: (_, i) {
            if (widget.itemCount != null) {
              if (i == widget.itemCount) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.itemCount >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return tweenView(i);
              }
            } else {
              if (i == widget.value!.list.length) {
                return widget.isGengduo
                    ? SizedBox()
                    : widget.value!.list.length >= widget.expCount
                        ? container
                        : SizedBox();
              } else {
                return widget.itemWidget!(widget.value!.list[i]);
              }
            }
          },
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: flag,
        padding: widget.padding,
        controller: _controller,
        // physics: widget.physics,
        physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
        reverse: widget.reverse,
        cacheExtent: widget.cacheExtent,
        itemBuilder: (_, i) => tweenView(i),
        separatorBuilder: (_, i) {
          return BottomTouchAnimation(
            index: i,
            length: widget.itemCount,
            scrollController: _controller,
            isRef: widget.isShuaxin,
            isMore: widget.isGengduo,
            isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
            isCloseTop: widget.isCloseTopTouchBottomAnimation,
            value: widget.touchBottomAnimationValue,
            animaTime: 10,
            child: widget.dividerBuilder == null ? (widget.divider ?? SizedBox()) : widget.dividerBuilder!(i),
          );
        },
        itemCount: widget.itemCount,
      );
    }
  }

  ///带有Expanded的分割线列表
  Widget buildListViewSeparatedExpanded() {
    return Expanded(
      child: widget.isShuaxin
          ? RefresherWidget(
              isShuaxin: widget.isShuaxin,
              isGengduo: widget.isGengduo,
              onRefresh: widget.onRefresh ?? () async => getTime(),
              onLoading: widget.onLoading ?? () async => getTime(),
              header: widget.header ?? buildClassicHeader(text: widget.value?.msg),
              footer: widget.footer ?? buildCustomFooter(text: widget.value?.msg),
              child: ListView.separated(
                controller: _controller,
                padding: widget.padding,
                // physics: widget.physics,
                physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
                reverse: widget.reverse,
                cacheExtent: widget.cacheExtent,
                itemCount: widget.itemCount == null ? widget.value!.list.length + 1 : widget.itemCount + 1,
                separatorBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    return i == widget.itemCount - 1
                        ? SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ??
                                Divider(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  thickness: 1,
                                  indent: 18,
                                  height: 0,
                                  endIndent: 18,
                                ))
                            : widget.dividerBuilder!(i);
                  } else {
                    return i == widget.value!.list.length - 1
                        ? SizedBox()
                        : widget.dividerBuilder == null
                            ? (widget.divider ??
                                Divider(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  thickness: 1,
                                  indent: 18,
                                  height: 0,
                                  endIndent: 18,
                                ))
                            : widget.dividerBuilder!(i);
                  }
                },
                itemBuilder: (_, i) {
                  if (widget.itemCount != null) {
                    if (i == widget.itemCount) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.itemCount >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return tweenView(i);
                    }
                  } else {
                    if (i == widget.value!.list.length) {
                      return widget.isGengduo
                          ? SizedBox()
                          : widget.value!.list.length >= widget.expCount
                              ? container
                              : SizedBox();
                    } else {
                      return widget.itemWidget!(widget.value!.list[i]);
                    }
                  }
                },
              ),
            )
          : ListView.separated(
              controller: _controller,
              padding: widget.padding,
              // physics: widget.physics,
              physics: widget.physics ?? AlwaysScrollableScrollPhysics(parent: (isNearTheTop ? BouncingScrollPhysics() : MyBouncingScrollPhysics())),
              reverse: widget.reverse,
              cacheExtent: widget.cacheExtent,
              itemBuilder: (_, i) => tweenView(i),
              separatorBuilder: (_, i) {
                return widget.dividerBuilder == null
                    ? (widget.divider ??
                        Divider(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          thickness: 1,
                          indent: 18,
                          height: 0,
                          endIndent: 18,
                        ))
                    : widget.dividerBuilder!(i);
              },
              itemCount: widget.itemCount,
            ),
    );
  }

  Widget tweenView(int i) {
    return BottomTouchAnimation(
      index: i,
      length: widget.itemCount,
      scrollController: _controller,
      isRef: widget.isShuaxin,
      isMore: widget.isGengduo,
      isClose: widget.isCloseTouchBottomAnimation || widget.isGengduo,
      isCloseTop: widget.isCloseTopTouchBottomAnimation,
      value: widget.touchBottomAnimationValue,
      animaTime: !widget.isShuaxin ? 10 : widget.touchBottomAnimationAnimaTime,
      child: Builder(
        builder: (_) {
          var value = {
            Alignment.centerLeft: -50.0,
            Alignment.centerRight: 50.0,
            Alignment.bottomCenter: 50.0,
            Alignment.topCenter: -50.0,
          }[widget.animationDirection];
          // if ((Platform.isMacOS || Platform.isWindows)) {

          return widget.item(i);
        },
      ),
    );
  }
}

///触底动画
class BottomTouchAnimation extends StatefulWidget {
  final Widget? child;
  final bool isRef;
  final bool isMore;
  final bool isClose;
  final bool isCloseTop;
  final double value;
  final ScrollController? scrollController;
  final int index;
  final int length;
  final int animaTime;
  const BottomTouchAnimation({
    Key? key,
    this.child,
    this.scrollController,
    this.isRef = false,
    this.isMore = false,
    this.isClose = false,
    this.value = 0.2,
    this.isCloseTop = false,
    this.index = 0,
    this.length = 0,
    required this.animaTime,
  }) : super(key: key);

  @override
  State<BottomTouchAnimation> createState() => _BottomTouchAnimationState();
}

class _BottomTouchAnimationState extends State<BottomTouchAnimation> {
  late ScrollController _controller;

  var _scaleY = 0.0;

  int value = 500;

  bool extentAfter = false;

  ///指针是否松开
  // int isPointerUp = 1;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    _controller = widget.scrollController!;
    if (widget.isClose) {
    } else {
      _controller.addListener(() {
        extentAfter = _controller.offset > 0.0;
        // flog(extentAfter);
        if (!widget.isClose) {
          if (_controller.position.extentAfter == 0.0) {
            var extentAfterValue = -(_controller.position.maxScrollExtent - _controller.offset);
            if (extentAfterValue <= value) {
              // isPointerUp = (_controller.position.activity.velocity != 0.0) ? 1 : 0;
              if (mounted) setState(() => _scaleY = (extentAfterValue / value));
            }
          } else if (_controller.position.extentBefore == 0.0) {
            var extentBeforeValue = -(_controller.offset);
            if (extentBeforeValue <= value) {
              // isPointerUp = (_controller.position.activity.velocity != 0.0) ? 2 : 0;
              if (mounted) setState(() => _scaleY = (extentBeforeValue / value));
            }
          } else {
            // isPointerUp = 0;
            if (_scaleY != 0.0) if (mounted) setState(() => _scaleY = 0.0);
          }
        } else {
          // flog('还没到触发条件');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // flog(_scaleY);
    // return widget.child;
    if (widget.isClose) return widget.child!;
    bool isToEnd = true;
    if (widget.isCloseTop) {
      if (_controller.hasClients) {
        isToEnd = (_controller?.position?.extentAfter ?? 1.0) == 0.0;
      }
    }
    // flog(_controller.offset);
    return TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: 1.0 + (isToEnd ? (_scaleY * widget.value) : 0)),
      duration: Duration(milliseconds: widget.animaTime ?? 250),
      curve: Curves.easeOutCubic,
      child: widget.child,
      builder: (_, v, vv) {
        var y1 = ((v - 1) * 10 * (widget.index + 1)) * widget.index;
        var btmIndex = (widget.length - widget.index);
        var y2 = (-(v - 1) * 10 * (btmIndex + 1)) * btmIndex;
        return Transform.translate(
          offset: Offset(0, [y1, y2][extentAfter ? (1) : (0)]),
          child: vv,
        );
      },
    );
  }
}
