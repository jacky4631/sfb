/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../widget/top_rank_item.dart';

///实时疯抢榜
class TopPage extends StatefulWidget {
  final Map? data;

  const TopPage({Key? key, this.data}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getTabData();
  }

  @override
  bool get wantKeepAlive => true;

  ///tab数据
  var tabDm = DataModel();
  Future<int> getTabData() async {
    var res = await BService.rankingCate().catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) tabDm.addList(res, true, 0);
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool showArrowBack = (widget.data == null ||
         widget.data?['showArrowBack'] == null ||
        widget.data?['showArrowBack']);
    var leftIcon = showArrowBack
        ? Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )
        : SizedBox();
    var leftCallback = showArrowBack?()=>Navigator.pop(context):(){};
    return ScaffoldWidget(
            bgColor: Color(0xffF4F5F6),
            brightness: Brightness.light,
            appBar: buildTitle(context,color:Colours.app_main,
                title: '实时榜单', widgetColor: Colors.white, leftIcon: leftIcon, leftCallback: leftCallback),
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
                  color: Colours.app_main,
                  unselectedColor: Colors.black,
                  indicatorColor: Colors.transparent,
                  fontWeight: FontWeight.normal,
                  tabPage: List.generate(tabList.length, (i) {
                    return TopChild(list[i] as Map);
                  }),
                );
              },
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
    String title = widget.tabValue['title'];
    int rankType = 1;
    if (title == '全天榜') {
      rankType = 2;
    }
    var res =
        await BService.rankingList(rankType, page, cid: widget.tabValue['id'])
            .catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) listDm.addList(res, isRef, 200);
    // flog(listDm.toJson());
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
          header: buildClassicHeader(color: Colors.grey),
          footer: buildCustomFooter(color: Colors.grey),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            var data = list[i] as Map;

            return PWidget.container(
              Global.openFadeContainer(createItem(i, data), ProductDetails(data)),
              [null, null, Colors.white],
              {'crr': 16, 'mg': [0, 8, 0, 0]},
            );
          },
        );
      },
    );
  }

  Widget createItem(int i, Map data) {
    final price = num.tryParse('${data['actualPrice']}') ?? 0;
    final rate = num.tryParse('${data['commissionRate']}') ?? 0;
    final reward = getHbData(price * rate / 100, TB);
    return TopRankItem(
      rank: i + 1,
      data: data,
      rewardText: '可拆${reward['min']}～${reward['max']}元',
    );
  }
}
