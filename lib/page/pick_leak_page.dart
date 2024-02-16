/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';

import '../util/paixs_fun.dart';
import '../widget/lunbo_widget.dart';

class TitleBarValue extends ValueNotifier {
  TitleBarValue() : super(null);
  var isShowTabbar = false;
  void changeIsShowTabbar(v) {
    isShowTabbar = v;
    notifyListeners();
  }
}

TitleBarValue titleBarValue = TitleBarValue();

///捡漏清单
class PickLeakPage extends StatefulWidget {
  @override
  _PickLeakPageState createState() => _PickLeakPageState();
}

class _PickLeakPageState extends State<PickLeakPage>
    with TickerProviderStateMixin {
  int index = 0;
  List tabList = [];
  ScrollController _scrollController = ScrollController();
  var themeColor = Color(0xff538F45);
  bool loading = false;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  @override
  void dispose() {
    // 记得销毁对象
    _scrollController.dispose();
    super.dispose();
  }

  ///初始化函数
  Future initData() async {
    titleBarValue.changeIsShowTabbar(false);
    await getTabData();
    await getListData(isRef: true);
  }

  ///tab数据
  var tabDm = DataModel();
  Future<int> getTabData() async {
    var res = await BService.pickCate().catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) {
      tabDm.addList(res, true, 0);
    }
    setState(() {});
    return tabDm.flag;
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var cateId = tabDm.list.isNotEmpty ? "${tabDm.list[index]['id']}" : 0;
    var res = await BService.pickList(page, cateId).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null && res.isNotEmpty) {
      listDm.addList(res, isRef, 500);
    } else {
      listDm.hasNext = false;
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bgColor: Colors.white,
      body: Stack(children: [
        Positioned.fill(
          bottom: 56,
          child: AnimatedSwitchBuilder(
            value: tabDm,
            initViewIsCenter: true,
            errorOnTap: () => this.getTabData(),
            defaultBuilder: () {
              if (loading) {
                return Global.showLoading2();
              }
              return MyCustomScroll(
                controller: _scrollController,
                isGengduo: listDm.hasNext,
                isShuaxin: true,
                refHeader: buildClassicHeader(color: Colors.grey),
                refFooter: buildCustomFooter(color: Colors.grey),
                onRefresh: () => this.getListData(isRef: true),
                onLoading: (p) => this.getListData(page: p),
                headers: headers,
                itemModel: listDm,
                onScrollToList: (b, v) => titleBarValue.changeIsShowTabbar(b),
                maskHeight: 40 + pmPadd.top + 16 + 32,
                maskWidget: () => ValueListenableBuilder(
                  valueListenable: titleBarValue,
                  builder: (_, __, ___) {
                    return PWidget.positioned(
                      PWidget.container(
                        titleBarValue.isShowTabbar ? buildTabBar(false) : null,
                        [null, null, themeColor],
                        {
                          'sd': PFun.sdLg(themeColor.withOpacity(0.5)),
                          'pd': PFun.lg(pmPadd.top + 16 + 32)
                        },
                      ),
                      [
                        titleBarValue.isShowTabbar
                            ? 0
                            : -(2 + pmPadd.top + 16 + 32),
                        null,
                        0,
                        0
                      ],
                    );
                  },
                ),
                itemModelBuilder: (i, v) {
                  return Global.openFadeContainer(createItem(i, v), ProductDetails(v));
                },
              );
            },
          ),
        ),
        titleBarView(),
        if (tabList.isNotEmpty) btmBarView(),
      ]),
    );
  }

  Widget createItem(i, v) {
    var img = '${v['itempic']}';
    String endPrice = v['itemendprice'];
    endPrice = endPrice.split('.')[0];
    String startPrice = v['itemprice'];
    startPrice = startPrice.split('.')[0];
    return PWidget.container(
      PWidget.row([
        img.isNotEmpty
            ? PWidget.wrapperImage(
            '$img', {'ar': 1 / 1, 'br': 8, 'exp': true})
            : SizedBox(),
        Expanded(
            flex: 2,
            child: PWidget.text(
                '${v['itemshorttitle']}',
                [Colors.black.withOpacity(0.75)],
                {'isOf': false, 'pd': [4,4,2,2], 'max': 2})),
        Expanded(
            flex: 1,
            child: PWidget.text('${v['activity_gameplay']}',
                [themeColor], {'isOf': false, 'pd':  [4,4,2,2], 'max': 2})),
        // PWidget.text(v['activity_gameplay'], [themeColor], {'ct': true}),
        v['itemendprice'] != '0.00'
            ? PWidget.ccolumn([
          PWidget.text('¥$endPrice',
              [themeColor, 14, true]),
          PWidget.text(
              '¥$startPrice',
              [Colors.black26, 12],
              {'td': TextDecoration.lineThrough}),
        ], {
          'exp': 1,
        })
            : SizedBox(),
        PWidget.container(
          PWidget.text('马上抢', [Colors.white, 12, true]),
          [null, null, themeColor],
          {
            'ali': PFun.lg(0, 0),
            'br': 56,
            'exp': true,
            'pd': PFun.lg(5, 4, 8, 8)
          },
        ),
      ]),
      {
        'pd': 8,
        'bd': PFun.bdLg(Colors.black12, 0,
            i == listDm.list.length - 1 ? 0 : 1),
      },
    );
  }

  List<Widget> get headers {
    return [
      AnimatedSwitchBuilder(
        value: tabDm,
        errorOnTap: () => this.getTabData(),
        errorView: PWidget.boxh(0),
        noDataView: PWidget.boxh(0),
        initialState: PWidget.container(null, [double.infinity]),
        listBuilder: (list, _, __) {
          tabList = list.where((w) => (w! as Map)['type'] != 0).toList();
          // var bannarList = list.where((w) => (w! as Map)['type'] == 0).toList();
          var bannerList = [
            {
              'img':
                  "http://img-haodanku-com.cdn.fudaiapp.com/FidecMbZv9-1_VLlFQl6aViRFa4T"
            }
          ];
          return Column(children: [
            LunboWidget(
              bannerList,
              value: 'img',
              aspectRatio: 750 / 170,
              loop: false,
              fun: (v) {},
            ),
            buildTabBar(true),
          ]);
        },
      ),
    ];
  }

  ///底部栏
  Widget btmBarView() {
    return PWidget.positioned(
      PWidget.container(
        Stack(alignment: Alignment.centerRight, children: [
          PWidget.container(
            PWidget.row(
              List.generate(tabList.length, (i) {
                var tab = tabList[i]['name'];
                return PWidget.container(
                  PWidget.text('$tab', [Colors.black.withOpacity(0.75)]),
                  [null, 48, index == i ? Colors.white : Color(0xffF5F5F5)],
                  {
                    'fun': () => onTap(i),
                    'pd': PFun.lg(0, 0, 12, 12),
                    'ali': PFun.lg(0, 0),
                    'bd': PFun.bdLg(Colors.black.withOpacity(0.1), 0, 0,
                        i == 0 ? 0 : 0.5, i == tabList.length - 1 ? 0 : 0.5)
                  },
                );
              }),
              {'pd': 0},
            ),
            {'sd': PFun.sdLg(Colors.grey, 1), 'pd': PFun.lg(0, 0, 0, 48)},
          ),
          PWidget.container(
            PWidget.icon(Icons.menu_rounded),
            [48, 48, Color(0xffF5F5F5)],
            {
              'sd': PFun.sdLg(Colors.black26, 8),
              'fun': () => showSheet(
                  barrierColor: Colors.transparent,
                  builder: (_) =>
                      PopupWidget(tabList, index, fun: (i) => onTap(i)))
            },
          ),
        ]),
        [null, null, Colors.white],
        {
          'pd': [0, MediaQuery.of(context).padding.bottom, 0, 0],
        },
      ),
      [null, 0, 0, 0],
    );
  }

  ///标题栏视图
  Widget titleBarView() {
    return PWidget.container(
      PWidget.row([
        PWidget.container(
          PWidget.icon(Icons.keyboard_arrow_left_rounded, [Colors.white]),
          [32, 32, Colors.black26],
          {'br': 56, 'fun': () => close()},
        ),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8, 16, 16)},
    );
  }

  Widget buildTabBar(bool isFixed) {
    var titleBarList = ['商品图', '商品标题', '优惠信息', '到手价', '购买'];
    return PWidget.row(
      List.generate(titleBarList.length, (i) {
        var title = titleBarList[i];
        var container = PWidget.container(
          PWidget.text('$title', [Colors.white]),
          [null, 48, themeColor],
          {
            'ali': PFun.lg(0, 0),
            'bd': PFun.bdLg(Colors.white.withOpacity(isFixed ? 1 : 0.1), 0, 0,
                i == 0 ? 0 : 0.5, i == titleBarList.length - 1 ? 0 : 0.5)
          },
        );
        if (title == '商品标题') return Expanded(child: container, flex: 2);
        return Expanded(child: container);
      }),
    );
  }

  void onTap(i) async {
    index = i;
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    setState(() {
      loading = true;
    });
    await getListData(isRef: true);
    setState(() {
      loading = false;
    });
  }
}

class PopupWidget extends StatefulWidget {
  final List list;
  final int index;
  final Function(int)? fun;
  const PopupWidget(this.list, this.index, {Key? key, this.fun})
      : super(key: key);
  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  int seleIndex = 0;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    seleIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(widget.list.length, (i) {
          var data = widget.list[i];
          var w = (pmSize.width - 16 - 32) / 3;
          var isDy = seleIndex == i;
          return PWidget.container(
            PWidget.text(
                data['name'], [isDy ? Color(0xff538F45) : Colors.black]),
            [
              w,
              null,
              isDy ? Color(0xffE2F3E3) : Colors.black.withOpacity(0.05)
            ],
            {
              'pd': PFun.lg(8, 8),
              'ali': PFun.lg(0, 0),
              'bd':
                  PFun.bdAllLg(Color(0xff538F45).withOpacity(isDy ? 1 : 0), 1),
              'br': 6,
              'fun': () async {
                setState(() => seleIndex = i);
                close();
                widget.fun!(seleIndex);
              },
            },
          );
        }),
      ),
      [null, null, Colors.white],
      {'pd': 16, 'sd': PFun.sdLg(Colors.black26, 4)},
    );
  }
}
