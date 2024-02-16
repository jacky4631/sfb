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
import 'package:sufenbao/me/fans/fans_util.dart';
import 'package:sufenbao/service.dart';

import '../../util/global.dart';
import '../../util/paixs_fun.dart';
//我的粉丝的粉丝
class FansDetailPage extends StatelessWidget {
  final Map data;
  const FansDetailPage(this.data, {Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(
        children: [
          PWidget.container(null, [double.infinity, double.infinity], {'gd': PFun.cl2crGd(Colors.white, Colors.white)}),
          ScaffoldWidget(
            bgColor: Colors.transparent,
            brightness: Brightness.dark,
            appBar: buildTitle(context, title: '${data['showName']}的用户', widgetColor: Colors.black, leftIcon: Icon(Icons.arrow_back_ios)),
            body: TopChild(data)
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
    var res = await BService.fans(page, uid: widget.data['uid']);
    if (res != null) listDm.addList(res['data']['list'], isRef, res['data']['total']);
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: listDm,
      initialState: Global.showLoading2(),
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
          padding: EdgeInsets.only(bottom: 72),
          item: (i) {
            Map data = list[i] as Map;
            String phone = data['phone']??'';
            if(!Global.isEmpty(phone)) {
              phone = phone.replaceAll(phone.substring(3,7),"****");
            }
            String nickname = data['nickname'];
            if(nickname.isNotEmpty && Global.isPhone(nickname)) {
              nickname = nickname.replaceAll(nickname.substring(3,7), '****');
            }
            String showName = nickname.isEmpty ? phone : nickname;
            data['showName'] = showName;
            String feeStr = getFansFee(data['fee']??'0');

            String updateTime = data['updateTime'];
            return PWidget.container(
              PWidget.row(
                [
                  PWidget.wrapperImage('${data['avatar']}', [88, 88], {'br': 8}),

                  PWidget.boxw(28),
                  PWidget.column([
                    PWidget.row([
                      PWidget.text(showName, [Colors.black.withOpacity(0.75), 16], {'exp': true,'max':2}),
                    ]),
                    PWidget.boxh(8),
                    PWidget.text('', [], {'fun':(){
                      Navigator.pushNamed(context, '/feeTabPage', arguments: data);
                    }}, [
                      PWidget.textIs('近30天预估  ', [Colors.red, 12]),
                      PWidget.textIs(feeStr, [Colors.black45, 12], {'td': TextDecoration.underline}),
                    ]),
                    PWidget.boxh(8),
                    PWidget.text('', [], {}, [
                      PWidget.textIs('最近登录  ', [Colors.red, 12]),
                      PWidget.textIs(updateTime, [Colors.black45, 12], {}),
                    ]),
                  ], {
                    'exp': 1,
                  }),
                ],
                '001',
                {'fill': true},
              ),
              [null, null, Colors.white],
              {'pd': 12,},
            );
          },
        );
      },
    );
  }
}
