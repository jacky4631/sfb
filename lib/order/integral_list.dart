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
import 'package:sufenbao/service.dart';

import '../util/paixs_fun.dart';

///积分明细
class IntegralList extends StatelessWidget {
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
                title: '积分明细',
                widgetColor: Colors.black,
                leftIcon: Icon(Icons.arrow_back_ios)),
            body: TopChild(),
          ),
        ],
      ),
    );
  }
}

class TopChild extends StatefulWidget {
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
    var res = await BService.moneyList(page);
    if (res != null) listDm.addList(res['data'], isRef, res['total']);
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
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            var data = list[i] as Map;
            String type = data['type'];
            String isPlus = (type == 'order') ? '+' : '-';
            num price = data['balance'];
            num changeIntegral = data['number'];
            return PWidget.container(
              PWidget.row(
                [
                  PWidget.column([
                    PWidget.row([
                      PWidget.text(data['title'],
                          [Colors.black.withOpacity(0.75), 16], {'exp': true}),
                      PWidget.text(
                        '$isPlus${changeIntegral.toInt()}',
                        [Colors.red.withOpacity(0.75), 16],
                      ),
                    ]),
                    PWidget.boxh(4),
                    PWidget.row([
                      PWidget.text(data['createTime'], [Colors.black45, 14],
                          {'exp': true}),
                      PWidget.text(
                        '余额：${price.toInt()}',
                        [Colors.black45, 14],
                      ),
                    ]),
                    PWidget.boxh(4),
                    PWidget.container(
                      PWidget.row([
                        PWidget.text('', [], {}, [
                          PWidget.textIs('${data['mark']}',
                              [Colors.black.withOpacity(0.75), 12],{'max':2
                              }),
                        ]),
                      ])
                    ),
                  ], {
                    'exp': 1,
                  }),
                  Divider(
                    height: 5,
                    color: Colors.grey,
                  )
                ],
                '001',
                {'fill': true},
              ),
              [null, null, Colors.white],
              {
                'pd': 12,
                'fun': () => {
                      // jumpPage(ProductDetails(data))
                    }
              },
            );
          },
        );
      },
    );
  }
}
