import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sufenbao/search/provider.dart';
import 'package:sufenbao/util/value_util.dart';
import 'package:sufenbao/widget/loading.dart';

import '../service.dart';
import '../util/custom.dart';
import '../util/global.dart';
import '../widget/CustomWidgetPage.dart';
import 'model/search_param.dart';

class ListWidgetPage extends ConsumerStatefulWidget {
  final int tabIndex;
  const ListWidgetPage(this.tabIndex, {Key? key}) : super(key: key);
  @override
  _ListWidgetPageState createState() => _ListWidgetPageState();
}

class _ListWidgetPageState extends ConsumerState<ListWidgetPage> {
  SearchParam searchParam = SearchParam();

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(goodsSearchProvider(tabIndex: widget.tabIndex));
    final notifier = ref.watch(goodsSearchProvider(tabIndex: widget.tabIndex).notifier);

    return EasyRefresh.builder(
      controller: notifier.controller,
      onLoad: notifier.loadMore,
      onRefresh: notifier.refresh,
      childBuilder: (context, physics) {
        return provider.when(
            data: (data) => ListView.builder(
                  physics: physics,
                  padding: EdgeInsets.only(top: 0),
                  itemBuilder: (BuildContext c, int i) {
                    final v = data[i];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Global.openFadeContainer(
                            createItem(v, i), searchParam.jump2Detail(context, widget.tabIndex, v)),
                      ),
                    );
                  },
                  itemCount: data.length,
                ),
            error: (o, s) => ErrorState(),
            loading: () => LoadingState());
      },
    );
  }

  Widget createItem(v, i) {
    Map data = v as Map;
    String img = '';
    String sale = '0';
    num fee = 0;
    String title = '';
    String endPrice = '0';
    String startPrice = '0';
    String shopName = '';
    String jdOwner = '';
    String platform = TB;
    if (widget.tabIndex == 0) {
      title = data['title'];
      img = data['mainPic'] == '' ? data['pict_url'] : data['mainPic'];
      img = '${img}_310x310';
      sale = BService.formatNum(data['monthSales']);
      startPrice = ValueUtil.toStr(data['originalPrice']);

      final actualPrice = ValueUtil.toNum(data['actualPrice']);
      fee = ValueUtil.toNum(data['commissionRate']) * actualPrice / 100;
      endPrice = actualPrice.toStringAsFixed(2);
      shopName = data['shopName'];
      platform = TB;
    } else if (widget.tabIndex == 1) {
      title = data['goodsName'];
      img = data['goodsImageUrl'];
      sale = data['salesTip'];
      fee = data['promotionRate'] * data['minGroupPrice'] / 100;
      endPrice = data['minGroupPrice'].toString();
      startPrice = data['minNormalPrice'].toString();
      shopName = data['mallName'];
      platform = PDD;
    } else if (widget.tabIndex == 2) {
      title = data['skuName'];
      img = data['whiteImage'] == '' ? data['imageUrlList'][0] : data['whiteImage'];
      sale = data['inOrderCount30Days'].toString();
      fee = data['couponCommission'];
      endPrice = data['lowestCouponPrice'].toString();
      startPrice = data['lowestPrice'].toString();
      shopName = data['shopName'];
      jdOwner = data['owner'];
      platform = JD;
    } else if (widget.tabIndex == 3) {
      title = data['title'];
      img = data['cover'];
      sale = BService.formatNum(data['sales']);
      fee = data['cosFee'];
      endPrice = data['price'].toString();
      startPrice = data['price'].toString();
      shopName = data['shopName'];
      platform = DY;
    } else if (widget.tabIndex == 4) {
      title = data['goodsName'];
      img = data['white_image'] == null ? data['goodsMainPicture'] : data['white_image'];
      if (!Global.isEmpty(data['sales'])) {
        sale = BService.formatNum(data['sales']);
      }
      fee = double.parse(data['commission']);
      endPrice = data['vipPrice'].toString();
      startPrice = data['marketPrice'].toString();
      shopName = data['storeInfo']['storeName'];
      platform = VIP;
    }
    debugPrint(data.toString());
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              img,
              width: 124,
              height: 124,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 124,
                  height: 124,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: getTitleWidget(title, max: 2)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    getPriceWidget(endPrice, startPrice),
                  ],
                ),
                SizedBox(height: 8),
                getMoneyWidget(context, fee, platform),
                SizedBox(height: 8),
                Row(
                  children: [
                    if (jdOwner == 'g')
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '自营',
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    if (jdOwner == 'g') SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        shopName,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.tabIndex != 4)
                      Text(
                        '已售$sale',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
