import 'package:flutter/material.dart';
import 'package:maixs_utils/widget/paixs_widget.dart';

import '../service.dart';
import '../util/colors.dart';
import '../util/global.dart';
import '../util/launchApp.dart';
import '../util/login_util.dart';
import '../util/toast_utils.dart';
import '../widget/CustomWidgetPage.dart';
import 'coupon_product.dart';

/// Clipboard coupon dialog, using the same product flow as TSQ.
class ContentParseDialog extends StatefulWidget {
  final int code;
  final Map data;
  const ContentParseDialog(this.code, this.data, {super.key});

  @override
  State<ContentParseDialog> createState() => _ContentParseDialogState();
}

class _ContentParseDialogState extends State<ContentParseDialog> {
  late final CouponProduct product = CouponProduct(widget.code, widget.data);
  late final bool _parsedWhileLoggedIn;

  @override
  void initState() {
    super.initState();
    _parsedWhileLoggedIn = Global.login;
  }
  bool buying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!product.found) ...[
            const SizedBox(height: 12),
            Text(product.keyword, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20),
            const Text(
              '暂无优惠，试试全网搜索相似商品',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: _searchButton(primary: true),
            ),
          ] else ...[
            const Text(
              '已为您找到',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _productCard(context),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _searchButton()),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: buying ? null : _buy,
                    style: TextButton.styleFrom(
                      backgroundColor: Colours.app_main,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(buying ? '请稍候' : '领取优惠'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context) {
    final platformIcon = product.platform == 'tb' ? 'tm' : product.platform;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colours.hb_bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              PWidget.wrapperImage(product.img, [100, 100], {'br': 8}),
              Image.asset(
                'assets/images/mall/$platformIcon.png',
                width: 16,
                height: 16,
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                if (product.coupon > 0)
                  Text(
                    '补贴 ${product.coupon.toStringAsFixed(2)}元',
                    style: const TextStyle(
                      color: Colours.app_main,
                      fontSize: 12,
                    ),
                  ),
                if (product.fee > 0) ...[
                  const SizedBox(height: 4),
                  getMoneyWidget(
                    context,
                    product.fee,
                    product.platform,
                    canClick: false,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '到手约 ￥${product.endPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colours.app_main,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchButton({bool primary = false}) => TextButton(
    onPressed: () {
      final navigator = Navigator.of(context);
      navigator.pop();
      navigator.pushNamed(
        '/searchResult',
        arguments: {
          ...product.data,
          'keyword': product.keyword,
          'showArrowBack': true,
        },
      );
    },
    style: TextButton.styleFrom(
      backgroundColor: primary ? Colours.app_main : Colors.grey.shade100,
      foregroundColor: primary ? Colors.white : Colours.app_main,
      minimumSize: const Size(0, 44),
      shape: const StadiumBorder(),
    ),
    child: const Text('全网搜索'),
  );

  Future<void> _buy() async {
    if (!Global.login) {
      onTapDialogLogin(context);
      return;
    }
    final pageContext = Navigator.of(context, rootNavigator: true).context;
    setState(() => buying = true);
    try {
      bool authorized = true;
      if (product.platform == 'tb') {
        authorized = (await BService.tbAuthQuery())['auth'] == true;
      } else if (product.platform == 'pdd') {
        authorized = await BService.pddAuthQuery() != 0;
      }
      if (!mounted) return;
      if (!authorized) {
        Navigator.pop(context);
        // 先关闭查券弹窗，释放全局弹窗锁，再打开对应渠道授权。
        await Future<void>.delayed(const Duration(milliseconds: 250));
        Future<void> afterAuth() async {
          try {
            Navigator.pop(pageContext);
            bool success = product.platform == 'tb'
                ? (await BService.tbAuthQuery())['auth'] == true
                : await BService.pddAuthQuery() != 0;
            if (success) await _openProduct(pageContext, refreshTaobao: true);
          } catch (error) {
            ToastUtils.showToast('领取优惠失败，请稍后重试');
          }
        }

        if (product.platform == 'tb') {
          await Global.showChannelAuthDialog(
            afterAuth,
            showDirectBuy: true,
            onDirectBuy: () => _openProduct(pageContext,
                refreshTaobao: !_parsedWhileLoggedIn),
          );
        } else {
          await Global.showPddAuthDialog(afterAuth);
        }
        return;
      }
      Navigator.pop(context);
      await _openProduct(pageContext, refreshTaobao: !_parsedWhileLoggedIn);
    } catch (error) {
      ToastUtils.showToast('领取优惠失败，请稍后重试');
    } finally {
      if (mounted) setState(() => buying = false);
    }
  }

  Future<void> _openProduct(
    BuildContext pageContext, {
    bool refreshTaobao = false,
  }) async {
    if (product.platform == 'tb' && product.shortUrl.isNotEmpty) {
      String link = product.shortUrl;
      if (refreshTaobao && product.originContent.isNotEmpty) {
        // 登录或渠道授权状态改变后重新转链，保证订单归属当前用户。
        final response = await BService.parseContent(
          product.originContent,
          Global.login,
        );
        final refreshed = CouponProduct(
          int.tryParse('${response['code']}') ?? -1,
          response['data'] is Map ? response['data'] as Map : {},
        );
        if (!refreshed.found || refreshed.shortUrl.isEmpty) {
          throw StateError('淘宝转链失败');
        }
        link = refreshed.shortUrl;
      }
      // 淘宝查券接口已完成转链，直接使用短链，避免数字商品 ID 再查详情失败。
      await LaunchApp.launchTb(pageContext, link);
    } else {
      Navigator.pushNamed(
        pageContext,
        product.detailRoute,
        arguments: product.data,
      );
    }
  }
}
