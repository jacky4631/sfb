class TaobaoAuthError {
  static const missingToken = '请先在淘宝完成实名认证后再授权。';
  static const fallback = '授权失败';

  static String? _specific(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || const ['null', '操作失败', '授权失败', '请求失败'].contains(text)
        ? null
        : text;
  }

  static String response(Map? data) {
    for (final key in ['subMessage', 'subMsg', 'sub_msg', 'msg', 'message']) {
      final text = _specific(data?[key]);
      if (text != null) return text;
    }
    return fallback;
  }

  static String sdk(String? message, String? code) =>
      _specific(message) ?? fallback;
}
