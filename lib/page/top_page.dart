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
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/util/global.dart';
import 'package:sufenbao/page/product_details.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../util/colors.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';

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
              {'crr': 8, 'mg': [0,8,0,0]},
            );
          },
        );
      },
    );
  }

  Widget createItem(int i, Map data) {
    num fee = data['actualPrice']*data['commissionRate']/100;

    String shopType = data['shopType']==1?'天猫':'淘宝';
    String shopName = data['shopName'];
    return PWidget.container(
      PWidget.row(
        [
            PWidget.wrapperImage(
                data['mainPic'] + '_300x300', [144, 144], {'br': 8}),

          PWidget.boxw(6),
          PWidget.column([
            getTitleWidget(data['title'], max: 2,size: 15),
            PWidget.boxh(4),
            PWidget.row([
              PWidget.container(
                Text('爆卖', style: TextStyle(fontSize: 13, color: Colors.white, fontStyle: FontStyle.italic),),
                [null, null, Colours.app_main],
                {
                  'pd': PFun.lg(1, 1, 16, 16), 'br': PFun.lg(16, 0, 16, 0)},
              ),
              PWidget.container(
                PWidget.textNormal('已售${data['twoHoursSales']}件', [Colours.app_main, 12], {}),
                [null, null, Colours.light_app_main],
                {
                  'pd': PFun.lg(1, 1, 16, 16),
                  'mg': PFun.lg(0, 0, 0, 0),
                  'ali': PFun.lg(-1, 0),
                  'br': PFun.lg(0, 16, 0, 16),
                  'exp': true
                },
              ),
            ]),

            PWidget.boxh(6),
            PWidget.row([
              getPriceWidget(data['actualPrice'], data['originalPrice'], endPrefix: '券后 '),
            ]),
            PWidget.boxh(6),
            getMoneyWidget(context, fee, TB),
            PWidget.boxh(6),
            PWidget.row([
              PWidget.textNormal('$shopType | $shopName', [Colors.black45, 12]),
            ])


          ], {
            'exp': 1,
          }),
        ],
        '001',
        {'fill': true},
      ),
      [null, null, Colors.white],
      {
        'pd': 10,
      },
    );
  }
}
