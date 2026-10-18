/// Shared contract for clipboard coupon results and product navigation.
class CouponProduct {
  CouponProduct(int code, Map source)
    : data = Map<String, dynamic>.from(source) {
    final rawPlatform =
        source['platType'] ?? source['plat_type'] ?? source['plat'];
    platform =
        const {
          '1': 'tb',
          '2': 'jd',
          '3': 'pdd',
          '4': 'dy',
          '5': 'vip',
        }['$rawPlatform'] ??
        (const ['tb', 'jd', 'pdd', 'dy', 'vip'].contains(rawPlatform)
            ? rawPlatform as String
            : 'tb');
    title = '${source['title'] ?? source['item_title'] ?? ''}';
    originContent = '${source['originContent'] ?? ''}';
    goodsId =
        '${source['goodsId'] ?? source['goodsSign'] ?? source['item_id'] ?? source['itemId'] ?? source['skuId'] ?? source['sku_id'] ?? ''}';
    startPrice = number(source['startPrice'] ?? source['item_price']);
    endPrice = number(source['endPrice'] ?? source['item_end_price']);
    coupon = number(source['coupon'] ?? source['coupon_money']);
    fee = source['fee'] != null
        ? number(source['fee'])
        : endPrice * number(source['feeRatio'] ?? source['rates']) / 100;
    img = '${source['img'] ?? source['item_pic'] ?? ''}';
    if (img.startsWith('//')) img = 'https:$img';
    found =
        (code == 0 || code == 200) && title.isNotEmpty && goodsId.isNotEmpty;
    data.addAll({
      'goodsId': goodsId,
      'title': title,
      'img': img,
      'startPrice': startPrice,
      'endPrice': endPrice,
      'coupon': coupon,
      'plat': platform,
      'originContent': originContent,
    });
    if (platform == 'pdd') data['goodsSign'] = goodsId;
    if (platform == 'vip') data['category'] = 'vip';
  }

  final Map<String, dynamic> data;
  late final String platform, title, originContent, goodsId;
  late String img;
  late final num startPrice, endPrice, coupon, fee;
  late final bool found;
  String get shortUrl => '${data['shortUrl'] ?? ''}';
  String get keyword => title.isNotEmpty ? title : originContent;
  String get detailRoute => const {
    'tb': '/detail',
    'jd': '/detailJD',
    'pdd': '/detailPDD',
    'dy': '/detailDY',
    'vip': '/detailVIP',
  }[platform]!;

  static num number(dynamic value) {
    final result = num.tryParse('$value');
    return result != null && result.isFinite ? result : 0;
  }
}
