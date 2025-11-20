import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../service.dart';

part 'provider.g.dart';

@riverpod
class VipList extends _$VipList {
  ///数据分页
  int page = 1;

  ///分页条数
  int pageSize = 20;

  var listId = '';

  final EasyRefreshController controller = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  @override
  Future<List> build({String keyword = ''}) async {
    ref.onDispose(() {
      controller.dispose();
    });

    var res = await BService.vipList(page, keyword: keyword).catchError((v) {
      debugPrint('网络异常');
    });
    if (res != null) {
      return res['goodsInfoList'];
    }

    return [];
  }

  Future<void> refresh() async {
    page = 1;
    listId = '';
    state = AsyncValue.data(await build(keyword: keyword));
    controller.finishRefresh();
    controller.resetFooter();
  }

  Future<void> loadMore() async {
    page += 1;
    List list = await build(keyword: keyword);
    state = AsyncValue.data([...?state.value, ...list]);
    controller.finishLoad(list.length < pageSize ? IndicatorResult.noMore : IndicatorResult.success);
  }
}
