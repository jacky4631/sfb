/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/energy/wave_view.dart';
import 'package:sufenbao/me/styles.dart';

import '../service.dart';
import '../util/colors.dart';
import '../util/login_util.dart';
import '../widget/rise_number_text.dart';

///热度页面
class EnergyPage extends StatefulWidget {
  final Map data;
  const EnergyPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _EnergyPageState createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage> with TickerProviderStateMixin {
  late TabController tabCon;
  int index = 0;
  List tabList = [];
  Map userEnergy = {};
  bool loadingEnergy = true;
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future<int> initData() async {
    await getListData(isRef: true);
    await getEnergy();

    return 1333;
  }

  ///列表数据
  var listDm = EnergyDataModel();
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    listDm.addList([
      {"test": 1}
    ], isRef, 1);
    setState(() {});
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future getEnergy() async {
    userEnergy = await BService.getEnergyDetail();
    setState(() {
      loadingEnergy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('星选会员', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await initData();
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(headers),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < listDm.list.length) {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(),
                    );
                  } else if (listDm.hasNext) {
                    // Load more trigger
                    getListData(page: listDm.page + 1);
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return null;
                },
                childCount: listDm.list.length + (listDm.hasNext ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get headers {
    return [
      Container(
        height: 700,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colours.app_main, Colours.app_main],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('总热度', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5),
                      loadingEnergy
                          ? SizedBox()
                          : RiseNumberText(userEnergy['totalEnergy'], fixed: 1, style: TextStyles.ts(fontSize: 24)),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/energyList', arguments: widget.data);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                      margin: EdgeInsets.fromLTRB(4, 4, 8, 8),
                      child: Text('热度明细', style: TextStyle(color: Colours.app_main)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.fromLTRB(10, 15, 8, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/images/mall/tb.png', width: 18, height: 18),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/images/mall/jd.png', width: 18, height: 18),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/images/mall/pdd.png', width: 18, height: 18),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/images/mall/dy.png', width: 18, height: 18),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/images/mall/vip.png', width: 18, height: 18),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loadingEnergy ? '赠送: ' : '赠送: ${userEnergy['tbEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '赠送: ' : '赠送: ${userEnergy['jdEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '赠送: ' : '赠送: ${userEnergy['pddEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '赠送: ' : '赠送: ${userEnergy['dyEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '赠送: ' : '赠送: ${userEnergy['vipEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loadingEnergy ? '推广: ' : '推广: ${userEnergy['tbTuiEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '推广: ' : '推广: ${userEnergy['jdTuiEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '推广: ' : '推广: ${userEnergy['pddTuiEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '推广: ' : '推广: ${userEnergy['dyTuiEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(height: 8),
                          Text(loadingEnergy ? '推广: ' : '推广: ${userEnergy['vipTuiEnergy']}',
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            loadingEnergy
                ? SizedBox()
                : Container(
                    decoration: BoxDecoration(
                      color: Colours.energy_bg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.fromLTRB(10, 15, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        createEnergyChangeWidget('tbDay', 'tb'),
                        SizedBox(width: 20),
                        createEnergyChangeWidget('jdDay', 'jd'),
                        SizedBox(width: 20),
                        createEnergyChangeWidget('pddDay', 'pdd'),
                        SizedBox(width: 20),
                        createEnergyChangeWidget('dyDay', 'dy'),
                        SizedBox(width: 20),
                        createEnergyChangeWidget('vipDay', 'vip'),
                      ],
                    ),
                  ),
            SizedBox(height: 10),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '热度规则',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('\t1.热度作用：获取用户下单后拆红包提成；', style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text('\t2.赠送热度来源：加盟星选会员赠送，',
                            style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                      ),
                      GestureDetector(
                        onTap: () {
                          onTapLogin(context, '/tabVip', args: {'index': 0});
                        },
                        child: Text('去加盟>',
                            style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.underline),
                            maxLines: 2),
                      ),
                    ],
                  ),
                  Text('\t3.推广热度来源：自购拆红包、用户拆红包、用户加盟星选会员；',
                      style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                  Text('\t4.点击+-设置每日消耗的热度；', style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                  Text('\t5.热度每日消耗可设置范围50-500；', style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                  Text('\t6.热度消耗越大当日热度订单越多；', style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                  Text('\t7.热度不足时，当日不消耗；', style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  Widget createEnergyChangeWidget(key, platform) {
    return createDayWidget(userEnergy[key], platform, () {
      addEnergyFun(key, platform);
    }, () {
      removeEnergyFun(key, platform);
    });
  }

  Widget createDayWidget(energy, platform, Function addF, Function removeF) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => addF(),
          child: Icon(Icons.add, color: Colors.black, size: 24),
        ),
        SizedBox(height: 8),
        Container(
          width: 50,
          height: 160,
          child: WaveView(percentageValue: energy / 5, txt: '店', platform: platform),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => removeF(),
          child: Icon(Icons.remove, color: Colors.black, size: 24),
        ),
      ],
    );
  }

  Future addEnergyFun(key, platform) async {
    num tbDay = userEnergy[key];
    if (tbDay + userEnergy['defaultDayEnergy'] > userEnergy['dayEnergyMax']) {
      ToastUtils.showToast('单日消耗热度不能大于${userEnergy['dayEnergyMax']}');
      return;
    }
    userEnergy = await BService.setEnergy(tbDay + userEnergy['defaultDayEnergy'], platform);
    setState(() {});
  }

  Future removeEnergyFun(key, platform) async {
    num tbDay = userEnergy[key];
    if (tbDay - userEnergy['defaultDayEnergy'] < userEnergy['defaultDayEnergy']) {
      ToastUtils.showToast('单日消耗热度不能小于${userEnergy['defaultDayEnergy']}');
      return;
    }
    userEnergy = await BService.setEnergy(tbDay - userEnergy['defaultDayEnergy'], platform);
    setState(() {});
  }
}

class EnergyDataModel {
  List list = [];
  bool hasNext = true;
  int page = 1;

  void addList(List newList, bool isRefresh, int totalPages) {
    if (isRefresh) {
      list = newList;
      page = 1;
    } else {
      list.addAll(newList);
    }
    hasNext = page < totalPages;
    if (!isRefresh) page++;
  }

  void clear() {
    list.clear();
    hasNext = true;
    page = 1;
  }
}
