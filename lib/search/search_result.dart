/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/search/model/search_param.dart';
import 'package:sufenbao/search/search_bar_widget.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/global.dart';

import '../util/custom.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';

var tabList = [
  {'name': '淘宝', 'img': 'assets/images/mall/tb.png'},
  {'name': '拼多多', 'img': 'assets/images/mall/pdd.png'},
  {'name': '京东', 'img': 'assets/images/mall/jd.png'},
  {'name': '抖音', 'img': 'assets/images/mall/dy.png'},
  {'name': '唯品会', 'img': 'assets/images/mall/vip.png'},
];

///搜索结果页
class SearchResultPage extends StatefulWidget {
  final Map data;
  const SearchResultPage(this.data, {Key? key}) : super(key: key);
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  int tabIndex = 0;
  SearchParam searchParam = SearchParam();

  var sort;

  var keyword;
  var tabDm = DataModel();
  bool loading = true;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    keyword = widget.data['keyword']??widget.data['itemName']
        ??widget.data['item_title']??widget.data['originContent'];

    await saveHistory();
    await this.superSearch();
    tabDm.addList(tabList, false, 0);

  }

  Future saveHistory() async {
    await BService.historySave(keyword);
  }

  ///超级搜索
  var superSearchDm = DataModel();
  Future<int> superSearch({int page = 1, bool isRef = false}) async {
    if (tabIndex == 0) {
      var res = await BService.goodsSearch(page, keyword,
              sort: searchParam.getTaoSortKey(sort))
          .catchError((v) {
        superSearchDm.toError('网络异常');
      });
      if (res != null) {
        superSearchDm.addList(res, isRef, 1000);
      }
      setState(() {
        loading = false;
      });
      return superSearchDm.flag;
    } else if (tabIndex == 1) {
      return pddSearch(page: page, isRef: isRef);
    } else if (tabIndex == 2) {
      return jdSearch(page: page, isRef: isRef);
    } else if (tabIndex == 3) {
      return dySearch(page: page, isRef: isRef);
    } else {
      return vipSearch(page: page, isRef: isRef);
    }
  }

  var listId = '';
  Future<int> pddSearch({int page = 1, bool isRef = false}) async {
    var sortKey = searchParam.getPddSortKey(sort);
    var res = await BService.pddSearch(page,
            keyword: keyword, sortType: sortKey, listId: listId)
        .catchError((v) {
      superSearchDm.toError('网络异常');
    });
    if (res != null) {
      num totalCount = res['totalCount'];
      if(totalCount > 0) {
        listId = res['listId'];
        //破接口返回数据不一致 做特殊处理
        if(res['goodsList'][0]['goodsName'] == null) {
          totalCount = 0;
          res['goodsList'] = [];
        }
      }
      superSearchDm.addList(res['goodsList'], isRef, totalCount);
    }
    setState(() {
      loading = false;
    });
    return superSearchDm.flag;
  }

  Future<int> jdSearch({int page = 1, bool isRef = false}) async {
    var sortKey = searchParam.getJdSortKey(sort);
    //京东销量排序第一页全是广告，从第二页开始搜
    if (sort == 2) {
      page = page + 1;
    }
    var res = await BService.jdList(page,
            keyword: keyword,
            sortName: sortKey['sortName'],
            sort: sortKey['sort'])
        .catchError((v) {
      superSearchDm.toError('网络异常');
    });
    if (res != null) {
      superSearchDm.addList(res['list'], isRef, res['totalNum']);
    }
    setState(() {
      loading = false;
    });
    return superSearchDm.flag;
  }
  Future<int> dySearch({int page = 1, bool isRef = false}) async {
    var sortKey = searchParam.getDySortKey(sort);
    var sortType = 1;
    if (sort == 4) {
      sortType = 0;
    }
    var res = await BService.dySearch(page,
            keyword: keyword, searchType: sortKey, sortType: sortType)
        .catchError((v) {
      superSearchDm.toError('网络异常');
    });
    if (res != null) {
      superSearchDm.addList(res['list'], isRef, res['total']);
    }
    setState(() {
      loading = false;
    });
    return superSearchDm.flag;
  }

  Future<int> vipSearch({int page = 1, bool isRef = false}) async {
    var sortKey = searchParam.getVipSortKey(sort);
    var order = 1;
    if (sort == 2 || sort == 4) {
      order = 0;
    }
    var res = await BService.vipSearch(page,
            keyword: keyword, fieldName: sortKey, order: order)
        .catchError((v) {
      superSearchDm.toError('网络异常');
    });
    if (res != null && (res['returnCode'] == null || res['returnCode'] != '1009')) {
      superSearchDm.addList(res['goodsInfoList'], isRef, res['total']);
    }
    setState(() {
      loading = false;
    });
    return superSearchDm.flag;
  }

  Future changeTab() async {
    setState(() {
      loading = true;
    });
    await superSearch(isRef: true, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      appBar: titleBarView(),
      brightness: Brightness.dark,
      body: PWidget.column([
        AnimatedSwitchBuilder(
          value: tabDm,
          isExd: true,
          errorOnTap: () => this.superSearch(),
          initViewIsCenter: true,
          noDataView: PWidget.boxh(0),
          errorView: PWidget.boxh(0),
          // initialState: PWidget.container(null, [double.infinity]),
          initialState: Global.showLoading2(),
          isAnimatedSize: false,
          listBuilder: (list, p, h) {
            return getListContent(list);
          },
        ),
        SearchSortWidget((v) {
          //0 综合 2销量 4价格从小到大 5价格从大到小
          sort = v;
          changeTab();
        }),
        PWidget.boxh(8),
        SousuoTabWidget((i) {
          tabIndex = i;
          changeTab();
        }),
        PWidget.boxh(MediaQuery.of(context).padding.bottom + 8)
      ]),
    );
  }

  ///标题栏视图
  Widget titleBarView() {
    return PWidget.container(
      PWidget.row([
        PWidget.container(
            PWidget.icon(
                Icons.arrow_back_ios_rounded, [Colors.black.withOpacity(0.75)]),
            [40, 40],
            {'fun': () => Navigator.pop(context)}),
        SearchBarWidget(
          keyword,
          DataModel(),
          autoFocus: false,
          onChanged: (v) {},
          onSubmit: (v, t) {
            keyword = v;
            setState(() {
              loading = true;
            });
            this.superSearch(page: 1, isRef: true);
          },
          onClear: () {
            Navigator.pop(context);
          },
          onTap: (f) {},
        ),
        PWidget.boxw(8),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8)},
    );
  }

  getListContent(list) {
    if (loading) {
      return Global.showLoading2();
    }
    return MyCustomScroll(
      isShuaxin: true,
      onRefresh: () => this.superSearch(isRef: true),
      onLoading: (p) => this.superSearch(page: p),
      refHeader: buildClassicHeader(color: Colors.grey),
      refFooter: buildCustomFooter(color: Colors.grey),
      isGengduo: superSearchDm.hasNext,
      crossAxisCount: 1,
      itemModel: superSearchDm,
      itemPadding: EdgeInsets.all(8),
      // divider: Divider(color: Colors.transparent, height: 8),
      itemModelBuilder: (i, v) {
        return PWidget.container(
            Global.openFadeContainer(createItem(v, i), searchParam.jump2Detail(context, tabIndex, v)),
          [null, null, Colors.white],
          {
            'sd': PFun.sdLg(Colors.black12),
            'br': 8,
            'mg': PFun.lg(0, 6),
            'crr': [5,5,5,5]
          },
        );
      }
    );
  }

  Widget createItem(v, i) {
      Map data = v as Map;
      String img = '';
      String sale = '0';
      num fee = 0;
      String title = '';
      String endPrice = '0';
      String startPrice = '0';
      String shopName = '';
      String jdOwner = '';
      String platform = TB;
      if (tabIndex == 0) {
        title = data['title'];
        img = data['white_image'] == ''
            ? data['pict_url']
            : data['white_image'];
        img = '${img}_310x310';
        sale = BService.formatNum(data['volume']);
        startPrice = data['zk_final_price'];
        double actualPrice = double.parse(startPrice) -
            (Global.isEmpty(data['coupon_amount']) ? 0 : double.parse(data['coupon_amount']));
        fee = data['commission_rate'] * actualPrice / 100;
        endPrice = actualPrice.toStringAsFixed(2);
        shopName = data['shop_title'];
        platform = TB;
      } else if (tabIndex == 1) {
        title = data['goodsName'];
        img = data['goodsImageUrl'];
        sale = data['salesTip'];
        fee = data['promotionRate'] * data['minGroupPrice'] / 100;
        endPrice = data['minGroupPrice'].toString();
        startPrice = data['minNormalPrice'].toString();
        shopName = data['mallName'];
        platform = PDD;
      } else if (tabIndex == 2) {
        title = data['skuName'];
        img = data['whiteImage'] == ''
            ? data['imageUrlList'][0]
            : data['whiteImage'];
        sale = data['inOrderCount30Days'].toString();
        fee = data['couponCommission'];
        endPrice = data['lowestCouponPrice'].toString();
        startPrice = data['lowestPrice'].toString();
        shopName = data['shopName'];
        jdOwner = data['owner'];
        platform = JD;
      } else if (tabIndex == 3) {
        title = data['title'];
        img = data['cover'];
        sale = BService.formatNum(data['sales']);
        fee = data['cosFee'];
        endPrice = data['price'].toString();
        startPrice = data['price'].toString();
        shopName = data['shopName'];
        platform = DY;
      }else if (tabIndex == 4) {
        title = data['goodsName'];
        img = data['white_image'] == null
            ? data['goodsMainPicture']
            : data['white_image'];
        if(!Global.isEmpty(data['sales'])) {
          sale = BService.formatNum(data['sales']);
        }
        fee = double.parse(data['commission']);
        endPrice = data['vipPrice'].toString();
        startPrice = data['marketPrice'].toString();
        shopName = data['storeInfo']['storeName'];
        platform = VIP;
      }
      return PWidget.container(PWidget.row(
          [
            PWidget.wrapperImage(img, [124, 124], {'br': 8}),
            PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                getTitleWidget(title, max: 2),
                // PWidget.text('${data['title']}', {'max': 2, 'exp': true}),
              ], [
                '0',
                '1',
                '1'
              ]),
              PWidget.boxh(8),
              PWidget.row([
                getPriceWidget(endPrice, startPrice),
              ],),
              PWidget.boxh(8),
              getMoneyWidget(context, fee, platform),
              PWidget.spacer(),
              PWidget.row([
                jdOwner == 'g'
                    ? PWidget.container(
                  PWidget.text('自营', [Colors.white, 9]),
                  [null, null, Colors.red],
                  {
                    'bd': PFun.bdAllLg(Colors.red, 0.5),
                    'pd': PFun.lg(1, 1, 4, 4),
                    'br': PFun.lg(4, 4, 4, 4)
                  },
                )
                    : SizedBox(),
                jdOwner == 'g' ? PWidget.boxw(4) : SizedBox(),
                PWidget.text(shopName, [Colors.black54, 12], {'exp': true}),
                tabIndex ==4 ? SizedBox() : PWidget.text('已售$sale', [Colors.black54, 12]),
              ])
            ], {
              'exp': 1,
            }),
          ],
          '001',
          {'fill': true},
        ),

      [null, null, Colors.white],
          {'pd':8}
      );

  }
}

///搜索tab
class SousuoTabWidget extends StatefulWidget {
  final Function(int) fun;

  const SousuoTabWidget(this.fun, {Key? key}) : super(key: key);
  @override
  _SousuoTabWidgetState createState() => _SousuoTabWidgetState();
}

class _SousuoTabWidgetState extends State<SousuoTabWidget> {
  var tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PWidget.row(
      List.generate(tabList.length, (i) {
        var isDy = tabIndex == i;
        var mg = PFun.lg(0, 0, 0, tabList.length - 1 == i ? 0 : 8);
        return PWidget.container(
          PWidget.row([
            PWidget.container(
                PWidget.image(tabList[i]['img'], [14, 14]), {'crr': 14}),
            PWidget.boxw(4),
            PWidget.text(tabList[i]['name'],
                [isDy ? Colors.red : Colors.black, 12, true]),
          ]),
          [null, null, Colors.red.withOpacity(isDy ? 0.1 : 0)],
          {
            'fun': () {
              widget.fun(i);
              setState(() => tabIndex = i);
            },
            'mg': mg,
            'pd': PFun.lg(8, 8, 12, 12),
            'br': 56
          },
        );
      }),
      {'pd': 12},
    );
  }
}

///排序组件
class SearchSortWidget extends StatefulWidget {
  final Function(int) fun;
  const SearchSortWidget(this.fun, {Key? key}) : super(key: key);
  @override
  _SearchSortWidgetState createState() => _SearchSortWidgetState();
}

class _SearchSortWidgetState extends State<SearchSortWidget> {
  var sortIndex = 0;
  var sort = 0;

  var sortList = ['综合', '销量', '价格'];

  @override
  Widget build(BuildContext context) {
    return PWidget.row(
      List.generate(sortList.length, (i) {
        return PWidget.container(
          sortTag(sortList[i], i),
          [null, null, Colors.red.withOpacity(i == sortIndex ? 0.1 : 0)],
          {'br': 56, 'pd': PFun.lg(4, 4, 12, 12)},
        );
      }),
      '141',
    );
  }

  // 排序标记文字
  Widget sortTag(name, i) {
    return PWidget.ccolumn([
      if (name == '价格')
        PWidget.row([
          PWidget.text('价格', [
            i == sortIndex
                ? Colors.red.withOpacity(0.75)
                : Colors.black.withOpacity(i == sortIndex ? 0.75 : 0.25),
            12,
            true
          ]),
          PWidget.container(
            Stack(clipBehavior: Clip.none, children: [
              PWidget.positioned(
                  PWidget.icon(Icons.arrow_drop_up_rounded,
                      [Colors.red.withOpacity(sort == 4 ? 0.75 : 0.25), 16]),
                  [0]),
              PWidget.positioned(
                  PWidget.icon(Icons.arrow_drop_down_rounded,
                      [Colors.red.withOpacity(sort == 5 ? 0.75 : 0.25), 16]),
                  [7]),
            ]),
            [16, 24],
          ),
        ], '220')
      else
        PWidget.text(name ?? '文本', [
          i == sortIndex
              ? Colors.red.withOpacity(0.75)
              : Colors.black.withOpacity(i == sortIndex ? 0.75 : 0.25),
          12,
          true
        ]),
      // PWidget.container(null, [40, 2, Colors.red.withOpacity(i == sortIndex ? 1 : 0)], {'br': 8, 'mg': 4}),
    ], {
      // 'exp': 1,
      'fun': () {
        setState(() => sortIndex = i);
        sort = [0, 2, sort][sortIndex];
        if (sortIndex == 2) sort = sort == 4 ? 5 : 4;
        widget.fun(sort);
      }
    });
  }
}
