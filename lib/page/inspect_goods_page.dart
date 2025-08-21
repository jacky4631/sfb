/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../widget/lunbo_widget.dart';
import '../widget/tab_widget.dart';

//爆款验货
class InspectGoodsPage extends StatefulWidget {
  final Map data;
  const InspectGoodsPage(this.data, {Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<InspectGoodsPage> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;
  
  // 替换DataModel的状态管理
  List<Map> _tabList = [];
  bool _tabLoading = true;
  bool _tabError = false;

  @override
  void initState() {
    super.initState();

    // 对 scrollController 进行监听
    _scrollController.addListener(() {
      // _scrollController.position.pixels 获取当前滚动部件滚动的距离
      // 当滚动距离大于 800 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.position.pixels >= 800);
    });
    getTabData();
  }

  ///tab数据
  Future<void> getTabData() async {
    try {
      setState(() {
        _tabLoading = true;
        _tabError = false;
      });
      
      var tabData = Global.getFullCategory();
      _tabList = List<Map>.from(tabData);
      
      setState(() {
        _tabLoading = false;
      });
    } catch (e) {
        setState(() {
          _tabLoading = false;
          _tabError = true;
        });
      }
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List imgs = [{'img':'https://img.alicdn.com/imgextra/i1/2053469401/O1CN01TbOBvx2JJiAJR6p32_!!2053469401.png'}];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF39A638), Colors.white],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: _showBackTop
              ? FloatingActionButton(
                  backgroundColor: Colors.grey[300],
                  onPressed: () {
                    _scrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  },
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                )
              : null,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: Stack(
              children: [
                LunboWidget(
                  imgs,
                  value: 'img',
                  aspectRatio: 75 / 31,
                  loop: false,
                  fun: (v) {},
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_tabLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
        ),
      );
    }

    if (_tabError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64),
            SizedBox(height: 16),
            Text(
              '加载失败',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: getTabData,
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_tabList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text(
              '暂无数据',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    var tabList = _tabList.map<String>((m) => m['name'] as String).toList();
    return TabWidget(
      tabList: tabList,
      indicatorColor: Colors.white,
      tabPage: List.generate(tabList.length, (i) {
        return TopChild(_scrollController, _tabList[i]);
      }),
    );
  }
}

class TopChild extends StatefulWidget {
  final ScrollController scrollController;
  final Map data;
  const TopChild(this.scrollController, this.data, {Key? key})
      : super(key: key);
  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  // 替换DataModel的状态管理
  List<Map> _dataList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasNext = false;
  int _currentPage = 1;
  int _totalNum = 0;
  bool _isLoadingMore = false;
  
  final ScrollController _listScrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _listScrollController.addListener(_onScroll);
    initData();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_listScrollController.position.pixels >=
        _listScrollController.position.maxScrollExtent - 200) {
      if (_hasNext && !_isLoadingMore) {
        _loadMore();
      }
    }
  }

  ///初始化函数
  Future<void> initData() async {
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

      var res = await BService.getGoodsList(page, inspectedGoods: 1, cid: widget.data['cid']);
      
      if (res.isNotEmpty) {
        var list = List<Map>.from(res['list'] ?? []);
        var totalNum = res['totalNum'] ?? 0;
        
        setState(() {
          if (isRef) {
            _dataList = list;
          } else {
            _dataList.addAll(list);
          }
          _totalNum = totalNum;
          _hasNext = _dataList.length < _totalNum;
          _currentPage = page;
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _hasError = true;
          _errorMessage = '网络异常';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _hasError = true;
        _errorMessage = '网络异常';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasNext) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    await getListData(page: _currentPage + 1, isRef: false);
  }

  Future<void> _onRefresh() async {
    await getListData(isRef: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff9cc8c)),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.black, fontSize: 16),
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

    return _buildContent();
  }

  Widget _buildContent() {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: GridView.builder(
        controller: _listScrollController,
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _dataList.length + (_hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _dataList.length) {
            return _buildLoadingItem();
          }
          
          var item = _dataList[index];
          return _buildGridItem(index, item);
        },
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      margin: EdgeInsets.only(top: _dataList.length % 2 == 1 ? 0 : 12),
      child: Center(
        child: _isLoadingMore
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildGridItem(int index, Map item) {
    return GestureDetector(
       onTap: () {
         Global.openFadeContainer(
           _createItemContent(index, item),
           ProductDetails(item),
         );
       },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: _createItemContent(index, item),
      ),
    );
  }

  Widget _createItemContent(int index, Map item) {
    var img = '${item['mainPic']}_310x310';
    var sale = BService.formatNum(item['monthSales']);
    int descMaxLine = index % 3 + 2;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${item['desc']}',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: descMaxLine,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: getPriceWidget('${item['actualPrice']}元', '${item['actualPrice']}元'),
                    ),
                    getSalesWidget(sale),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
