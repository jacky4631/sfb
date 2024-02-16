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
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../util/tao_util.dart';

///大额优惠券
class BigCouponPage extends StatefulWidget {
  final Map? data;

  const BigCouponPage({Key? key, this.data}) : super(key: key);

  @override
  _BigCouponPageState createState() => _BigCouponPageState();
}

class _BigCouponPageState extends State<BigCouponPage>{
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
    var res = await BService.cmsCate('411').catchError((v) {
      tabDm.toError('网络异常');
    });
    res.removeAt(0);
    if (res != null) tabDm.addList(res, true, 0);
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    bool showArrowBack = (widget.data == null || widget.data!['showArrowBack']);
    var leftIcon = showArrowBack
        ? Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )
        : null;
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.tbGd(Colours.app_main, Colors.white)}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.light,
            appBar: buildTitle(context,
                title: '大额券热卖清单', widgetColor: Colors.white, leftIcon: leftIcon),
            body: AnimatedSwitchBuilder(
              value: tabDm,
              errorOnTap: () => this.getTabData(),
              initialState: PWidget.container(null, [double.infinity]),
              listBuilder: (list, _, __) {
                var tabList =
                    list.map<String>((m) => (m! as Map)['title']).toList();
                return TabWidget(
                  tabList: tabList,
                  indicatorWeight: 2,
                  tabPage: List.generate(tabList.length, (i) {
                    return TopChild(list[i] as Map);
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

class TopChild extends StatefulWidget {
  final Map tabValue;

  const TopChild(this.tabValue, {Key? key}) : super(key: key);
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
    String url = widget.tabValue['config']['url'];
    var res = await BService.goodsBigList(page, url).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) listDm.addList(res['list'], isRef, res['totalNum']);
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
          footer: buildCustomFooter(color: Colors.grey),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          itemCount: list.length,
          padding: const EdgeInsets.all(12),
          divider: const Divider(height: 12, color: Colors.transparent),

          listViewType: ListViewType.Separated,
          item: (i) {
            var data = list[i] as Map;
            return Global.openFadeContainer(createItem(data), ProductDetails(data));
          },
        );
      },
    );
  }

  Widget createItem(data) {
    String sale = BService.formatNum(data['monthSales']);
    return PWidget.container(
      PWidget.row(
        [
          PWidget.wrapperImage(getTbMainPic(data), [124, 124], {'br': 8}),
          PWidget.boxw(8),
          PWidget.column([
            PWidget.row([
              PWidget.text(data['dtitle'],
                  [Colors.black.withOpacity(0.75), 14, true], {'exp': true,'max':2}),
            ]),
            PWidget.spacer(),
            getPriceWidget(data['actualPrice'], data['originalPrice']),
            Stack(alignment: Alignment.centerRight, children: [
              PWidget.container(
                PWidget.text('', [], {}, [
                  PWidget.textIs('热销', [Color(0xff793E1B), 12]),
                  PWidget.textIs('$sale+', [Colours.app_main, 12]),
                ]),
                [double.infinity, 32, Color(0xffFAEDE6)],
                {
                  'pd': PFun.lg(0, 0, 8, 8),
                  'mg': PFun.lg(0, 0, 0, 45),
                  'ali': PFun.lg(-1, 0)
                },
              ),
              Stack(alignment: Alignment.center, children: [
                PWidget.image('assets/images/mall/ljq.jpg', [90, 39]),
                PWidget.text('马上抢', [Colors.white, 14, true],
                    {'pd': PFun.lg(0, 4)}),
              ]),
            ]),
          ], {
            'exp': 1,
          }),
        ],
        '001',
        {'fill': true},
      ),
      [null, null, Colors.white],
      {'pd': 12,},
    );
  }
}
