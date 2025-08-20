/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluwx/fluwx.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/me/fans/fans_search_notifier.dart';
import 'package:sufenbao/me/provider.dart';
import 'package:sufenbao/me/select_text_item.dart';
import 'package:sufenbao/me/styles.dart';
import 'package:sufenbao/util/bao_icons.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:sufenbao/widget/load_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/colors.dart';
import '../util/dimens.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../widget/CustomWidgetPage.dart';
import 'listener/PersonalNotifier.dart';
import 'me_widget.dart';

class MySelfPage extends ConsumerStatefulWidget {
  @override
  _MySelfPageState createState() => _MySelfPageState();
}

class _MySelfPageState extends ConsumerState<MySelfPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool showCode = false;
  bool showKefu = false;
  bool isShuaxin = true;
  static bool Notice = false;

  @override
  void initState() {
    super.initState();
    initData();
    personalNotifier.addListener(_handleValueChanged);
  }

  @override
  void dispose() {
    personalNotifier.removeListener(_handleValueChanged);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _handleValueChanged() {
    setState(() {
      initData();
    });
  }

  ///初始化函数
  Future<int> initData() async {
    try {
      if (Global.isWeb()) {
        showKefu = true;
      } else {
        showKefu = await fluwx.isWeChatInstalled;
      }
    } catch (e) {
      flog(e);
    }
    Global.initCommissionInfo();

    await Global.init();
    if (Global.isAndroid()) {
      await initNotice();
    }
    return getTime();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: ListView(children: createMeWidget()));
  }

  List<Widget> createMeWidget() {
    final userinfo = ref.watch(userProvider);
    final userFee = ref.watch(userFeeProvider).when(data: (data) => data, error: (o, s) => Map(), loading: () => Map());

    List<Widget> widgets = <Widget>[
      Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 8),
          child: Row(children: [
            Global.login ? _createUserInfo() : _createUnLogin(),
            Spacer(),
            _createSettingIcon(),
          ])),
      if (Notice)
        Container(
          height: 40,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          margin: EdgeInsets.fromLTRB(8, 0, 8, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Text("关闭通知会收不到现金到账提醒", style: TextStyle(color: Colors.grey, fontSize: 14)),
            Expanded(child: Text("")),
            TextButton(
                onPressed: () {
                  openAppSettings();
                  Notice = false;
                  setState(() {});
                },
                child: Text("立即开启", style: TextStyle(color: Colors.red, fontSize: 14))),
            IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Notice = false;
                  setState(() {});
                },
                icon: Icon(Icons.close, color: Colors.grey, size: 20)),
          ]),
        ),

      GestureDetector(
        onTap: () {
          personalNotifier.value = false;
          onTapLogin(context, '/feeTabPage', args: {'clickable': true});
        },
        child: Container(
          height: 145,
          child: Column(
            children: [
              Row(children: [
                SizedBox(width: 10),
                Text(
                  '余额 ',
                  style: TextStyle(color: Colors.white),
                ),
                !Global.login
                    ? Text('****', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text((userinfo.nowMoney + userinfo.unlockMoney).toStringAsFixed(2),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          Text('元', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    personalNotifier.value = false;
                    onTapLogin(context, '/cashIndex');
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: Colours.app_main,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '立即提现',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                  createTodayFee(context, userFee),
                  SizedBox(height: 5),
                  Text("今日预估", style: TextStyles.textWhite14)
                ]),
                Container(color: Color(0x50FFFFFF), width: 1, height: 23),
                Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                  createMonthFee(context, userFee),
                  SizedBox(height: 5),
                  Text("本月预估", style: TextStyles.textWhite14)
                ])
              ])
            ],
          ),
          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
          decoration: BoxDecoration(
            color: Colours.app_main,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
        ),
      ),
      // if(!Global.isIOS())
      Container(
          height: 68,
          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
          child: Stack(children: <Widget>[
            Positioned(
                child: Container(
                    height: 100,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[Color(0xFFFDECC3), Color(0xFFF7CD7C)]),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                    child: InkWell(
                        child: Row(children: <Widget>[
                          Image.asset("assets/images/me/vip.png", width: 18, height: 18),
                          SizedBox(width: 5),
                          Text("五大平台加盟", style: TextStyle(color: Color(0xFF85682F), fontSize: 14)),
                          Spacer(),
                          Text("星选会员", style: TextStyle(color: Color(0xFF85682F), fontSize: 14)),
                          SizedBox(width: 5),
                          Icon(Icons.keyboard_arrow_right, size: 16, color: Color(0xFF85682F))
                        ]),
                        onTap: () {
                          personalNotifier.value = false;
                          onTapLogin(context, '/tabVip', args: {'index': 0});
                        })),
                top: 0,
                left: 8,
                right: 8)
          ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.fromLTRB(8, 1, 0, 8),
          child: Column(children: <Widget>[
            SelectTextItem(
                title: '订单明细',
                content: '购物拆红包',
                contentWidget: ref.watch(hasUnlockOrderProvider).when(
                    data: (data) {
                      return data
                          ? shimmerWidget(
                              Text('有红包可拆',
                                  textAlign: TextAlign.end, style: TextStyle(color: Colors.red, fontSize: 14)),
                              color: Colors.red)
                          : null;
                    },
                    error: (_, __) => null,
                    loading: () => null),
                leading: Icon(BaoIcons.order, size: 20, color: Colors.black),
                onTap: () {
                  personalNotifier.value = false;
                  onTapLogin(context, '/orderList', args: {});
                }),
            SelectTextItem(
                title: '订单找回',
                leading: Icon(BaoIcons.zhaohui, size: 20, color: Colors.black),
                onTap: () {
                  personalNotifier.value = false;
                  onTapLogin(context, '/orderRetrieval');
                }),
          ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.fromLTRB(8, 1, 0, 8),
          child: Column(children: <Widget>[
            SelectTextItem(
                title: '我的用户',
                onTap: () {
                  fansSearchNotifier.value = '';
                  onTapLogin(context, '/fans');
                },
                leading: Icon(BaoIcons.fans, size: 20, color: Colors.black)),
            SelectTextItem(
                title: '分享App',
                content: '邀请好友领现金',
                contentWidget: shimmerWidget(
                    Text('邀请好友领现金', textAlign: TextAlign.end, style: TextStyle(color: Colors.red, fontSize: 14)),
                    color: Colors.red),
                onTap: () {
                  personalNotifier.value = false;
                  onTapLogin(context, '/sharePage');
                },
                leading: Icon(BaoIcons.share, size: 20, color: Colors.black)),
          ])),
      if (!hidePonitsMall)
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.fromLTRB(8, 1, 0, 8),
            child: Column(children: <Widget>[
              SelectTextItem(
                  title: '积分商城',
                  content: '积分当钱花',
                  onTap: () {
                    personalNotifier.value = false;
                    onTapLogin(context, '/pointsMall', args: {'integral': userinfo.integral});
                  },
                  leading: Icon(BaoIcons.shop, size: 20, color: Colors.black)),
            ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.fromLTRB(8, 1, 0, 8),
          child: Column(children: <Widget>[
            SelectTextItem(
                title: '我的收藏',
                onTap: () {
                  onTapLogin(context, '/collectPage');
                },
                leading: Icon(BaoIcons.collect, size: 20, color: Colors.black)),
            SelectTextItem(
                title: '新手教程',
                leading: Icon(BaoIcons.help, size: 20, color: Colors.black),
                onTap: () {
                  personalNotifier.value = false;
                  onTapLogin(context, '/helpPage');
                }),
            !showKefu
                ? SizedBox()
                : SelectTextItem(
                    title: '在线客服',
                    leading: Icon(BaoIcons.kefu, size: 20, color: Colors.black),
                    onTap: () {
                      openCustomer();
                    }),
          ])),
    ];
    return widgets;
  }

  openCustomer() {
    if (Global.isWeb()) {
      launchUrl(Uri.parse(Global.qiyeWechatServiceWebUrl));
    } else {
      fluwx.open(target: CustomerServiceChat(url: Global.qiyeWechatServiceUrl, corpId: Global.qiyeWechatServiceCropId));
    }
  }

  Widget buildTabBar() {
    final userinfo = ref.watch(userProvider);

    return buildTitle(context,
        title: Global.login ? userinfo.showName() : '我的',
        widgetColor: Colors.black,
        color: Colors.white,
        isNoShowLeft: true,
        leftIcon: null,
        rightWidget: Global.login
            ? Container(
                padding: EdgeInsets.only(right: 20),
                child: _createSettingIcon(),
              )
            : SizedBox(),
        notSplit: true);
  }

  Widget _createSettingIcon() {
    return GestureDetector(
      child: Row(
        children: [
          // 已注释掉的代码转换为:
          // GestureDetector(
          //   onTap: () {
          //     openCustomer();
          //   },
          //   child: Icon(BaoIcons.kefu, color: Colors.black54),
          // ),
          // SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              personalNotifier.value = false;
              Navigator.pushNamed(context, '/settings');
            },
            child: Icon(CupertinoIcons.gear_alt, color: Colors.black54),
          )
        ],
      ),
    );
  }

  _createUserInfo() {
    double headSize = 64;
    List<Widget> levelWidgets = [];
    final vipinfo = ref.watch(vipinfoProvider).when(data: (data) => data, error: (o, s) => Map(), loading: () => Map());

    num level = ValueUtil.toNum(vipinfo['level']);

    var levelName = '';
    var levelImage = '';

    if (level > 1) {
      levelImage = getVipBgImage(level);
      levelName = vipinfo['levelName'];
    }

    if (vipinfo['level'] != null && vipinfo['level'] > 1) {
      if (vipinfo['levelJd'] > 1 || vipinfo['levelPdd'] > 1 || vipinfo['levelDy'] > 1 || vipinfo['levelVip'] > 1) {
        if (vipinfo['level'] > 4) {
          levelWidgets.add(getLevelWidget(vipinfo['level'], 'tb'));
          levelWidgets.add(SizedBox(width: 1));
        }
        if (vipinfo['levelJd'] > 4) {
          levelWidgets.add(getLevelWidget(vipinfo['levelJd'], 'jd'));
          levelWidgets.add(SizedBox(width: 1));
        }
        if (vipinfo['levelPdd'] > 4) {
          levelWidgets.add(getLevelWidget(vipinfo['levelPdd'], 'pdd'));
          levelWidgets.add(SizedBox(width: 1));
        }
        if (vipinfo['levelDy'] > 4) {
          levelWidgets.add(getLevelWidget(vipinfo['levelDy'], 'dy'));
          levelWidgets.add(SizedBox(width: 1));
        }
        if (vipinfo['levelVip'] > 4) {
          levelWidgets.add(getLevelWidget(vipinfo['levelVip'], 'vip'));
          levelWidgets.add(SizedBox(width: 1));
        }
      } else {
        levelWidgets = [
          Image.asset(levelImage, width: 16, height: 16),
          Text('$levelName', style: TextStyle(color: Colours.vip_white, fontSize: 14))
        ];
      }
    }

    final userinfo = ref.watch(userProvider);
    final energy = ref.watch(getEnergyProvider);

    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              personalNotifier.value = false;
              onTapLogin(context, '/personal');
            },
            child: Container(
              child: createHeadImgWidget(headSize, 28.0),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        personalNotifier.value = false;
                        onTapLogin(context, '/personal');
                      },
                      child: Text(
                        userinfo.showName(),
                        style: TextStyle(color: Colors.black, fontSize: Dimens.font_sp20),
                      ),
                    ),
                    SizedBox(width: 5),
                    Global.isEmpty(levelName)
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              personalNotifier.value = false;
                              onTapLogin(context, '/tabVip', args: {'index': 0});
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(1, 1, 4, 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: levelWidgets),
                            ),
                          ),
                  ],
                ),
              ]),
              Row(children: [
                Text('邀请口令：${showCode ? userinfo.code : '******'}', style: TextStyles.textBlack),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    if (showCode) {
                      showCode = false;
                    } else {
                      showCode = true;
                    }
                    setState(() {});
                  },
                  child: Icon(Icons.remove_red_eye_outlined, color: Colors.black, size: 18),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () =>
                      {FlutterClipboard.copy('${userinfo.code}').then((value) => ToastUtils.showToast('复制成功'))},
                  child: Text(
                    '复制',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimens.font_sp12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    personalNotifier.value = false;
                    Navigator.pushNamed(context, "/personal");
                  },
                  child: Text(
                    '绑定',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimens.font_sp12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    personalNotifier.value = false;
                    Navigator.pushNamed(context, "/koulingPage");
                  },
                  child: Text(
                    '申请专属口令',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimens.font_sp12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(width: 17),
                energy.when(
                    data: (userEnergy) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colours.app_main,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Row(children: [
                          rainbowText("热度:${(userEnergy['totalEnergy'] as num).toStringAsFixed(1)}", fontSize: 10.0,
                              onTap: () {
                            _createEnergyPop(userEnergy);
                          }),
                          Icon(Icons.arrow_drop_down, color: Colors.white, size: 12)
                        ]),
                      );
                    },
                    error: (_, __) => SizedBox(),
                    loading: () => SizedBox())
              ]),
            ],
          )
        ],
      ),
    );
  }

  Widget createHeadImgWidget(headSize, radius) {
    final userinfo = ref.watch(userProvider);
    print(userinfo.avatar);
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius), //设置圆角
        child: userinfo.avatar.isNotEmpty
            ? LoadImage(
                userinfo.avatar,
                height: headSize,
                width: headSize,
              )
            : SizedBox(
                width: headSize,
                height: headSize,
              ));
  }

  _createUnLogin() {
    return GestureDetector(
      onTap: () {
        personalNotifier.value = false;
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        //   return const AliAuthPage();
        // }));
        onTapLogin(context, '/personal');
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 16, 0, 16),
        child: Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(56),
            ),
            child: Icon(Icons.person, color: Colors.black12),
          ),
          SizedBox(width: 8),
          Text(
            '点击登录',
            style: TextStyle(
              color: Colors.black54,
              fontSize: Dimens.font_sp16,
            ),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }

  Widget createItem(i, v) {
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              v['itempic'],
              width: 124,
              height: 124,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8),
          Column(
            children: [
              Text(
                v['itemtitle'],
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  '${v['activity_gameplay']}',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
              ),
              Spacer(),
              Text(
                '${Decimal.parse(v['itemendprice']).toString()}元',
                style: TextStyle(
                  color: Colours.app_main,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
    );
  }

  Future initNotice() async {
    if (await Permission.notification.request().isGranted) {
      //允许通知
      Notice = false;
    } else {
      //不允许通知
      Notice = true;
    }
    setState(() {});
  }

  // 修复flog和getTime方法未定义的问题
  void flog(dynamic e) {
    print("Error: $e");
  }

  int getTime() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void _createEnergyPop(Map<dynamic, dynamic> userEnergy) {
    showMenu(
        // color: Colors.grey[350],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey)),
        context: context,
        position: RelativeRect.fromSize(Rect.fromLTRB(150, 130, 0, 0), Size(48, 0)),
        elevation: 10,
        items: <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
              height: 28,
              value: 'Item01',
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/mall/tb.png', width: 16, height: 16),
                ),
                Text('热度：', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 2),
                Text('${userEnergy['tbEnergy'] + userEnergy['tbTuiEnergy']}',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ])),
          PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem<String>(
              height: 28,
              value: 'Item02',
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/mall/jd.png', width: 16, height: 16),
                ),
                Text('热度：', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 2),
                Text('${userEnergy['jdEnergy'] + userEnergy['jdTuiEnergy']}',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ])),
          PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem<String>(
              height: 28,
              value: 'Item03',
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/mall/pdd.png', width: 16, height: 16),
                ),
                Text('热度：', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 2),
                Text('${userEnergy['pddEnergy'] + userEnergy['pddTuiEnergy']}',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ])),
          PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem<String>(
              height: 28,
              value: 'Item04',
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/mall/dy.png', width: 16, height: 16),
                ),
                Text('热度：', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 2),
                Text('${userEnergy['dyEnergy'] + userEnergy['dyTuiEnergy']}',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ])),
          PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem<String>(
              height: 28,
              value: 'Item05',
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/mall/vip.png', width: 16, height: 16),
                ),
                Text('热度：', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 2),
                Text('${userEnergy['vipEnergy'] + userEnergy['vipTuiEnergy']}',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ])),
          PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem<String>(
              height: 35,
              value: 'Item06',
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/energyPage');
                },
                child: Row(children: [Text('查看详情>', style: TextStyle(color: Colors.blue))]),
              ))
        ]).then((value) {
      if (null == value) {
        return;
      }
    });
  }
}
