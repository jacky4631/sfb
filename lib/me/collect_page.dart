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
import 'package:sticky_headers/sticky_headers.dart';

import '../util/colors.dart';
import '../service.dart';

//我的收藏
class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  var listDm = DataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    var res = await BService.collectList(page).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null) listDm.addList(res['data'], isRef, res['total']);
    // flog(listDm.toJson());
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(

        brightness: Brightness.dark,
        appBar: buildTitle(context,
            title: '我的收藏',
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
                    var data = list[i] as Map;
                    String createTime = data['createTime'];
                    return Semantics(

                        /// 将item默认合并的语义拆开，自行组合， 另一种方式见 account_record_list_page.dart
                        explicitChildNodes: true,
                        child: StickyHeader(
                          header: Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xFF242526)
                                    : Color(0xFFFAFAFA),
                            padding: const EdgeInsets.only(left: 16.0),
                            height: 34.0,
                            child: Text(createTime.split(' ').first),
                          ),
                          content: createItem(i, data),
                        ));
                  });
            }));
  }

  Widget createItem(int i, Map data) {
    String startPrice = data['startPrice'];
    if (startPrice == '0' || startPrice == '') {
      startPrice = '';
    } else {
      startPrice = '￥$startPrice';
    }
    return PWidget.container(
      PWidget.row(
        [
          Stack(children: [
            PWidget.wrapperImage(data['img'], [100, 100], {'br': 8}),
          ]),
          PWidget.boxw(8),
          PWidget.column([
            PWidget.row([
              PWidget.image('assets/images/mall/${data['category']}.png', [
                14,
                14
              ], {
                'pd': [4]
              }),
              PWidget.boxw(4),
              PWidget.text(data['title'], [Colors.black.withOpacity(0.75), 16],
                  {'exp': true, 'max': 2}),
            ], [
              '0',
              '1',
              '1'
            ]),
            PWidget.spacer(),
            PWidget.text('', [], {}, [
              PWidget.textIs('¥', [Colours.app_main, 12, true]),
              PWidget.textIs(
                  '${data['endPrice']}', [Colours.app_main, 20, true]),
              PWidget.textIs('  ', [Colours.app_main, 12]),
              PWidget.textIs('$startPrice', [Colors.black45, 12],
                  {'td': TextDecoration.lineThrough}),
            ]),
          ], {
            'exp': 1,
          }),
        ],
        '001',
        {'fill': true},
      ),
      [null, null, Colors.white],
      {'pd': 12, 'fun': () {
        jumpDetail(data);
      }},
    );
  }
  jumpDetail(data) {
    String category = data['category'];
    String link = '/detail';
    if(category == 'tb') {
      link = '/detail';
    }else if(category == 'jd') {
      link = '/detailJD';
    }else if(category == 'pdd') {
      link = '/detailPDD';
    }else if(category == 'dy') {
      link = '/detailDY';
    }else if(category == 'vip') {
      link = '/detailVIP';
    }
    Navigator.pushNamed(context, link, arguments: data);
  }
}
