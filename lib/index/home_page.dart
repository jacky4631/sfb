/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/service.dart';
import 'package:sufenbao/widget/tab_widget.dart';

import '../me/model/userinfo.dart';
import '../search/search_bar_widget.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import 'first_page.dart';
import 'other_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  FocusNode _searchFocus = FocusNode();
  bool agree = false;
  @override
  void initState() {
    initData();
    super.initState();

    //2.页面初始化的时候，添加一个状态的监听者
    WidgetsBinding.instance.addObserver(this);
  }

  ///初始化函数
  Future initData() async {
    agree = await Global.getAgree();
    setState(() {

    });
    Global.initCommissionInfo();
    parseContent();
    searchRankingList();
    await getTabData();
    _initUser();

  }
  ///搜索排名列表
  var searchRankingListDm = DataModel();
  Future<int> searchRankingList() async {
    var res = await BService.hotWords().catchError((v) {
      searchRankingListDm.toError('网络异常');
    });
    if (res != null) searchRankingListDm.addList(res, true, 0);
    setState(() {});
    return searchRankingListDm.flag;
  }
  Future _initUser() async {

    Map<String, dynamic> json = await BService.userinfo(baseInfo: true);
    if (json.isEmpty) {
      return;
    }
    Userinfo userinfo = Userinfo.fromJson(json);
    Global.userinfo = userinfo;
    await Global.initJPush();

  }
  ///tab数据
  var tabDm = DataModel();

  Future<int> getTabData() async {
    var res = await BService.goodsCategory().catchError((v) {
      tabDm.toError('网络异常');
    });
    if (res != null) {
      res.sort((e1, e2) {
        return e1['cid'] > e2['cid'] ? 1 : 0;
      });
      tabDm.addList(res, true, 0);
      tabDm.list.insert(
          0, {"cid": 0, "cname": "精选", "cpic": "", "subcategories": []});
    }
    setState(() {});
    return tabDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // showPrivacyDialog(func: (){
    //   Future.delayed(Duration(microseconds: 400)).then((value) => initData());
    //
    // });
    return _page();
  }

  @override
  void dispose() {
    super.dispose();
    //3. 页面销毁时，移出监听者
    WidgetsBinding.instance.removeObserver(this);
  }

  _page() {
    return ScaffoldWidget(
        body: Stack(children: [
      // PWidget.container(null, [double.infinity, double.infinity],
      //     {'gd': PFun.tbGd(Colours.app_main, Colors.white)}),
      ScaffoldWidget(
        // appBar: buildTitle(context, title: APP_NAME),
        // bottomSheet: BottomNav(0),
        brightness: Brightness.dark,
        appBar: titleBarView(),
        bgColor: Colors.transparent,
        body:
        // PWidget.column(
        //     [
        //       PWidget.container(
        //         PWidget.row(
        //             [
        //               PWidget.text('三步查券', [Colors.white, 14, true]),
        //               PWidget.text('1进入淘宝', [Colors.white, 14, true]),
        //               PWidget.text('2复制链接', [Colors.white, 14, true]),
        //               PWidget.text('3打开$APP_NAME', [Colors.white, 14, true]),
        //             ],
        //         ),
        //         [null, null, Colors.grey[400]],
        //         {'crr': PFun.lg(16, 16,16, 16), 'pd': PFun.lg(8, 8,16, 16),'mg':PFun.lg(4, 4,8, 8)},
        //       ),
              PWidget.container(
                tabDm.list.length == 1
                    ? FirstPage()
                    : AnimatedSwitchBuilder(
                        value: tabDm,
                        errorOnTap: () => this.getTabData(),
                        // initialState: buildLoad(color: Colors.grey),
                        initialState:
                            PWidget.container(null, [double.infinity]),
                        listBuilder: (list, _, __) {
                          var tabList = list
                              .map<String>((m) => (m! as Map)['cname'])
                              .toList();
                          return TabWidget(
                            tabList: tabList,
                            color: Colors.black,
                            indicatorColor: Colors.red,
                            fontSize: 14,
                            indicatorWeight: 2,
                            tabPage: List.generate(tabList.length, (i) {
                              return i == 0
                                  ? FirstPage()
                                  : OtherPage(list[i] as Map);
                            }),
                          );
                        },
                      ),
                [null, null, Color(0xffF6F6F6)],
                {'crr': PFun.lg(16, 16),
                  // 'exp': true
                },
            //   )
            // ],
          ),
      )
    ]));
  }

  navigatorToSearchPage() {
    _searchFocus.unfocus();
    Navigator.pushNamed(context, '/search', arguments: {'showArrowBack': true});
  }

  @override
  bool get wantKeepAlive => true;

  //剪切板识别
  Future parseContent() async {
    if (agree) {
      //延迟1秒 不然获取不到粘贴板数据
      await Future.delayed(Duration(seconds: 1));
      String content = await FlutterClipboard.paste();
      if (!Global.isEmpty(content.trim()) && !Global.isOrder(content.trim())) {
        var length = content.length;
        //长度大于800 中止查券
        if(length > 800) {
          return;
        }

        //判断是否复制了邀请码，如果复制了，保存到prefs
        if(content.startsWith('%') && content.endsWith('%')) {
          List splitContent = content.substring(1, content.length-1).split('\$\%\$');
          int size = splitContent.length;

          Global.savePrefs(PREFS_INVITE_CODE, splitContent[0]);
          if(size == 1) {
            return;
          } else if(size > 1) {
            //保存产品口令
            Global.savePrefs(PREFS_GOODS_CODE, splitContent[1]);
            content = splitContent[1];
          }
        }

        var data = await BService.parseContent(content, Global.login);
        //当没有查券数据时不弹窗
        if (data.isEmpty) {
          return;
        }
        await Global.showContentParseDialog(data);

        Clipboard.setData(ClipboardData(text: ''));

      }
    }
  }

  //监听程序进入前后台的状态改变的方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        parseContent();
        print("应用进入前台======");
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        print("当前页面即将退出======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        print("应用处于不可见状态 后台======");
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  // Future showPrivacyDialog({func}) async {
  //   var agree = await Global.getAgree();
  //   if ((agree == null || !agree) && !Global.showPrivacy) {
  //     Global.showPrivacy = true;
  //     Future.delayed(Duration(milliseconds: 200), () {
  //       AwesomeDialog(
  //         dismissOnTouchOutside: false,
  //         context: context,
  //         dialogType: DialogType.noHeader,
  //         body: PrivacyDialog(func: func),
  //         // btnCancelOnPress: () {},
  //         // btnOkOnPress: () {},
  //       )..show();
  //     });
  //   }
  // }

  ///标题栏视图
  Widget titleBarView() {
    return PWidget.container(
      PWidget.row([
        PWidget.boxw(8),
        //fluter textfield会导致剪切板的隐私问题
        if(agree)
        SearchBarWidget(
          '',
          searchRankingListDm,
          readOnly: true,
          onChanged: (v) {},
          onSubmit: (v, t) {
            navigatorToSearchPage();
          },
          onClear: () {},
          onTap: (f) {
            navigatorToSearchPage();
          },
        ),
        PWidget.boxw(8),
        PWidget.icon(Icons.mail_outline,
            [Colors.black], {
              'fun': () {
                Navigator.pushNamed(context, '/messageCenter');
              }
            }),
        PWidget.boxw(8),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8)},
    );
  }
}
