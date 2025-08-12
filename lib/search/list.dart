import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';
import 'package:sufenbao/search/provider.dart';

import '../service.dart';
import '../util/custom.dart';
import '../util/global.dart';
import '../util/paixs_fun.dart';
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
                    return PWidget.container(
                      Global.openFadeContainer(createItem(v, i), searchParam.jump2Detail(context, widget.tabIndex, v)),
                      [null, null, Colors.white],
                      {
                        'sd': PFun.sdLg(Colors.black12),
                        'br': 8,
                        'mg': PFun.lg(0, 6),
                        'crr': [5, 5, 5, 5]
                      },
                    );
                  },
                  itemCount: data.length,
                ),
            error: (o, s) => ErrorState(),
            loading: () => LoadingState());
      },
    );

    ;
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
    return PWidget.container(
        PWidget.row(
          [
            PWidget.wrapperImage(img, [124, 124], {'br': 8}),
            PWidget.boxw(8),
            PWidget.column([
              PWidget.row([
                getTitleWidget(title, max: 2),
                // PWidget.text('${data['title']}', {'max': 2, 'exp': true}),
              ], [
                '0',
                '1',
                '1'
              ]),
              PWidget.boxh(8),
              PWidget.row(
                [
                  getPriceWidget(endPrice, startPrice),
                ],
              ),
              PWidget.boxh(8),
              getMoneyWidget(context, fee, platform),
              PWidget.spacer(),
              PWidget.row([
                jdOwner == 'g'
                    ? PWidget.container(
                        PWidget.text('自营', [Colors.white, 9]),
                        [null, null, Colors.red],
                        {'bd': PFun.bdAllLg(Colors.red, 0.5), 'pd': PFun.lg(1, 1, 4, 4), 'br': PFun.lg(4, 4, 4, 4)},
                      )
                    : SizedBox(),
                jdOwner == 'g' ? PWidget.boxw(4) : SizedBox(),
                PWidget.text(shopName, [Colors.black54, 12], {'exp': true}),
                widget.tabIndex == 4 ? SizedBox() : PWidget.text('已售$sale', [Colors.black54, 12]),
              ])
            ], {
              'exp': 1,
            }),
          ],
          '001',
          {'fill': true},
        ),
        [null, null, Colors.white],
        {'pd': 8});
  }
}
