import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sufenbao/service.dart';

import 'model/search_param.dart';

part 'provider.g.dart';

@riverpod
Future<DataModel> goodsSearch(Ref ref, {required String keyword, int sort = 0}) async {
  var superSearchDm = DataModel();
  SearchParam searchParam = SearchParam();

  var res = await BService.goodsSearch(1, keyword, sort: searchParam.getTaoSortKey(sort)).catchError((v) {
    superSearchDm.toError('网络异常');
  });
  if (res.isNotEmpty) {
    superSearchDm.addList(res, true, 1000);
  }

  return superSearchDm;
}
