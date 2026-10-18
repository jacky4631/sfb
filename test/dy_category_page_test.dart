import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maixs_utils/util/utils.dart' as app_utils;
import 'package:sufenbao/dy/dy_index_page.dart';
import 'package:sufenbao/httpUrl.dart';
import 'package:sufenbao/service.dart';

class CategoryAdapter implements HttpClientAdapter {
  bool categoryFails = true;
  int listRequests = 0;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    Map body;
    if (options.path == API.dyCate) {
      body = categoryFails
          ? {'status': 500, 'success': false, 'msg': 'category failure'}
          : {'status': 200, 'success': true, 'data': [{'cid': 8, 'title': '食品'}]};
    } else {
      listRequests++;
      body = {'status': 200, 'success': true, 'data': {'list': [], 'minId': 1}};
    }
    return ResponseBody.fromString(jsonEncode(body), 200,
        headers: {Headers.contentTypeHeader: ['application/json']});
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late HttpClientAdapter original;
  late CategoryAdapter adapter;
  setUp(() {
    original = suClient.httpClientAdapter;
    adapter = CategoryAdapter();
    suClient.httpClientAdapter = adapter;
  });
  tearDown(() { suClient.httpClientAdapter = original; });

  test('HTTP 200 application error is rejected instead of treated as empty categories', () async {
    await expectLater(BService.dyCate(), throwsStateError);
    adapter.categoryFails = false;
    expect((await BService.dyCate()).first['title'], '食品');
  });

  testWidgets('category failure still loads featured products and retry restores tabs', (tester) async {
    await tester.pumpWidget(MaterialApp(navigatorKey: app_utils.navigatorKey, home: DyIndexPage()));
    await tester.pumpAndSettle();
    expect(find.text('精选'), findsOneWidget);
    expect(find.text('分类加载失败，当前显示精选商品'), findsOneWidget);
    expect(adapter.listRequests, greaterThan(0));
    expect(tester.takeException(), isNull);

    adapter.categoryFails = false;
    await tester.tap(find.text('重试'));
    await tester.pumpAndSettle();
    expect(find.text('食品'), findsOneWidget);
    expect(find.text('分类加载失败，当前显示精选商品'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
