/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/me/fee/fee_page.dart';
import 'package:sufenbao/util/global.dart';

import '../../dialog/income_rule_dialog.dart';
import '../../util/colors.dart';
import '../../widget/order_tab_widget.dart';
import '../../widget/rise_number_text.dart';
import '../styles.dart';

//订单明细
class FeeTabPage extends StatefulWidget {
  final Map data;
  const FeeTabPage(this.data, {Key? key,}) : super(key: key);

  @override
  _FeeTabPageState createState() => _FeeTabPageState();
}

class _FeeTabPageState extends State<FeeTabPage> {
  @override
  void initState() {
    mockDetail();
    initData();
    super.initState();
  }

  ///tab数据
  List<Map> tabList = [];
  bool tabLoading = true;
  ///初始化函数
  Future<int> initData() async {
    List list = [];
    list.addAll([
      {'title':'总览','cid': 1},
      {'title':'自购','cid': 2},
      {'title':'热度订单','cid': 7}
    ]);
    if(Global.appInfo.spreadLevel == 3) {
      list.add({'title':'金客','cid': 4});
      list.add({'title':'银客','cid': 5});
    } else {
      list.add({'title':'用户','cid': 4});
    }
    list.add({'title':'已结算','cid': 6});
    tabList = list.cast<Map>();
    tabLoading = false;

    setState(() {});
    return 1;
  }
  List<Map> mockList = [];
  bool mockLoading = true;
  Future<int> mockDetail() async {

    mockList = [{'name':'1'}];
    mockLoading = false;
    setState(() {});
    return 1;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colours.app_main,
            appBar: AppBar(
              title: Text(
                widget.data['showName']!=null ? '${widget.data['showName']}的收益' : '我的收益',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colours.app_main,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: TextButton(
                    onPressed: () {
                      showGeneralDialog(
                          context: context,
                          barrierDismissible:false,
                          barrierLabel: '',
                          transitionDuration: Duration(milliseconds: 200),
                          pageBuilder: (BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
                            return Scaffold(backgroundColor: Colors.transparent, body:IncomeRuleDialog(
                                {}, (){

                            }));
                          });
                    },
                    child: Text('收益规则', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            body: createGoodsList(),
          ),
        ],
      ),
    );
  }

  Widget createGoodsList() {
    return RefreshIndicator(
      onRefresh: () => this.mockDetail(),
      child: CustomScrollView(
        slivers: [
          if(widget.data['showName'] == null)
            SliverToBoxAdapter(
              child: createIntegralPanel(),
            ),
          SliverToBoxAdapter(
            child: Container(
              height: 1000,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: tabLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : OrderTabWidget(
                      color: Colours.app_main,
                      unselectedColor: Colors.black.withValues(alpha: 0.5),
                      fontSize: 16,
                      tabList: tabList,
                      padding: EdgeInsets.only(bottom: 8),
                      indicatorColor: Colours.jd_main,
                      indicatorWeight: 2,
                      tabPage: List.generate(tabList.length, (i) {
                        Map data = Map.from(tabList[i]);
                        data['user'] = widget.data;
                        return FeePage(data);
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
  createIntegralPanel() {
    List<Widget> widgets = [];
    widgets.add(Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.fromLTRB(8, 30, 8, 15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('余额 (元)', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 5),
                    RiseNumberText(Global.userinfo!.nowMoney + Global.userinfo!.unlockMoney, prefixTxt: '￥', style: TextStyles.ts(fontSize: 18)),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cashIndex', arguments: widget.data);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
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
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: widgets,
      ),
    );
  }
}