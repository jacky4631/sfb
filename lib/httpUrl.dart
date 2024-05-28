/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
/*
 * @discripe: 网络服务
 */
import 'package:dio/dio.dart';

import 'base.dart';

// 接口URL
abstract class API {
  static const sendSms = '/register/verify';
  static const login = '/login/mobile';
  static const loginShanyan = '/login/shanyan';
  static const goodsList = '/tao/goods/list';
  static const goodsSearch = '/tao/goods/search';
  static const goodsSimilarList = '/tao/goods/similar/list';
  static const goodsDetail = '/tao/goods/detail';
  static const goodsDetailPDD = '/pdd/goods/detail';
  static const goodsWord = '/tao/goods/word';
  static const ddq = '/tao/ddq';
  static const rankingList = '/tao/ranking/list';
  static const shopConvert = '/tao/shop/convert';
  static const brandList = '/tao/brand/list';
  static const goodsCate = '/tao/goods/category';
  static const activityParse = '/tao/activity/parse';
  static const tbAuthQuery = '/user/auth/query';

  static const goodsSearchPDD = '/pdd/goods/list';
  static const pddGoodsCate = '/pdd/goods/cate';

  static const pddAuthQuery = '/pdd/auth/query';
  static const pddAuth = '/pdd/auth';
  static const pddGoodsWord = '/pdd/goods/word';


  static const goodsWordJD = '/jd/goods/word';
  static const goodsDetailJD = '/jd/goods/detail';
  static const goodsListJD = '/jd/goods/list';
  static const brandListJD = '/jd/brand/list';
  static const ninesListJD = '/jd/nines/list';
  static const rankListJD = '/jd/rank/list';

  static const goodsListVIP = '/vip/goods/list';
  static const goodsWordVIP = '/vip/goods/word';
  static const vipSearch = '/vip/goods/search';
  static const vipGoodsDetail = '/vip/goods/detail';

  static const pddList = '/ku/pdd/list';
  static const pddNav = '/ku/pdd/nav';
  static const pddCate = '/ku/pdd/cate';

  static const dyList = '/ku/dy/list';
  static const dyNav = '/ku/dy/nav';
  static const dyCate = '/ku/dy/cate';
  static const pickCate = '/ku/pick/cate';
  static const pickList = '/ku/pick/list';

  static const miniList = '/ku/mini/list';
  static const banner = '/ku/banner';
  static const banners = '/ku/banners';
  static const tiles = '/ku/tiles';
  static const customCate = '/ku/custom/cate';
  static const customList = '/ku/custom/list';
  static const activityDetail = '/ku/activity/detail';
  //抖音盛夏洗护
  static const dyBannerWord = '/ku/dy/banner/word';
  static const goodsWordPDDHAODANKU = '/ku/pdd/goods/word';
  static const shortLink = '/ku/shortLink';

  //库美团饿了么 美团暂不用
  static const waimaiActivityList = '/ku/waimai/list';
  static const eleActivityList = '/ku/ele/list';
  static const waimaiActivityWord = '/ku/waimai/word';

  //美团官方 使用
  static const mtActivityList = '/mt/activity/list';
  static const mtActivityWord = '/mt/activity/code';

  static const dyGoodsDetail = '/dy/goods/detail';
  static const dyWord = '/dy/word';
  static const dyGoodsSearch = '/dy/goods/search';


  static const orderSubmit = '/order/submit';
  static const homeUrl = '/tao/home/url';

  static const userinfo = '/userinfo';
  static const userWxProfile = '/user/wxprofile';
  static const userCard = '/user/card';
  static const userShare = '/user/share';
  static const vipinfo = '/vipinfo';
  static const userfee = '/userfee';
  static const userfeedetail = '/userfeedetail';
  static const spreadHb = '/spread/hb';
  static const hasUnlockOrder = '/hasUnlockOrder';

  static const commissionInfo = '/commissionInfo';
  static const userDelete = '/user/delete';
  static const userSpread = '/user/spread';
  static const cityList = '/city_list';
  static const addressEdit = '/address/edit';
  static const addressDel = '/address/del';
  static const addressDefaultSet = '/address/default/set';
  static const addressList = '/address/list';
  static const addressDefault = '/address/default';
  static const extract = '/extract/cash';
  static const extractConfig = '/extract/config';
  static const payConfig = '/pay/config';
  static const updateConfig = '/update/config';
  static const payWechat = '/pay/channel';
  static const payBank = '/pay/channel';
  static const payAli = '/pay/channel';
  static const payChannel = '/pay/channel';
  static const payIOS = '/recharge/app/ios';
  static const rechargeResult = '/recharge/result';
  static const payNotifyIOS = '/ios/notify';

  static const rechargeCoupon = '/recharge/coupon';
  static const cmsDdq = '/cms/ddq';
  static const cmsHot = '/cms/hot';
  static const cmsEveryBuy = '/cms/everyone/buy';
  static const cmsBrand = '/cms/brand/list';
  static const hotWords = '/cms/hot-words';
  static const hotWordsCenter = '/ku/hot/words';
  static const rankingCate = '/cms/ranking/cate';
  static const bigList = '/cms/big/list';
  static const cmsCate = '/cms/cate';
  static const brandGoodsList = '/cms/brand/goods/list';
  static const nineList = '/cms/nine/list';
  static const nineTop = '/cms/nine/top';
  static const nineCate = '/cms/nine/cate';


  static const mePointsMall = '/products';
  static const mePointsMallDetail = '/product/detail';
  static const meCategory = '/category';
  static const meIntegralConfirm = '/integral/confirm';
  static const createOrder = '/order/create';


  static const parseContent = '/tao/parse/content';
  static const parseContent2 = '/tao/parse/content2';
  static const taoOrders = '/tao/orders';
  static const jdOrders = '/jd/orders';
  static const pddOrders = '/pdd/orders';
  static const vipOrders = '/vip/orders';
  static const dyOrders = '/dy/orders';
  static const mtOrders = '/mt/orders';
  static const integralOrders = '/order/list';
  static const orderTab = '/order/tab';
  static const orderTabFirst = '/order/tab/first';
  //资金明细
  static const integralList = '/integral/list';
  //热度明细
  static const energyList = '/energy/list';
  static const wechatAppLogin = '/wechat/app/auth';
  static const wechatLogin = '/wechat/auth';
  static const appleLogin = '/apple/app/auth';
  static const wechatBinding = '/wechat/app/binding';
  static const alipayBinding = '/alipay/app/binding';
  static const alipayCode = '/alipay/app/code';

  static const loginmustcode = '/loginmustcode';

  static const fans = '/spread/people';
  static const fileUpload = '/api/alioss/upload';
  static const cardUpload = '/user/card/upload';
  static const signatureUpload = '/user/signature/upload';
  static const userEdit = '/user/edit';
  static const userGrade = '/user/level/grade';
  static const userHistory = '/user/history';
  static const userHistorySave = '/user/history/save';
  static const userHistoryClear = '/user/history/clear';
  static const userBindMobile = '/user/bind/mobile';
  static const userFace = '/user/face';
  static const userFaceResult = '/user/face/result';
  static const userEnergy = '/user/energy';
  static const userEnergyDetail = '/user/energy/detail';

  static const collectAdd = '/collect/add';
  static const collect = '/collect';
  static const collectDel = '/collect/del';
  static const collectList = '/collect/user';

  static const extractList = '/extract/list';

  static const channelAuth = '/user/binding';

  static const payBind = '/pay/bind';

  static const bindBankcard = '/pay/bank/bind';
  static const bindBankcardConfirm = '/pay/bank/bind/confirm';
  static const bindBankcardList = '/user/bank/list';
  static const bindBankConfirm = '/pay/confirm';

  static const bankInfo = '/pay/bank/info';
  static const supportBank = '/pay/bank/support';

  static const cashbindBankcard = '/extract/bank/bind';
  static const cashbindBankcardConfirm = '/extract/bank/bind/confirm';

  static const getLifeCity = '/ku/dy/life/getcity';
  static const getLifeCategory = '/ku/dy/life/category/list';
  static const getLifeCityList = '/ku/dy/life/city/list';
  static const getLifeGoodsList = '/ku/dy/life/goods/list';
  static const getLifeGoodsWord = '/ku/dy/life/goods/word';

  static const getWechatId = '/wechat/id';


  static const userFeedbackAdd = '/user/feedback/add';
}

final suClient = Dio(BaseOptions(
  baseUrl: BBase.suUrl,
  responseType: ResponseType.json,
  connectTimeout: Duration(milliseconds: 6000),
  receiveTimeout: Duration(milliseconds: 6000),
));

final defaultClient = Dio(BaseOptions(
  responseType: ResponseType.json,
  connectTimeout: Duration(milliseconds: 6000),
  receiveTimeout: Duration(milliseconds: 6000),
));