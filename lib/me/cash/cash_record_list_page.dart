/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../service.dart';

//提现记录
class CashRecordListPage extends StatefulWidget {
  const CashRecordListPage({super.key});

  @override
  _CashRecordListPageState createState() =>
      _CashRecordListPageState();
}

class _CashRecordListPageState extends State<CashRecordListPage> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    await getListData(isRef: true);
    setState(() {});
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.extractList(page-1);
    if (res != null) listDm.addList(res['content'], isRef, res['totalElements']);
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      brightness: Brightness.dark,
      appBar: buildTitle(context,
          title: '提现记录',
          widgetColor: Colors.black,
          leftIcon: Icon(Icons.arrow_back_ios)),
      body: AnimatedSwitchBuilder(
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
            itemCount: list.length,
            listViewType: ListViewType.Separated,
            item: (i) {
              Map record = list[i] as Map;
              String createTime = record['createTime'];
              return Semantics(
                /// 将item默认合并的语义拆开，自行组合， 另一种方式见 account_record_list_page.dart
                explicitChildNodes: true,
                child: StickyHeader(
                  header: Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Color(0xFF242526)
                        : Color(0xFFFAFAFA),
                    padding: const EdgeInsets.only(left: 16.0),
                    height: 34.0,
                    child: Text(createTime.split(' ').first),
                  ),
                  content: _buildItem(i, record),
                ),
              );
            },
          );
        },
      )
    );
  }

  Widget _buildItem(int index, Map record) {
    String createTime = record['createTime'];
    final Widget content = Stack(
      children: <Widget>[
        Text(record['extractType'] == 'weixin' ? '微信到账' : '支付宝到账'),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Text(record['extractPrice'].toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          child: Text(createTime.split(' ').last,
              style: Theme.of(context).textTheme.titleSmall),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Text(
            record['status'] == 1 ? '审核成功' : '审核中',
            style: record['status'] == 1
                ? TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error,
                  )
                : const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF8547),
                  ),
          ),
        ),
      ],
    );

    Widget container = Container(
      height: 72.0,
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, width: 0.8),
        ),
      ),
      child: MergeSemantics(
        child: content,
      ),
    );
    return Column(children: [container]);
  }
}
