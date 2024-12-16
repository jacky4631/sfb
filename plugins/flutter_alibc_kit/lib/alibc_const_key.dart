import 'package:collection/collection.dart' show IterableExtension;

///
/// @Author: 无星
/// @Date: 2019-08-30 15:55:44
/// @Last Modified by: 无星
/// @Last Modified time: 2019-08-30 17:17:07
///

class AlibcConstKey {
  // 错误码
  static String errorCode = "errorCode";
  // 错误信息
  static String errorMessage = "errorMessage";
  // 平台，iOS为iOS，Android为Android
  static String platform = "platform";
  // result
  static String data = "data";

  static String platform_ios = "iOS";
  static String platform_andriod = "andriod";
}

///  成功支付
///  成功添加到购物车
enum TradeResultType {
  AlibcTradeResultTypePaySuccess,
  AlibcTradeResultTypeAddCard
}

///  智能判断
///  强制拉端(手淘/天猫)
enum AlibcOpenType { AlibcOpenTypeAuto, AlibcOpenTypeNative }

//  拉起手淘失败后的处理策略

//  - AlibcNativeFailModeJumpH5: 当拉起手淘/天猫失败, 则在 webview 中跳转对应 H5 页面; 默认选项
//  - AlibcNativeFailModeJumpDownloadPage: 当拉起手淘/天猫失败, 则跳转对应 App 下载页面
//  - AlibcNativeFailModeNone: 当拉起手淘/天猫失败, 不做额外操作
enum AlibcNativeFailMode {
  AlibcNativeFailModeJumpH5,
  AlibcNativeFailModeJumpDownloadPage,
  AlibcNativeFailModeNone
}
// 天猫
// 淘宝
enum AlibcSchemeType { AlibcSchemeTmall, AlibcSchemeTaoBao }

enum CallBackType {
  AlibcTaobaoLogin,
  AlibcTaokeLogin,
  AlibcTaokeLoginForCode,
  AlibcOpenURL,
  AlibcOpenCar,
  AlibcOpenDetail,
  AlibcOpenShop
}

T? enumFromString<T>(Iterable<T> values, String value) {
  return values
      .firstWhereOrNull((type) => type.toString().split('.').last == value);
}
