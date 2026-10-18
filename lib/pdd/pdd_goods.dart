/// PDD API prices are yuan; the payable price is group price minus coupon.
class PddGoods {
  static num number(dynamic value) => num.tryParse('$value') ?? 0;

  static String id(Map data) =>
      (data['goodsSign'] ??
              data['goodsId'] ??
              data['goods_sign'] ??
              data['productId'] ??
              data['itemId'] ??
              '')
          .toString();

  static num price(Map data) =>
      (number(data['endPrice']) - number(data['coupon'])).clamp(
        0,
        double.infinity,
      );

  static num fee(Map data) => data['fee'] != null
      ? number(data['fee'])
      : number(data['endPrice']) * number(data['feeRatio']) / 100;

  static String title(Map data) => '${data['dtitle'] ?? data['title'] ?? ''}';
}
