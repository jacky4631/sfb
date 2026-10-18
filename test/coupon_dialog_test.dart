import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/dialog/contet_parse_dialog.dart';

void main() {
  testWidgets('failed parse opens full search using the original share content', (tester) async {
    Map? searchArgs;
    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name != '/searchResult') return null;
        searchArgs = settings.arguments as Map;
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('搜索结果页')));
      },
      home: Builder(builder: (context) => Scaffold(
        body: TextButton(onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const Dialog(child: ContentParseDialog(-1, {
            'originContent': '原商品分享内容',
          })),
        ), child: const Text('查券')),
      )),
    ));
    await tester.tap(find.text('查券'));
    await tester.pumpAndSettle();
    expect(find.text('暂无优惠，试试全网搜索相似商品'), findsOneWidget);
    expect(find.text('领取优惠'), findsNothing);
    await tester.tap(find.text('全网搜索'));
    await tester.pumpAndSettle();
    expect(find.text('搜索结果页'), findsOneWidget);
    expect(searchArgs?['keyword'], '原商品分享内容');
    expect(searchArgs?['showArrowBack'], isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets('PDD success displays product and claim action', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(
      body: Center(child: SizedBox(width: 340, child: ContentParseDialog(0, {
        'platType': 3, 'goodsId': 'opaque-id', 'title': '拼多多优惠商品',
        'endPrice': 19.9, 'coupon': 5,
      }))),
    )));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('拼多多优惠商品'), findsOneWidget);
    expect(find.text('领取优惠'), findsOneWidget);
    expect(find.text('到手约 ￥19.90'), findsOneWidget);
    expect(find.text('暂无优惠，试试全网搜索相似商品'), findsNothing);
    expect(tester.takeException(), isNull);
  });

}
