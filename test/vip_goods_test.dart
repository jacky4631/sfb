import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/vip/vip_goods.dart';

void main() {
  test('VIPShop coupon price retains cents and leaves provider price intact', () {
    final data = {'endPrice': 129.9, 'startPrice': 399, 'couponInfo': {'fav': 20}};
    expect(VipGoods.price(data), closeTo(109.9, 0.001));
    expect(VipGoods.money(VipGoods.price(data)), '109.9');
    expect(data['endPrice'], 129.9);
    expect(VipGoods.price({'endPrice': '19.95'}), 19.95);
  });

  test('VIPShop optional coupon, fee and shop fields are safe', () {
    expect(VipGoods.price({'endPrice': 10, 'couponInfo': {'fav': 20}}), 0);
    expect(VipGoods.fee({'fee': '12.5'}), 12.5);
    expect(VipGoods.fee({'endPrice': 100, 'feeRatio': 5}), 5);
    expect(VipGoods.shop({'storeInfo': {'storeName': '品牌店'}}), '品牌店');
    expect(VipGoods.price({}), 0);
    expect(VipGoods.money(100), '100');
  });

  test('VIPShop resolves list, favorites and order product IDs', () {
    expect(VipGoods.id({'goodsId': 123}), '123');
    expect(VipGoods.id({'productId': '456'}), '456');
    expect(VipGoods.id({'detailList': [{'goodsId': '789'}]}), '789');
    expect(VipGoods.id({'detailList': [], 'itemId': '123'}), '123');
    expect(VipGoods.id({}), '');
  });
}
