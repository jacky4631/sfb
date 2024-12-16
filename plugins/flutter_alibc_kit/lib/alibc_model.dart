// 初始化阿里百川的model
import 'alibc_const_key.dart';

class InitModel {
  // 错误码
  String? errorCode;
  // 错误信息
  String? errorMessage;

  InitModel(this.errorCode, this.errorMessage);

  InitModel.fromJson(Map<String, dynamic> map) {
    this.errorCode = map['errorCode'];
    this.errorMessage = map['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    var data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class LoginModel {
  // 错误码
  String? errorCode;
  // 错误信息
  String? errorMessage;

  UserModel? data;

  LoginModel(this.errorCode, this.errorMessage, {this.data});

  LoginModel.fromJson(Map<String, dynamic> map) {
    this.errorCode = map['errorCode'];
    this.errorMessage = map['errorMessage'];
    this.data = map['data'];
  }

  Map<String, dynamic> toJson() {
    var data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['data'] = this.data;
    return data;
  }
}

// 用户信息
class UserModel {
  // 用户昵称
  final String? nick;
  // 头像地址
  final String? avatarUrl;
  final String? openId;
  final String? openSid;
  final String? topAccessToken;
  final String? topAuthCode;
  UserModel(this.nick, this.avatarUrl, this.openId, this.openSid,
      this.topAccessToken, this.topAuthCode);
}

// 淘宝客的参数
class TaokeParams {
  //有adzoneId则pid失效
  String? adzoneId;
  String? pid;
  String? unionId;
  String? subPid;
  Map? extParams;
  TaokeParams(
      {this.adzoneId, this.pid, this.unionId, this.subPid, this.extParams});
}

// url打开或者page打开等的数据
class TradeResult {
  // 错误码,0为成功，非0为失败
  final String? errorCode;
  // 错误信息
  final String? errorMessage;

  TradeResultType? type;

  PayResult? payResult;
  // AddCardResult addCardResult;
  // Android没有，所以去掉
  // TradeFailResult tradeFailResult;

  TradeResult(
    this.errorCode,
    this.errorMessage, {
    this.type,
    this.payResult,
    // this.tradeFailResult,
  });
}

// 付款成功的result
class PayResult {
  // 支付成功的订单
  final List<String>? paySuccessOrders;
  // 支付失败的订单
  final List<String>? payFailedOrders;

  PayResult(this.paySuccessOrders, this.payFailedOrders);
}

// 添加购物车成功的result
// 因为没什么好返回的，所以不写
// class AddCardResult {}

// 失败，Android没有，所以去掉
// class TradeFailResult {
//   // 失败的订单list
//   final List<String> orderIdList;

//   TradeFailResult(this.orderIdList);
// }

// class TaoKeParams {
//   // 淘客ID
//   final String pid;
//   // 不知道什么id
//   final String subPid;
//   // 不知道什么id
//   final String unionId;

//   TaoKeParams(this.pid, this.subPid, this.unionId);
// }

// class TradeResult {
//   // 是否成功
//   final int openResultCode;
//   // 平台
//   final String platform;
//   // // 是否成功
//   // final bool isSuccessful;
//   // errorCode
//   final int errorCode;
//   //  错误信息
//   final String errorMessage;
//   // 打开配型
//   final TradeResultType tradeResultType;
//   // 成功付款商品
//   final List<String> paySuccessOrders;
//   // 付款失败商品
//   final List<String> payFailedOrders;

//   TradeResult({
//       this.openResultCode,
//       this.platform,
//       // this.isSuccessful,
//       this.errorCode,
//       this.errorMessage,
//       this.tradeResultType,
//       this.paySuccessOrders,
//       this.payFailedOrders
//       });
// }
