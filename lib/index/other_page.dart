/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sufenbao/service.dart';
import '../models/data_model.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../page/product_details.dart';

///其它分类页面
class OtherPage extends StatefulWidget {
  final Map data;

  const OtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  int sortValue = 0;
  late RefreshController _refreshController;

  Size get pmSize => MediaQuery.of(context).size;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int? sort, int page = 1, bool isRef = false}) async {
    if (sort != null) sortValue = sort;
    var res = await BService.getGoodsList(page, cid: widget.data['cid'], sort: sortValue).catchError((v) {
      listDm.toError('网络异常');
      return <String, dynamic>{};
    });
    if (res.isNotEmpty) {
      var list = res['list'];
      var totalNum = res['totalNum'];
      listDm.addList(list, isRef, totalNum);
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF4F5F6),
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: listDm.hasNext,
            header: ClassicHeader(
              textStyle: TextStyle(color: Colors.grey),
            ),
            footer: ClassicFooter(
              textStyle: TextStyle(color: Colors.grey),
            ),
            controller: _refreshController,
            onRefresh: () async {
              await getListData(isRef: true);
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              await getListData(page: listDm.page + 1);
              _refreshController.loadComplete();
            },
            child: CustomScrollView(slivers: [
              SliverList.list(children: headers),
              SliverList.builder(
                // padding: EdgeInsets.only(left: 8, right: 8),
                itemCount: listDm.list.length,
                itemBuilder: (context, index) {
                  var item = listDm.list[index];

                  return Container(
                    margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Global.openFadeContainer(createItem(index, item), ProductDetails(item)),
                  );
                },
              )
            ])));
  }

  Widget createItem(i, v) {
    num fee = v['actualPrice'] * v['commissionRate'] / 100;

    String sale = BService.formatNum(v['monthSales']);
    return Container(
      padding: EdgeInsets.all(8),
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              '${v['mainPic']}_310x310',
              width: 135,
              height: 129,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [Expanded(child: getTitleWidget(v['title'], max: 2, size: 15))],
                ),
                SizedBox(height: 8),
                getMoneyWidget(context, fee, TB),
                // Spacer(),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: ' 券后 ',
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          TextSpan(
                            text: '¥',
                            style: TextStyle(color: Colours.app_main, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${v['actualPrice']}',
                            style: TextStyle(color: Colours.app_main, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colours.app_main),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            '券',
                            style: TextStyle(color: Colours.app_main, fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colours.app_main,
                            border: Border.all(color: Colours.app_main),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            '${v['couponPrice']}元',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${v['shopName']}',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                    Spacer(),
                    getSalesWidget(sale),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get headers {
    return [
      Builder(builder: (context) {
        var subcategories = widget.data['subcategories'] as List;
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          color: Colors.white,
          child: Column(
            children: [
              Wrap(
                runSpacing: 8,
                children: List.generate(subcategories.length, (i) {
                  var wh = (pmSize.width - 32) / 4;
                  var subcategorie = subcategories[i];
                  var scpic = subcategorie['scpic'];
                  var subcname = subcategorie['subcname'];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, '/searchResult', arguments: {'keyword': subcategorie['subcname']})
                      // ref.watch(searchProvider.notifier).submit(subcategorie['subcname']);

                      Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
                    },
                    child: Container(
                      width: wh,
                      height: wh,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.network(
                              '$scpic',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '$subcname',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              SortWidget((v) => this.getListData(isRef: true, sort: v)),
            ],
          ),
        );
      }),
    ];
  }
}

///排序组件
class SortWidget extends StatefulWidget {
  final Function(int) fun;
  const SortWidget(this.fun, {Key? key}) : super(key: key);
  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  var sortIndex = 0;
  var sort = 0;

  var sortList = ['人气', '最新', '销量', '价格'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(sortList.length, (i) {
        return sortTag(sortList[i], i);
      }),
    );
  }

  // 排序标记文字
  Widget sortTag(name, i) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => sortIndex = i);
          sort = [0, 1, 3, sort][sortIndex];
          if (sortIndex == 3) sort = sort == 6 ? 5 : 6;
          widget.fun(sort);
        },
        child: Column(
          children: [
            if (name == '价格')
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '价格',
                    style: TextStyle(
                      color: Colors.black.withOpacity(i == sortIndex ? 0.75 : 0.25),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 16,
                    height: 24,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 2,
                          child: Icon(
                            Icons.arrow_drop_up_rounded,
                            color: Colors.black.withOpacity(sort == 6 ? 0.75 : 0.25),
                            size: 16,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Colors.black.withOpacity(sort == 5 ? 0.75 : 0.25),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Text(
                name ?? '文本',
                style: TextStyle(
                  color: Colors.black.withOpacity(i == sortIndex ? 0.75 : 0.25),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 20,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(i == sortIndex ? 1 : 0),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
