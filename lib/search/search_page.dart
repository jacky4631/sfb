/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maixs_utils/widget/anima_switch_widget.dart';
import 'package:maixs_utils/widget/mylistview.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:maixs_utils/widget/views.dart';
import 'package:sufenbao/search/provider.dart';
import 'package:sufenbao/search/search_result.dart';

import '../index/provider/provider.dart';
import '../models/data_model.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
import '../widget/lunbo_widget.dart';
import 'app_bar.dart';

///搜索
class SearchPage extends ConsumerStatefulWidget {
  final Map? data;

  const SearchPage({Key? key, this.data}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final searchParam = ref.watch(searchProvider);
    final associationalWordDm = ref
        .watch(associationalWordProvider)
        .when(data: (data) => DataModel(), error: (o, s) => DataModel(), loading: () => DataModel());

    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios),
        titleSpacing: 0,
        title: TitleBar(),
      ),
      body: searchParam.text.isNotEmpty
          ? SearchResultPage()
          : Stack(
              children: [
                MyListView(
                  isShuaxin: false,
                  flag: false,
                  item: (i) => item[i],
                  itemCount: item.length,
                  listViewType: ListViewType.Separated,
                ),
                associationalWordDm.list.isEmpty
                    ? SizedBox()
                    : PWidget.positioned(
                        PWidget.container(
                          MyListView(
                            isShuaxin: false,
                            flag: false,
                            item: (i) {
                              var data = associationalWordDm.list[i];
                              return PWidget.container(
                                PWidget.text('${data['keyword']}'),
                                {
                                  'pd': 8,
                                  'ali': PFun.lg2(-1, 0),
                                  'fun': () {
                                    ref.watch(searchProvider.notifier).submit(data['keyword']);
                                  }
                                },
                              );
                            },
                            padding: EdgeInsets.all(8),
                            divider: Divider(height: 8, color: Colors.transparent),
                            itemCount: associationalWordDm.list.length,
                            listViewType: ListViewType.Separated,
                          ),
                          [null, null, Colors.white],
                        ),
                        [0, pmSize.height, 0, 0],
                      ),
              ],
            ),
    );
  }

  List<Widget> get item {
    final historyDm = ref
        .watch(historiesProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    final searchRankingListDm = ref
        .watch(hotWordsProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    final lunboDm = ref
        .watch(getLunboDataProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    return [
      ///轮播
      if (!Global.isWeb() && lunboDm.list.isNotEmpty)
        LunboWidget(
          lunboDm.list,
          value: 'img',
          margin: 8,
          aspectRatio: 414 / (99 + 12),
          fun: (v) {
            Global.kuParse(context, v);
          },
        ),
      Global.login && historyDm.list.isNotEmpty
          ? PWidget.column([
              PWidget.row([
                PWidget.boxw(12),
                PWidget.text('搜索历史', [Colors.black.withOpacity(0.75), 16, true]),
                PWidget.spacer(),
                PWidget.text('清空', [
                  Colors.black.withOpacity(0.5)
                ], {
                  'pd': 8,
                  'fun': () {
                    ref.read(clearHistoryProvider.future);
                  }
                }),
              ]),
              PWidget.container(
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(historyDm.list.length, (i) {
                    return PWidget.container(
                      PWidget.textNormal(historyDm.list[i], [Colors.black54, 12]),
                      [null, null, Colors.black.withOpacity(0.05)],
                      {
                        'br': 56,
                        'pd': PFun.lg(2, 2, 8, 8),
                        'fun': () {
                          ref.watch(searchProvider.notifier).submit(historyDm.list[i]);
                        }
                      },
                    );
                  }),
                ),
                {'pd': PFun.lg(8, 16, 16, 16)},
              ),
            ])
          : SizedBox(),
      ...List.generate(1, (i) {
        final hotKeywordDm = ref
            .watch(hotWordsCenterProvider)
            .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

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
              children: List.generate(hotKeywordDm.list.length, (i) {
                var w = (pmSize.width - 16 - 32) / 2;
                var data = hotKeywordDm.list[i];
                return PWidget.container(PWidget.textNormal(data['keyword']), [
                  w
                ], {
                  'fun': () {
                    ref.watch(searchProvider.notifier).submit(data['keyword']);
                  }
                });
              }),
            ),
            {'pd': PFun.lg(0, 0, 16, 16)},
          ),
        ]);
      }),
      PWidget.container(
        PWidget.column([
          PWidget.text('', [], {}, [
            PWidget.textIs('热搜榜 ', [Colours.app_main, 18, true]),
            PWidget.textIs('每日实时更新', [Colours.app_main]),
          ]),
          ...List.generate(searchRankingListDm.list.length, (i) {
            var data = searchRankingListDm.list[i];
            return PWidget.container(
              PWidget.row([
                PWidget.text('${i + 1}', [
                  {0: Colors.red, 1: Colors.orangeAccent, 2: Colors.yellow.shade600}[i] ?? Colors.black26,
                  16,
                  true
                ]),
                PWidget.boxw(16),
                PWidget.text('${data['words']}'),
                PWidget.boxw(8),
                PWidget.text('${data['hotValue']}人已搜索', [Colors.black38, 12]),
                PWidget.boxw(8),
                PWidget.column([
                  Wrap(children: [
                    PWidget.text('${data['theme']}', {'isOf': false}),
                    // PWidget.boxw(4),
                    // PWidget.wrapperImage('${data['icon']}', [16, 16], {'pd': PFun.lg(2)}),
                  ]),
                  PWidget.boxh(4),
                ], {
                  'exp': 1
                }),
              ]),
              {
                'pd': 8,
                'fun': () {
                  ref.watch(searchProvider.notifier).submit(data['words']);
                }
              },
            );
          }),
        ]),
        {
          'mg': PFun.lg(16, 8, 8, 8),
          'br': 8,
          'pd': PFun.lg(8, 8, 16, 16),
          'gd': PFun.tbGd(Color(0xffFBF1F2), Color(0xffffffff)),
        },
      )
    ];
  }
}
