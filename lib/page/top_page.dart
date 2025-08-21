/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../widget/CustomWidgetPage.dart';

///实时疯抢榜
class TopPage extends StatefulWidget {
  final Map? data;

  const TopPage({Key? key, this.data}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Map> _tabList = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  @override
  bool get wantKeepAlive => true;

  ///tab数据
  Future<void> getTabData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      var res = await BService.rankingCate();
      if (res != null) {
        setState(() {
          _tabList = List<Map>.from(res);
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '网络异常';
      });
    }
  }

  AppBar buildTitle(BuildContext context, {
    required Color color,
    required String title,
    required Color widgetColor,
    Widget? leftIcon,
    VoidCallback? leftCallback,
  }) {
    return AppBar(
      backgroundColor: color,
      title: Text(
        title,
        style: TextStyle(color: widgetColor),
      ),
      leading: leftIcon != null
          ? IconButton(
              icon: leftIcon,
              onPressed: leftCallback,
            )
          : null,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool showArrowBack = (widget.data == null ||
         widget.data?['showArrowBack'] == null ||
        widget.data?['showArrowBack']);
    var leftIcon = showArrowBack
        ? Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )
        : SizedBox();
    var leftCallback = showArrowBack?()=>Navigator.pop(context):(){};
    
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      appBar: buildTitle(context,color:Colours.app_main,
          title: '实时榜单', widgetColor: Colors.white, leftIcon: leftIcon, leftCallback: leftCallback),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: getTabData,
              child: Text('重试'),
            ),
          ],
        ),
      );
    }
    
    if (_tabList.isEmpty) {
      return Center(child: Text('暂无数据'));
    }
    
    var tabList = _tabList.map<String>((m) => m['title'] as String).toList();
    return TabWidget(
      tabList: tabList,
      indicatorWeight: 2,
      color: Colours.app_main,
      unselectedColor: Colors.black,
      indicatorColor: Colors.transparent,
      fontWeight: FontWeight.normal,
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
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Map> _dataList = [];
  bool _hasMore = false;
  int _currentPage = 1;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
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
      String title = widget.tabValue['title'];
      int rankType = 1;
      if (title == '全天榜') {
        rankType = 2;
      }
      
      var res = await BService.rankingList(rankType, page, cid: widget.tabValue['id']);
      if (res != null) {
        setState(() {
          if (isRef) {
            _dataList = List<Map>.from(res);
          } else {
            _dataList.addAll(List<Map>.from(res));
          }
          _hasMore = res.length >= 200;
          _currentPage = page;
          _isLoading = false;
          _hasError = false;
        });
      }
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
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_hasError && _dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            SizedBox(height: 16),
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
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _dataList.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index >= _dataList.length) {
            // 加载更多指示器
            if (_hasMore) {
              getListData(page: _currentPage + 1);
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox();
          }
          
          var data = _dataList[index];
          return GestureDetector(
            onTap: () => Global.openFadeContainer(
              createItem(index, data), 
              ProductDetails(data)
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(10),
              child: createItem(index, data),
            ),
          );
        },
      ),
    );
  }

  Widget createItem(int i, Map data) {
    num fee = data['actualPrice']*data['commissionRate']/100;
    String shopType = data['shopType']==1?'天猫':'淘宝';
    String shopName = data['shopName'];
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            data['mainPic'] + '_300x300',
            width: 144,
            height: 144,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 144,
                height: 144,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitleWidget(data['title'], max: 2, size: 15),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colours.app_main,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      '爆卖',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colours.light_app_main,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        '已售${data['twoHoursSales']}件',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colours.app_main,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  getPriceWidget(data['actualPrice'], data['originalPrice'], endPrefix: '券后 '),
                ],
              ),
              SizedBox(height: 6),
              getMoneyWidget(context, fee, TB),
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '$shopType | $shopName',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
