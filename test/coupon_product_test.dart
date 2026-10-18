import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/dialog/coupon_product.dart';

void main() {
  test('all five platforms expose the right detail route and product id', () {
    final routes = [
      '/detail',
      '/detailJD',
      '/detailPDD',
      '/detailDY',
      '/detailVIP',
    ];
    final platforms = ['tb', 'jd', 'pdd', 'dy', 'vip'];
    for (var i = 0; i < routes.length; i++) {
      final result = CouponProduct(0, {
        'platType': i + 1,
        'goodsId': 'encrypted-id',
        'title': '商品',
        'startPrice': 100,
        'endPrice': 80,
        'coupon': 20,
        'feeRatio': 10,
      });
      expect(result.found, isTrue);
      expect(result.detailRoute, routes[i]);
      expect(result.platform, platforms[i]);
      expect(result.fee, 8);
      if (i == 2) expect(result.data['goodsSign'], 'encrypted-id');
      if (i == 4) expect(result.data['category'], 'vip');
    }
  });

  test(
    'legacy provider aliases accept numeric strings and keep encrypted ids',
    () {
      final result = CouponProduct(200, {
        'plat_type': '3',
        'item_id': 'opaque-pdd',
        'item_title': '拼多多商品',
        'item_price': '99.00',
        'item_end_price': '79.00',
        'rates': '10',
        'coupon_money': '20',
        'item_pic': '//example.com/photo.jpg',
      });
      expect(result.found, isTrue);
      expect(result.endPrice, 79);
      expect(result.fee, 7.9);
      expect(result.img, 'https://example.com/photo.jpg');
      expect(result.data['goodsSign'], 'opaque-pdd');
    },
  );

  test('taobao keeps the already converted short link', () {
    final result = CouponProduct(0, {
      'platType': 1,
      'goodsId': '123456',
      'title': '淘宝商品',
      'shortUrl': 'https://s.click.taobao.com/link',
      'shortPwd': '口令',
    });
    expect(result.found, isTrue);
    expect(result.shortUrl, 'https://s.click.taobao.com/link');
  });

  test('failed parse retains original clipboard as search keyword', () {
    final result = CouponProduct(-1, {'originContent': '原商品分享链接'});
    expect(result.found, isFalse);
    expect(result.keyword, '原商品分享链接');
    expect(result.endPrice, 0);
  });

  test('missing ids do not produce broken detail navigation', () {
    expect(CouponProduct(0, {'title': '无商品编号'}).found, isFalse);
    expect(CouponProduct(0, {'goodsId': '123'}).found, isFalse);
  });

  test('does not mutate provider response or accept nonfinite money', () {
    final source = {'goodsId': '123', 'title': '商品', 'endPrice': 'NaN'};
    final result = CouponProduct(0, source);
    result.data['showArrowBack'] = true;
    expect(source.containsKey('showArrowBack'), isFalse);
    expect(source.containsKey('plat'), isFalse);
    expect(result.endPrice, 0);
  });
}
