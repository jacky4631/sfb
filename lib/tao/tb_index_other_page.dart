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
import 'package:sufenbao/util/custom.dart';

import '../service.dart';
import '../util/tao_util.dart';
import '../widget/CustomWidgetPage.dart';

///其它分类页面
class TbIndexOtherPage extends StatefulWidget {
  final Map data;

  const TbIndexOtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _TbIndexOtherPageState createState() => _TbIndexOtherPageState();
}

class _TbIndexOtherPageState extends State<TbIndexOtherPage> {

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }
  var listDm = DataModel();
  Future<int> getListData({int? sort, int page = 1, bool isRef = false}) async {
    var res = await BService.getGoodsList(page,cid: widget.data['cid'])
        .catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      listDm.addList(res['list'], isRef, res['totalNum']);
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
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        itemPadding: EdgeInsets.all(8),
        itemModel: listDm,
        itemModelBuilder: (i, v) {
          return createTbFadeContainer(context, i, v);
        },
      ),
    );
  }
  Widget createItem(i, v) {
    num fee = v['commissionRate'] * v['actualPrice'] / 100;
    String shopType = v['shopType']==1?'天猫':'淘宝';

    String sales = BService.formatNum(v['monthSales']);
    return PWidget.container(
      PWidget.column([
        PWidget.wrapperImage(getTbMainPic(v), {'ar': 1 / 1}),
        PWidget.container(
          PWidget.column([
            PWidget.row([
              getTitleWidget(v['dtitle']),
            ]),
            PWidget.boxh(8),
            getPriceWidget(v['actualPrice'], v['originalPrice']),
            fee == 0 ? SizedBox() : PWidget.boxh(8),
            fee == 0 ? SizedBox() : getMoneyWidget(context, fee, TB),
            PWidget.boxh(8),
            PWidget.text('$shopType | ${v['shopName']}', [Colors.black45, 12]),
            PWidget.boxh(8),
            getSalesWidget(sales)
          ]),
          {'pd': 8},
        ),
      ]),
      [null, null, Colors.white],);
  }
}