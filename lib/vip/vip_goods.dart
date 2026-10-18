/// Shared VIPShop product values for lists, detail, favorites and sharing.
class VipGoods {
  static num number(dynamic value) => num.tryParse('$value') ?? 0;

  static String id(Map data) {
    final details = data['detailList'];
    if (details is List && details.isNotEmpty) {
      final id = details.first['goodsId'];
      if (id != null && '$id'.isNotEmpty) return '$id';
    }
    return '${data['productId'] ?? data['itemId'] ?? data['goodsId'] ?? ''}';
  }

  static num coupon(Map data) => number(data['couponInfo']?['fav']);
  static num price(Map data) =>
      (number(data['endPrice']) - coupon(data)).clamp(0, double.infinity);
  static num fee(Map data) => data['fee'] != null
      ? number(data['fee'])
      : number(data['endPrice']) * number(data['feeRatio']) / 100;
  static String title(Map data) => '${data['dtitle'] ?? data['title'] ?? ''}';
  static String shop(Map data) =>
      '${data['shopName'] ?? data['storeInfo']?['storeName'] ?? ''}';
  static String money(num value) =>
      value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}
