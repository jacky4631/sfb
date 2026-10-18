import 'package:flutter/material.dart';

import '../util/colors.dart';

/// Compact ranking card using SFB's product fields and brand colors.
class TopRankItem extends StatelessWidget {
  final int rank;
  final Map data;
  final String rewardText;

  const TopRankItem({
    super.key,
    required this.rank,
    required this.data,
    required this.rewardText,
  });

  @override
  Widget build(BuildContext context) {
    final price = num.tryParse('${data['actualPrice']}') ?? 0;
    final originalPrice = num.tryParse('${data['originalPrice']}') ?? 0;
    final rate = num.tryParse('${data['commissionRate']}') ?? 0;
    final isTmall = '${data['shopType']}' == '1';
    final title = '${data['dtitle'] ?? data['title'] ?? ''}';
    final shop = '${data['shopName'] ?? ''}';
    final sales = '${data['twoHoursSales'] ?? data['monthSales'] ?? 0}';
    final image = '${data['mainPic'] ?? ''}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank <= 3 ? Colours.light_app_main : Colours.bg_gray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: rank <= 3 ? Colours.app_main : Colours.dark_text_gray,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image.startsWith('//') ? 'https:$image' : image,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              cacheWidth: 288,
              errorBuilder: (_, __, ___) => Container(
                width: 96,
                height: 96,
                color: Colours.bg_gray,
                child: const Icon(
                  Icons.image_outlined,
                  color: Colours.text_gray_c,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Image.asset(
                        'assets/images/mall/${isTmall ? 'tm' : 'tb'}.png',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: Colours.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '券后 ¥${_price(price)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colours.app_main,
                      ),
                    ),
                    if (originalPrice > price)
                      Text(
                        '¥${_price(originalPrice)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colours.text_gray,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    if (price * rate > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colours.commission_bg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          rewardText,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colours.commission_text,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '已售$sales${shop.isEmpty ? '' : ' · $shop'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colours.text_gray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _price(num value) =>
      value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}
