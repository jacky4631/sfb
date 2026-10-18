/**
 *  Copyright (C) 2018-2026
 *  All rights reserved, Designed By www.mailvor.com
 */
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
  bool _parsingClipboard = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) parseContent();
  }

  /// 首页统一监听剪贴板，防止冷启动和 resumed 重复查券。
  Future<void> parseContent() async {
    if (_parsingClipboard || Global.dialogShowing) return;
    _parsingClipboard = true;
    try {
      if (!await Global.getAgree()) return;
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted || Global.dialogShowing) return;
      final original = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
      String content = original.trim();
      if (content.isEmpty || Global.isOrder(content) || content.length > 1200) return;
      if (content.startsWith('%') && content.endsWith('%')) {
        final parts = content.substring(1, content.length - 1).split(r'$%$');
        Global.savePrefs(PREFS_INVITE_CODE, parts.first);
        if (parts.length < 2) return;
        content = parts[1].trim();
        Global.savePrefs(PREFS_GOODS_CODE, content);
      }
      if (content.isEmpty) return;
      final result = await BService.parseContent(content, Global.login);
      if (!mounted || result.isEmpty || result['data'] is! Map ||
          (result['data'] as Map).isEmpty) return;
      final response = Map<String, dynamic>.from(result);
      response['data'] = {
        ...Map<String, dynamic>.from(result['data']),
        'originContent': content,
      };
      final shown = await Global.showContentParseDialog(response);
      // 用户查券期间复制的新内容不能被旧请求清除。
      if (shown && (await Clipboard.getData(Clipboard.kTextPlain))?.text == original) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    } catch (error) {
      debugPrint('剪贴板查券失败：$error');
    } finally {
      _parsingClipboard = false;
    }
  }

  ///初始化函数
  Future initData() async {
    agree = await Global.getAgree();
    setState(() {

    });
    // 先加载导航分类，再发起非首屏必需的请求。
    await getTabData();
    if (!mounted) return;
    await searchRankingList();
    await Global.initCommissionInfo();
    if (!mounted) return;
    await _initUser();
    WidgetsBinding.instance.addPostFrameCallback((_) => parseContent());

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

    Map<String, dynamic> json;
    try {
      json = await BService.userinfo(baseInfo: true);
    } catch (error) {
      debugPrint('用户信息加载失败：$error');
      return;
    }
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
    try {
      final res = await BService.goodsCategory();
      res.sort((e1, e2) {
        return e1['cid'] > e2['cid'] ? 1 : 0;
      });
      tabDm.addList(res, true, 0);
      tabDm.list.insert(
          0, {"cid": 0, "cname": "精选", "cpic": "", "subcategories": []});
    } catch (error) {
      tabDm.toError('网络异常');
    }
    if (mounted) setState(() {});
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    //3. 页面销毁时，移出监听者
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
