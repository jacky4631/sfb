/// CMS product prices and commissions are already yuan.
class DyGoods {
  static num number(dynamic value) => num.tryParse('$value') ?? 0;
  static String id(Map data) =>
      '${data['goodsId'] ?? data['itemid'] ?? data['product_id'] ?? data['productId'] ?? data['itemId'] ?? data['item_id'] ?? ''}';
  static num price(Map data) => number(data['endPrice'] ?? data['startPrice']);
  static num fee(Map data) => data['fee'] != null
      ? number(data['fee'])
      : price(data) * number(data['feeRatio']) / 100;
  static String title(Map data) => '${data['dtitle'] ?? data['title'] ?? ''}';
  static String money(num value) =>
      value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  static List<String> images(Map data, {bool detail = false}) {
    final result = <String>[];
    void add(dynamic value) {
      if (value is! String || value.trim().isEmpty) return;
      final url = value.trim().startsWith('//')
          ? 'https:${value.trim()}'
          : value.trim();
      if (!result.contains(url)) result.add(url);
    }

    final gallery = data[detail ? 'details' : 'banners'];
    if (!detail) add(data['img']);
    if (gallery is List) gallery.forEach(add);
    if (result.isEmpty) add(data['img']);
    return result;
  }
}
