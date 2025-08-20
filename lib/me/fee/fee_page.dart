/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:sufenbao/me/styles.dart';
import 'package:sufenbao/service.dart';

import '../../util/colors.dart';
import '../../widget/rise_number_text.dart';
import '../../widget/tab_widget.dart';

//我的收益
class FeePage extends StatefulWidget {
  final Map data;
  const FeePage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _FeePageState createState() => _FeePageState();
}

class _FeePageState extends State<FeePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initData();
  }

  List<Map> tabList = [];
  bool isLoading = true;
  String? errorMessage;

  ///初始化函数
  Future<int> initData() async {
    try {
      Map user = widget.data['user'];
      tabList = [
        {'name': '今日', 'type': 1, 'user': user},
        {'name': '近7日', 'type': 6, 'user': user},
        {'name': '本月', 'type': 3, 'user': user},
        {'name': '上月', 'type': 4, 'user': user}
      ];

      setState(() {
        isLoading = false;
      });

      return DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      color: Colors.white,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: GestureDetector(
                    onTap: () => initData(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(height: 8),
                        Text('加载失败，点击重试'),
                      ],
                    ),
                  ),
                )
              : TabWidget(
                  color: Colours.app_main,
                  unselectedColor: Colors.black.withValues(alpha: 0.5),
                  indicatorColor: Colours.jd_main,
                  fontSize: 15,
                  tabList: tabList.map<String>((m) => m['name']).toList(),
                  indicatorWeight: 2,
                  tabPage: List.generate(tabList.length, (i) {
                    Map data = Map.from(tabList[i]);
                    data['cid'] = widget.data['cid'];
                    return FeeDetailPage(data);
                  }),
                ),
    );
  }
}

class FeeDetailPage extends StatefulWidget {
  final Map data;
  const FeeDetailPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _FeeDetailPageState createState() => _FeeDetailPageState();
}

class _FeeDetailPageState extends State<FeeDetailPage> {
  static const num defC = 0;
  static const String defP = '￥0';
  static const String keyC = 'count';
  static const String keyF = 'fee';
  num totalCount = defC;
  String totalFee = '￥0';
  num upCount = defC;
  String upFee = defP;
  num tbCount = defC;
  String tbFee = defP;
  num jdCount = defC;
  String jdFee = defP;
  num pddCount = defC;
  String pddFee = defP;
  num dyCount = defC;
  String dyFee = defP;
  num vipCount = defC;
  String vipFee = defP;

  num mtCount = defC;
  String mtFee = defP;
  @override
  void initState() {
    super.initState();
    initData();
  }

  List<DataRow> rows = [];
  bool isLoading = true;
  String? errorMessage;

  ///初始化函数
  Future initData() async {
    initFeeDetail(widget.data['type'], widget.data['cid']);
  }

  onclick(page, pageTwo, platform) {
    //如果是已结算，打开结算列表
    if (widget.data['cid'] == 6) {
      Navigator.pushNamed(context, '/moneyList', arguments: {'platform': platform});
      return;
    }

    Map vdData = widget.data['user'];
    vdData['page'] = page;
    vdData['pageTwo'] = pageTwo;
    Navigator.pushNamed(context, '/orderList', arguments: vdData);
  }

  void initFeeDetail(type, cid) async {
    num uid = 0;
    if (widget.data['user'] != null && widget.data['user']['uid'] != null) {
      uid = widget.data['user']['uid'];
    }
    Map detail = await BService.userFeeDetail(type: type, uid: uid, cid: cid);

    Map tb = detail['tb'] ?? {};
    Map jd = detail['jd'] ?? {};
    Map pdd = detail['pdd'] ?? {};
    Map dy = detail['dy'] ?? {};
    Map vip = detail['vip'] ?? {};
    Map mt = detail['mt'] ?? {};
    Map up = detail['up'] ?? {};

    upCount = up[keyC] ?? defC;
    upFee = up[keyF] ?? defP;
    tbCount = tb[keyC] ?? defC;
    tbFee = tb[keyF] ?? defP;
    jdCount = jd[keyC] ?? defC;
    jdFee = jd[keyF] ?? defP;
    pddCount = pdd[keyC] ?? defC;
    pddFee = pdd[keyF] ?? defP;
    dyCount = dy[keyC] ?? defC;
    dyFee = dy[keyF] ?? defP;
    vipCount = vip[keyC] ?? defC;
    vipFee = vip[keyF] ?? defP;
    mtCount = mt[keyC] ?? defC;
    mtFee = mt[keyF] ?? defP;

    Color chColor = Colors.black;
    Color sColor = Colors.grey[600]!;
    double ts = 14;
    bool clickable = (widget.data['user'] == null || widget.data['user']['clickable'] == null)
        ? false
        : widget.data['user']['clickable'];
    //总览不允许查看
    if (cid == 1) {
      clickable = false;
    }
    Widget arrowWidget = clickable ? Icon(Icons.arrow_forward_ios, color: sColor, size: ts) : SizedBox();
    bool showUpgrade = (cid == 2 || cid == 3 || cid == 7) ? false : true;
    bool showMt = cid == 7 ? false : true;

    int pageOne = cid - 1;
    if (cid == 3) {
      pageOne = 1;
    } else if (cid == 4 || cid == 5) {
      pageOne = cid - 1;
    } else if (cid == 7) {
      pageOne = 2;
    } else if (cid > 1) {
      pageOne = cid - 2;
    }
    rows = [
      if (showUpgrade)
        DataRow2(
            cells: [
              DataCell(Text('加盟星选', style: TextStyle(color: chColor, fontSize: ts))),
              DataCell(Text(upCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
              DataCell(Text(upFee, style: TextStyle(color: sColor, fontSize: ts))),
              DataCell(arrowWidget)
            ],
            onTap: clickable
                ? () {
                    if (cid == 6) {
                      onclick(pageOne, 6, 'up');
                    } else {
                      Navigator.pushNamed(context, '/moneyList', arguments: {'type': 'upgrade', 'title': '加盟星选明细'});
                    }
                  }
                : null),
      DataRow2(
          cells: [
            DataCell(Text('淘宝', style: TextStyle(color: chColor, fontSize: ts))),
            DataCell(Text(tbCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
            DataCell(SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(tbFee, style: TextStyle(color: sColor, fontSize: ts)))),
            DataCell(arrowWidget)
          ],
          onTap: clickable
              ? () {
                  onclick(pageOne, 0, 'tb');
                }
              : null),
      DataRow2(
          cells: [
            DataCell(Text('京东', style: TextStyle(color: chColor, fontSize: ts))),
            DataCell(Text(jdCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
            DataCell(SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(jdFee, style: TextStyle(color: sColor, fontSize: ts)))),
            DataCell(arrowWidget)
          ],
          onTap: clickable
              ? () {
                  onclick(pageOne, 1, 'jd');
                }
              : null),
      DataRow2(
          cells: [
            DataCell(Text('拼多多', style: TextStyle(color: chColor, fontSize: ts))),
            DataCell(Text(pddCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
            DataCell(SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(pddFee, style: TextStyle(color: sColor, fontSize: ts)))),
            DataCell(arrowWidget)
          ],
          onTap: clickable
              ? () {
                  onclick(pageOne, 2, 'pdd');
                }
              : null),
      DataRow2(
          cells: [
            DataCell(Text('抖音', style: TextStyle(color: chColor, fontSize: ts))),
            DataCell(Text(dyCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
            DataCell(SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(dyFee, style: TextStyle(color: sColor, fontSize: ts)))),
            DataCell(arrowWidget)
          ],
          onTap: clickable
              ? () {
                  onclick(pageOne, 3, 'dy');
                }
              : null),
      DataRow2(
          cells: [
            DataCell(Text('唯品会', style: TextStyle(color: chColor, fontSize: ts))),
            DataCell(Text(vipCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
            DataCell(SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(vipFee, style: TextStyle(color: sColor, fontSize: ts)))),
            DataCell(arrowWidget)
          ],
          onTap: clickable
              ? () {
                  onclick(pageOne, 4, 'vip');
                }
              : null),
      if (showMt)
        DataRow2(
            cells: [
              DataCell(Text('美团', style: TextStyle(color: chColor, fontSize: ts))),
              DataCell(Text(mtCount.toString(), style: TextStyle(color: sColor, fontSize: ts))),
              DataCell(SingleChildScrollView(
                  scrollDirection: Axis.horizontal, child: Text(mtFee, style: TextStyle(color: sColor, fontSize: ts)))),
              DataCell(arrowWidget)
            ],
            onTap: clickable
                ? () {
                    onclick(pageOne, 5, 'mt');
                  }
                : null),
    ];
    double min = 0;
    double max = 0;
    if (tb.isNotEmpty) {
      totalCount += tbCount;
      List<String> feeSplit = splitFee(tbFee);
      min += double.parse(feeSplit[0]);
      if (feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if (jd.isNotEmpty) {
      totalCount += jdCount;
      List<String> feeSplit = splitFee(jdFee);
      min += double.parse(feeSplit[0]);
      if (feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if (pdd.isNotEmpty) {
      totalCount += pddCount;
      List<String> feeSplit = splitFee(pddFee);
      min += double.parse(feeSplit[0]);
      if (feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if (dy.isNotEmpty) {
      totalCount += dyCount;
      List<String> feeSplit = splitFee(dyFee);
      min += double.parse(feeSplit[0]);
      if (feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if (vip.isNotEmpty) {
      totalCount += vipCount;
      List<String> feeSplit = splitFee(vipFee);
      min += double.parse(feeSplit[0]);
      if (feeSplit.length > 1) {
        max += double.parse(feeSplit[1]);
      }
    }
    if (showUpgrade && up.isNotEmpty) {
      totalCount += upCount;
      List<String> feeSplit = splitFee(upFee);
      if (feeSplit.length > 1) {
        min += double.parse(feeSplit[0]);
        max += double.parse(feeSplit[1]);
      } else {
        min += double.parse(feeSplit[0]);
        max += double.parse(feeSplit[0]);
      }
    }
    if (cid == 6) {
      totalFee = '￥${min.toStringAsFixed(2)}';
    } else if (max == 0) {
      totalFee = '￥0';
    } else {
      totalFee = '￥${min.toStringAsFixed(2)}-￥${max.toStringAsFixed(2)}';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return createMyItems();
  }

  List<String> splitFee(String fee) {
    return fee.replaceAll('￥', '').split('-');
  }

  Widget createMyItems() {
    List<Widget> widgets = <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('预估收入存在一定延时，以订单中心为准！', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('总销售笔数', style: TextStyle(color: Colors.black, fontSize: 15)),
                SizedBox(height: 5),
                Text('$totalCount', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('总${widget.data['cid'] == 6 ? '结算' : '预估'}收入',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                SizedBox(height: 5),
                Text(totalFee, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: 500,
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: DataTable2(
            columnSpacing: 1,
            horizontalMargin: 16,
            columns: [
              DataColumn2(
                label: Text('渠道', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text('销售笔数', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text('${widget.data['cid'] == 6 ? '结算' : '预估'}收入',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                size: ColumnSize.L,
              ),
              DataColumn2(label: Text(''), fixedWidth: 1, numeric: true),
            ],
            rows: rows),
      )
    ];
    return Container(
      color: Color(0xffF4F5F6),
      child: Column(children: widgets),
    );
  }

  createIntegralPanel() {
    List<Widget> widgets = [];
    widgets.add(Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(30, 15, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            child: Row(
              children: [
                Column(
                  children: [
                    Text('账户余额 (元)', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 5),
                    RiseNumberText(widget.data['nowMoney'], prefixTxt: '￥', style: TextStyles.ts(fontSize: 18)),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cashIndex', arguments: widget.data);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                    margin: EdgeInsets.fromLTRB(4, 4, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('立即提现', style: TextStyle(color: Colours.app_main)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
    widgets.add(SizedBox(height: 10));
    return Container(
      height: 120,
      color: Colours.app_main,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
      child: Column(children: widgets),
    );
  }
}
