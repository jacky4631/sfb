/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';

import '../widget/CustomWidgetPage.dart';

///首页
class TbIndexFirstPage extends StatefulWidget {
  @override
  _TbIndexFirstPageState createState() => _TbIndexFirstPageState();
}

class _TbIndexFirstPageState extends State<TbIndexFirstPage> {
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
    var res = await BService.getGoodsList(page,)
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
        headers: headers,
        itemPadding: EdgeInsets.all(8),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        itemModel: listDm,
        itemModelBuilder: (i, v) {
          return createTbFadeContainer(context, i, v);
        },
      ),
    );
  }

  List<Widget> get headers {
    return [
    ];
  }
}
