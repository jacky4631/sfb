/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/custom.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../page/product_details.dart';
import '../widget/tab_bar_indicator.dart';

///其它分类页面
class OtherPage extends StatefulWidget {
  final Map data;

  const OtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  int sortValue = 0;

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
  Future<int> getListData({int? sort, int page = 1, bool isRef = false}) async {
    if (sort != null) sortValue = sort;
    var res = await BService.getGoodsList(page, cid: widget.data['cid'], sort: sortValue).catchError((v) {
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
    return ScaffoldWidget(
      bgColor: Color(0xffF4F5F6),
      body: MyCustomScroll(
        isGengduo: listDm.hasNext,
        isShuaxin: true,
        onRefresh: () => this.getListData(isRef: true),
        onLoading: (p) => this.getListData(page: p),
        refHeader: buildClassicHeader(color: Colors.grey),
        refFooter: buildCustomFooter(color: Colors.grey),
        headers: headers,
        itemModel: listDm,
        itemPadding: EdgeInsets.only(left: 8, right: 8),
        itemModelBuilder: (i, v) {
          return PWidget.container(
            Global.openFadeContainer(createItem(i, v), ProductDetails(v)),
            [null, null, Colors.white],
            {'crr': 8, 'mg': PFun.lg(0, 8)},
          );
        },
      ),
    );
  }

  Widget createItem(i, v) {
    num fee = v['actualPrice'] * v['commissionRate'] / 100;

    String sale = BService.formatNum(v['monthSales']);
    return PWidget.container(
      PWidget.row([
        PWidget.wrapperImage('${v['mainPic']}_310x310', [135, 129]),
        PWidget.boxw(8),
        PWidget.container(
          PWidget.column([
            PWidget.row([getTitleWidget(v['title'], max: 2, size: 15)]),
            PWidget.boxh(8),
            getMoneyWidget(context, fee, TB),
            PWidget.spacer(),
            PWidget.row([
              PWidget.text('', [], {}, [
                PWidget.textIs(' 券后 ', [Colors.black54, 12]),
                PWidget.textIs('¥', [Colours.app_main, 12, true]),
                PWidget.textIs('${v['actualPrice']}', [Colours.app_main, 20, true]),
              ]),
              PWidget.spacer(),
              PWidget.row([
                PWidget.container(
                  PWidget.text('券', [Colours.app_main, 12]),
                  {'bd': PFun.bdAllLg(Colours.app_main), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(4, 0, 4, 0)},
                ),
                PWidget.container(
                  PWidget.text('${v['couponPrice']}元', [Colors.white, 12]),
                  [null, null, Colours.app_main],
                  {'bd': PFun.bdAllLg(Colours.app_main), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(0, 4, 0, 4)},
                ),
              ]),
            ]),
            PWidget.boxh(8),
            PWidget.row([
              PWidget.text('${v['shopName']}', [Colors.black45, 12]),
              PWidget.spacer(),
              getSalesWidget(sale)
            ]),
          ]),
          {'exp': true},
        ),
      ], {
        'fill': true
      }),
      [null, null, Colors.white],
      {
        'pd': 8,
        'bd': PFun.bdLg(Colors.black12, 0, 0.5),
      },
    );
  }

  List<Widget> get headers {
    return [
      Builder(builder: (context) {
        var subcategories = widget.data['subcategories'] as List;
        return PWidget.container(
          PWidget.column([
            Wrap(
              runSpacing: 8,
              children: List.generate(subcategories.length, (i) {
                var wh = (pmSize.width - 32) / 4;
                var subcategorie = subcategories[i];
                var scpic = subcategorie['scpic'];
                var subcname = subcategorie['subcname'];
                return PWidget.container(
                    PWidget.ccolumn([
                      PWidget.wrapperImage('$scpic', [56, 56], {'br': 56}),
                      PWidget.spacer(),
                      PWidget.text('$subcname'),
                      PWidget.spacer(),
                    ]),
                    [
                      wh,
                      wh
                    ],
                    {
                      'fun': () => Navigator.pushNamed(context, '/searchResult',
                          arguments: {'keyword': subcategorie['subcname']})
                    });
              }),
            ),
            PWidget.boxh(16),
            SortWidget((v) => this.getListData(isRef: true, sort: v)),
          ]),
          [null, null, Colors.white],
          {'pd': PFun.lg(16, 0, 16, 16), 'mg': PFun.lg(0, 8)},
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
    return PWidget.row(List.generate(sortList.length, (i) {
      return sortTag(sortList[i], i);
    }));
  }

  // 排序标记文字
  Widget sortTag(name, i) {
    return PWidget.ccolumn([
      if (name == '价格')
        PWidget.row([
          PWidget.text('价格', [Colors.black.withOpacity(i == sortIndex ? 0.75 : 0.25), 14, true]),
          PWidget.container(
            Stack(clipBehavior: Clip.none, children: [
              PWidget.positioned(
                  PWidget.icon(Icons.arrow_drop_up_rounded, [Colors.black.withOpacity(sort == 6 ? 0.75 : 0.25), 16]),
                  [2]),
              PWidget.positioned(
                  PWidget.icon(Icons.arrow_drop_down_rounded, [Colors.black.withOpacity(sort == 5 ? 0.75 : 0.25), 16]),
                  [8]),
            ]),
            [16, 24],
          ),
        ], '220')
      else
        PWidget.text(name ?? '文本', [Colors.black.withOpacity(i == sortIndex ? 0.75 : 0.25), 14, true]),
      PWidget.container(null, [20, 5, Colors.red.withOpacity(i == sortIndex ? 1 : 0)], {'br': 8, 'mg': 4}),
    ], {
      'exp': 1,
      'fun': () {
        setState(() => sortIndex = i);
        sort = [0, 1, 3, sort][sortIndex];
        if (sortIndex == 3) sort = sort == 6 ? 5 : 6;
        widget.fun(sort);
      }
    });
  }
}
