/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/launchApp.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../service.dart';
import '../util/tao_util.dart';

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
    bool showArrowBack = (widget.data == null
        || widget.data!['showArrowBack'] == null || widget.data!['showArrowBack']);
    var leftIcon = showArrowBack? Icon(Icons.arrow_back_ios, color: Colors.white,):null;
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity], {'gd': PFun.tbGd(Colours.app_main, Colors.white)}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.light,
            appBar: buildTitle(context, title: '品牌特卖', widgetColor: Colors.white, leftIcon: leftIcon),
            body: TabWidget(
              tabList: tabList,
              tabPage: List.generate(tabList.length, (i) {
                return i==0 ? HomeChild(tabs[i]) : HomeChildOther(tabs[i]);
              }),
            ),
          ),
        ],
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
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }
  Future getShopData(shopId, shopName) async {
    var res = await BService.shopConvert(shopId, shopName);
    if (res != null) {
      LaunchApp.launchTb(context, res['shopLinks']);
    };
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    int cid = widget.tabData['cid'];
    var res = await BService.brandList(page, cid);
    if (res != null) {
        listDm.addList(res['list'], isRef, int.parse(res['total_num']));
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colors.white),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          header: buildClassicHeader(color: Colors.white),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          itemCount: list.length + 1,
          listViewType: ListViewType.Separated,
          padding: const EdgeInsets.all(12),
          divider: const Divider(height: 12, color: Colors.transparent),
          item: (i) {
            if (i == 0)
              return PWidget.ccolumn([
                PWidget.text('口碑品牌', [Colors.white, 20, true]),
                PWidget.boxh(4),
                PWidget.text('买赠送好礼、折扣享不停', [Colors.white, 14]),
              ]);
            i = i - 1;
            var data = list[i] as Map;
            var productList = data['list'] as List;
            var sales = BService.formatNum(data['sales']);
            var fans = BService.formatNum(data['fansNum']);
            var brandBg = getTbMainPic(data);
            if(productList.isEmpty || (data['brandName'] as String).isEmpty) {
              return SizedBox();
            }
            return PWidget.container(
              PWidget.column([
                PWidget.row([
                  PWidget.wrapperImage(BService.formatUrl(data['brandLogo']), [40, 40],{'fit': BoxFit.fitWidth}),
                  PWidget.boxw(8),
                  PWidget.text(data['brandName'], [Colors.black.withOpacity(0.75), 16, true]),
                ]),
                if(brandBg.startsWith("http"))
                PWidget.boxh(8),
                if(brandBg.startsWith("http"))
                PWidget.container(
                  Stack(children: [
                    Positioned.fill(child: PWidget.wrapperImage(brandBg)),
                    PWidget.container(
                      PWidget.column([
                        PWidget.text(data['brand_text'], [Colors.white, 16, true]),
                        PWidget.spacer(),
                        PWidget.text(data['brandFeatures'], [Colors.white]),
                        PWidget.spacer(),
                        PWidget.text('', [], {}, [
                          PWidget.textIs('粉丝:', [Colors.white, 12]),
                          PWidget.textIs(fans, [Colors.white, 12]),
                          PWidget.textIs('\t|\t', [Colors.white, 12], ),
                          PWidget.textIs('近期销量:', [Colors.white, 12]),
                          PWidget.textIs(sales, [Colors.white, 12], ),


                        ]),
                      ]),
                      {'pd': 12},
                    ),
                  ]),
                  [double.infinity, 112],
                  {'crr': 12, 'fun':(){
                    List list = data['list'] as List;
                    if(list.isNotEmpty) {
                      getShopData(list[0]['sellerId'], list[0]['shopName']);
                    }

                  }
                  },
                ),
                if (productList.isNotEmpty) PWidget.boxh(12),
                if (productList.isNotEmpty)
                  PWidget.container(
                    PWidget.row(
                      List.generate(productList.length, (i) {
                        var product = productList[i];
                        return Global.openFadeContainer(createItem(product), ProductDetails(product));
                      }),
                      {'pd': 0},
                    ),
                    [null, ((MediaQuery.of(context).size.width - 64) / 3) + 80],
                  ),
              ]),
              [null, null, Colors.white],
              {'br': 12, 'pd': 12},
            );
          },
        );
      },
    );
  }

  Widget createItem(product) {
    var w = (MediaQuery.of(context).size.width - 64) / 3;
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getTbMainPic(product), [w, w], {'br': 12}),
        PWidget.spacer(),
        getPriceWidget(product['actualPrice'], product['originPrice']),
        PWidget.spacer(),
        Builder(builder: (context) {
          ///是否包含旗舰店
          var contains = ('${product['shopName']}'.contains('旗舰店'));
          return PWidget.container(
            PWidget.text(contains ? '旗舰店' : '', [Colours.app_main, 12]),
            {'bd': PFun.bdAllLg(Colors.red.withOpacity(contains ? 1 : 0), 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': 4},
          );
        }),
        PWidget.spacer(),
        PWidget.text('已售${product['monthSales']}件', [Colors.black54, 12]),
      ]),
      {'pd': 4,},
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
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }
  Future getShopData(brandId) async {
    var res = await BService.brandGoodsList(brandId);
    if(res != null) {
      List list = res['list'];
      if(list.isNotEmpty) {
        var shopData = await BService.shopConvert(list[0]['sellerId'], list[0]['shopName']);
        if (shopData != null) {
          LaunchApp.launchTb(context, shopData['shopLinks']);
        };
      }
    }

  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    int cid = widget.tabData['cid'];
    var res = await BService.brandList(page, cid);
    if (res != null) {
        listDm.addList(res['lists'], isRef, res['totalCount']);
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colors.white),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          header: buildClassicHeader(color: Colors.white),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          padding: const EdgeInsets.all(12),
          divider: const Divider(height: 12, color: Colors.transparent),
          item: (i) {
            var data = list[i] as Map;
            var productList = data['goodsList'] as List;
            String logo = data['brandLogo'];
            if(!logo.startsWith('http')) {
              logo = 'https:$logo';
            }
            String sale = BService.formatNum(data['sales']);
            return PWidget.container(
              PWidget.column([
                PWidget.row([
                  PWidget.wrapperImage(logo, [40, 40],{'fit': BoxFit.fitWidth}),
                  PWidget.boxw(8),
                  PWidget.text(data['brandName'], [Colors.black.withOpacity(0.75), 16, true]),
                  Spacer(),
                  PWidget.text('已售$sale件', [Colors.black54, 12]),
                  Icon(Icons.keyboard_arrow_right_sharp, color: Colors.black54,)
                ], {'fun':(){
                  getShopData(data['brandId']);
                }}),
                PWidget.boxh(8),
                PWidget.text('品牌折扣低至${data['maxDiscount']}折', [Colors.black.withOpacity(0.75), 14]),

                if (productList.isNotEmpty) PWidget.boxh(12),
                if (productList.isNotEmpty)
                  PWidget.container(
                    PWidget.row(
                      List.generate(productList.length, (i) {
                        var product = productList[i];
                        return Global.openFadeContainer(createOtherItem(product), ProductDetails(product));
                      }),
                      {'pd': 0},
                    ),
                    [null, ((MediaQuery.of(context).size.width - 64) / 3) + 80],
                  ),
              ]),
              [null, null, Colors.white],
              {'br': 12, 'pd': 12},
            );
          },
        );
      },
    );
  }

  Widget createOtherItem(product) {
    var w = (MediaQuery.of(context).size.width - 64) / 3;
    String sale = BService.formatNum(product['monthSales']);
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getTbMainPic(product), [w, w], {'br': 12}),
        PWidget.spacer(),
        PWidget.text('', [], {}, [
          PWidget.textIs('¥', [Colours.app_main, 16, true]),
          PWidget.textIs('${product['actualPrice']}  ', [Colours.app_main, 16, true]),
          PWidget.textIs('¥${product['originPrice']}', [Colors.black45, 12], {'td': TextDecoration.lineThrough}),
        ]),
        PWidget.spacer(),
        Builder(builder: (context) {
          ///是否包含旗舰店
          var contains = ('${product['shopName']}'.contains('旗舰店'));
          return PWidget.container(
            PWidget.text(contains ? '旗舰店' : '', [Colours.app_main, 12]),
            {'bd': PFun.bdAllLg(Colors.red.withOpacity(contains ? 1 : 0), 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': 4},
          );
        }),
        PWidget.spacer(),
        PWidget.text('已售$sale件', [Colors.black54, 12]),
      ]),
      {'pd': 4, },
    );
  }
}
