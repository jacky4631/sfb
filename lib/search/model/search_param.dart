/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */

import 'package:flutter/widgets.dart';
import 'package:sufenbao/dy/dy_detail_page.dart';

import '../../jd/jd_details_page.dart';
import '../../page/product_details.dart';
import '../../pdd/pdd_detail_page.dart';
import '../../vip/vip_detail_page.dart';

///搜索框
class SearchParam {
  getTaoSortKey(sort) {
    switch(sort) {
      case 0:
        return '';
      case 2:
        return 'total_sales_des';
      case 4:
        return 'price_asc';
      case 5:
        return 'price_des';
      default:
        return '';
    }
  }

  getJdSortKey(sort) {
    switch(sort) {
      case 0:
        return {};
      case 2:
        return {'sortName': 'inOrderCount30Days', 'sort': 'desc'};
      case 4:
        return {'sortName': 'price', 'sort': 'asc'};
      case 5:
        return {'sortName': 'price', 'sort': 'desc'};
      default:
        return {};
    }
  }
  getPddSortKey(sort) {
    switch(sort) {
      case 0:
        return 2;
      case 2:
        return 6;
      case 4:
        return 3;
      case 5:
        return 4;
      default:
        return 2;
    }
  }
  getDySortKey(sort) {
    switch(sort) {
      case 0:
        return 0;
      case 2:
        return 1;
      case 4:
        return 2;
      case 5:
        return 2;
      default:
        return 0;
    }
  }

  getVipSortKey(sort) {
    switch(sort) {
      case 0:
        return 'COMMISSION_RATE';
      case 2:
        return 'SALES';
      case 4:
        return 'PRICE';
      case 5:
        return 'PRICE';
      default:
        return 'COMMISSION_RATE';
    }
  }

  Widget jump2Detail(context, tabIndex, data) {
    String pageUrl = '/detail';
    switch (tabIndex) {
      case 0://淘宝
        return ProductDetails(data);
      case 1://拼多多
        return PddDetailPage(data);
      case 2://京东
        return JDDetailsPage(data);
      case 3://抖音
        return DyDetailPage(data);
      case 4://唯品会
        return VipDetailPage(data);
      default:
        return ProductDetails(data);
    }
  }
}
