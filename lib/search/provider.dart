import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sufenbao/service.dart';
import 'package:http/http.dart' as http;
import 'package:sufenbao/util/value_util.dart';

import '../api/http_client.dart';
import '../models/data_model.dart';
import '../util/global.dart';
import 'model/search_param.dart';

part 'provider.g.dart';

@riverpod
class Search extends _$Search {
  set searchParam(SearchParam param) {
    state = param;
  }

  @override
  SearchParam build() {
    return SearchParam();
  }

  final _controller = TextEditingController();

  TextEditingController get controller => _controller;

  Future<void> submit(String text) async {
    state = state.copyWith(text: text);
    if (text.isNotEmpty) {
      onTapText(text);
      await BService.historySave(text);
    }
  }

  void onTapText(String text) {
    _controller.value =
        TextEditingValue(text: text, selection: TextSelection.fromPosition(TextPosition(offset: text.length)));
  }

  void clearAll() {}

  void clear() {
    state = SearchParam();
    _controller.clear();
  }
}

@riverpod
class Sort extends _$Sort {
  @override
  int build() {
    return 0;
  }
}

///轮播图
@riverpod
Future<DataModel> getLunboData(Ref ref) async {
  var lunboDm = DataModel();
  var res = await BService.tiles().catchError((v) {
    lunboDm.toError('网络异常');
  });
  if (res != null) {
    res.removeWhere((element) {
      return element['link_type'] == 3;
    });
    lunboDm.addList(res, true, 0);
  }
  return lunboDm;
}

///热门关键字
@riverpod
Future<DataModel> hotWordsCenter(Ref ref) async {
  var hotKeywordDm = DataModel();

  var res = await BService.hotWordsCenter().catchError((v) {
    hotKeywordDm.toError('网络异常');
  });
  if (res.isNotEmpty) hotKeywordDm.addList(res, true, 0);
  return hotKeywordDm;
}

///联想词
@riverpod
Future<DataModel> associationalWord(Ref ref) async {
  var associationalWordDm = DataModel();
  final param = ref.watch(searchProvider);
  var url =
      'https://api.cmspro.haodanku.com/search/associationalWord?keyword=${param.text}&cid=${Global.appInfo.kuCid}';
  var res = await http.get(Uri.parse(url)).catchError((v) {
    associationalWordDm.toError('网络异常');
  });
  if (res.body.isNotEmpty) associationalWordDm.addList(jsonDecode(res.body)['data'], true, 0);
  return associationalWordDm;
}

///搜索历史

@riverpod
Future<DataModel> histories(Ref ref) async {
  var historyDm = DataModel();
  var res = await BService.histories().catchError((v) {
    historyDm.toError('网络异常');
  });
  print("=========${res}");
  if (res.isNotEmpty) historyDm.addList(res, true, 0);
  return historyDm;
}

@riverpod
Future<DataModel> clearHistory(Ref ref) async {
  var historyDm = DataModel();
  var res = await BService.historyClear().catchError((v) {
    historyDm.toError('网络异常');
  });
  historyDm.list.clear();
  return historyDm;
}

@riverpod
class GoodsSearch extends _$GoodsSearch {
  ///数据分页
  int page = 1;

  ///分页条数
  int pageSize = 20;

  var listId = '';

  final EasyRefreshController controller = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  final searchParam = SearchParam();
  @override
  Future<List> build({int tabIndex = 0}) async {
    ref.onDispose(() {
      controller.dispose();
    });

    if (tabIndex == 0) {
      return await tbSearch();
    } else if (tabIndex == 1) {
      return await pddSearch();
    } else if (tabIndex == 2) {
      return await jdSearch();
    } else if (tabIndex == 3) {
      return await dySearch();
    } else {
      return await vipSearch();
    }
  }

  Future<void> refresh() async {
    page = 1;
    listId = '';
    state = AsyncValue.data(await build(tabIndex: tabIndex));
    controller.finishRefresh();
    controller.resetFooter();
  }

  Future<void> loadMore() async {
    page += 1;
    List list = await build(tabIndex: tabIndex);
    state = AsyncValue.data([...?state.value, ...list]);
    controller.finishLoad(list.length < pageSize ? IndicatorResult.noMore : IndicatorResult.success);
  }

  Future<List> tbSearch() async {
    try {
      final param = ref.watch(searchProvider);

      final params = {
        'keyWords': param.text,
        'sort': searchParam.getTaoSortKey(param.sort),
        'pageId': page,
        'pageSize': pageSize,
      };

      var res = await HttpClient().get('/goods/get-dtk-search-goods', params: params);

      final data = ValueUtil.toMap(res['data']);
      final list = ValueUtil.toList(data['list']);
      // var res = await BService.goodsSearch(page, param.text, sort: searchParam.getTaoSortKey(searchParam.sort))
      //     .catchError((v) {});
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> pddSearch() async {
    final searchParam = ref.watch(searchProvider);

    var sortKey = searchParam.getPddSortKey(searchParam.sort);
    var res =
        await BService.pddSearch(page, keyword: searchParam.text, sortType: sortKey, listId: listId).catchError((v) {});
    if (res != null) {
      num totalCount = res['totalCount'];
      if (totalCount > 0) {
        listId = res['listId'];
        //破接口返回数据不一致 做特殊处理
        if (res['goodsList'][0]['goodsName'] == null) {
          totalCount = 0;
          res['goodsList'] = [];
        }
      }
      return res['goodsList'];
    }
    return [];
  }

  Future<List> jdSearch() async {
    final searchParam = ref.watch(searchProvider);
    var sortKey = searchParam.getJdSortKey(searchParam.sort);
    //京东销量排序第一页全是广告，从第二页开始搜
    if (searchParam.sort == 2) {
      page = page + 1;
    }
    var res =
        await BService.jdList(page, keyword: searchParam.text, sortName: sortKey['sortName'], sort: sortKey['sort'])
            .catchError((v) {});
    if (res != null) {
      return res['list'];
    }
    return [];
  }

  Future<List> dySearch() async {
    final searchParam = ref.watch(searchProvider);

    var sortKey = searchParam.getDySortKey(searchParam.sort);
    var sortType = 1;
    if (searchParam.sort == 4) {
      sortType = 0;
    }
    var res = await BService.dySearch(page, keyword: searchParam.text, searchType: sortKey, sortType: sortType)
        .catchError((v) {});
    if (res != null) {
      return res['list'];
    }
    return [];
  }

  Future<List> vipSearch() async {
    final searchParam = ref.watch(searchProvider);

    var sortKey = searchParam.getVipSortKey(searchParam.sort);
    var order = 1;
    if (searchParam.sort == 2 || searchParam.sort == 4) {
      order = 0;
    }
    var res =
        await BService.vipSearch(page, keyword: searchParam.text, fieldName: sortKey, order: order).catchError((v) {});
    if (res != null && (res['returnCode'] == null || res['returnCode'] != '1009')) {
      return res['goodsInfoList'];
    }
    return [];
  }
}
