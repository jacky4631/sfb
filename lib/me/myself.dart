/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/my_custom_scroll.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sufenbao/me/fans/fans_search_notifier.dart';
import 'package:sufenbao/me/model/userinfo.dart';
import 'package:sufenbao/me/select_text_item.dart';
import 'package:sufenbao/me/styles.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/util/bao_icons.dart';
import 'package:sufenbao/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page/product_details.dart';
import '../util/colors.dart';
import '../util/dimens.dart';
import '../util/global.dart';
import '../util/login_util.dart';
import '../util/paixs_fun.dart';
import '../widget/CustomWidgetPage.dart';
import 'listener/PersonalNotifier.dart';
import 'me_widget.dart';

class TitleBarNotify extends ValueNotifier {
  TitleBarNotify() : super(null);
  var isShowTtitleBar = false;
  void changeIsShowTabbar(v) {
    isShowTtitleBar = v;
    notifyListeners();
  }
}

TitleBarNotify titleBarNotify = TitleBarNotify();

class MySelfPage extends StatefulWidget {
  @override
  _MySelfPageState createState() => _MySelfPageState();
}

class _MySelfPageState extends State<MySelfPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Map<String, dynamic> json;
  String avatar = '';
  String nickName = '';
  String code = '';
  String codeX = '******';
  bool showCode = false;
  num nowMoney = 0;
  bool loading = true;
  bool showKefu = false;
  String levelName = '';
  var image = '';
  bool isShuaxin = true;
  bool hasUnlockOrder = false;
  Map? userFee = null;
  Map vipinfo = {};
  static bool Notice = false;

  Map userEnergy = {};
  bool loadingEnergy = true;

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
    setState(() {
      loading = true;
    });
    try{
      if (Global.isWeb()) {
        showKefu = true;
      } else {
        showKefu = await isWeChatInstalled;
      }
    }catch(e) {
      flog(e);
    }
    json = await BService.userinfo(baseInfo: true);
    setState(() {
      loading = false;
    });
    initGoodsData(page: 1, isRef: true);
    if (json == null || json.isEmpty) {
      return getTime();
    }
    Global.initCommissionInfo();
    Userinfo userinfo = Userinfo.fromJson(json);
    Global.userinfo = userinfo;

    setState(() {
      avatar = userinfo.avatar;
      nickName = userinfo.showName();
      code = userinfo.code;
      nowMoney = userinfo.nowMoney;
      //todo 刷新 积分 提现 粉丝
    });

    JPush jpush = new JPush();
    jpush.setAlias('uid${userinfo.uid.toString()}').then((map) {
      print("设置别名成功$map");
    });
    hasUnlockOrder = await BService.hasUnlockOrder();
    setState(() {

    });
    await initUserFee();
    await initVipInfo();
    await Global.init();
    if(Global.isAndroid()) {
      await initNotice();
    }
    await getEnergy();
    return getTime();
  }
  Future getEnergy() async {
    userEnergy = await BService.getEnergy();
    setState(() {
      loadingEnergy = false;
    });
  }
  Future initUserFee() async {
    userFee = await BService.userFee();
    setState(() {

    });
  }
  Future initVipInfo() async {
    vipinfo = await BService.vipinfo();
    num level = vipinfo['level'];

    if (level > 1) {
      image = getVipBgImage(level);
      levelName = vipinfo['levelName'];
    }
    setState(() {

    });
  }
  var listDm = DataModel();
  Future<int> initGoodsData({int page = 1, bool isRef = false}) async {
    if(Global.isWeb()) {
      listDm.hasNext = false;
      isShuaxin = false;
      setState(() {});
      return 0;
    }
    await initUserFee();
    var cateId = '185';
    if(Global.homeUrl['myCateId'] != null) {
      cateId = Global.homeUrl['myCateId'];
    } else {
      var resCate = await BService.pickCate().catchError((v) {
      });
      if (resCate != null && resCate.isNotEmpty) {
        cateId = resCate[0]['id'];
      }
    }
    var res = await BService.pickList(page, cateId).catchError((v) {
      listDm.toError('网络异常');
    });
    if (res != null && res.isNotEmpty) {
      listDm.addList(res, isRef, 500);
    } else {
      listDm.hasNext = false;
    }
    setState(() {});
    return listDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
        bgColor: Color(0xffF4F5F6),
        brightness: Brightness.dark,
        body: createGoodsList(),
        );
  }

  Widget createGoodsList() {
    return MyCustomScroll(
      isGengduo: listDm.hasNext,
      isShuaxin: isShuaxin,
      onRefresh: () => this.initData(),
      onLoading: (p) => this.initGoodsData(page: p),
      refHeader: buildClassicHeader(color: Colours.app_main),
      refFooter: buildCustomFooter(color: Colors.grey),
      itemModel: listDm,
      itemPadding: EdgeInsets.all(8),
      headers: createMeWidget(),
      onScrollToList: (b, v) => titleBarNotify.changeIsShowTabbar(b),
      maskWidget: () => ValueListenableBuilder(
        valueListenable: titleBarNotify,
        builder: (_, __, ___) {
          return PWidget.positioned(
            PWidget.container(
              titleBarNotify.isShowTtitleBar ? buildTabBar() : null,
              [null, null, Colors.white],
              {'sd': PFun.sdLg(Colors.white),},
            ),
            [titleBarNotify.isShowTtitleBar ? 0 : -(2 + pmPadd.top), null, 0, 0],
          );
        },
      ),
      itemModelBuilder: (i, v) {
        return PWidget.container(
            Global.openFadeContainer(createItem(i, v), ProductDetails(v)),
            [null, null, Colors.white],
            {
              'sd': PFun.sdLg(Colors.black12), 'br': 8, 'mg': PFun.lg(0, 6), 'crr': [5,5,5,5]
            });
      },
    );
  }

  List<Widget> createMeWidget() {
    bool feeEmpty = userFee== null || userFee!.isEmpty;
    List<Widget> widgets = <Widget>[
      _createUserTop(),
        if(Notice)
        PWidget.container(
          PWidget.row([
            Text("关闭通知会收不到现金到账提醒",style: TextStyle(color: Colors.grey,fontSize: 14)),
            Expanded(child: Text("")),
                TextButton(onPressed: () {
                    openAppSettings();
                    Notice = false;
                    setState(() {});
                },
                  child:
                  Text("立即开启",style: TextStyle(color: Colors.red,fontSize: 14))),
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Notice = false;
                      setState(() {});
                  },
                  icon: PWidget.icon(Icons.close,[Colors.grey,20])),
          ]),
          [null, 40, Colors.white], //宽度，高度，背景色
            { 'pd': PFun.lg(0, 0, 20, 0), //padding
              'br': PFun.lg(10, 10, 10, 10), //圆角
              'mg': PFun.lg(0, 6, 8, 8)   //margin
            }
        ),
        PWidget.container(
            PWidget.column([
              PWidget.row([
                PWidget.textNormal('可提现 ', [Colours.dark_text_color]),
                !Global.login ? PWidget.text('****',[Colors.white, 20, true]):
                PWidget.text(nowMoney.toStringAsFixed(2),[Colors.white, 20, true],{},[
                  PWidget.textIsNormal('元',[Colors.white, 14]),
                ],),
                PWidget.spacer(),
                PWidget.container(PWidget.textNormal('立即提现', [Colors.white]),
                  [null, null, Colours.app_main],
                  {'bd': PFun.bdAllLg(Colors.white), 'pd': PFun.lg(8, 8, 16, 16),
                    'mg': PFun.lg(8, 8, 8, 8),'br': PFun.lg(16, 16, 16, 16),'fun':(){
                    personalNotifier.value = false;
                    onTapLogin(context, '/cashIndex');
                  }},

                )
              ],{'pd':[0,0,10,10]}),
              PWidget.boxh(10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          createTodayFee(context, feeEmpty, userFee),
                          PWidget.boxh(5),
                          Text("今日预估", style: TextStyles.textWhite14)
                        ]),
                    Container(color: Color(0x50FFFFFF), width: 1, height: 23),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          createMonthFee(context, feeEmpty, userFee),
                          PWidget.boxh(5),
                          Text("本月预估", style: TextStyles.textWhite14)
                        ])
                  ])
            ]),
            [null, 145, Colours.app_main],
            {'pd': PFun.lg(16, 8, 8, 8),'bd': PFun.bdAllLg(Colors.white),
              'br': PFun.lg(16, 16, 16, 16),'mg': PFun.lg(0, 0, 8, 8), 'fun': (){
              personalNotifier.value = false;
              onTapLogin(context, '/feeTabPage', args: {'nowMoney': json['nowMoney'],'clickable':true});
            }
            }
        ),
        if(!Global.isIOS())
        PWidget.container(
        Stack(children: <Widget>[
          Positioned(
            child: Container(
                height: 100,
                width: double.infinity,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Color(0xFFFDECC3), Color(0xFFF7CD7C)]),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),),
                child: InkWell(
                    child: Row(children: <Widget>[
                      Image.asset("assets/images/me/vip.png",
                          width: 18, height: 18),
                      PWidget.boxw(5),
                      Text("五大平台加盟",
                          style: TextStyle(
                              color: Color(0xFF85682F), fontSize: 14)),
                      Spacer(),
                      Text("星选会员",
                          style: TextStyle(
                              color: Color(0xFF85682F), fontSize: 14)),
                      PWidget.boxw(5),
                      Icon(Icons.keyboard_arrow_right,
                          size: 16, color: Color(0xFF85682F))
                    ]),
                    onTap: () {
                      personalNotifier.value = false;
                      onTapLogin(context, '/tabVip', args: {'index': 0});
                    })),
            top: 0,
            left: 8,
            right: 8)]),
        [null, 68, ],{'pd': [4, 0, 0,0],}
        ),
      PWidget.container(Column(children: <Widget>[
          SelectTextItem(
              title: '订单明细',
              content: '购物拆红包',
              contentWidget: hasUnlockOrder ? shimmerWidget(Text('有红包可拆',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.red, fontSize: 14)),
                  color: Colors.red):null,
              leading: Icon(BaoIcons.order, size: 20, color: Colors.black),
              onTap: () {
                personalNotifier.value = false;
                onTapLogin(context, '/orderList',args: {});
              }),
          SelectTextItem(
              title: '订单找回',
              leading: Icon(BaoIcons.zhaohui, size: 20, color: Colors.black),
              onTap: () {
                personalNotifier.value = false;
                onTapLogin(context, '/orderRetrieval');
              }),
        if(!hidePonitsMall)
        SelectTextItem(
            title: '积分商城',
            content: '积分当钱花',
            onTap: () {
              personalNotifier.value = false;
              onTapLogin(context, '/pointsMall', args: {'integral': json['integral']});
            },
            leading: Icon(BaoIcons.shop, size: 20, color: Colors.black)),
        ]),
        {'br': 8, 'pd': [0, 1, 8,8],}
      ),
      PWidget.container(Column(children: <Widget>[
          SelectTextItem(
              title: '我的用户',
              onTap: () {
                fansSearchNotifier.value = '';
                //rechargeType 0=正式 1=体验 2=月卡
                onTapLogin(context, '/fans');
              },
              leading: Icon(BaoIcons.fans, size: 20, color: Colors.black)),
          SelectTextItem(
              title: '分享App',
              content: '用户购物返红包',
              onTap: () {
                personalNotifier.value = false;
                onTapLogin(context, '/sharePage');
              },
              leading: Icon(BaoIcons.share, size: 20, color: Colors.black)),
        ]),
          {'br': 8, 'pd': [0, 1, 8,8],}
      ),
      if(!hidePonitsMall)
      PWidget.container(Column(children: <Widget>[
          SelectTextItem(
              title: '积分商城',
              content: '积分当钱花',
              onTap: () {
                personalNotifier.value = false;
                onTapLogin(context, '/pointsMall', args: {'integral': json['integral']});
              },
              leading: Icon(BaoIcons.shop, size: 20, color: Colors.black)),
        ]), {'br': 8, 'pd': [0, 1, 8,8],}
      ),
      PWidget.container(Column(children: <Widget>[
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
        ]), {'br': 16, 'pd': [0, 0, 8,8],}
      ),
      if (listDm.list.isNotEmpty)
        PWidget.container(
          PWidget.text('┉┉∞  品牌全网真折扣  ∞┉┉', [Colors.grey, 16, true], { 'ct': true}),
          [null, null, Colors.white],
          {'br': 8, 'pd': [8, 8, 8,8],'mg':[0, 0, 8,8],},
        ),
    ];
    return widgets;
  }

  openCustomer() {
    if(Global.isWeb()) {
      launchUrl(Uri.parse(Global.qiyeWechatServiceWebUrl));
    } else {
      openWeChatCustomerServiceChat(
          url: Global.qiyeWechatServiceUrl,
          corpId: Global.qiyeWechatServiceCropId);
    }
  }

  _createUserTop() {
    return PWidget.container(
        PWidget.row([
          PWidget.container(Global.login ? _createUserInfo() : _createUnLogin()),
          Spacer(),
          _createSettingIcon(),
        ],'221'),{'br': 8, 'pd': [MediaQuery.of(context).padding.top + 15, 8, 8,8], 'mg': PFun.lg(0, 8, 8, 8),});
  }

  Widget buildTabBar() {
    return buildTitle(context,
        title: Global.login? nickName : '我的',
        widgetColor: Colors.black,
        color: Colors.white,
        isNoShowLeft: true,
        leftIcon: null,
        rightWidget: Global.login ? PWidget.container(_createSettingIcon(), {'pd':[0,0,0,20]}) : SizedBox(),
        notSplit: true);
  }

  Widget _createSettingIcon(){
    return PWidget.container(PWidget.row([
      PWidget.icon(BaoIcons.kefu, [
        Colors.black54
      ], {
        'fun': () {
          openCustomer();
        }
      }),
      PWidget.boxw(8),
      PWidget.icon(CupertinoIcons.gear_alt, [
        Colors.black54
      ], {
        'fun': () {
          personalNotifier.value = false;
          Navigator.pushNamed(context, '/settings');
        }
      })
    ]));
  }
  _createUserInfo() {
    double headSize = 64;
    List<Widget> levelWidgets = [];
    if(vipinfo['level'] != null && vipinfo['level'] > 1) {
      if(vipinfo['levelJd']>1 || vipinfo['levelPdd']>1 || vipinfo['levelDy']>1 || vipinfo['levelVip']>1){
        if(vipinfo['level']>4){
          levelWidgets.add(getLevelWidget(vipinfo['level'],'tb'));
          levelWidgets.add(PWidget.boxw(1));
        }
        if(vipinfo['levelJd']>4){
          levelWidgets.add(getLevelWidget(vipinfo['levelJd'],'jd'));
          levelWidgets.add(PWidget.boxw(1));
        }
        if(vipinfo['levelPdd']>4){
          levelWidgets.add(getLevelWidget(vipinfo['levelPdd'],'pdd'));
          levelWidgets.add(PWidget.boxw(1));
        }
        if(vipinfo['levelDy']>4){
          levelWidgets.add(getLevelWidget(vipinfo['levelDy'],'dy'));
          levelWidgets.add(PWidget.boxw(1));
        }
        if(vipinfo['levelVip']>4){
          levelWidgets.add(getLevelWidget(vipinfo['levelVip'],'vip'));
          levelWidgets.add(PWidget.boxw(1));
        }
      } else {
        levelWidgets = [
          PWidget.image(image, [16, 16]),
          PWidget.text('$levelName', [Colours.vip_white, 14])
        ];
      }
    }
    return PWidget.container(
        PWidget.row(
          [
            loading ? Global.showLoading2() : PWidget.container(
              createHeadImgWidget(headSize, 28.0),
                {
                  'fun': () {
                    personalNotifier.value = false;
                    onTapLogin(context, '/personal');
                  },
                }
            ),
            PWidget.boxw(20),
            PWidget.column(
              [
                PWidget.row([
                  PWidget.textNormal(nickName, [Colors.black, Dimens.font_sp20],{
                    'fun': () {
                      personalNotifier.value = false;
                      onTapLogin(context, '/personal');
                    },
                  }),
                  PWidget.boxw(5),
                  Global.isEmpty(levelName)
                      ? SizedBox()
                      : PWidget.container(
                          PWidget.row(levelWidgets),
                          [null, null, Colors.white],
                          {
                            'pd': PFun.lg(1, 1, 4, 4),
                            'br': 8,
                            'fun': () {
                              personalNotifier.value = false;
                              onTapLogin(context, '/tabVip', args: {'index': 0});
                            },
                          },
                        ),
                ]),
                PWidget.boxh(10),
                PWidget.row([
                  Text('邀请口令：${showCode ? code : codeX}', style: TextStyles.textBlack),
                  PWidget.boxw(5),
                  PWidget.icon(Icons.remove_red_eye_outlined,[Colors.black, 18]
                      ,{'fun':(){
                        if(showCode) {
                          showCode = false;
                        } else {
                          showCode = true;
                        }
                        setState(() {

                        });
                      }}),
                  PWidget.boxw(10),
                  PWidget.text('复制', [
                    Colors.black,
                    Dimens.font_sp12,
                    false
                  ], {
                    'td': TextDecoration.underline,
                    'fun': () => {
                          FlutterClipboard.copy('$code')
                              .then((value) => ToastUtils.showToast('复制成功'))
                        }
                  }),
                  PWidget.boxw(10),
                  PWidget.text('绑定', [
                    Colors.black,
                    Dimens.font_sp12,
                    false
                  ], {
                    'td': TextDecoration.underline,
                    'fun': () {
                      personalNotifier.value = false;
                      Navigator.pushNamed(context, "/personal");
                    }
                  }),
                ]),
                PWidget.boxh(10),
                PWidget.row([
                  PWidget.text('申请专属口令', [
                    Colors.black,
                    Dimens.font_sp12,
                    false
                  ], {
                    'td': TextDecoration.underline,
                    'fun': (){
                      personalNotifier.value = false;
                      Navigator.pushNamed(context, "/koulingPage");
                    }
                  }),
                  PWidget.boxw(17),
                  loadingEnergy ? SizedBox() : PWidget.container(
                    PWidget.row([
                      rainbowText("热度:${(userEnergy['totalEnergy'] as num).toStringAsFixed(1)}",fontSize: 10.0,onTap: (){
                        _createEnergyPop();
                      }),
                      PWidget.icon(Icons.arrow_drop_down,[Colors.white,12])
                    ]),
                      [null, null, Colours.app_main],
                      {
                        'pd': PFun.lg(2, 2, 2, 2),
                        'br': PFun.lg(8, 8, 8, 8),
                        'fun':(){
                          _createEnergyPop();
                        }},
                  ),
                ]),
              ],
            ),
          ],
        ),);
  }

  Widget createHeadImgWidget(headSize,radius) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius), //设置圆角
        child: avatar != null
            ? CachedNetworkImage(
          imageUrl: avatar ?? '',
          height: headSize,
          width: headSize,
        )
            : SizedBox(
          width: headSize,
          height: headSize,
        ));
  }
  _createUnLogin() {
    return PWidget.container(PWidget.row([
      PWidget.container(
        PWidget.icon(Icons.person, [Colors.black12]),
        [56, 56, Colors.white],
        {'br': 56},
      ),
      PWidget.boxw(8),
      PWidget.textNormal('点击登录', [Colors.black54, Dimens.font_sp16], {'ct': true}),
    ]),{'mg':[16,16,0,16],
      'fun': () {
      personalNotifier.value = false;
      onTapLogin(context, '/personal');
    },});
  }

  Widget createItem(i, v) {
    return PWidget.container(
        PWidget.row(
            [
              PWidget.wrapperImage(v['itempic'], [
                124,
                124
              ], {
                'br': 8,
              }),
              PWidget.boxw(8),
              PWidget.column([
                PWidget.text(v['itemtitle'],
                    [Colors.black.withOpacity(0.75), 15, true], {'max': 2}),
                PWidget.boxh(8),
                PWidget.container(
                    PWidget.text('${v['activity_gameplay']}', [
                      Colors.black45,12
                    ], {
                      'pd': 4,
                    }),
                    [null, null, Colors.grey[100]]),
                PWidget.spacer(),
                PWidget.text('${Decimal.parse(v['itemendprice']).toString()}元', [Colours.app_main, 15, true]),
                PWidget.boxh(8),
              ], {
                'exp': 1,
              }),
            ],
            '001',
            {'fill': true}),
        {'pd': 8, });
  }

  Future initNotice() async {
    if(await Permission.notification.request().isGranted){
      //允许通知
      Notice = false;
    }else{
      //不允许通知
      Notice = true;
    }
    setState(() {});
  }
  void _createEnergyPop() {
    showMenu(
        // color: Colors.grey[350],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.grey)),
        context: context,
        position: RelativeRect.fromSize(Rect.fromLTRB(150, 130, 0, 0),Size(48, 0)),
        elevation: 10,
        items: <PopupMenuEntry<String>>[
          PopupMenuItem<String>(height: 28,value: 'Item01', child:
              PWidget.row([
                PWidget.textNormal('淘',[Colors.black,12, true]),
                PWidget.boxw(2),
                PWidget.textNormal('赠送: ${userEnergy['tbEnergy']}',[Colors.black,11]),
                PWidget.boxw(2),
                PWidget.textNormal('推广: ${userEnergy['tbTuiEnergy']}',[Colors.black,11])
              ])),
          PopupMenuDivider(height: 5,),
          PopupMenuItem<String>(height: 28,value: 'Item02', child:
          PWidget.row([
            PWidget.textNormal('京',[Colors.black,12, true]),
            PWidget.boxw(2),
            PWidget.textNormal('赠送: ${userEnergy['jdEnergy']}',[Colors.black,11]),
            PWidget.boxw(2),
            PWidget.textNormal('推广: ${userEnergy['jdTuiEnergy']}',[Colors.black,11])
          ])),
          PopupMenuDivider(height: 5,),
          PopupMenuItem<String>(height: 28,value: 'Item03', child:
          PWidget.row([
            PWidget.textNormal('多',[Colors.black,12, true]),
            PWidget.boxw(2),
            PWidget.textNormal('赠送: ${userEnergy['pddEnergy']}',[Colors.black,11]),
            PWidget.boxw(2),
            PWidget.textNormal('推广: ${userEnergy['pddTuiEnergy']}',[Colors.black,11])
          ])),
          PopupMenuDivider(height: 5,),
          PopupMenuItem<String>(height: 28,value: 'Item04', child:
          PWidget.row([
            PWidget.textNormal('抖',[Colors.black,12, true]),
            PWidget.boxw(2),
            PWidget.textNormal('赠送: ${userEnergy['dyEnergy']}',[Colors.black,11]),
            PWidget.boxw(2),
            PWidget.textNormal('推广: ${userEnergy['dyTuiEnergy']}',[Colors.black,11])
          ])),
          PopupMenuDivider(height: 5,),
          PopupMenuItem<String>(height: 28,value: 'Item05', child:
          PWidget.row([
            PWidget.textNormal('唯',[Colors.black,12, true]),
            PWidget.boxw(2),
            PWidget.textNormal('赠送: ${userEnergy['vipEnergy']}',[Colors.black,11]),
            PWidget.boxw(2),
            PWidget.textNormal('推广: ${userEnergy['vipTuiEnergy']}',[Colors.black,11])
          ])),
          PopupMenuDivider(height: 5,),
          PopupMenuItem<String>(height: 35,value: 'Item06', child:
          PWidget.row([
            PWidget.textNormal('查看详情>', [Colors.blue], {'fun':(){
              Navigator.pushNamed(context, '/energyPage');
            }})
          ], '221')
          )
        ]).then((value) {
      if (null == value) {
        return;
      }
    });
  }
}
