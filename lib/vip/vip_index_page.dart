/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sufenbao/util/scroll_controller_ext.dart';
import 'package:sufenbao/vip/provider.dart';

import '../util/colors.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/lunbo_widget.dart';

//唯品会首页
class VipIndexPage extends StatefulWidget {
  final Map data;
  const VipIndexPage(this.data, {Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<VipIndexPage> with SingleTickerProviderStateMixin {
  var _showBackTop = false;

  /// 嵌套滚动
  final _scrollController = ScrollController();
  final scrollY = ValueNotifier(0.0);
  final scrollProgress = ValueNotifier(0.0);

  final bgColor = Color(0xffF3F3F3);

  /// 用于记录页面可见度变化
  double _visibleFraction = 0.0;

  late TabController _tabController;
  late PageController _pageController;
  final _tabs = [
    {'name': '美妆'},
    {'name': '母婴'},
    {'name': '鞋包'},
    {'name': '女装'},
    {'name': '男装'},
    {'name': '居家百货'},
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();

    _scrollController.addListener(() {
      scrollY.value = _scrollController.offset;
      scrollProgress.value = _scrollController.position.progress;
      // _scrollController.position.pixels 获取当前滚动部件滚动的距离
      // 当滚动距离大于 800 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// 交互页面构建
  Widget buildNestedScrollViewPage({
    required double expandedHeight,
    required double collapsedHeight,
    required Widget collapsed,
    required Color collapsedBackgroundColor,
    required Widget header,
    required Widget body,
  }) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   DLog.d([
    //     "$this topKey",
    //     topKey.currentContext?.size,
    //     ((topKey.currentContext?.size?.height ?? 0) - context.paddingTop)
    //   ].asMap());
    // });

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              centerTitle: false,
              pinned: true,
              floating: false,
              snap: false,
              primary: true,
              leading: IconButton(
                // splashColor: bwColor,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: scrollProgress.value > 0.65 ? collapsedBackgroundColor : bgColor,
              title: ValueListenableBuilder(
                valueListenable: scrollY,
                builder: (context, value, child) {
                  try {
                    final opacity = _scrollController.position.progress > 0.9 ? 1.0 : 0.0;
                    return AnimatedOpacity(
                      opacity: opacity,
                      duration: const Duration(milliseconds: 100),
                      child: collapsed,
                    );
                  } catch (e) {
                    debugPrint("$this $e");
                  }
                  return const SizedBox();
                },
              ),
              toolbarHeight: collapsedHeight,
              collapsedHeight: collapsedHeight,
              expandedHeight: expandedHeight,
              elevation: 0,
              scrolledUnderElevation: 0,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                // key: topKey,
                background: SizedBox(
                  height: expandedHeight,
                  child: header,
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        margin: EdgeInsets.only(top: collapsedHeight + MediaQuery.of(context).padding.top),
        child: body,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const collapsedHeight = kToolbarHeight;

    final headerHeight = MediaQuery.of(context).size.width / 2.3 - 2;

    var expandedHeight = headerHeight;

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
          ? FloatingActionButton(
              backgroundColor: Colours.vip_main,
              mini: true,
              onPressed: () {
                // scrollController 通过 animateTo 方法滚动到某个具体高度
                // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                _scrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
              },
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            )
          : null,
      body: buildNestedScrollViewPage(
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        collapsedBackgroundColor: Color(0xffff3295),
        header: buildTopBox(),
        collapsed: buildUserBar(),
        body: buildScheduleBox(),
      ),
    );
  }

  /// 待办事项
  Widget buildScheduleBox() {
    return Container(
      color: Color(0xffff3295),
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 40,
      child: Column(
        children: [
          // buildHeader(),
          Expanded(
            child: buildListView(),
          ),
        ],
      ),
    );
  }

  /// 待办事项列表
  Widget buildListView() {
    final list = [
      {'name': '美妆'},
      {'name': '母婴'},
      {'name': '鞋包'},
      {'name': '女装'},
      {'name': '男装'},
      {'name': '居家百货'},
    ];

    return Column(
      children: [
        // 自定义 Tab 栏
        TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab['name'])).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          indicator: const TabBarIndicator(borderSide: BorderSide(width: 5, color: Colors.white)),
          unselectedLabelColor: Colors.white70, dividerColor: Colors.transparent, //去除白色线
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),

        // PageView 内容区域
        Expanded(
          child: _buildPageView(),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _tabs.length,
      onPageChanged: (index) {
        // 监听 PageView 变化，同步 TabController
        _tabController.animateTo(index);
      },
      itemBuilder: (context, index) {
        return TopChild(_tabs[index]);
      },
    );
  }

  /// 底部 待办事项
  Widget buildHeader() {
    return InkWell(
      onTap: () {
        Log.d("待办事项");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 17,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text('待办事项')
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildUserBar() {
    var realNameAndTypeText = "唯品快抢";

    return Container(
      height: 28,
      // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              realNameAndTypeText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopBox() {
    List imgs = [
      {'img': 'https://sr.ffquan.cn/cms_pic/20220427/c9kabkv92a41b8dv6jug0.png'}
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
      ),
      child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 15),
          // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          width: double.infinity,
          child: LunboWidget(
            imgs,
            value: 'img',
            aspectRatio: 2 / 1,
            loop: false,
            fun: (v) {},
          )),
    );
  }
}

class TopChild extends ConsumerStatefulWidget {
  final Map data;

  const TopChild(this.data, {Key? key}) : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends ConsumerState<TopChild> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(vipListProvider(keyword: widget.data['name']));
    final notifier = ref.watch(vipListProvider(keyword: widget.data['name']).notifier);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: EasyRefresh(
          onRefresh: () => notifier.refresh(),
          onLoad: () => notifier.loadMore(),
          child: provider.when(
              data: (data) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, index) {
                    var v = data[index] as Map;
                    return createVipFadeContainer(context, v);
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 8);
                  },
                  itemCount: data.length,
                );
              },
              error: (o, s) => ErrorState(),
              loading: () => LoadingState())),
    );
  }
}
