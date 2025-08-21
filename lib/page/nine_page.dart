/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/tao_util.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../widget/slide_progress_bar_widget.dart';

///9.9包邮
class NinePage extends StatefulWidget {
  @override
  _NinePageState createState() => _NinePageState();
}

class _NinePageState extends State<NinePage> {
  List<Map<String, dynamic>> tabData = [];
  bool isLoadingTabs = true;
  String? tabErrorMessage;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  ///tab数据
  Future<void> getTabData() async {
    try {
      setState(() {
        isLoadingTabs = true;
        tabErrorMessage = null;
      });

      var res = await BService.nineCate();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colours.dark_app_main, Colours.app_main],
          ),
        ),
        child: Stack(
          children: [
            // 顶部背景区域
            AspectRatio(
              aspectRatio: 413 / 213,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colours.dark_app_main, Colours.app_main],
                  ),
                ),
              ),
            ),
            // 主要内容区域
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56 + MediaQuery.of(context).padding.top),
                  child: titleBar(),
                ),
                body: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoadingTabs) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
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
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getTabData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colours.app_main,
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (tabData.isEmpty) {
      return const Center(
        child: Text(
          '暂无数据',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }

    var tabList = tabData.map<String>((m) => m['title'] as String).toList();
    return TabWidget(
      tabList: tabList,
      indicatorColor: Colors.white.withValues(alpha: 0),
      tabPage: List.generate(tabList.length, (i) {
        return FreeShippingChild(tabData[i]);
      }),
    );
  }

  Widget titleBar() {
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
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/mall/99.png',
            width: 71,
            height: 24,
          ),
          const Spacer(),
          const SizedBox(width: 32, height: 32),
        ],
      ),
    );
  }
}

class FreeShippingChild extends StatefulWidget {
  final Map<String, dynamic> tabValue;

  const FreeShippingChild(this.tabValue, {Key? key}) : super(key: key);
  @override
  _FreeShippingChildState createState() => _FreeShippingChildState();
}

class _FreeShippingChildState extends State<FreeShippingChild> {
  ScrollController controller = ScrollController();
  ScrollController listController = ScrollController();

  List<Map<String, dynamic>> listData = [];
  List<Map<String, dynamic>> topGoodsData = [];
  bool isLoadingList = true;
  bool isLoadingTop = true;
  bool hasNext = true;
  String? listErrorMessage;
  String? topErrorMessage;
  int currentPage = 1;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    listController.dispose();
    super.dispose();
  }

  ///初始化函数
  Future initData() async {
    await getGoodsNineTop();
    await getListData(isRef: true);
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

      var res = await BService.nineList(page, widget.tabValue['id']);
      if (res['lists'] != null) {
        setState(() {
          if (isRef) {
            listData = List<Map<String, dynamic>>.from(res['lists']);
          } else {
            listData.addAll(List<Map<String, dynamic>>.from(res['lists']));
          }
          hasNext = listData.length < (res['totalCount'] ?? 0);
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

  ///顶部数据
  Future<void> getGoodsNineTop() async {
    try {
      setState(() {
        isLoadingTop = true;
        topErrorMessage = null;
      });

      var res = await BService.nineTop();
      if (res['goodsList'] != null) {
        setState(() {
          topGoodsData = List<Map<String, dynamic>>.from(res['goodsList']);
          isLoadingTop = false;
        });
      } else {
        setState(() {
          isLoadingTop = false;
          topErrorMessage = '暂无数据';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingTop = false;
        topErrorMessage = '网络异常';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      color: Colors.white,
      child: CustomScrollView(
        controller: listController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // 顶部商品区域
          SliverToBoxAdapter(
            child: _buildTopSection(),
          ),
          // 商品网格
          _buildGridSection(),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    if (isLoadingTop) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (topErrorMessage != null || topGoodsData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '近1小时疯抢',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Image.asset(
                    'assets/images/mall/hot.png',
                    width: 14,
                    height: 14,
                  ),
                ),
                const Text(
                  '2.4万人正在抢',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 188,
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: topGoodsData.length,
              separatorBuilder: (_, i) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                var data = topGoodsData[i];
                return Global.openFadeContainer(
                  createHeaderItem(data),
                  ProductDetails(data),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SlideProgressBarWidget(
            controller,
            bgBarWidth: MediaQuery.of(context).size.width - 32,
            barWidth: 112,
            bgBarColor: Colors.transparent,
            barColor: Colors.black12,
          ),
          if (listData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/mall/jx.png',
                width: 166 / 2,
                height: 70 / 2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridSection() {
    if (isLoadingList && listData.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
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
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => getListData(isRef: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colours.app_main,
                  ),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
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
                alignment: Alignment.center,
                child: hasNext
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        '没有更多数据了',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
              );
            }

            var data = listData[index];
            return Container(
              margin: EdgeInsets.only(
                top: [0, 1].contains(index % 2) ? 0 : 8,
              ),
              child: Global.openFadeContainer(
                createItem(index, data),
                ProductDetails(data),
              ),
            );
          },
          childCount: listData.length + (hasNext ? 1 : 0),
        ),
      ),
    );
  }

  Widget createItem(int index, Map<String, dynamic> data) {
    var sale = BService.formatNum(data['xiaoliang'] as int);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                getTbMainPic(data),
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data['dtitle'] ?? '',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _getPriceWidget(
                    data['jiage'],
                    data['jiage'],
                    endPrefix: ' 券后 ',
                    endPrefixColor: Colors.black54,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colours.app_main,
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(4),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        child: Text(
                          '券',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colours.app_main,
                          border: Border.all(
                            color: Colours.app_main,
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(4),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        child: Text(
                          '${data['quanJine']}元',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _getSalesWidget(sale),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createHeaderItem(Map<String, dynamic> data) {
    String sale = BService.formatNum(data['xiaoliang']);
    return SizedBox(
      width: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                '${data['pic']}_310x310',
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colours.dark_app_main, Colours.app_main],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x40E47E35),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '疯抢$sale件',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const Spacer(),
          Text(
            data['dtitle'] ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          _getPriceWidget(data['jiage'], data['yuanjia']),
        ],
      ),
    );
  }

  Widget _getPriceWidget(
    dynamic endPrice,
    dynamic originalPrice, {
    String endPrefix = '',
    Color? endPrefixColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              if (endPrefix.isNotEmpty)
                TextSpan(
                  text: endPrefix,
                  style: TextStyle(
                    color: endPrefixColor ?? Colors.black54,
                    fontSize: 12,
                  ),
                ),
              TextSpan(
                text: '¥${endPrice?.toString() ?? '0'}',
                style: const TextStyle(
                  color: Color(0xFFFD471F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (originalPrice != null && originalPrice != endPrice)
          Text(
            '¥${originalPrice.toString()}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _getSalesWidget(String sale) {
    return Text(
      '已售$sale件',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }
}
