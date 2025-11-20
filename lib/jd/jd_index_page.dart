/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sufenbao/jd/jd_details_page.dart';
import 'package:sufenbao/util/value_util.dart';
import 'package:sufenbao/widget/tab_widget.dart';
import 'package:sufenbao/service.dart';
import '../util/colors.dart';

class DataModel<T> {
  List list = [];
  T? object;
  bool hasError = false;
  bool hasNext = false;
  int flag = 0;

  void addList(List newList, bool clear, int newFlag) {
    if (clear) {
      list.clear();
    }
    list.addAll(newList);
    flag = newFlag;
    hasError = false;
  }

  void addObject(T newObject) {
    object = newObject;
    hasError = false;
  }

  void setError() {
    hasError = true;
  }
}

///京东首页
class JdIndexPage extends StatefulWidget {
  @override
  _JdIndexPageState createState() => _JdIndexPageState();
}

class _JdIndexPageState extends State<JdIndexPage> {
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
  var tabDm = DataModel();

  Future<int> getTabData() async {
    tabDm.addList([
      {'title': '精选', 'index': 1},
      {'title': '大牌', 'index': 2},
      {'title': '9.9', 'index': 3}
    ], true, 0);
    setState(() {});

    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colours.jd_main, Colors.white],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('京东特价'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (tabDm.hasError) {
      return Center(
        child: GestureDetector(
          onTap: () => getTabData(),
          child: Text('点击重试'),
        ),
      );
    }

    if (tabDm.list.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<String> tabList = tabDm.list.map((e) => e['title'].toString()).toList();
    return TabWidget(
      tabList: tabList,
      indicatorColor: Colors.white.withValues(alpha: 0),
      tabPage: List.generate(tabList.length, (i) {
        return JdListView(tabDm.list[i] as Map);
      }),
    );
  }

  ///9.9精选数据
  var goodsNineTopDm = DataModel<Map>();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<int> getGoodsNineTop() async {
    var res = await BService.nineTop();

    if (res['goodsList'] != null) {
      goodsNineTopDm.addList(res['goodsList'], true, 0);
    } else {
      goodsNineTopDm.setError();
    }
    setState(() {});
    return goodsNineTopDm.flag;
  }

  void _onRefresh() async {
    await getGoodsNineTop();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }
}

class JdListView extends StatefulWidget {
  final Map data;
  JdListView(this.data);

  @override
  _JdListViewState createState() => _JdListViewState();
}

class _JdListViewState extends State<JdListView> {
  var goodsNineTopDm = DataModel<Map>();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getGoodsNineTop();
  }

  Future<int> getGoodsNineTop() async {
    var res = await BService.nineTop();
    final goodsList = ValueUtil.toList(res['goodsList']);
    if (goodsList.isNotEmpty) {
      goodsNineTopDm.addList(goodsList, true, 0);
    } else {
      goodsNineTopDm.setError();
    }
    setState(() {});
    return goodsNineTopDm.flag;
  }

  void _onRefresh() async {
    await getGoodsNineTop();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(),
      footer: ClassicFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(headers),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 0.64,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= goodsNineTopDm.list.length) return null;
                var item = goodsNineTopDm.list[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JDDetailsPage(item),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.all(8),
                    child: createHeaderItem(item),
                  ),
                );
              },
              childCount: goodsNineTopDm.list.length,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get headers {
    return [
      _buildGoodsNineTopWidget(),
    ];
  }

  Widget _buildGoodsNineTopWidget() {
    if (goodsNineTopDm.hasError) {
      return GestureDetector(
        onTap: () => getGoodsNineTop(),
        child: SizedBox.shrink(),
      );
    }

    if (goodsNineTopDm.list.isEmpty) {
      return Container(
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(color: Colours.jd_main),
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 12),
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
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
                padding: EdgeInsets.only(left: 2),
                child: Image.asset(
                  'assets/images/mall/hot.png',
                  width: 14,
                  height: 14,
                ),
              ),
              Text(
                '2.4万人正在抢',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: goodsNineTopDm.list.length,
              separatorBuilder: (context, index) => SizedBox(width: 12),
              itemBuilder: (context, index) {
                var item = goodsNineTopDm.list[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JDDetailsPage(item),
                      ),
                    );
                  },
                  child: createHeaderItem(item),
                );
              },
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget createHeaderItem(data) {
    String img = ValueUtil.toStr(data['pic']);
    return Container(
      width: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
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
          ),
          Container(
            margin: EdgeInsets.fromLTRB(2, 1, 8, 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              '疯抢${data['xiaoliang']}件',
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ),
          Spacer(),
          Row(
            children: [
              SizedBox(width: 4),
              if (data['owner'] == 'g')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colours.jd_main,
                    border: Border.all(color: Colours.jd_main, width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '自营',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              if (data['owner'] == 'g') SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${data['title']}',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Spacer(),
          getPriceWidget(ValueUtil.toStr(data['jiage']), ValueUtil.toStr(data['yuanjia']))
        ],
      ),
    );
  }

  Widget getPriceWidget(
    String actualPrice,
    String originalPrice, {
    double endTextSize = 16,
    String startPrefix = '',
    double endPrefixSize = 12,
    Color endTextColor = Colors.red,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          if (startPrefix.isNotEmpty)
            TextSpan(
              text: startPrefix,
              style: TextStyle(
                color: Colors.black54,
                fontSize: endPrefixSize,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          if (originalPrice.isNotEmpty && originalPrice != actualPrice)
            TextSpan(
              text: '¥$originalPrice ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          TextSpan(
            text: '¥',
            style: TextStyle(
              color: endTextColor,
              fontSize: endPrefixSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: actualPrice,
            style: TextStyle(
              color: endTextColor,
              fontSize: endTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
