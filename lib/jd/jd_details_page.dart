import 'package:flutter/material.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../service.dart';
import '../util/toast_utils.dart';
import '../page/product_details.dart';
import '../widget/loading.dart';

class DataModel<T> {
  List<T> list = [];
  T? object;
  bool hasError = false;
  String errorMsg = '';
  bool hasMore = true;
  int page = 1;
  int pageSize = 20;

  void addList(List<T> newList) {
    list.addAll(newList);
  }

  void addObject(T obj) {
    object = obj;
  }

  void setError(String msg) {
    hasError = true;
    errorMsg = msg;
  }

  void clear() {
    list.clear();
    object = null;
    hasError = false;
    errorMsg = '';
    hasMore = true;
    page = 1;
  }
}

class JDDetailsPage extends StatefulWidget {
  final arguments;

  const JDDetailsPage(this.arguments, {Key? key}) : super(key: key);

  @override
  _JDDetailsPageState createState() => _JDDetailsPageState();
}

class _JDDetailsPageState extends State<JDDetailsPage> {
  ScrollController controller = ScrollController();

  EdgeInsets get pmPadd => MediaQuery.of(context).padding;
  List tabList = ['商品', '详情', '同款'];
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  List<GlobalKey> keyList = [];
  List<Widget> headers = [];
  double key1H = 0.0;
  double key2H = 0.0;
  double key3H = 0.0;
  int tabIndex = 0;
  bool isGo = false;
  bool loading = true;
  bool collect = false;
  String goodsIdStr = '';
  String img = '';
  String title = '';
  String startPrice = '';
  String endPrice = '';
  String? couponUrl;
  bool showShareBuy = false;
  Map res = {};
  DataModel detailDm = DataModel();
  DataModel listSimilarGoodsByOpenDm = DataModel();

  @override
  void initState() {
    super.initState();
    keyList = [key1, key2, key3];
    controller.addListener(scrollListener);
    initData();
  }

  void scrollListener() {
    if (controller.offset > key1H + key2H - 56 - pmPadd.top) {
      tabIndex = 2;
    } else if (controller.offset > key1H - 56 - pmPadd.top) {
      tabIndex = 1;
    } else {
      tabIndex = 0;
    }
    setState(() {});
  }

  void initData() async {
    if (widget.arguments != null) {
      res = widget.arguments['res'] ?? {};
      goodsIdStr = res['goodsId'] ?? res['skuId'] ?? '';
      img = res['pict_url'] ?? res['white_image'] ?? '';
      title = res['title'] ?? res['short_title'] ?? '';
      startPrice = res['zk_final_price'] ?? res['actualPrice'] ?? '';
      endPrice = res['reserve_price'] ?? res['originPrice'] ?? '';
    }

    await getDetail();
    await getSimilarGoods();
    await getCollect();

    setState(() {
      loading = false;
    });
  }

  Future<void> getDetail() async {
    try {
      var result = await BService.goodsDetailJD(int.parse(goodsIdStr));
      if (result != null) {
        detailDm.addObject(result);
        couponUrl = await BService.goodsWordJD(
            int.parse(result['itemId'].toString()),
            result['couponLink'],
            result['materialUrl']);
        showShareBuy = result['showShareBuy'] ?? false;
      }
    } catch (e) {
      detailDm.setError('获取详情失败');
    }
  }

  Future<void> getSimilarGoods() async {
    try {
      var result = await BService.goodsSearch(1, title);
      if (result != null) {
        listSimilarGoodsByOpenDm
            .addList(List<Map<String, dynamic>>.from(result));
      }
    } catch (e) {
      listSimilarGoodsByOpenDm.setError('获取相似商品失败');
    }
  }

  Future<void> getCollect() async {
    try {
      collect = await BService.collect(int.parse(goodsIdStr));
      setState(() {});
    } catch (e) {
      collect = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F3F3),
      body: Stack(
        children: [
          loading
              ? Global.showLoading2()
              : CustomScrollView(
                  controller: controller,
                  slivers: [
                    ...headers
                        .map((header) => SliverToBoxAdapter(child: header))
                        .toList(),
                    SliverPadding(
                      padding: EdgeInsets.all(16).copyWith(
                          bottom: MediaQuery.of(context).padding.bottom + 70),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= listSimilarGoodsByOpenDm.list.length)
                              return null;
                            var v = listSimilarGoodsByOpenDm.list[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: EdgeInsets.only(top: index < 2 ? 0 : 10),
                              child: Global.openFadeContainer(
                                  createSimilarItem(index, v),
                                  ProductDetails(v)),
                            );
                          },
                          childCount: listSimilarGoodsByOpenDm.list.length,
                        ),
                      ),
                    ),
                  ],
                ),
          titleBarView(),
          btmBarView(),
        ],
      ),
    );
  }

  Widget createSimilarItem(i, v) {
    String img = v['white_image'] == "" ? v['pict_url'] : v['white_image'];
    String sale = '';
    if (!Global.isEmpty(v['tk_total_sales'])) {
      sale = BService.formatNum(int.parse(v['tk_total_sales']));
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Image.network(
              img,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: Image.asset(
                        'assets/images/mall/jd.png',
                        width: 14,
                        height: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        v['short_title'],
                        style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.75)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '¥',
                        style: TextStyle(
                          color: Colours.app_main,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${v['zk_final_price']}',
                        style: TextStyle(
                          color: Colours.app_main,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '已售',
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                      TextSpan(
                        text: sale,
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  v['shop_title'],
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 45 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 4),
            createBottomBackArrow(context),
            SizedBox(width: 8),
            btmBtnView('收藏', Icons.star_rate_rounded, () {
              BService.collectProduct(context, collect, goodsIdStr, 'jd', img,
                      title, startPrice, endPrice)
                  .then((value) {
                getCollect();
              });
            }, collect),
            SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 45,
                child: Row(
                  children: [
                    if (showShareBuy)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onTapDialogLogin(context, fun: () {
                            res['klUrl'] = couponUrl;
                            Navigator.pushNamed(context, '/sellPage',
                                arguments: {'res': res, 'platType': 'JD'});
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffFAEDE0),
                            ),
                            child: Center(
                              child: Text(
                                '转卖',
                                style: TextStyle(
                                  color: Colours.app_main,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTapDialogLogin(context, fun: () {
                          launch(false);
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colours.jd_main,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '¥',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${detailDm.object?['actualPrice'] ?? ''} ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '¥${detailDm.object?['originPrice'] ?? ''}',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '领券购买',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleBarView() {
    return Container(
      height: 56 + pmPadd.top,
      padding: EdgeInsets.fromLTRB(16, pmPadd.top + 8, 16, 8),
      decoration: BoxDecoration(
        color: isGo ? Colors.white : Colors.transparent,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          if (isGo)
            ...tabList.asMap().entries.map((entry) {
              int index = entry.key;
              String tab = entry.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => scrollToTab(index),
                  child: Container(
                    height: 32,
                    child: Center(
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: tabIndex == index
                              ? Colours.app_main
                              : Colors.black54,
                          fontSize: 14,
                          fontWeight: tabIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  void scrollToTab(int index) {
    double offset = 0;
    if (index == 1) {
      offset = key1H - 56 - pmPadd.top;
    } else if (index == 2) {
      offset = key1H + key2H - 56 - pmPadd.top;
    }
    controller.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget createBottomBackArrow(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget btmBtnView(
      String text, IconData icon, VoidCallback onTap, bool isActive) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colours.app_main : Colors.black54,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Colours.app_main : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future launch(showLoading) async {
    if (couponUrl == null) {
      if (!showLoading) {
        Loading.show(context);
      }
      await Future.delayed(Duration(milliseconds: 300));
      Loading.hide(context);
      ToastUtils.showToast('暂无优惠券链接');
      return;
    }

    try {
      // 这里需要实现启动应用的逻辑
      ToastUtils.showToast('功能开发中');
    } catch (e) {
      ToastUtils.showToast('打开链接失败');
    }
  }

  void onTapDialogLogin(BuildContext context, {required VoidCallback fun}) {
    // 这里应该检查登录状态，如果未登录则显示登录对话框
    // 简化处理，直接执行回调
    fun();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
