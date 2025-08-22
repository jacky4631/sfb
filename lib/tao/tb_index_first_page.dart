import 'package:flutter/material.dart';
import '../service.dart';
import '../widget/CustomWidgetPage.dart';
import '../page/product_details.dart';
import '../util/global.dart';

///首页
class TbIndexFirstPage extends StatefulWidget {
  @override
  _TbIndexFirstPageState createState() => _TbIndexFirstPageState();
}

class _TbIndexFirstPageState extends State<TbIndexFirstPage> {
  List<Map> _goodsList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasNext = true;
  int _currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasNext && !_isLoading) {
        getListData(page: _currentPage + 1);
      }
    }
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (_isLoading) return 0;

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (isRef) {
        _goodsList.clear();
        _currentPage = 1;
      }
    });

    try {
      var res = await BService.getGoodsList(page);
      List<Map> newList = List<Map>.from(res['list'] ?? []);
      int totalNum = res['totalNum'] ?? 0;

      if (isRef) {
        _goodsList = newList;
      } else {
        _goodsList.addAll(newList);
      }

      _currentPage = page;
      _hasNext = _goodsList.length < totalNum;
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = '网络异常';
    }

    setState(() {
      _isLoading = false;
    });

    return _hasError ? -1 : 1;
  }

  Widget _buildTbFadeContainer(BuildContext context, int index, Map data) {
    return Container(
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
      margin: EdgeInsets.only(
        left: index % 2 == 0 ? 0 : 8,
        right: index % 2 == 1 ? 0 : 8,
      ),
      child: Global.openFadeContainer(
        createTbItem(context, index, data),
        ProductDetails(data),
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError && _goodsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_goodsList.isEmpty && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_goodsList.isEmpty) {
      return Center(
        child: Text('暂无数据', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          ...headers.map((widget) => SliverToBoxAdapter(child: widget)),
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _goodsList.length) {
                    return _buildTbFadeContainer(context, index, _goodsList[index]);
                  } else {
                    return Center(
                      child: _isLoading ? CircularProgressIndicator() : (_hasNext ? Text('加载更多...') : Text('没有更多了')),
                    );
                  }
                },
                childCount: _goodsList.length + (_hasNext ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F6),
      body: _buildBody(),
    );
  }

  List<Widget> get headers {
    return [];
  }
}
