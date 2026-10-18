import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/me/model/app_info.dart';

void main() {
  test('extracts CID from complete address and builds activity on configured host', () {
    final info = AppInfo()..kuCid = 'http://jkj.mailvor.com/?cid=FazG6352';
    expect(info.cmsCid, 'FazG6352');
    final activity = Uri.parse(info.cmsActivityUrl('dy_special')!);
    expect(activity.host, 'jkj.mailvor.com');
    expect(activity.scheme, 'http');
    expect(activity.queryParameters['cid'], 'FazG6352');
    expect(activity.queryParameters['code'], 'FazG6352');
    expect(activity.queryParameters['tmp'], 'dy_special');
    expect(activity.fragment, '/sp');
  });

  test('keeps configured path and extra query values', () {
    final info = AppInfo()..kuCid = 'https://shop.example.com/cms/?from=app&cid=test123#/';
    final activity = Uri.parse(info.cmsActivityUrl('special')!);
    expect(activity.path, '/cms/');
    expect(activity.queryParameters['from'], 'app');
    expect(activity.queryParameters['cid'], 'test123');
  });

  test('missing or legacy CID-only configuration does not produce a broken URL', () {
    for (final value in ['', 'FazG6352', 'https://example.com/']) {
      final info = AppInfo()..kuCid = value;
      expect(info.cmsCid, '');
      expect(info.cmsActivityUrl('special'), isNull);
    }
  });
}
