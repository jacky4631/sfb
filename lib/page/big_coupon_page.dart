/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/tao_util.dart';

///大额优惠券
class BigCouponPage extends StatefulWidget {
  final Map? data;

  const BigCouponPage({Key? key, this.data}) : super(key: key);

  @override
  _BigCouponPageState createState() => _BigCouponPageState();
}

class _BigCouponPageState extends State<BigCouponPage>{
  List<Map> _tabList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

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
        _isLoading = true;
        _hasError = false;
      });
      
      var res = await BService.cmsCate('411');
      if (res.isNotEmpty) {
        res.removeAt(0);
        _tabList = List<Map>.from(res);
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '网络异常';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showArrowBack = (widget.data == null || widget.data!['showArrowBack']);
    
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
              '大额券热卖清单',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: showArrowBack
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            centerTitle: true,
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.white),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: getTabData,
              child: Text('重试'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colours.app_main,
              ),
            ),
          ],
        ),
      );
    }

    if (_tabList.isEmpty) {
      return Center(
        child: Text(
          '暂无数据',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    var tabList = _tabList.map<String>((m) => m['title'] as String).toList();
    return TabWidget(
      tabList: tabList,
      indicatorWeight: 2,
      tabPage: List.generate(tabList.length, (i) {
        return TopChild(_tabList[i]);
      }),
    );
  }
}

class TopChild extends StatefulWidget {
  final Map tabValue;

  const TopChild(this.tabValue, {Key? key}) : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  List<Map> _dataList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasMore = false;
  int _currentPage = 1;
  int _totalNum = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    initData();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoading) {
        getListData(page: _currentPage + 1);
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    try {
      if (isRef) {
        setState(() {
          _isLoading = true;
          _hasError = false;
          _currentPage = 1;
        });
      }

      String url = widget.tabValue['config']['url'];
      var res = await BService.goodsBigList(page, url);
      
      List<Map> newList = List<Map>.from(res['list'] ?? []);
      _totalNum = res['totalNum'] ?? 0;
      
      if (isRef) {
        _dataList = newList;
      } else {
        _dataList.addAll(newList);
      }
      
      _currentPage = page;
      _hasMore = _dataList.length < _totalNum;
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '网络异常';
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
            Icon(Icons.error_outline, size: 64, color: Colors.white),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colours.app_main,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      color: Colours.app_main,
      backgroundColor: Colors.white,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: _dataList.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= _dataList.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            );
          }
          
          var data = _dataList[index];
          return Global.openFadeContainer(createItem(data), ProductDetails(data));
        },
      ),
    );
  }

  Widget createItem(Map data) {
    String sale = BService.formatNum(data['monthSales']);
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              getTbMainPic(data),
              width: 124,
              height: 124,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 124,
                  height: 124,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['dtitle'] ?? '',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                getPriceWidget(data['actualPrice'], data['originalPrice']),
                SizedBox(height: 8),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 32,
                      margin: EdgeInsets.only(right: 45),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFAEDE6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '热销',
                              style: TextStyle(color: Color(0xff793E1B), fontSize: 12),
                            ),
                            TextSpan(
                              text: '$sale+',
                              style: TextStyle(color: Colours.app_main, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/mall/ljq.jpg',
                          width: 90,
                          height: 39,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 39,
                              decoration: BoxDecoration(
                                color: Colours.app_main,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '马上抢',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
