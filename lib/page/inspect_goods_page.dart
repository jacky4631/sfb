/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/image.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../widget/lunbo_widget.dart';
import '../widget/tab_widget.dart';

//爆款验货
class InspectGoodsPage extends StatefulWidget {
  final Map data;
  const InspectGoodsPage(this.data, {Key? key}) : super(key: key);

  @override
  _MIniPageState createState() => _MIniPageState();
}

class _MIniPageState extends State<InspectGoodsPage>{
  ScrollController _scrollController = ScrollController();
  var _showBackTop = false;

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
  var tabDm = DataModel();
  Future<int> getTabData() async {
      tabDm.addList(
          Global.getFullCategory(),
          true,
          0);
      // tabCon = TabController(length: tabDm.list.where((w) => w['type'] != 0).toList().length, vsync: this);
    return tabDm.flag;
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
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Color(0xFF39A638), Colors.white)}),
          ScaffoldWidget(
              floatingActionButton:
                  _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
                      ? FloatingActionButton(
                          backgroundColor: Colors.grey[300],
                          onPressed: () {
                            // scrollController 通过 animateTo 方法滚动到某个具体高度
                            // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
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
              bgColor: Colors.transparent,
              brightness: Brightness.light,
              appBar: Stack(
                children: [
                  LunboWidget(
                          imgs,
                          value: 'img',
                          aspectRatio: 75 / 31,
                          loop: false,
                          fun: (v) {},
                        )
                      ,
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      // splashColor: bwColor,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              body: AnimatedSwitchBuilder(
                value: tabDm,
                errorOnTap: () => this.getTabData(),
                initialState: buildLoad(color: Colours.app_main),
                listBuilder: (list, _, __) {
                  var tabList = list
                      .map<String>((m) => (m! as Map)['name'])
                      .toList();
                  return TabWidget(
                    tabList: tabList,
                    indicatorColor: Colors.white,
                    tabPage: List.generate(tabList.length, (i) {
                      return TopChild(_scrollController, list[i] as Map);
                    }),
                  );
                },
              )),
        ],
      ),
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
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.getGoodsList(page, inspectedGoods: 1, cid: widget.data['cid']).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      var list = res['list'];
      var totalNum = res['totalNum'];
      listDm.addList(list, isRef, totalNum);
    }
    setState(() {});
    return listDm.flag;
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Color(0xff9cc8c)),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return createContent();
      },
    );
  }

  createContent() {
    return MyCustomScroll(
      isGengduo: listDm.hasNext,
      isShuaxin: true,
      onRefresh: () => this.getListData(isRef: true),
      onLoading: (p) => this.getListData(page: p),
      refHeader: buildClassicHeader(color: Colors.grey),
      refFooter: buildCustomFooter(color: Colors.grey),
      itemModel: listDm,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      itemPadding: EdgeInsets.all(16),
      itemModelBuilder: (i, v) {
        return PWidget.container(
          Global.openFadeContainer(createItem(i, v), ProductDetails(v)),
          [null, null, Colors.white],
          {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 12)},
        );
      },
    );
  }

  Widget createItem(i, v) {
    var img = '${v['mainPic']}_310x310';
    var sale = BService.formatNum(v['monthSales']);
    int descMaxLine = i%3 + 2 ;
    return PWidget.container(
      PWidget.column([
        PWidget.container(WrapperImage(url: '$img'), {'crr': 4}),
        PWidget.text('${v['desc']}', [Colors.black.withOpacity(0.75), 14, true], {'isOf': false, 'pd': PFun.lg(4, 4),'max':descMaxLine}),
        PWidget.boxh(8),
        PWidget.row([
          getPriceWidget('${v['actualPrice']}元', '${v['actualPrice']}元'),
          PWidget.spacer(),
          getSalesWidget(sale)
        ]),
      ]),
      [null, null, Colors.white],
      {'pd': 8, 'sd': PFun.sdLg(Colors.black12), 'br': 8, },
    );
  }
}
