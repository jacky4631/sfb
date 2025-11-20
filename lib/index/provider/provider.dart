import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/data_model.dart';
import '../../service.dart';

part 'provider.g.dart';

@riverpod
Future<DataModel> banners(Ref ref) async {
  var bannerDm = DataModel(value: [[], []]);

  var res = await BService.banners().catchError((v) {
    print('网络异常');
  });

  if (res.isNotEmpty) {
    //移除网络链接link_type=3 保留小样种草 移除抖音
    res.removeWhere((element) {
      return (element['link_type'] == 3 && element['id'] != 380) || element['id'] == 530;
    });
    // const List tbHbData = [
    //   {'title':'淘宝看视频领红包', 'key':'pddbanner1',
    //     'img': 'https://shengqianapp.oss-cn-shanghai.aliyuncs.com/sfb/menu/tbhbbanner.jpg'}
    // ];
    // res.insertAll(0, tbHbData);
    bannerDm.addList(res, true, 0);
  }
  return bannerDm;
}

@riverpod
Future<DataModel> tiles(Ref ref) async {
  var tilesDm = DataModel(value: [{}]);

  var res = await BService.tiles().catchError((v) {
    tilesDm.toError('网络异常');
  });
  if (res.isNotEmpty) {
    res.removeWhere((element) {
      return element['link_type'] == 3;
    });
    tilesDm.addList(res, true, 0);
  }
  return tilesDm;
}

///卡片数据
@riverpod
Future<DataModel> homeCardHot(Ref ref) async {
  var cardDm = DataModel();

  ///热销榜url
  List res1 = await BService.homeCardHot().catchError((v) {
    cardDm.toError('网络异常');
  });
  if (res1.isNotEmpty) {
    cardDm.value = res1;
    cardDm.setTime();
  }

  ///限时秒杀url
  var res2 = await BService.homeCardDDQ().catchError((v) {
    cardDm.toError('网络异常');
  });
  if (res2.isNotEmpty) cardDm.addObject(res2);

  return cardDm;
}

///品牌特卖
@riverpod
Future<DataModel> getBrandList(Ref ref) async {
  var brandListDm = DataModel();
  var res = await http.get(Uri.parse(BService.getBrandUrl())).catchError((v) {
    brandListDm.toError('网络异常');
  });
  if (res.body.isNotEmpty) {
    var json = jsonDecode(res.body);
    brandListDm.addList(json, true, 10);
  }
  return brandListDm;
}

///列表数据
@riverpod
Future<DataModel> getGoodsList(Ref ref) async {
  var listDm = DataModel();
  var res = await BService.getGoodsList(1).catchError((v) {
    listDm.toError('网络异常');
  });
  if (res.isNotEmpty) {
    var list = res['list'];
    var totalNum = res['totalNum'];
    listDm.addList(list, true, totalNum);
  }
  return listDm;
}

///大家都在领

@riverpod
Future<DataModel> getEveryBuyUrl(Ref ref) async {
  var searchDm = DataModel();
  var res = await http.get(Uri.parse(BService.getEveryBuyUrl())).catchError((v) {
    searchDm.toError('网络异常');
  });

  print("===========${res.body}");

  if (res.body.isNotEmpty) {
    var json = jsonDecode(res.body);
    if (json['success'] != null && json['success']) {
      var list = json['data']['list'];
      var totalNum = int.parse('${json['data']['totalNum']}');
      searchDm.addList(list, true, totalNum);
    }
  }
  return searchDm;
}

///搜索排名列表
@riverpod
Future<DataModel> hotWords(Ref ref) async {
  var searchRankingListDm = DataModel();
  var res = await BService.hotWords().catchError((v) {
    searchRankingListDm.toError('网络异常');
  });
  if (res != null) searchRankingListDm.addList(res, true, 0);
  return searchRankingListDm;
}

///tab数据

@riverpod
Future<DataModel> goodsCategory(Ref ref) async {
  var tabDm = DataModel();
  var res = await BService.goodsCategory().catchError((v) {
    tabDm.toError('网络异常');
  });
  if (res.isNotEmpty) {
    res.sort((e1, e2) {
      return e1['cid'] > e2['cid'] ? 1 : 0;
    });
    tabDm.addList(res, true, 0);
    tabDm.list.insert(0, {"cid": 0, "cname": "精选", "cpic": "", "subcategories": []});
  }
  return tabDm;
}
