import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/dialog/channel_auth_dialog.dart';

void main() {
  testWidgets('optional authorization offers direct purchase without calling authorization', (tester) async {
    var directPurchases = 0;
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Center(child: SizedBox(width: 340, child: ChannelAuthDialog({
        'showDirectBuy': true,
        'fun': () { directPurchases++; },
      }))),
    )));
    await tester.pumpAndSettle();
    expect(find.text('前往淘宝授权'), findsOneWidget);
    expect(find.text('暂不授权，直接购买'), findsOneWidget);
    await tester.tap(find.text('暂不授权，直接购买'));
    expect(directPurchases, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit authorization remains available without purchase action', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Center(child: SizedBox(width: 340, child: ChannelAuthDialog({}))),
    )));
    await tester.pumpAndSettle();
    expect(find.text('前往淘宝授权'), findsOneWidget);
    expect(find.text('暂不授权，直接购买'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
