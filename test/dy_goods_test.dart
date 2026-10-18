import 'package:flutter_test/flutter_test.dart';
import 'package:maixs_utils/model/data_model.dart';
import 'package:sufenbao/dy/dy_goods.dart';
import 'package:sufenbao/service.dart';

void main() {
  test('CMS yuan prices and commissions are not divided or discounted again', () {
    final data = {'endPrice': 29.9, 'startPrice': 99, 'coupon': 10, 'fee': 3.5};
    expect(DyGoods.price(data), 29.9);
    expect(DyGoods.fee(data), 3.5);
    expect(DyGoods.money(DyGoods.price(data)), '29.9');
    expect(DyGoods.price({'startPrice': 19.95}), 19.95);
    expect(DyGoods.price({}), 0);
  });

  test('gallery is sanitized, deduplicated and falls back to main image', () {
    expect(DyGoods.images({'img': '//example.com/main', 'banners': ['', null, '//example.com/main', 'https://example.com/other']}),
        ['https://example.com/main', 'https://example.com/other']);
    expect(DyGoods.images({'img': 'main', 'details': []}, detail: true), ['main']);
    expect(DyGoods.images({'img': 'main', 'details': ['detail']}, detail: true), ['detail']);
  });

  test('normalized, legacy and order IDs resolve to product ID', () {
    for (final field in ['goodsId', 'itemid', 'product_id', 'productId', 'itemId', 'item_id']) {
      expect(DyGoods.id({field: 123}), '123');
    }
    expect(DyGoods.id({}), '');
  });

  test('list pagination follows CMS cursor and stops on an empty page', () {
    final model = DataModel();
    BService.addDyList(model, {'list': [1], 'minId': 17}, 1, true);
    expect(model.page, 17);
    expect(model.hasNext, isTrue);
    BService.addDyList(model, {'list': [], 'minId': 29}, 17, false);
    expect(model.hasNext, isFalse);
    expect(model.page, 17);
  });
}
