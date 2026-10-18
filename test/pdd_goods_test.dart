import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/pdd/pdd_goods.dart';

void main() {
  test('PDD uses yuan and subtracts coupon once', () {
    final product = {'endPrice': 39.9, 'coupon': 10, 'feeRatio': 20};
    expect(PddGoods.price(product), closeTo(29.9, 0.001));
    expect(PddGoods.fee(product), closeTo(7.98, 0.001));
    expect(product['endPrice'], 39.9);
  });

  test('supplied commission is retained and absent coupons are safe', () {
    expect(PddGoods.fee({'fee': '1.25', 'endPrice': 30, 'feeRatio': 50}), 1.25);
    expect(PddGoods.price({'endPrice': '18.9'}), 18.9);
    expect(PddGoods.price({'endPrice': 5, 'coupon': 10}), 0);
    expect(PddGoods.fee({}), 0);
  });

  test('normalized, legacy and order entries resolve a goodsSign', () {
    for (final key in ['goodsId', 'goodsSign', 'goods_sign', 'productId', 'itemId']) {
      expect(PddGoods.id({key: 'signed-product'}), 'signed-product');
    }
    expect(PddGoods.id({}), '');
    expect(PddGoods.title({'dtitle': '商品名称', 'title': '商品描述'}), '商品名称');
  });
}
