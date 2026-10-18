import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sufenbao/dialog/taobao_auth_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/dialog/channel_auth_dialog.dart';

void main() {
  testWidgets(
    'optional authorization offers direct purchase without calling authorization',
    (tester) async {
      var directPurchases = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 340,
                child: ChannelAuthDialog({
                  'showDirectBuy': true,
                  'fun': () {
                    directPurchases++;
                  },
                }),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('前往淘宝授权'), findsOneWidget);
      expect(find.text('暂不授权，直接购买'), findsOneWidget);
      await tester.tap(find.text('暂不授权，直接购买'));
      expect(directPurchases, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'explicit authorization remains available without purchase action',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 340, child: ChannelAuthDialog({})),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('前往淘宝授权'), findsOneWidget);
      expect(find.text('暂不授权，直接购买'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  test('preserves Taobao channel eligibility and SDK failure reasons', () {
    expect(
      TaobaoAuthError.response({'msg': '操作失败', 'subMsg': '账号未满足渠道申请条件'}),
      '账号未满足渠道申请条件',
    );
    expect(TaobaoAuthError.response({'msg': '该淘宝号已被其他账户授权'}), '该淘宝号已被其他账户授权');
    expect(TaobaoAuthError.sdk('用户取消授权', '-1'), '用户取消授权');
    expect(TaobaoAuthError.response({'msg': '操作失败'}), TaobaoAuthError.fallback);
  });

  testWidgets(
    'missing token shows only the real-name reminder and keeps direct purchase available',
    (tester) async {
      final messenger = tester.binding.defaultBinaryMessenger;
      const native = MethodChannel('flutter_alibc');
      const toast = MethodChannel('PonnamKarthik/fluttertoast');
      messenger.setMockMethodCallHandler(native, (_) async => null);
      final messages = <String>[];
      messenger.setMockMethodCallHandler(toast, (call) async {
        messages.add('${call.arguments['msg']}');
        return true;
      });
      addTearDown(() {
        messenger.setMockMethodCallHandler(native, null);
        messenger.setMockMethodCallHandler(toast, null);
      });
      var completed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 340,
                child: ChannelAuthDialog({
                  'showDirectBuy': true,
                  'fun': () {},
                  'callback': () {
                    completed = true;
                  },
                }),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('前往淘宝授权'));
      await tester.pump();
      await messenger.handlePlatformMessage(
        'flutter_alibc',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AlibcTaobaoLogin', {
            'errorCode': '0',
            'errorMessage': '',
            'data': <String, dynamic>{},
          }),
        ),
        (_) {},
      );
      await tester.pumpAndSettle();
      expect(messages, [TaobaoAuthError.missingToken]);
      expect(find.text('暂不授权，直接购买'), findsOneWidget);
      expect(find.text('前往淘宝授权'), findsOneWidget);
      expect(completed, isFalse);
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    },
  );
}
