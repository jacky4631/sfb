/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/my_bouncing_scroll_physics.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/jd/jd_details_page.dart';
import 'package:sufenbao/widget/tab_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';
import '../widget/slide_progress_bar_widget.dart';

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
    final categories = await BService.jdRankCate();
    if (!mounted) return tabDm.flag;
    tabDm.addList([
      ...categories.map((item) => {'title': item['title'], 'index': 1, 'rankId': item['rankId']}),
      {'title': '大牌', 'index': 2},
      {'title': '9.9', 'index': 3},
    ], true, 0);
    setState(() {});

    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          AspectRatio(
              aspectRatio: 413 / 213,
              child: PWidget.container(
                  null, {'gd': PFun.tbGd(Colours.jd_main, Colours.jd_main)})),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.light,
            appBar: buildTitle(context,
                title: '京东',
                widgetColor: Colors.white,
                leftIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                )),
            body: AnimatedSwitchBuilder(
              value: tabDm,
              errorOnTap: () => this.getTabData(),
              initialState: buildLoad(color: Colours.jd_main),
              listBuilder: (list, _, __) {
                var tabList =
                    list.map<String>((m) => (m! as Map)['title']).toList();
                return TabWidget(
                  tabList: tabList,
                  indicatorColor: Colors.white.withOpacity(0),
                  tabPage: List.generate(tabList.length, (i) {
                    return JdListView(list[i] as Map);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JdListView extends StatefulWidget {
  final Map tabValue;

  const JdListView(this.tabValue, {Key? key}) : super(key: key);
  @override
  _JdListViewState createState() => _JdListViewState();
}

class _JdListViewState extends State<JdListView> {
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
    int tabIndex = widget.tabValue['index'] - 1;
    var res;
    if (tabIndex == 0) {
      res = await BService.jdRankList(page, rankId: widget.tabValue['rankId'] ?? 200000);
    } else if (tabIndex == 1) {
      res = await BService.jdBrandList(page);
    } else {
      res = await BService.jdNinesList(page);
    }
    if (res != null) {
      //   List list = res['list'];
      //   list.removeWhere((element){
      //     String whiteImage = element['whiteImage'];
      //     if( whiteImage== null || whiteImage == ''){
      //       return true;
      //     }
      //     return false;
      //   });
      BService.addJdList(listDm, res, page, isRef);
    } else {
      listDm.toError('网络异常');
    }
    setState(() {});
    return listDm.flag;
  }

  ///顶部数据
  var goodsNineTopDm = DataModel();
  Future<int> getGoodsNineTop() async {
    var res = await BService.jdRankList(1, rankId: widget.tabValue['rankId'] ?? 200000);
    if (res != null) {
      List list = res['list'];

      goodsNineTopDm.addList(list, true, 0);
    } else {
      goodsNineTopDm.toError('网络异常');
    }
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
      refFooter: buildCustomFooter(color: Colours.jd_main),
      headers: headers,
      crossAxisCount: 2,
      itemModel: listDm,
      itemPadding: EdgeInsets.all(8),
      crossAxisSpacing: 6,
      itemModelBuilder: (i, v) {
        return createJdFadeContainer(context, i, v);
      },
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
                PWidget.image(
                    'assets/images/mall/hot.png', [14, 14], {'pd': PFun.lg(2)}),
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
                  separatorBuilder: (_, i) =>
                      VerticalDivider(color: Colors.transparent, width: 8),
                  itemBuilder: (_, i) {
                    var data = list[i] as Map;
                    return Global.openFadeContainer(createHeaderItem(data), JDDetailsPage(data));
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
              if (listDm.list.isNotEmpty)
                PWidget.image(
                    'assets/images/mall/jx.png', [166 / 2, 70 / 2], {'pd': 12}),
            ]),
          );
        },
      ),
    ];
  }

  Widget createHeaderItem(data) {
    String img = data['img'] ?? '';
    return PWidget.container(
        PWidget.ccolumn([
          PWidget.wrapperImage(img, {'ar': 1 / 1, 'br': 8}),
          PWidget.container(
            PWidget.text('疯抢${data['sales'] ?? 0}件',
                [Colors.black45, 12]),
            {
              'pd': PFun.lg(2, 1, 8, 8),
              'br': 24,
              'gd': PFun.cl2crGd(
                  Colors.grey[100], Colors.grey[100]),
            },
          ),
          PWidget.spacer(),
          PWidget.row([
            PWidget.boxw(4),
            data['owner'] == 'g'
                ? PWidget.container(
              PWidget.text('自营', [Colors.white, 8]),
              [null, null, Colours.jd_main],
              {
                'bd': PFun.bdAllLg(Colours.jd_main, 0.5),
                'pd': PFun.lg(1, 1, 4, 4),
                'br': PFun.lg(4, 4, 4, 4)
              },
            )
                : SizedBox(),
            data['owner'] == 'g' ? PWidget.boxw(4) : SizedBox(),
            PWidget.text('${data['title']}',
                [Colors.black, 12], {'exp': true}),
          ]),
          PWidget.spacer(),
          getPriceWidget(data['endPrice'] ?? 0, data['startPrice'] ?? 0)
        ],),
        [
          115
        ],);
  }
}
