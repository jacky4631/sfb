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

import '../service.dart';
import '../util/paixs_fun.dart';

class SupportBankList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity],
              {'gd': PFun.cl2crGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.dark,
            appBar: buildTitle(context,
                title: '支持银行',
                widgetColor: Colors.black,
                leftIcon: Icon(Icons.arrow_back_ios)),
            body: ChildWidget(),
          ),
        ],
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  @override
  _ChildWidget createState() => _ChildWidget();
}

class _ChildWidget extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colors.white),
      errorOnTap: () => this.getListData(),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: false,
          isGengduo: false,
          header: buildClassicHeader(color: Colors.grey),
          footer: buildCustomFooter(color: Colors.grey),
          // onRefresh: () => this.getListData(),
          // onLoading: () => this.getListData(),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            var data = list[i] as Map;
            var bankName = data['bankName'];
            return PWidget.container(
              PWidget.column([
                PWidget.row([
                  PWidget.boxw(30),
                  PWidget.textNormal(bankName, [
                    Colors.black.withOpacity(0.75),
                    15
                  ], {
                    'max': 1,
                    'ss': StrutStyle(
                        forceStrutHeight: true, height: 2, leading: 0.5),
                  })
                ]),
                Divider()
              ]),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    await getListData();
  }

  ///列表数据
  var listDm = DataModel();

  Future<int> getListData() async {
    List res = await BService.supportBank();
    res = res.where((element) => element['supportDebitCard'] == 'Y').toList();
    listDm.addList(res, false, res.length);
    setState(() {});
    return listDm.flag;
  }
}
