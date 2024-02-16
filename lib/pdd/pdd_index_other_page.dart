/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';

import '../service.dart';
import '../widget/CustomWidgetPage.dart';

///其它分类页面
class PddIndexOtherPage extends StatefulWidget {
  final Map data;

  const PddIndexOtherPage(this.data, {Key? key}) : super(key: key);
  @override
  _PddIndexOtherPageState createState() => _PddIndexOtherPageState();
}

class _PddIndexOtherPageState extends State<PddIndexOtherPage> {

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
  var listId = '';
  Future<int> getListData({int? sort, int page = 1, bool isRef = false}) async {
    var res = await BService.pddSearch(page,
        listId: listId,catId: widget.data['id'])
        .catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) {
      listId = res['listId'];
      listDm.addList(res['goodsList'], isRef, res['totalCount']);
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
          return createPddFadeContainer(context, i, v);
        },
      ),
    );
  }
}