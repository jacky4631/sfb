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

import '../../util/colors.dart';
import '../../util/paixs_fun.dart';

///余额明细
class MoneyList extends StatelessWidget {
  final Map data;
  const MoneyList(this.data, {Key? key,}) : super(key: key);

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
                title: (data==null ||data['title']== null) ? '资金明细' : data['title'],
                widgetColor: Colors.black,
                leftIcon: Icon(Icons.arrow_back_ios)),
            body: TopChild(data),
          ),
        ],
      ),
    );
  }

}

class TopChild extends StatefulWidget {
  final Map data;
  const TopChild(this.data, {Key? key,}) : super(key: key);

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
    String type = widget.data['type']??'';
    String platform = widget.data['platform']??'';
    var unlockStatus = widget.data['unlockStatus'];
    var res = await BService.moneyList(page, category: 'now_money', type: type, platform: platform, unlockStatus: unlockStatus);
    if (res != null) listDm.addList(res['data'], isRef, res['total']);
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: buildLoad(color: Colours.app_main),
      errorOnTap: () => this.getListData(isRef: true),
      listBuilder: (list, p, h) {
        return MyListView(
          isShuaxin: true,
          isGengduo: h,
          header: buildClassicHeader(color: Colors.grey),
          footer: buildCustomFooter(color: Colors.grey),
          onRefresh: () => this.getListData(isRef: true),
          onLoading: () => this.getListData(page: p),
          padding: EdgeInsets.only(top: 8, bottom: 8),
          itemCount: list.length,
          listViewType: ListViewType.Separated,
          item: (i) {
            var data = list[i] as Map;
            String type = data['type'];
            String isPlus = (type == 'gain' || type== 'retail' || type == 'upgrade' || type=='system_add') ? '+' : '-';
            num changeIntegral = data['number'];
            num unlockStatus = data['unlockStatus']??0;
            String unlockStatusStr = '';
            Color statusColor = Colors.black38;
            //如果是提现不显示状态
            if(type != 'extract') {
              if(unlockStatus == 1) {
                unlockStatusStr = '待解锁';
                statusColor = Colors.red;
              } else if (unlockStatus == 0) {
                unlockStatusStr = '已结算';
                statusColor = Colors.green;
              } else {
                unlockStatusStr = '已失效';
              }
            }
            return PWidget.container(
              PWidget.row(
                [
                  PWidget.column([
                    PWidget.row([
                      PWidget.textNormal(data['title'],
                          [Colors.black.withOpacity(0.75), 14, true], {'exp': true}),
                      PWidget.textNormal(
                        '$isPlus${changeIntegral}元',
                        [Colors.red.withOpacity(0.75), 14],
                      ),
                    ]),
                    PWidget.boxh(4),
                    PWidget.row([
                      PWidget.textNormal(data['createTime'], [Colors.black54, 12]),
                      PWidget.spacer(),
                      PWidget.textNormal(unlockStatusStr, [statusColor, 12],),
                    ]),
                    PWidget.boxh(4),
                    if(unlockStatus == 1)
                      PWidget.textNormal('解锁时间：${data['unlockTime']}', [Colors.red, 12],),
                    PWidget.boxh(4),
                    PWidget.textNormal('${data['mark']}', [Colors.black54, 12], {'max':2,
                    'ss':StrutStyle(forceStrutHeight: true, height: 1, leading: 0.9),}),

                    Divider(height: 1, color: Colors.grey[200],),
                  ], {
                    'exp': 1,
                  }),
                ],
                '001',
                {'fill': true},
              ),
              [null, null, Colors.white],
              {
                'pd': [0,12,12,12],
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
