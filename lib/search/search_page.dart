/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maixs_utils/model/data_model.dart';
import 'package:maixs_utils/util/utils.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/scaffold_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/search/search_bar_widget.dart';
import 'package:sufenbao/service.dart';

import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../widget/lunbo_widget.dart';

class FocusNodeValue extends ValueNotifier {
  FocusNodeValue() : super(null);
  bool hasFocus = false;
  void changeHasFocus(bool v) {
    hasFocus = v;
    notifyListeners();
  }
}

FocusNodeValue focusNodeValue = FocusNodeValue();

///搜索
class SearchPage extends StatefulWidget {
  final Map? data;

  const SearchPage({Key? key, this.data}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    focusNodeValue.changeHasFocus(false);
    await this.getHistories();
    await this.getHotKeyword();
    await this.getLunboData();
    await this.searchRankingList();
  }
  @override
  bool get wantKeepAlive => true;
  ///搜索历史
  var historyDm = DataModel();
  Future<int> getHistories() async {
    var res = await BService.histories().catchError((v) {
      historyDm.toError('网络异常');
    });
    if (res != null) historyDm.addList(res, true, 0);
    setState(() {});
    return historyDm.flag;
  }
  ///热门关键字
  var hotKeywordDm = DataModel();
  Future<int> getHotKeyword() async {
    var res = await BService.hotWordsCenter().catchError((v) {
      hotKeywordDm.toError('网络异常');
    });
    if (res != null) hotKeywordDm.addList(res, true, 0);
    setState(() {});
    return hotKeywordDm.flag;
  }
  Future clearHistory() async{
    var res = await BService.historyClear().catchError((v) {
      historyDm.toError('网络异常');
    });
    historyDm.list.clear();
    setState(() {});
    return historyDm.flag;
  }
  ///轮播图
  var lunboDm = DataModel();
  Future<int> getLunboData() async {
    var res = await BService.tiles().catchError((v) {
      lunboDm.toError('网络异常');
    });
    if (res != null) {
      res.removeWhere((element) {
        return element['link_type'] == 3;
      });
      lunboDm.addList(res, true, 0);
    }
    setState(() {});
    return lunboDm.flag;
  }

  ///搜索排名列表
  var searchRankingListDm = DataModel();
  Future<int> searchRankingList() async {
    var res = await BService.hotWords();
    if (res != null) searchRankingListDm.addList(res, true, 0);
    setState(() {});
    return searchRankingListDm.flag;
  }

  ///联想词
  var associationalWordDm = DataModel();
  Future<int> associationalWord(keyword) async {
    var url = 'https://api.cmspro.haodanku.com/search/associationalWord?keyword=$keyword&cid=${Global.appInfo.kuCid}';
    var res = await http.get(Uri.parse(url)).catchError((v) {
      associationalWordDm.toError('网络异常');
    });
    if (res != null) associationalWordDm.addList(jsonDecode(res.body)['data'], true, 0);
    setState(() {});
    return associationalWordDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      appBar: titleBarView(),
      brightness: Brightness.dark,
      bgColor: Colors.white,
      body: Stack(
        children: [
          MyListView(
            isShuaxin: false,
            flag: false,
            item: (i) => item[i],
            itemCount: item.length,
            listViewType: ListViewType.Separated,
          ),
          associationalWordDm.list.isEmpty ? SizedBox() :
          ValueListenableBuilder(
            valueListenable: focusNodeValue,
            builder: (_, __, ___) {
              return PWidget.positioned(
                PWidget.container(
                  MyListView(
                    isShuaxin: false,
                    flag: false,
                    item: (i) {
                      var data = associationalWordDm.list[i];
                      return PWidget.container(
                        PWidget.text('${data['keyword']}'),
                        {'pd': 8, 'ali': PFun.lg2(-1, 0), 'fun': () => jump2Result({'keyword':data['keyword'] })},
                      );
                    },
                    padding: EdgeInsets.all(8),
                    divider: Divider(height: 8, color: Colors.transparent),
                    itemCount: associationalWordDm.list.length,
                    listViewType: ListViewType.Separated,
                  ),
                  [null, null, Colors.white],
                ),
                [0, focusNodeValue.hasFocus ? 0 : pmSize.height, 0, 0],
              );
            },
          ),
        ],
      ),
    );
  }

  jump2Result(data) {
    Navigator.pushNamed(context, '/searchResult', arguments: data)
        .then((value) {
          associationalWordDm.list.clear();
          historyDm.list.clear();
          getHistories();
    });
  }

  List<Widget> get item {
    return [
      ///轮播
      if(!Global.isWeb())
        lunboDm.list.isEmpty ? SizedBox(height: 80,) :
        animatedSwitchBuilder(lunboDm, builder: (lunbo) {
          return LunboWidget(
          lunbo.list,
          value: 'img',
          margin: 8,
          aspectRatio: 414 / (99 + 12),
          fun: (v) {
            Global.kuParse(context, v);
          },
        );
      }),
      Global.login && historyDm.list.isNotEmpty ? PWidget.column([
        PWidget.row([
          PWidget.boxw(12),
          PWidget.text('搜索历史', [Colors.black.withOpacity(0.75), 16, true]),
          PWidget.spacer(),
          PWidget.text('清空', [Colors.black.withOpacity(0.5)], {'pd': 8, 'fun':(){
            clearHistory();
          }}),
        ]),
        PWidget.container(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(historyDm.list.length, (i) {
              return PWidget.container(
                PWidget.textNormal(historyDm.list[i], [Colors.black54, 12]),
                [null, null, Colors.black.withOpacity(0.05)],
                {'br': 56, 'pd': PFun.lg(2, 2, 8, 8),'fun': ()=>jump2Result({'keyword':historyDm.list[i] })},
              );
            }),
          ),
          {'pd': PFun.lg(8, 16, 16, 16)},
        ),
      ]) : SizedBox(),
      ...List.generate(1, (i) {
        return animatedSwitchBuilder(hotKeywordDm, builder: (dm) {
          return PWidget.column([
            PWidget.row([
              PWidget.boxw(12),
              PWidget.text('搜索发现', [Colors.black.withOpacity(0.75), 16, true]),
            ]),
            PWidget.boxh(8),
            PWidget.container(
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(dm.list.length, (i) {
                  var w = (pmSize.width - 16 - 32) / 2;
                  var data = dm.list[i];
                  return PWidget.container(PWidget.textNormal(data['keyword']), [w],{'fun': ()=>jump2Result({'keyword':data['keyword'] })});
                }),
              ),
              {'pd': PFun.lg(0, 0, 16, 16)},
            ),
          ]);
        });
      }),
      animatedSwitchBuilder(searchRankingListDm, builder: (dm) {
        return PWidget.container(
          PWidget.column([
            PWidget.text('', [], {}, [
              PWidget.textIs('热搜榜 ', [Colours.app_main, 18, true]),
              PWidget.textIs('每日实时更新', [Colours.app_main]),
            ]),
            ...List.generate(dm.list.length, (i) {
              var data = dm.list[i];
              return PWidget.container(
                PWidget.row([
                  PWidget.text('${i + 1}', [
                    {0: Colors.red, 1: Colors.orangeAccent, 2: Colors.yellow.shade600}[i] ?? Colors.black26,
                    16,
                    true
                  ]),
                  PWidget.boxw(16),
                  PWidget.wrapperImage('${data['pic']}_310x310', [56, 56], {'br': 8}),
                  PWidget.boxw(8),
                  PWidget.column([
                    Wrap(children: [
                      PWidget.text('${data['theme']}', {'isOf': false}),
                      // PWidget.boxw(4),
                      // PWidget.wrapperImage('${data['icon']}', [16, 16], {'pd': PFun.lg(2)}),
                    ]),
                    PWidget.boxh(4),
                    PWidget.text('${data['hotValue']}人已搜索', [Colors.black38, 12]),
                  ], {
                    'exp': 1
                  }),
                ]),
                {'pd': 8, 'fun': ()=>jump2Result({'keyword':data['words'] })},
              );
            }),
          ]),
          {
            'mg': PFun.lg(16, 8, 8, 8),
            'br': 8,
            'pd': PFun.lg(8, 8, 16, 16),
            'gd': PFun.tbGd(Color(0xffFBF1F2), Color(0xffffffff)),
          },
        );
      })
    ];
  }

  ///标题栏视图
  Widget titleBarView() {
    bool showArrowBack = (widget.data != null && widget.data!['showArrowBack']);
    return PWidget.container(
      PWidget.row([
        showArrowBack? PWidget.container(PWidget.icon(Icons.arrow_back_ios_rounded, [Colors.black.withOpacity(0.75)]), [40, 40], {'fun': () => close()})
            :PWidget.boxw(8),
        SearchBarWidget('', searchRankingListDm,
            autoFocus: widget.data!['autoFocus']??true,
            onChanged: (v) {
              this.associationalWord(v);
            },
            onSubmit: (v,t){
              t.clear();
              setState(() {

              });
              focusNodeValue.changeHasFocus(false);
              jump2Result({'keyword':v });
            },
            onClear: (){
              focusNodeValue.changeHasFocus(false);
            },
            onTap: (f){

            },
        ),
        PWidget.boxw(8),
      ]),
      [null, 56 + pmPadd.top],
      {'pd': PFun.lg(pmPadd.top + 8, 8)},
    );
  }
}

Widget animatedSwitchBuilder(
  DataModel dataModel, {
  required Widget Function(DataModel) builder,
}) {
  return AnimatedSwitchBuilder(
    value: dataModel,
    errorOnTap: () async {return 0;},
    noDataView: PWidget.boxh(0),
    errorView: PWidget.boxh(0),
    initialState: PWidget.container(null, [double.infinity]),
    defaultBuilder: () => builder(dataModel),
  );
}
