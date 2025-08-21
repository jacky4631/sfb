/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/logger_util.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';

import '../widget/lunbo_widget.dart';

class TitleBarValue extends ValueNotifier {
  TitleBarValue() : super(null);
  var isShowTabbar = false;
  void changeIsShowTabbar(v) {
    isShowTabbar = v;
    notifyListeners();
  }
}

TitleBarValue titleBarValue = TitleBarValue();

///捡漏清单
class PickLeakPage extends StatefulWidget {
  @override
  _PickLeakPageState createState() => _PickLeakPageState();
}

class _PickLeakPageState extends State<PickLeakPage> with TickerProviderStateMixin {
  int index = 0;
  List tabList = [];
  ScrollController _scrollController = ScrollController();
  var themeColor = Color(0xff538F45);
  bool loading = false;

  // 状态管理变量
  List<Map<String, dynamic>> tabData = [];
  List<Map<String, dynamic>> listData = [];
  bool isLoadingTabs = true;
  bool isLoadingList = true;
  bool hasNext = true;
  String? tabErrorMessage;
  String? listErrorMessage;
  int currentPage = 1;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  ///初始化函数
  Future initData() async {
    titleBarValue.changeIsShowTabbar(false);
    await getTabData();
    await getListData(isRef: true);
  }

  ///tab数据
  Future<void> getTabData() async {
    try {
      setState(() {
        isLoadingTabs = true;
        tabErrorMessage = null;
      });

      var res = await BService.pickCate();
      if (res.isNotEmpty) {
        setState(() {
          tabData = List<Map<String, dynamic>>.from(res);
          isLoadingTabs = false;
        });
      } else {
        setState(() {
          isLoadingTabs = false;
          tabErrorMessage = '暂无数据';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingTabs = false;
        tabErrorMessage = '网络异常';
      });
    }
  }

  ///列表数据
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    try {
      if (isRef) {
        setState(() {
          isLoadingList = true;
          listErrorMessage = null;
          currentPage = 1;
        });
      }

      Log.e(index);
      var cateId = tabData.isNotEmpty ? "${tabData[index]['id']}" : 0;
      var res = await BService.pickList(page, cateId);
      if (res.isNotEmpty) {
        setState(() {
          if (isRef) {
            listData = List<Map<String, dynamic>>.from(res);
          } else {
            listData.addAll(List<Map<String, dynamic>>.from(res));
          }
          hasNext = listData.length < 500; // 假设最大500条数据
          currentPage = page;
          isLoadingList = false;
        });
      } else {
        setState(() {
          hasNext = false;
          isLoadingList = false;
          if (isRef && listData.isEmpty) {
            listErrorMessage = '暂无数据';
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoadingList = false;
        if (isRef) {
          listErrorMessage = '网络异常';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned(
          child: _buildBody(),
        ),
        if (tabList.isNotEmpty)
          Positioned(
            bottom: 56,
            child: btmBarView(),
          ),
        titleBarView()
      ]),
    );
  }

  Widget _buildBody() {
    if (isLoadingTabs) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (tabErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tabErrorMessage!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getTabData,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (loading) {
      return Global.showLoading2();
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // 头部内容
          SliverToBoxAdapter(
            child: _buildHeaders(),
          ),
          // 遮罩层
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 40,
              maxHeight: 40,
              child: ValueListenableBuilder(
                valueListenable: titleBarValue,
                builder: (_, __, ___) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.translationValues(
                      0,
                      titleBarValue.isShowTabbar ? 0 : -72,
                      0,
                    ),
                    child: Container(
                      height: 40,
                      color: themeColor,
                      child: titleBarValue.isShowTabbar ? buildTabBar(false) : null,
                    ),
                  );
                },
              ),
            ),
          ),
          // 列表内容
          _buildListContent(),
        ],
      ),
    );
  }

  Widget _buildHeaders() {
    if (isLoadingTabs) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (tabErrorMessage != null) {
      return const SizedBox.shrink();
    }

    if (tabData.isEmpty) {
      return const SizedBox.shrink();
    }

    tabList = tabData.where((w) => w['type'] != 0).toList();
    var bannerList = [
      {'img': "http://img-haodanku-com.cdn.fudaiapp.com/FidecMbZv9-1_VLlFQl6aViRFa4T"}
    ];

    return Column(children: [
      LunboWidget(
        bannerList,
        value: 'img',
        aspectRatio: 750 / 170,
        loop: false,
        fun: (v) {},
      ),
      buildTabBar(true),
    ]);
  }

  Widget _buildListContent() {
    if (isLoadingList && listData.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (listErrorMessage != null && listData.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  listErrorMessage!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => getListData(isRef: true),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= listData.length) {
            // 加载更多指示器
            if (hasNext && !isLoadingList) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getListData(page: currentPage + 1);
              });
            }
            return Container(
              height: 60,
              alignment: Alignment.center,
              child: hasNext
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : const Text(
                      '没有更多数据了',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
            );
          }

          var data = listData[index];
          return Global.openFadeContainer(
            createItem(index, data),
            ProductDetails(data),
          );
        },
        childCount: listData.length + (hasNext ? 1 : 0),
      ),
    );
  }

  Widget createItem(int i, Map<String, dynamic> v) {
    var img = '${v['itempic']}';
    String endPrice = v['itemendprice'];
    endPrice = endPrice.split('.')[0];
    String startPrice = v['itemprice'];
    startPrice = startPrice.split('.')[0];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: i == listData.length - 1 ? 0 : 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 商品图片
          if (img.isNotEmpty)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          else
            const SizedBox(),

          // 商品标题
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '${v['itemshorttitle']}',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // 优惠信息
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '${v['activity_gameplay']}',
                style: TextStyle(color: themeColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // 价格信息
          if (v['itemendprice'] != '0.00')
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¥$endPrice',
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '¥$startPrice',
                    style: const TextStyle(
                      color: Colors.black26,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(),

          // 购买按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(56),
            ),
            child: const Text(
              '马上抢',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///底部栏
  Widget btmBarView() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Expanded(
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabList.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, i) {
                        var tab = tabList[i]['name'];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => onTap(i),
                            child: Container(
                              height: 48,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: index == i ? Colors.white : const Color(0xffF5F5F5),
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    width: i == 0 ? 0 : 0.5,
                                  ),
                                  right: BorderSide(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    width: i == tabList.length - 1 ? 0 : 0.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                '$tab',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.75),
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _showSheet(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => PopupWidget(
        tabList,
        index,
        fun: (i) => onTap(i),
      ),
    );
  }

  ///标题栏视图
  Widget titleBarView() {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(56),
              ),
              child: const Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabBar(bool isFixed) {
    var titleBarList = ['商品图', '商品标题', '优惠信息', '到手价', '购买'];
    return Row(
      children: List.generate(titleBarList.length, (i) {
        var title = titleBarList[i];
        var container = Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: themeColor,
            border: Border(
              left: BorderSide(
                color: Colors.white.withValues(alpha: isFixed ? 1 : 0.1),
                width: i == 0 ? 0 : 0.5,
              ),
              right: BorderSide(
                color: Colors.white.withValues(alpha: isFixed ? 1 : 0.1),
                width: i == titleBarList.length - 1 ? 0 : 0.5,
              ),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        );
        if (title == '商品标题') return Expanded(child: container, flex: 2);
        return Expanded(child: container);
      }),
    );
  }

  void onTap(i) async {
    index = i;
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
    setState(() {
      loading = true;
    });
    await getListData(isRef: true);
    setState(() {
      loading = false;
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

class PopupWidget extends StatefulWidget {
  final List list;
  final int index;
  final Function(int)? fun;
  const PopupWidget(this.list, this.index, {Key? key, this.fun}) : super(key: key);
  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  int seleIndex = 0;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    seleIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(widget.list.length, (i) {
          var data = widget.list[i];
          var w = (MediaQuery.of(context).size.width - 16 - 32) / 3;
          var isDy = seleIndex == i;
          return GestureDetector(
            onTap: () async {
              setState(() => seleIndex = i);
              Navigator.pop(context);
              widget.fun!(seleIndex);
            },
            child: Container(
              width: w,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDy ? const Color(0xffE2F3E3) : Colors.black.withValues(alpha: 0.05),
                border: Border.all(
                  color: Color(0xff538F45).withValues(
                    alpha: isDy ? 1 : 0,
                  ),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                data['name'],
                style: TextStyle(
                  color: isDy ? const Color(0xff538F45) : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
