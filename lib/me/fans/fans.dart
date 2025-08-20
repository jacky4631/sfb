/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sufenbao/me/fans/fans_util.dart';
import 'package:sufenbao/search/view.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/CustomWidgetPage.dart';

import '../../util/colors.dart';
import '../../util/global.dart';
import '../../util/login_util.dart';

import '../../widget/order_tab_widget.dart';
import 'fans_search_notifier.dart';

//我的粉丝
class Fans extends StatefulWidget {
  final Map data;
  Fans(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _FansState createState() => _FansState();
}

class _FansState extends State<Fans> {
  TextEditingController textCon = TextEditingController();
  List<Map> tabList = [
    {'title': '金客', 'index': 0},
    {'title': '银客', 'index': 1}
  ];
  bool tabLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (Global.appInfo.spreadLevel == 2) {
      body = TopChild({'title': '金客', 'index': 0});
    } else {
      body = tabLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : OrderTabWidget(
              color: Colours.app_main,
              unselectedColor: Colors.black.withValues(alpha: 0.5),
              fontSize: 15,
              tabList: tabList,
              padding: EdgeInsets.only(bottom: 10),
              indicatorColor: Colours.app_main,
              indicatorWeight: 2,
              tabPage: List.generate(tabList.length, (i) {
                return TopChild(tabList[i]);
              }),
            );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfffafafa),
      appBar: _searchBar(context),
      body: body,
    );
  }

  PreferredSizeWidget _searchBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(58 + MediaQuery.of(context).padding.top),
      child: Container(
        height: 58 + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top + 8, 8, 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black.withValues(alpha: 0.75),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colours.vip_dark, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: (textCon.text.isNotEmpty ? 1 : 0)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: buildTFView(context,
                            height: 56,
                            hintText: '搜索手机号码或用户昵称',
                            hintSize: 14,
                            textSize: 14,
                            textColor: Colors.black.withValues(alpha: 0.75),
                            con: textCon,
                            padding: EdgeInsets.symmetric(horizontal: 8), onChanged: (String text) {
                          if (text.isEmpty) {
                            fansSearchNotifier.value = '';
                          }
                        }, onSubmitted: (String text) {
                          fansSearchNotifier.value = text;
                        }),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        fansSearchNotifier.value = textCon.text;
                      },
                      child: Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colours.yellow_bg, Colours.vip_dark],
                          ),
                        ),
                        child: Text(
                          '搜索',
                          style: TextStyle(color: Colours.dark_text_color),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopChild extends StatefulWidget {
  final Map data;
  const TopChild(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  num total = 0;
  num index = 0;
  Map spreadUser = new Map();
  @override
  void initState() {
    initData();
    super.initState();
    fansSearchNotifier.addListener(initData);
  }

  @override
  void dispose() {
    fansSearchNotifier.removeListener(initData);
    super.dispose();
  }

  ///初始化函数
  Future initData() async {
    index = widget.data['index'];
    await getListData(isRef: true);
    await initSpreadUser();
  }

  ///列表数据
  List<Map> listData = [];
  bool hasNext = false;
  bool loading = false;

  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (loading) return 0;

    setState(() {
      loading = true;
    });

    var res;
    if (index == 0) {
      res = await BService.fans(page, keyword: fansSearchNotifier.value);
    } else {
      res = await BService.fans(page, grade: 1, keyword: fansSearchNotifier.value);
    }

    if (res != null) {
      total = res['data']['total'];
      List<Map> newList = List<Map>.from(res['data']['list'] ?? []);

      if (isRef) {
        listData = newList;
      } else {
        listData.addAll(newList);
      }

      hasNext = listData.length < total;
    }

    setState(() {
      loading = false;
    });

    return hasNext ? 1 : 0;
  }

  initSpreadUser() async {
    if (index == 0) {
      spreadUser = await BService.userSpread();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => this.getListData(isRef: true),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: top(),
          ),
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i >= listData.length) {
                    if (hasNext && !loading) {
                      // 触发加载更多
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        getListData(page: (listData.length ~/ 20) + 1);
                      });
                    }
                    return loading
                        ? Container(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(color: Colours.app_main),
                            ),
                          )
                        : SizedBox.shrink();
                  }

                  Map data = listData[i];
                  String phone = data['phone'] ?? '';
                  if (!Global.isEmpty(phone)) {
                    phone = phone.replaceAll(phone.substring(3, 7), "****");
                  }
                  String nickname = data['nickname'] ?? '';
                  if (nickname.isNotEmpty && Global.isPhone(nickname)) {
                    nickname = nickname.replaceAll(nickname.substring(3, 7), '****');
                  }
                  String showName = nickname.isEmpty ? phone : nickname;

                  data['showName'] = showName;
                  String feeStr = getFansFee(data['fee'] ?? '0');

                  String updateTime = data['updateTime'];
                  double padding = 12;
                  if (index != 0) {
                    padding = 56;
                  }
                  return Container(
                    height: 130,
                    color: Colors.white,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                AwesomeDialog(
                                    dialogType: DialogType.noHeader,
                                    showCloseIcon: true,
                                    context: context,
                                    body: CardDialog(data))
                                  ..show();
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage('${data['avatar']}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(showName),
                                      createFansLevelWidget(data),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '加入日期：${data['time']}',
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (index == 0)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/fansDetailPage', arguments: data);
                                },
                                child: Text(
                                  '邀请明细 >',
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                            if (index != 0)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/feeTabPage', arguments: data);
                                },
                                child: Text(
                                  '本月预估 >',
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    updateTime,
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.75),
                                    ),
                                  ),
                                  Text(
                                    '最近登录',
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              SizedBox(
                                height: 15,
                                child: VerticalDivider(
                                  color: Colors.black.withValues(alpha: 0.75),
                                ),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/feeTabPage', arguments: data);
                                    },
                                    child: Text(
                                      feeStr,
                                      style: TextStyle(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '本月预估',
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              if (index == 0) Spacer(),
                              if (index == 0)
                                SizedBox(
                                  height: 15,
                                  child: VerticalDivider(
                                    color: Colors.black.withValues(alpha: 0.75),
                                  ),
                                ),
                              if (index == 0) Spacer(),
                              if (index == 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/fansDetailPage', arguments: data);
                                      },
                                      child: Text(
                                        data['childCount'].toString(),
                                        style: TextStyle(
                                          color: Colors.black.withValues(alpha: 0.75),
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '用户数量',
                                      style: TextStyle(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: listData.length + (hasNext ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createFansLevelWidget(data) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
      child: Row(
        children: [
          SizedBox(width: 4),
          if (data['level'] == 5) getLevelWidget(5, 'tb'),
          if (data['levelJd'] == 5) getLevelWidget(5, 'jd'),
          if (data['levelPdd'] == 5) getLevelWidget(5, 'pdd'),
          if (data['levelDy'] == 5) getLevelWidget(5, 'dy'),
          if (data['levelVip'] == 5) getLevelWidget(5, 'vip'),
        ],
      ),
    );
  }

  Widget top() {
    if (index == 0) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (spreadUser.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    Global.getHideName(spreadUser['nickname']),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    spreadUser['phone'],
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '我的邀请人',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  '$total',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  Global.appInfo.spreadLevel == 3 ? '我的金客' : '我的用户',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    onTapLogin(context, '/sharePage');
                  },
                  child: Text(
                    '去邀请 >',
                    style: TextStyle(
                      color: Colours.app_main,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Text(
                '$total',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '我的银客',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class CardDialog extends Dialog {
  final Map data;
  CardDialog(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '我的用户',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            '您想为${data['showName']}做些什么',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  press(context, 0);
                },
                child: Text(
                  "加盟星选会员",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(top: 4, left: 14, right: 14, bottom: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colours.app_main,
                ),
              ),
            ],
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
    );
  }

  Future<void> press(BuildContext context, int rechargeType) async {
    Map<String, dynamic> card = await BService.userCard();
    String contractPath = card['contractPath'] ?? '';
    if (contractPath.isEmpty) {
      showSignDialog(context, () {
        Navigator.pushNamed(context, '/shopAuthPage');
      });
      return;
    }
    data['rechargeType'] = rechargeType;
    onTapLogin(context, '/tabVip', args: {'index': 0, 'user': data});
  }
}
