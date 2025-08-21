/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/tao_util.dart';
import '../service.dart';

//品牌特卖
class BrandSalePage extends StatefulWidget {
  final Map? data;

  const BrandSalePage({Key? key, this.data}) : super(key: key);

  @override
  _BrandSalePageState createState() => _BrandSalePageState();
}

class _BrandSalePageState extends State<BrandSalePage> {
  @override
  Widget build(BuildContext context) {
    List tabs = Global.getFullCategory();
    List<String> tabList = tabs.map((e) => e['name'].toString()).toList();
    bool showArrowBack =
        (widget.data == null || widget.data!['showArrowBack'] == null || widget.data!['showArrowBack']);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colours.app_main, Colors.white],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              '品牌特卖',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: showArrowBack
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            centerTitle: true,
          ),
          body: TabWidget(
            tabList: tabList,
            tabPage: List.generate(tabList.length, (i) {
              return i == 0 ? HomeChild(tabs[i]) : HomeChildOther(tabs[i]);
            }),
          ),
        ),
      ),
    );
  }
}

class HomeChild extends StatefulWidget {
  final Map tabData;

  const HomeChild(this.tabData, {Key? key}) : super(key: key);

  @override
  _HomeChildState createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  List<Map> _dataList = [];
  bool _isLoading = true;
  bool _hasError = false;
  ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  int _currentPage = 1;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        getListData(page: _currentPage + 1);
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  Future getShopData(shopId, shopName) async {
    var res = await BService.shopConvert(shopId, shopName);
    if (res != null) {
      LaunchApp.launchTb(context, res['shopLinks']);
    }
  }

  ///列表数据
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _currentPage = 1;
      });
    }

    try {
      int cid = widget.tabData['cid'];
      var res = await BService.brandList(page, cid);
      if (res.isNotEmpty) {
        setState(() {
          if (isRef) {
            _dataList = List<Map>.from(res['list']);
          } else {
            _dataList.addAll(List<Map>.from(res['list']));
          }
          _totalCount = int.parse(res['total_num']);
          _hasMore = _dataList.length < _totalCount;
          _currentPage = page;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _dataList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_hasError && _dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 64),
            SizedBox(height: 16),
            Text(
              '加载失败',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      color: Colors.white,
      backgroundColor: Colours.app_main,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        itemCount: _dataList.length + 1,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '口碑品牌',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '买赠送好礼、折扣享不停',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            );
          }

          int dataIndex = index - 1;
          if (dataIndex >= _dataList.length) {
            return _hasMore
                ? Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SizedBox();
          }

          var data = _dataList[dataIndex];
          var productList = data['list'] as List;
          var sales = BService.formatNum(data['sales']);
          var fans = BService.formatNum(data['fansNum']);
          var brandBg = getTbMainPic(data);

          if (productList.isEmpty || (data['brandName'] as String).isEmpty) {
            return SizedBox();
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        BService.formatUrl(data['brandLogo']),
                        width: 40,
                        height: 40,
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      data['brandName'],
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.75),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (brandBg.startsWith("http")) ...[
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      List list = data['list'] as List;
                      if (list.isNotEmpty) {
                        getShopData(list[0]['sellerId'], list[0]['shopName']);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(brandBg),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['brand_text'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              data['brandFeatures'],
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '粉丝:',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: fans,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: '\t|\t',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: '近期销量:',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: sales,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                if (productList.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Container(
                      height: ((MediaQuery.of(context).size.width - 64) / 3) + 80,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            var product = productList[index];
                            return Expanded(
                              child: Global.openFadeContainer(
                                createItem(product),
                                ProductDetails(product),
                              ),
                            );
                          })),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget createItem(product) {
    var w = (MediaQuery.of(context).size.width - 64) / 3;
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              getTbMainPic(product),
              width: w,
              height: w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: w,
                  height: w,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Spacer(),
          getPriceWidget(product['actualPrice'], product['originPrice']),
          Spacer(),
          Builder(builder: (context) {
            ///是否包含旗舰店
            var contains = ('${product['shopName']}'.contains('旗舰店'));
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red.withValues(alpha: contains ? 1 : 0),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                contains ? '旗舰店' : '',
                style: TextStyle(color: Colours.app_main, fontSize: 12),
              ),
            );
          }),
          Spacer(),
          Text(
            '已售${product['monthSales']}件',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class HomeChildOther extends StatefulWidget {
  final Map tabData;

  const HomeChildOther(this.tabData, {Key? key}) : super(key: key);

  @override
  _HomeChildOtherState createState() => _HomeChildOtherState();
}

class _HomeChildOtherState extends State<HomeChildOther> {
  List<Map> _dataList = [];
  bool _isLoading = true;
  bool _hasError = false;
  ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  int _currentPage = 1;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        getListData(page: _currentPage + 1);
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  Future getShopData(brandId) async {
    var res = await BService.brandGoodsList(brandId);
    if (res.isNotEmpty) {
      List list = res['list'];
      if (list.isNotEmpty) {
        var shopData = await BService.shopConvert(list[0]['sellerId'], list[0]['shopName']);
        if (shopData.isNotEmpty) {
          LaunchApp.launchTb(context, shopData['shopLinks']);
        }
      }
    }
  }

  ///列表数据
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _currentPage = 1;
      });
    }

    try {
      int cid = widget.tabData['cid'];
      var res = await BService.brandList(page, cid);
      if (res.isNotEmpty) {
        setState(() {
          if (isRef) {
            _dataList = List<Map>.from(res['lists']);
          } else {
            _dataList.addAll(List<Map>.from(res['lists']));
          }
          _totalCount = res['totalCount'];
          _hasMore = _dataList.length < _totalCount;
          _currentPage = page;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _dataList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_hasError && _dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 64),
            SizedBox(height: 16),
            Text(
              '加载失败',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      color: Colors.white,
      backgroundColor: Colours.app_main,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        itemCount: _dataList.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= _dataList.length) {
            return Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          var data = _dataList[index];
          var productList = data['goodsList'] as List;
          String logo = data['brandLogo'];
          if (!logo.startsWith('http')) {
            logo = 'https:$logo';
          }
          String sale = BService.formatNum(data['sales']);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    getShopData(data['brandId']);
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          logo,
                          width: 40,
                          height: 40,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        data['brandName'],
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '已售${sale}件',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_sharp,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '品牌折扣低至${data['maxDiscount']}折',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                ),
                if (productList.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Container(
                    height: ((MediaQuery.of(context).size.width - 64) / 3) + 80,
                    child: Row(
                      children: List.generate(productList.length, (i) {
                        var product = productList[i];
                        return Expanded(
                          child: Global.openFadeContainer(
                            createOtherItem(product),
                            ProductDetails(product),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget createOtherItem(product) {
    var w = (MediaQuery.of(context).size.width - 64) / 3;
    String sale = BService.formatNum(product['monthSales']);
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              getTbMainPic(product),
              width: w,
              height: w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: w,
                  height: w,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '¥',
                  style: TextStyle(
                    color: Colours.app_main,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${product['actualPrice']}  ',
                  style: TextStyle(
                    color: Colours.app_main,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '¥${product['originPrice']}',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Builder(builder: (context) {
            ///是否包含旗舰店
            var contains = ('${product['shopName']}'.contains('旗舰店'));
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red.withValues(alpha: contains ? 1 : 0),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                contains ? '旗舰店' : '',
                style: TextStyle(color: Colours.app_main, fontSize: 12),
              ),
            );
          }),
          Spacer(),
          Text(
            '已售${sale}件',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
