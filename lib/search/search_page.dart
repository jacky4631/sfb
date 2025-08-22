/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sufenbao/search/provider.dart';
import 'package:sufenbao/search/search_result.dart';

import '../index/provider/provider.dart';
import '../models/data_model.dart';
import '../util/colors.dart';
import '../util/global.dart';
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
        titleSpacing: 0,
        title: TitleBar(),
      ),
      body: searchParam.text.isNotEmpty
          ? SearchResultPage()
          : Stack(
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => _buildItem(index),
                  separatorBuilder: (context, index) => SizedBox.shrink(),
                  itemCount: _getItemCount(),
                ),
                if (associationalWordDm.list.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      child: ListView.separated(
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          var data = associationalWordDm.list[index];
                          return InkWell(
                            onTap: () {
                              ref.watch(searchProvider.notifier).submit(data['keyword']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: Text('${data['keyword']}'),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(height: 8, color: Colors.transparent),
                        itemCount: associationalWordDm.list.length,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  int _getItemCount() {
    final historyDm = ref
        .watch(historiesProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    final lunboDm = ref
        .watch(getLunboDataProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    int count = 0;
    if (!Global.isWeb() && lunboDm.list.isNotEmpty) count++; // 轮播
    if (Global.login && historyDm.list.isNotEmpty) count++; // 搜索历史
    count++; // 搜索发现
    count++; // 热搜榜
    return count;
  }

  Widget _buildItem(int index) {
    final historyDm = ref
        .watch(historiesProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    final searchRankingListDm = ref
        .watch(hotWordsProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());
    final lunboDm = ref
        .watch(getLunboDataProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    int currentIndex = 0;

    // 轮播
    if (!Global.isWeb() && lunboDm.list.isNotEmpty) {
      if (index == currentIndex) {
        return LunboWidget(
          lunboDm.list,
          value: 'img',
          margin: 8,
          aspectRatio: 414 / (99 + 12),
          fun: (v) {
            Global.kuParse(context, v);
          },
        );
      }
      currentIndex++;
    }

    // 搜索历史
    if (Global.login && historyDm.list.isNotEmpty) {
      if (index == currentIndex) {
        return _buildSearchHistory(historyDm);
      }
      currentIndex++;
    }

    // 搜索发现
    if (index == currentIndex) {
      return _buildSearchDiscovery();
    }
    currentIndex++;

    // 热搜榜
    if (index == currentIndex) {
      return _buildHotSearchRanking(searchRankingListDm);
    }

    return SizedBox.shrink();
  }

  Widget _buildSearchHistory(DataModel historyDm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 12),
            Text(
              '搜索历史',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.75),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                ref.read(clearHistoryProvider.future);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  '清空',
                  style: TextStyle(color: Colors.black.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(historyDm.list.length, (i) {
              return InkWell(
                onTap: () {
                  ref.watch(searchProvider.notifier).submit(historyDm.list[i]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Text(
                    historyDm.list[i],
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchDiscovery() {
    final hotKeywordDm = ref
        .watch(hotWordsCenterProvider)
        .when(data: (data) => data, error: (o, s) => DataModel(), loading: () => DataModel());

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 12),
            Text(
              '搜索发现',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.75),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(hotKeywordDm.list.length, (i) {
              var w = (MediaQuery.of(context).size.width - 16 - 32) / 2;
              var data = hotKeywordDm.list[i];
              return InkWell(
                onTap: () {
                  ref.watch(searchProvider.notifier).submit(data['keyword']);
                },
                child: Container(
                  width: w,
                  child: Text(
                    data['keyword'],
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildHotSearchRanking(DataModel searchRankingListDm) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffFBF1F2), Color(0xffffffff)],
        ),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '热搜榜 ',
                  style: TextStyle(
                    color: Colours.app_main,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '每日实时更新',
                  style: TextStyle(color: Colours.app_main),
                ),
              ],
            ),
          ),
          ...List.generate(searchRankingListDm.list.length, (i) {
            var data = searchRankingListDm.list[i];
            return InkWell(
              onTap: () {
                ref.watch(searchProvider.notifier).submit(data['words']);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: {0: Colors.red, 1: Colors.orangeAccent, 2: Colors.yellow.shade600}[i] ?? Colors.black26,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text('${data['words']}'),
                    SizedBox(width: 8),
                    Text(
                      '${data['hotValue']}人已搜索',
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['theme']}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
