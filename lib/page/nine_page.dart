/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/tao_util.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../widget/slide_progress_bar_widget.dart';

///9.9包邮
class NinePage extends StatefulWidget {
  @override
  _NinePageState createState() => _NinePageState();
}

class _NinePageState extends State<NinePage> {
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
    var res = await BService.nineCate().catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) tabDm.addList(res, true, 0);
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          AspectRatio(aspectRatio: 413 / 213, child: PWidget.container(null, {'gd': PFun.tbGd(Colours.dark_app_main, Colours.app_main)})),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.light,
            appBar: titleBar(),
            body: AnimatedSwitchBuilder(
              value: tabDm,
              errorOnTap: () => this.getTabData(),
              initialState: buildLoad(color: Colours.app_main),
              listBuilder: (list, _, __) {
                var tabList = list.map<String>((m) => (m! as Map)['title']).toList();
                return TabWidget(
                  tabList: tabList,
                  indicatorColor: Colors.white.withOpacity(0),
                  tabPage: List.generate(tabList.length, (i) {
                    return FreeShippingChild(list[i] as Map);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget titleBar() {
    return PWidget.container(
      PWidget.row([
        PWidget.container(PWidget.icon(Icons.arrow_back_ios_new_rounded, [Colors.white, 20]), [32, 32], {'fun': () => close()}),
        PWidget.spacer(),
        PWidget.image('assets/images/mall/99.png', [71, 24]),
        PWidget.spacer(),
        PWidget.container(null, [32, 32]),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8, 16, 16)},
    );
  }
}

class FreeShippingChild extends StatefulWidget {
  final Map tabValue;

  const FreeShippingChild(this.tabValue, {Key? key}) : super(key: key);
  @override
  _FreeShippingChildState createState() => _FreeShippingChildState();
}

class _FreeShippingChildState extends State<FreeShippingChild> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getGoodsNineTop();
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.nineList(page, widget.tabValue['id']).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) listDm.addList(res['lists'], isRef, res['totalCount']);
    setState(() {});
    return listDm.flag;
  }

  ///顶部数据
  var goodsNineTopDm = DataModel();
  Future<int> getGoodsNineTop() async {
    var res = await BService.nineTop().catchError((v) {
      goodsNineTopDm.toError('网络异常');
    });
    if (res != null) goodsNineTopDm.addList(res['goodsList'], true, 0);
    setState(() {});
    return goodsNineTopDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScroll(
      isGengduo: listDm.hasNext,
      isShuaxin: true,
      onRefresh: () => this.getListData(isRef: true),
      onLoading: (p) => this.getListData(page: p),
      refHeader: buildClassicHeader(color: Colors.white),
      refFooter: buildCustomFooter(color: Colours.app_main),
      headers: headers,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      itemPadding: EdgeInsets.all(8),
      itemModel: listDm,
      itemModelBuilder: (i, v) {
        return PWidget.container(
          Global.openFadeContainer(createItem(i, v), ProductDetails(v)),
          [null, null, Colors.white],
          {'crr': 8, 'mg': PFun.lg(PFun.lg2(0, 1).contains(i) ? 0 : 8)},
        );
        // return Global.openFadeContainer(createItem(i, v), ProductDetails(v));
      },
    );
  }

  Widget createItem(i, v) {
    var sale = BService.formatNum(v['xiaoliang'] as int);
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getTbMainPic(v), {'ar': 1 / 1, 'br': 8}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              PWidget.text(v['dtitle'], [Colors.black.withOpacity(0.75), 14 ,true], {'exp': true}),
            ]),
            PWidget.boxh(8),

            getPriceWidget(v['jiage'], v['jiage'], endPrefix: ' 券后 ', endPrefixColor: Colors.black54),
            PWidget.boxh(8),
            PWidget.row([
              PWidget.container(
                PWidget.text('券', [Colours.app_main, 12]),
                {'bd': PFun.bdAllLg(Colours.app_main, 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(4, 0, 4, 0)},
              ),
              PWidget.container(
                PWidget.text('${v['quanJine']}元', [Colors.white, 12]),
                [null, null, Colours.app_main],
                {'bd': PFun.bdAllLg(Colours.app_main, 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(0, 4, 0, 4)},
              ),
            ]),
            PWidget.boxh(8),
            getSalesWidget(sale)
          ]),
          {'pd': 8},
        ),
      ]),
      [null, null, Colors.white],
      {'pd': PFun.lg(0, 0, 8, 8), },
    );
  }

  List<Widget> get headers {
    return [
      AnimatedSwitchBuilder(
        value: goodsNineTopDm,
        errorOnTap: () => this.getGoodsNineTop(),
        noDataView: PWidget.boxh(0),
        errorView: PWidget.boxh(0),
        initialState: PWidget.container(null, [double.infinity]),
        isAnimatedSize: false,
        listBuilder: (list, _, __) {
          return PWidget.container(
            PWidget.ccolumn([
              PWidget.boxh(12),
              PWidget.row([
                PWidget.boxw(16),
                PWidget.text('近1小时疯抢', [Colors.white, 16, true], {'exp': true}),
                PWidget.image('assets/images/mall/hot.png', [14, 14], {'pd': PFun.lg(2)}),
                PWidget.text('2.4万人正在抢', [Colors.white]),
                PWidget.boxw(16),
              ]),
              PWidget.boxh(12),
              PWidget.container(
                ListView.separated(
                  itemCount: list.length,
                  controller: controller,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: MyBouncingScrollPhysics(),
                  separatorBuilder: (_, i) => VerticalDivider(color: Colors.transparent, width: 8),
                  itemBuilder: (_, i) {
                    var data = list[i] as Map;
                    return Global.openFadeContainer(createHeaderItem(data), ProductDetails(data));
                  },
                ),
                [null, 188],
              ),
              PWidget.boxh(12),
              SlideProgressBarWidget(
                controller,
                bgBarWidth: pmSize.width - 32,
                barWidth: 112,
                bgBarColor: Colors.transparent,
                barColor: Colors.black12,
              ),
              if (listDm.list.isNotEmpty) PWidget.image('assets/images/mall/jx.png', [166 / 2, 70 / 2], {'pd': 12}),
            ]),
          );
        },
      ),
    ];
  }
  Widget createHeaderItem(data) {

    String sale = BService.formatNum(data['xiaoliang']);
    return PWidget.container(
        PWidget.ccolumn([
          PWidget.wrapperImage('${data['pic']}_310x310', {'ar': 1 / 1, 'br': 8}),
          PWidget.container(
            PWidget.text('疯抢$sale件', [Colors.white, 12]),
            {
              'pd': PFun.lg(2, 1, 8, 8),
              'br': 24,
              'sd': PFun.sdLg(Color(0x40E47E35), 2, 0, 2, -1),
              'gd': PFun.cl2crGd(Colours.dark_app_main, Colours.app_main),
            },
          ),
          PWidget.spacer(),
          PWidget.text('${data['dtitle']}', [Colors.black, 12]),
          PWidget.spacer(),

          getPriceWidget(data['jiage'], data['yuanjia'])
        ]),
        [115],
    );
  }
}
