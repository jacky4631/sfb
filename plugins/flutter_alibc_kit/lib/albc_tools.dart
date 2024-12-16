///
 /// @Description: 工具类
 /// @Author: wuxing
 /// @Date: 2019-09-06 22:51:22
 /// @LastEditors: wuxing
 /// @LastEditTime: 2019-09-06 22:52:48
 ///

import 'alibc_const_key.dart';
import 'alibc_model.dart';

class AlibcTools {
  // -------------------------------------------//
// --------这里是工具类，不要从这获取-------------//
// -------------------------------------------//

  // 获取返回数据
  static TradeResult getTradeResult(Map result) {
    // 如果失败
    if (result[AlibcConstKey.errorCode] != "0") {
      return TradeResult(
        result[AlibcConstKey.errorCode],
        result[AlibcConstKey.errorMessage],
      );
    }

    // 判断类型
    if (result[AlibcConstKey.data]["type"] ==
        TradeResultType.AlibcTradeResultTypePaySuccess) {
      // 付款成功
      return TradeResult(
          result[AlibcConstKey.errorCode], result[AlibcConstKey.errorMessage],
          type: TradeResultType.AlibcTradeResultTypePaySuccess,
          payResult: PayResult(
            result[AlibcConstKey.data]["paySuccessOrders"],
            result[AlibcConstKey.data]["payFailedOrders"],
          ));
    } else {
      // 添加购物车成功
      return TradeResult(
        result[AlibcConstKey.errorCode],
        result[AlibcConstKey.errorMessage],
        type: TradeResultType.AlibcTradeResultTypeAddCard,
      );
    }
  }

// 设置淘宝客数据
  static Map? getTaokeMap(TaokeParams? taokeParams) {
    Map? taoKe;
    if (taokeParams != null) {
      taoKe = {
        "adzoneId": taokeParams.adzoneId ?? "",
        "pid": taokeParams.pid ?? "",
        "unionId": taokeParams.unionId ?? "",
        "subPid": taokeParams.subPid ?? "",
        "extParams": taokeParams.extParams ?? {}
      };
    }
    return taoKe;
  }
}
