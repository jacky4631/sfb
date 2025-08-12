/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 业务层方法
 */
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sufenbao/util/login_util.dart';
import 'util/global.dart';
import 'util/toast_utils.dart';
import 'base.dart';

abstract class BService {
  ///大家都在领
  static getEveryBuyUrl() {
    return BBase.suUrl + API.cmsEveryBuy;
  }

  ///品牌特卖
  static getBrandUrl() {
    return BBase.suUrl + API.cmsBrand;
  }

  static getMeCategoryUrl() {
    return BBase.suUrl + API.meCategory;
  }

  static getMePointsMallUrl(page) {
    return BBase.suUrl + API.mePointsMall + '?&page=$page&limit=10&isIntegral=1';
  }

  static getMePointsMallDetailUrl(productId) {
    return BBase.suUrl + API.mePointsMallDetail + '/$productId';
  }

  static Future<Map> getGoodsList(pageId,
      {pageSize = 10, cid, sort, inspectedGoods, brand = 0, tchaoshi = 0, lowestPrice = 0}) async {
    var res = await suClient.get(
      API.goodsList,
      queryParameters: {
        'pageId': pageId,
        'pageSize': pageSize,
        'cids': cid,
        'sort': sort,
        'inspectedGoods': inspectedGoods,
        'brand': brand,
        'tchaoshi': tchaoshi,
        'lowestPrice': lowestPrice,
      },
    );

    return res.data['data'];
  }

  static Future<List> goodsSearch(page, keywords, {sort}) async {
    var res = await suClient.get(
      API.goodsSearch,
      queryParameters: {
        'pageNo': page,
        'keyWords': keywords,
        'sort': sort,
      },
    );

    return res.data['data'];
  }

  ///首页热销榜
  static Future<List> homeCardHot() async {
    var res = await suClient.get(
      API.cmsHot,
    );
    return res.data['data'];
  }

  ///首页限时秒杀
  static Future<Map> homeCardDDQ() async {
    var res = await suClient.get(
      API.cmsDdq,
    );
    return res.data['data'];
  }

  static Future<Map> getGoodsWord(goodsId, {uid}) async {
    await setAuthInfo();
    var res = await suClient.get(
      API.goodsWord,
      queryParameters: {'goodsId': goodsId, 'uid': uid},
    );
    return res.data['data'];
  }

  static Future<Map> getGoodsDetail(goodsId) async {
    var res = await suClient.get(
      API.goodsDetail,
      queryParameters: {'goodsId': goodsId},
    );
    return res.data['data'] ?? {};
  }

  static Future<List> getCityList() async {
    var res = await suClient.get(
      API.cityList,
    );
    return res.data['data'];
  }

  static Future addressEdit(data) async {
    var res = await suClient.post(API.addressEdit, data: data);
  }

  static Future addressDel(id) async {
    var res = await suClient.post(API.addressDel, data: {'id': id.toString()});
    return res;
  }

  static Future addressDefaultSet(id) async {
    var res = await suClient.post(API.addressDefaultSet, data: {'id': id.toString()});
    return res;
  }

  static Future<List> addressList() async {
    var res = await suClient.get(
      API.addressList,
    );
    return res.data['data'];
  }

  static Future<Map> addressDefault() async {
    var res = await suClient.get(
      API.addressDefault,
    );
    return res.data['data'];
  }

  static Future<Map> createOrder(data) async {
    var res = await suClient.post(API.createOrder, data: data);
    return res.data;
  }

  static Future<Map> parseContent(content, auth) async {
    await setAuthInfo();
    var res = await suClient.get(API.parseContent2,
        queryParameters: {'content': content}, options: new Options(receiveTimeout: Duration(milliseconds: 10000)));
    return res.data;
  }

  static Future<Map?> goodsDetailJD(goodsId) async {
    var res = await suClient.get(
      API.goodsDetailJD,
      queryParameters: {'goodsId': goodsId},
    );
    if (res.data['data'] == null) {
      return null;
    }
    return res.data['data'][0];
  }

  static Future<String> goodsWordJD(itemId, couponLink, materialUrl) async {
    await setAuthInfo();
    var res = await suClient.get(
      API.goodsWordJD,
      queryParameters: {'goodsId': itemId, 'couponLink': couponLink, 'materialUrl': materialUrl},
    );
    return res.data['data'];
  }

  static Future<Map> goodsDetailPDD(goodsSign) async {
    var res = await suClient.get(
      API.goodsDetailPDD,
      queryParameters: {'goodsSign': goodsSign},
    );
    return res.data['data'] ?? {};
  }

  static Future<Map> goodsWordPDD(goodsSign, {uid}) async {
    await setAuthInfo();
    var res = await suClient.get(
      API.pddGoodsWord,
      queryParameters: {'goodsSign': goodsSign, 'uid': uid},
    );
    return res.data['data'];
  }

  static Future<Map> orderSubmit(orderId) async {
    await setAuthInfo();
    var res = await suClient.post(
      API.orderSubmit,
      data: {'orderId': orderId},
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> homeUrl() async {
    var res = await suClient.get(
      API.homeUrl,
    );
    return res.data;
  }

  static Future setAuthInfo() async {
    String token = await Global.getToken();
    if (token.isNotEmpty) {
      suClient.options.headers["Authorization"] = 'Bearer $token';
    }
  }

  static Future<Map> integralConfirm(context, id) async {
    await setAuthInfo();
    var res = await suClient.post(
      API.meIntegralConfirm,
      data: {'id': id},
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> userinfo({baseInfo = false}) async {
    var token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return {};
    }
    await setAuthInfo();
    var res = await suClient.get(API.userinfo, queryParameters: {'baseInfo': baseInfo});
    //如果token失效，清空本地登录数据
    if (!res.data['success']) {
      Global.clearUser();
    }
    return res.data['data'] ?? {};
  }

  static Future<Map<String, dynamic>> userWxProfile() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.userWxProfile,
    );
    return res.data['data'] ?? {};
  }

  static Future userCard({uid}) async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return null;
    }
    await setAuthInfo();
    var res = await suClient.get(API.userCard, queryParameters: {'uid': uid});
    return res.data['data'];
  }

  static Future<Map> payBind({payType = 0}) async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return {};
    }
    await setAuthInfo();
    var res = await suClient.get(API.payBind, queryParameters: {'payType': payType});
    return res.data;
  }

  static Future<Map> modifyPhone(phone) async {
    await setAuthInfo();
    var res = await suClient.post(API.sendSms, data: {'phone': phone});
    return res.data;
  }

  static Future vipinfo() async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return null;
    }
    await setAuthInfo();
    var res = await suClient.get(API.vipinfo);
    return res.data['data'];
  }

  static Future<Map> userFee() async {
    var token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return {};
    }
    await setAuthInfo();
    var res = await suClient.get(
      API.userfee,
    );
    return res.data['data'];
  }

  static Future<Map> userFeeDetail({type = 1, cid = 1, uid}) async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return {};
    }
    await setAuthInfo();
    var res = await suClient.get(API.userfeedetail, queryParameters: {'type': type, 'uid': uid, 'cid': cid});
    return res.data['data'];
  }

  static Future<bool> hasUnlockOrder() async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return false;
    }
    await setAuthInfo();
    var res = await suClient.get(
      API.hasUnlockOrder,
    );
    return res.data['data'];
  }

  static Future<Map<String, dynamic>> commissionInfo() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.commissionInfo,
    );
    return res.data['data'];
  }

  static Future<Map> userDelete() async {
    await setAuthInfo();
    var res = await suClient.delete(
      API.userDelete,
    );
    return res.data;
  }

  static Future<Map> userSpread() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.userSpread,
    );
    return res.data['data'] ?? {};
  }

  static Future<String> uploadAvatar(formData) async {
    await setAuthInfo();
    var res = await suClient.post(
      API.fileUpload,
      data: formData,
    );
    return res.data;
  }

  static Future<Map> uploadCard(formData, type, {angle = 0}) async {
    await setAuthInfo();
    var res = await suClient.post(API.cardUpload,
        data: formData,
        queryParameters: {'type': type, 'angle': angle},
        options: new Options(receiveTimeout: Duration(milliseconds: 30000)));
    return res.data;
  }

  static Future<Map> userEdit(data, {token}) async {
    if (token != null) {
      suClient.options.headers["Authorization"] = 'Bearer $token';
    } else {
      await setAuthInfo();
    }
    var res = await suClient.post(
      API.userEdit,
      data: data,
    );
    return res.data;
  }

  static Future taoOrders(page, Map param, {innerType = 0, level = 0}) async {
    await setAuthInfo();
    var res = await suClient.get(param['api'],
        queryParameters: {
          'page': page - 1,
          'size': 10,
          'sort': '${param['sort']},desc',
          'innerType': innerType,
          'level': level
        },
        options: new Options(receiveTimeout: Duration(milliseconds: 10000)));
    return res.data;
  }

  static Future<List> orderTab(level, innerType) async {
    await setAuthInfo();
    var res = await suClient.get(API.orderTab, queryParameters: {'level': level, 'innerType': innerType});
    return res.data['data'];
  }

  static Future<List> orderTabFirst() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.orderTabFirst,
    );
    return res.data['data'];
  }

  static Future<String> shortLink(link) async {
    await setAuthInfo();
    var res = await suClient.get(API.shortLink, queryParameters: {'link': link});
    if (res.data['success']) {
      return res.data['data']['short_url'];
    }
    return '';
  }

  static Future<List> goodsSimilarList(goodsId) async {
    var res = await suClient.get(
      API.goodsSimilarList,
      queryParameters: {'id': goodsId},
    );
    return res.data['data'] ?? [];
  }

  static Future integralOrders(page) async {
    await setAuthInfo();
    var res = await suClient.get(API.integralOrders, queryParameters: {'page': page});
    return res.data;
  }

  static Future moneyList(page, {category = 'integral', type, platform, unlockStatus}) async {
    await setAuthInfo();
    var res = await suClient.get(API.integralList, queryParameters: {
      'page': page,
      'category': category,
      'type': type,
      'platform': platform,
      'unlockStatus': unlockStatus
    });
    return res.data;
  }

  static Future energyList(page) async {
    await setAuthInfo();
    var res = await suClient.get(API.energyList, queryParameters: {
      'page': page,
    });
    return res.data['data'];
  }

  static Future wechatAppLogin(code) async {
    var res = await suClient.get(API.wechatAppLogin, queryParameters: {'code': code});
    return res.data;
  }

  static Future wechatLogin(code) async {
    var res = await suClient.get(API.wechatLogin, queryParameters: {'code': code});
    return res.data;
  }

  static Future appleLogin(AuthorizationCredentialAppleID credential) async {
    var res = await suClient.post(API.appleLogin, data: {
      'userIdentifier': credential.userIdentifier,
      'realName': '${credential.familyName}${credential.givenName}',
      'email': credential.email
    });
    return res.data;
  }

  static Future loginMustCode() async {
    var res = await suClient.get(
      API.loginmustcode,
    );
    Global.loginMustCode = res.data['data'];
    return res.data;
  }

  static Future wechatBinding(code) async {
    var res = await suClient.get(API.wechatBinding, queryParameters: {'code': code});
    return res.data;
  }

  static Future<Map> alipayBinding(code) async {
    var res = await suClient.get(API.alipayBinding, queryParameters: {'code': code});
    return res.data;
  }

  static Future<String> alipayCode() async {
    var res = await suClient.get(API.alipayCode, queryParameters: {});
    return res.data['data'];
  }

  static Future fans(page, {uid, grade = 0, keyword}) async {
    await setAuthInfo();
    var res = await suClient.post(API.fans, data: {'page': page, 'uid': uid, 'grade': grade, 'keyword': keyword});
    return res.data;
  }

  static Future<List> userShareImages() async {
    await setAuthInfo();
    var res = await suClient.get(API.userShare);
    return res.data['data'];
  }

  static Future<Map> bindMobile(mobile, captcha) async {
    await setAuthInfo();
    var res = await suClient.post(API.userBindMobile, data: {
      'account': mobile,
      'captcha': captcha,
    });
    return res.data;
  }

  static Future hotWords() async {
    var res = await suClient.get(API.hotWords);
    return res.data['data'];
  }

  static Future jdList(page, {keyword, sortName, sort}) async {
    var res = await suClient.get(API.goodsListJD, queryParameters: {
      'pageId': page,
      'keyword': keyword,
      'sortName': sortName,
      'sort': sort,
    });
    return res.data['data'];
  }

  static Future jdBrandList(page) async {
    var res = await suClient.get(API.brandListJD, queryParameters: {
      'pageId': page,
    });
    return res.data['data'];
  }

  static Future jdNinesList(page) async {
    var res = await suClient.get(API.ninesListJD, queryParameters: {
      'pageId': page,
    });
    return res.data['data'];
  }

  static Future jdRankList(page) async {
    var res = await suClient.get(API.rankListJD, queryParameters: {'pageId': page, 'pageSize': 10});
    return res.data['data'];
  }

  static Future ddq(roundTime) async {
    var res = await suClient.get(API.ddq, queryParameters: {
      'roundTime': roundTime,
    });
    return res.data;
  }

  static Future rankingCate() async {
    var res = await suClient.get(
      API.rankingCate,
    );
    return res.data['data'];
  }

  static Future rankingList(
    rankType,
    pageId, {
    cid,
    pageSize = 10,
  }) async {
    var res = await suClient.get(API.rankingList,
        queryParameters: {'rankType': rankType, 'pageId': pageId, 'cid': cid, 'pageSize': pageSize});
    return res.data['data'];
  }

  static Future miniList(pageId, {keyword = ''}) async {
    var res = await suClient.get(API.miniList, queryParameters: {
      'keyword': keyword,
      'pageId': pageId,
    });
    return res.data['data'];
  }

  static Future<List> pddList(cateId, pageId) async {
    var res = await suClient.get(API.pddList, queryParameters: {
      'cateId': cateId,
      'pageId': pageId,
    });
    return res.data['data'];
  }

  static Future pddNav() async {
    var res = await suClient.get(
      API.pddNav,
    );
    return res.data['data'];
  }

  static Future pddCate({parentId = 0}) async {
    var res = await suClient.get(API.pddGoodsCate, queryParameters: {'parentId': parentId});
    return res.data['data'];
  }

  static Future dyList(cateId, pageId, {pageSize = 20, searchType = 4, sortType = 1, firstCid}) async {
    var res = await suClient.get(API.dyList, queryParameters: {
      'cateId': cateId,
      'pageId': pageId,
      'pageSize': pageSize,
      'searchType': searchType,
      'sortType': 1,
      'firstCid': firstCid
    });
    return res.data['data'];
  }

  static Future dyNav() async {
    var res = await suClient.get(
      API.dyNav,
    );
    return res.data['data'];
  }

  static Future dyCate() async {
    var res = await suClient.get(
      API.dyCate,
    );
    return res.data['data'];
  }

  static Future<Map> dyGoodsDetail(goodsId) async {
    var res = await suClient.get(
      API.dyGoodsDetail,
      queryParameters: {'goodsId': goodsId},
    );
    return res.data['data'] ?? {};
  }

  static Future<Map> dyWord(productUrl, {uid}) async {
    var res = await suClient.get(
      API.dyWord,
      queryParameters: {'productUrl': productUrl, 'uid': uid},
    );
    return res.data['data'] ?? {};
  }

  static Future<Map> vipGoodsDetail(goodsId) async {
    await setAuthInfo();
    var res = await suClient.get(
      API.vipGoodsDetail,
      queryParameters: {'goodsId': goodsId},
    );
    return res.data['data'][0];
  }

  static Future<Map> goodsBigList(pageId, params, {pageSize}) async {
    var res = await suClient.get(
      API.bigList,
      queryParameters: {
        'pageId': pageId,
        'params': params,
        'pageSize': pageSize,
      },
    );
    return res.data['data'];
  }

  static Future<List> pickCate() async {
    var res = await suClient.get(
      API.pickCate,
    );
    return res.data['data'];
  }

  static Future<List> pickList(pageId, cateId) async {
    var res = await suClient.get(
      API.pickList,
      queryParameters: {
        'pageId': pageId,
        'cateId': cateId,
      },
    );
    return res.data['data'];
  }

  static Future<List> cmsCate(id) async {
    var res = await suClient.get(
      API.cmsCate,
      queryParameters: {
        'id': id,
      },
    );
    return res.data['data']['floor'];
  }

  static Future shopConvert(shopId, shopName) async {
    var res = await suClient.get(API.shopConvert, queryParameters: {
      'shopId': shopId,
      'shopName': shopName,
    });
    return res.data['data'];
  }

  static Future<Map> brandList(pageId, cid) async {
    var res = await suClient.get(
      API.brandList,
      queryParameters: {
        'pageId': pageId,
        'cid': cid,
      },
    );
    return res.data['data'];
  }

  static Future<Map> brandGoodsList(brandId) async {
    var res = await suClient.get(
      API.brandGoodsList,
      queryParameters: {
        'pageId': 1,
        'pageSize': 1,
        'brandId': brandId,
      },
    );
    return res.data['data'];
  }

  static Future<List> goodsCategory() async {
    var res = await suClient.get(
      API.goodsCate,
    );
    return res.data['data'];
  }

  static Future<List> nineCate() async {
    var res = await suClient.get(
      API.nineCate,
    );
    return res.data['data'];
  }

  static Future<Map> nineTop() async {
    var res = await suClient.get(
      API.nineTop,
    );
    return res.data['data'];
  }

  static Future<Map> nineList(pageId, cid, {pageSize = 10}) async {
    var res = await suClient.get(
      API.nineList,
      queryParameters: {
        'pageId': pageId,
        'pageSize': pageSize,
        'cid': cid,
      },
    );
    return res.data['data']['data'];
  }

  static Future<Map> banner() async {
    var res = await suClient.get(
      API.banner,
    );
    return res.data['data'];
  }

  static Future<List> banners() async {
    var res = await suClient.get(
      API.banners,
    );

    print(res);

    return res.data;
  }

  static Future<List> tiles() async {
    var res = await suClient.get(
      API.tiles,
    );
    return res.data;
  }

  static Future<Map> kuCustomCate(id) async {
    var res = await suClient.get(
      API.customCate,
      queryParameters: {
        'id': id,
      },
    );
    return res.data['data'];
  }

  static Future<List> kuCustomList(param) async {
    var res = await suClient.get(
      API.customList,
      queryParameters: param,
    );
    return res.data['data']['list'];
  }

  static Future<Map> dyBannerWord() async {
    var res = await suClient.get(
      API.dyBannerWord,
    );
    return res.data['data'];
  }

  static Future<Map> activityDetail(id) async {
    var res = await suClient.get(
      API.activityDetail,
      queryParameters: {
        'id': id,
      },
    );
    return res.data['data']['meeting'];
  }

  static Future<Map> taoActivityParse(id) async {
    var res = await suClient.get(
      API.activityParse,
      queryParameters: {
        'promotionSceneId': id,
      },
    );
    return res.data['data'];
  }

  static Future vipList(page, {keyword, fieldName = 'SALES', order = 1}) async {
    await setAuthInfo();
    var res = await suClient.get(API.goodsListVIP,
        queryParameters: {'page': page, 'keyword': keyword, 'fieldName': fieldName, 'order': order});
    return res.data['data'];
  }

  static Future<Map> goodsWordVIP(itemUrl, adCode, {uid}) async {
    var selUid;
    if (uid != null) {
      selUid = uid;
    } else {
      selUid = await Global.getUid();
    }
    await setAuthInfo();
    var res = await suClient.get(
      API.goodsWordVIP,
      queryParameters: {'itemUrl': itemUrl, 'statParam': selUid, 'adCode': adCode},
    );
    return res.data['data']['urlInfoList'][0];
  }

  static Future pddSearch(page, {catId, keyword, sortType = 0, listId}) async {
    var res = await suClient.get(API.goodsSearchPDD,
        queryParameters: {'page': page, 'keyword': keyword, 'sortType': sortType, 'listId': listId, 'catId': catId});
    return res.data['data'];
  }

  static Future<Map> tbAuthQuery() async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return {"auth": true};
    }
    await setAuthInfo();
    var res = await suClient.get(
      API.tbAuthQuery,
    );
    return res.data['data'];
  }

  static Future<int> pddAuthQuery() async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return 1;
    }
    await setAuthInfo();
    var res = await suClient.get(
      API.pddAuthQuery,
    );
    return res.data['data'];
  }

  static Future<Map> pddAuth() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.pddAuth,
    );
    List list = res.data['data'];
    if (list != null && list.isNotEmpty) {
      return list[0];
    }
    return {};
  }

  static Future dySearch(page, {keyword, sortType, searchType}) async {
    var res = await suClient.get(API.dyGoodsSearch, queryParameters: {
      'page': page,
      'title': keyword,
      'sortType': sortType,
      'searchType': searchType,
    });
    return res.data['data'];
  }

  static Future vipSearch(page, {keyword, fieldName, order}) async {
    await setAuthInfo();
    var res = await suClient.get(API.vipSearch,
        queryParameters: {'page': page, 'keyword': keyword, 'fieldName': fieldName, 'order': order});
    return res.data['data'];
  }

  static Future<Map> userGrade() async {
    var res = await suClient.get(
      API.userGrade,
    );
    return res.data['data'];
  }

  static Future<Map> extract(int type, String amount, {bankId}) async {
    String extractType = 'weixin';
    if (type == 1) {
      extractType = 'alipay';
    } else if (type == 2) {
      extractType = 'bank';
    }
    var res = await suClient.post(API.extract, data: {'extractType': extractType, 'money': amount, 'bankId': bankId});
    return res.data;
  }

  static Future<Map> extractList(page, {size = 10, sort = 'create_time,desc'}) async {
    var res = await suClient.get(API.extractList, queryParameters: {'page': page, 'size': size, 'sort': sort});
    return res.data['data'];
  }

  static Future<Map> pay(rechargeId, platform, {payType = 1, uid, bankId, type = 0}) async {
    //type 订单类型 0=年卡
    await setAuthInfo();
    var res = await suClient.post(API.payChannel, data: {
      'rechargeId': rechargeId,
      'from': 'app',
      'platform': platform,
      'payType': payType,
      'uid': uid,
      'bankId': bankId,
      'type': type
    });
    return res.data;
  }

  static Future rechargeResult(orderId, result) async {
    await setAuthInfo();
    var res = await suClient.post(API.rechargeResult, data: {
      'orderId': orderId,
      'result': result,
    });
    return res.data;
  }

  static Future<Map> payIos(rechargeId, platform, uid, {type = 0}) async {
    return pay(rechargeId, platform, payType: 0, uid: uid, type: type);
  }

  static Future<Map> payWechat(rechargeId, platform, uid, {type = 0}) async {
    return pay(rechargeId, platform, payType: 2, uid: uid, type: type);
  }

  static Future<Map> payAli(rechargeId, platform, uid, {type = 0}) async {
    return pay(rechargeId, platform, payType: 1, uid: uid, type: type);
  }

  static Future<Map> payBank(rechargeId, platform, uid, {type = 0}) async {
    return pay(rechargeId, platform, payType: 3, uid: uid, type: type);
  }

  static Future<Map> payBindBank(rechargeId, platform, uid, bankId, {type = 0}) async {
    return pay(rechargeId, platform, payType: 4, uid: uid, bankId: bankId, type: type);
  }

  static Future<Map> rechargeCoupon(rechargeId, platform) async {
    await setAuthInfo();
    var res = await suClient.post(API.rechargeCoupon, data: {
      'rechargeId': rechargeId,
      'platform': platform,
    });
    return res.data['data'] ?? {};
  }

  static Future<Map> payNotifyIOS(orderSn, receipt) async {
    await setAuthInfo();
    var res = await suClient.post(API.payNotifyIOS, data: {
      'orderSn': orderSn,
      'receipt': receipt,
    });
    return res.data;
  }

  static Future<Map> verifyIOS(receipt) async {
    await setAuthInfo();
    var res = await suClient.post("https://buy.itunes.apple.com/verifyReceipt",
        data: {
          'receipt-data': receipt,
        },
        options: Options(headers: {"content-type": "application/json"}));
    return res.data;
  }

  static Future<List> hotWordsCenter() async {
    var res = await suClient.get(
      API.hotWordsCenter,
    );
    return res.data['data'];
  }

  static Future historySave(keyword) async {
    if (Global.isEmpty(keyword)) {
      return;
    }
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return null;
    }
    await setAuthInfo();
    var res = await suClient.post(API.userHistorySave, data: keyword);
    return res.data;
  }

  static Future<List> histories() async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return [];
    }
    await setAuthInfo();
    var res = await suClient.get(
      API.userHistory,
    );
    return res.data['data'];
  }

  static Future historyClear() async {
    await setAuthInfo();
    var res = await suClient.delete(
      API.userHistoryClear,
    );
    return res.data;
  }

  static Future<Map> collectList(page, {size = 10}) async {
    await setAuthInfo();
    var res = await suClient.get(API.collectList, queryParameters: {'page': page, 'size': size, 'type': 'collect'});
    return res.data;
  }

  static Future collectAdd(id, category, img, title, startPrice, endPrice, {originalId}) async {
    await setAuthInfo();
    var res = await suClient.post(API.collectAdd, data: {
      'id': id,
      'category': category,
      'img': img,
      'title': title,
      'startPrice': startPrice,
      'endPrice': endPrice,
      'originalId': originalId
    });
    return res.data;
  }

  static Future collectDel(id) async {
    await setAuthInfo();
    var res = await suClient.post(API.collectDel, data: {
      'id': id,
    });
    return res.data;
  }

  static Future collect(id) async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return false;
    }
    await setAuthInfo();
    var res = await suClient.get(API.collect, queryParameters: {'id': id});
    return res.data['data'];
  }

  static Future collectProduct(BuildContext context, collect, goodsId, type, img, title, startPrice, endPrice,
      {originalId}) async {
    if (!Global.login) {
      onTapDialogLogin(context);
    } else {
      if (collect) {
        await BService.collectDel(goodsId);
      } else {
        await BService.collectAdd(goodsId, type, img, title, startPrice, endPrice, originalId: originalId);
        ToastUtils.showToast('收藏成功');
      }
    }
  }

  static Future<Map> channelAuth(session) async {
    await setAuthInfo();
    var res = await suClient.post(API.channelAuth, data: {'session': session});
    return res.data;
  }

  static Future<Map> spreadHb(orderId, type, {skuId}) async {
    String token = await Global.getToken();
    if (Global.isEmpty(token)) {
      return {'success': false};
    }
    await setAuthInfo();
    var res = await suClient.get(API.spreadHb, queryParameters: {'orderId': orderId, 'type': type, 'skuId': skuId});
    return res.data;
  }

  static Future loginShanyan(token) async {
    int type = Platform.isAndroid ? 1 : 2;
    var res = await suClient.post(API.loginShanyan, data: {'token': token, 'type': type});
    return res.data;
  }

  static Future<Map> getAliFaceTicket(certName, certNo, phone) async {
    var res = await suClient.post(API.userFace, data: {"certName": certName, "certNo": certNo, "phone": phone});
    return res.data['data'];
  }

  static Future<Map> getAliFaceResult(certifyId, phone) async {
    Map data = {"certifyId": certifyId, "phone": phone};
    String enc = await Global.encodeString(jsonEncode(data));
    var res = await suClient.post(API.userFaceResult,
        data: enc, options: new Options(receiveTimeout: Duration(milliseconds: 30000)));
    return res.data['data'];
  }

  static Future<Map> extractConfig() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.extractConfig,
    );
    return res.data['data'];
  }

  static Future<Map> payConfig() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.payConfig,
    );
    return res.data['data'];
  }

  static Future<Map> updateConfig() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.updateConfig,
    );
    return res.data['data'] ?? {};
  }

  static Future<Map> getEnergy() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.userEnergy,
    );
    return res.data['data'];
  }

  static Future<Map> getEnergyDetail() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.userEnergyDetail,
    );
    return res.data['data'];
  }

  static Future<Map> setEnergy(dayEnergy, platform) async {
    await setAuthInfo();
    var res = await suClient.post(API.userEnergy, data: {'dayEnergy': dayEnergy, 'platform': platform});
    return res.data['data'];
  }

  //美团活动和转链
  static Future waimaiActivityList() async {
    var res = await suClient.get(API.waimaiActivityList);
    return res.data['data'];
  }

  static Future eleActivityList() async {
    var res = await suClient.get(API.eleActivityList);
    return res.data['data'];
  }

  static Future waimaiActivityWord(String activityId, int type) async {
    await setAuthInfo();
    var res = await suClient.get(API.waimaiActivityWord, queryParameters: {'activityId': activityId, 'type': type});
    return res.data['data'];
  }

  //美团活动和转链
  static Future mtActivityList() async {
    var res = await suClient.get(API.mtActivityList);
    return res.data['data'];
  }

  static Future mtActivityWord(String activityId) async {
    await setAuthInfo();
    var res = await suClient.get(API.mtActivityWord, queryParameters: {
      'activityId': activityId,
    });
    return res.data['data'];
  }

  // 格式化数值
  static String formatNum(int number) {
    if (number == null) {
      return '';
    }
    if (number >= 10000) {
      var str = BService._formatNum(number / 10000, 1);
      var splitStr = str.split('.');
      if (splitStr[0] == '0' && splitStr[1] == '0') {
        str = str.split('.')[0];
      }
      return str + '万';
    }
    return number.toString();
  }

  static String _formatNum(double number, int postion) {
    if ((number.toString().length - number.toString().lastIndexOf(".") - 1) < postion) {
      // 小数点后有几位小数
      return (number
          .toStringAsFixed(postion)
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString());
    } else {
      return (number.toString().substring(0, number.toString().lastIndexOf(".") + postion + 1).toString());
    }
  }

  // 格式化时间
  static String formatTime(int timeSec) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeSec * 1000);
    var now = DateTime.now();
    var yesterday = DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch - 24 * 60 * 60 * 1000);

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '今天${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return '昨天${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return 'https:$url';
  }

  static String formatName(String r) {
    if (r == null) {
      return '';
    }
    String realName = '';
    if (r.length == 1) {
      realName = r;
    }
    if (r.length == 2) {
      realName = r.replaceFirst(r.substring(0, 1), "*");
    }
    if (r.length > 2) {
      realName = r.replaceFirst(r.substring(0, 2), "**");
    }
    return realName;
  }

  static String formatPhone(String phone) {
    if (phone == null) {
      return '';
    }
    String realName = '';
    if (phone.length == 11) {
      realName = phone.replaceFirst(phone.substring(3, 7), "****");
    }
    return realName;
  }

  static Future<Map> bindBankcard(cardNo, type, phone) async {
    await setAuthInfo();
    var res = await suClient.post(API.bindBankcard, data: {'bankNo': cardNo, 'payType': type, 'phone': phone});
    return res.data ?? {};
  }

  static Future<bool> bindBankcardConfirm(code, type, requestNo) async {
    await setAuthInfo();
    var res =
        await suClient.post(API.bindBankcardConfirm, data: {'code': code, 'payType': type, 'requestNo': requestNo});
    return res.data['success'];
  }

  static Future<List> getbindBankcardList({extract}) async {
    await setAuthInfo();
    var res = await suClient.get(API.bindBankcardList, queryParameters: {
      'extract': extract,
    });
    return res.data['data'];
  }

  static Future<Map> bindBankConfirm(code, bizSn, orderId) async {
    await setAuthInfo();
    var res = await suClient.post(API.bindBankConfirm, data: {
      'code': code,
      'bizSn': bizSn,
      'orderId': orderId,
    });
    return res.data;
  }

  static Future<Map> getBankInfo(bankNo) async {
    await setAuthInfo();
    var res = await suClient.get(API.bankInfo, queryParameters: {
      'bankNo': bankNo,
    });
    return res.data ?? {};
  }

  static Future<String> getBankLogo(bankNo) async {
    var res = await defaultClient.get(
        "https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=" +
            bankNo +
            "&cardBinCheck=true");
    Map bankInfo = res.data as Map;
    return "https://apimg.alipay.com/combo.png?d=cashier&t=" + bankInfo['bank'] + "_s";
    // var ress = await defaultClient.get(
    //     "https://apimg.alipay.com/combo.png?d=cashier&t=" + bankInfo['bank'] + "_s"
    // );
    // return ress.data;
  }

  static Future supportBank() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.supportBank,
    );
    return res.data['data'] ?? [];
  }

  static Future<Map> cashbindBankcard({cardNo, phone, id}) async {
    await setAuthInfo();
    var res = await suClient.post(API.cashbindBankcard,
        data: {'bankId': id, 'bankNo': cardNo, 'phone': phone},
        options: new Options(receiveTimeout: Duration(milliseconds: 8000)));
    return res.data ?? {};
  }

  static Future<bool> cashbindBankcardConfirm(code, authSn, requestNo) async {
    await setAuthInfo();
    var res = await suClient
        .post(API.cashbindBankcardConfirm, data: {'code': code, 'authSn': authSn, 'requestNo': requestNo});
    return res.data['success'];
  }

  static Future<Map> getLifeCity(longitude, latitude) async {
    await setAuthInfo();
    var res = await suClient.get(API.getLifeCity, queryParameters: {
      'longitude': longitude,
      'latitude': latitude,
    });
    return res.data ?? {};
  }

  static Future<Map> getLifeCategory() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.getLifeCategory,
    );
    return res.data ?? {};
  }

  static Future<Map> getLifeCityList() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.getLifeCityList,
    );
    return res.data ?? {};
  }

  static Future<Map> getLifeGoodsList(page, {categoryId, cityCode, longitude, latitude, keyword}) async {
    await setAuthInfo();
    var res = await suClient.get(API.getLifeGoodsList, queryParameters: {
      'page': page,
      'categoryId': categoryId,
      'cityCode': cityCode,
      'longitude': longitude,
      'latitude': latitude,
      'keyword': keyword,
    });
    return res.data ?? {};
  }

  static Future<Map> getLifeGoodsWord(id) async {
    await setAuthInfo();
    var res = await suClient.get(
      API.getLifeGoodsWord,
      queryParameters: {
        'id': id,
      },
    );
    return res.data['data'];
  }

  static Future<String> getWechatId() async {
    await setAuthInfo();
    var res = await suClient.get(
      API.getWechatId,
    );
    return res.data['data'];
  }

  static Future<Map> userFeedbackAdd(content) async {
    await setAuthInfo();
    var res = await suClient.post(API.userFeedbackAdd, data: {
      'feedback': content,
    });
    return res.data;
  }
}
