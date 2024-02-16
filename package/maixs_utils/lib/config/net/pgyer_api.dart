import 'dart:developer';
import 'dart:convert' as convert;
import 'Config.dart';
import 'api.dart';
import 'package:encrypt/encrypt.dart' as XYQ;

final Http http = Http();

///加密链接
var noEncryptedLink = [];

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = Config.BaseUrl;
    // interceptors.add(PgyerApiInterceptor());
  }
}

class ResponseData extends BaseResponseData {
  final RequestOptions options;
  bool get success => code == 'success';

  ResponseData.fromJson(Map<String, dynamic> json, this.options) {
    if (json != null) {
      code = json['resultCode'];
      message = json['resultMsg'];
      data = json['result'];
      if (data is Map) {
        formatDouble(data);
      } else if (data is List) {
        (data as List).forEach((f) => formatDouble(f));
      }
    }
    try {
      var str = options.path.split('/').last;
      log(convert.json.encode(json), name: '接口：${str.substring(0, str.indexOf('?'))}/请求响应');
      try {
        log(convert.json.encode(json['result']['data'][0]), name: '接口：${str.substring(0, str.indexOf('?'))}/序列1的对象');
      } catch (e) {
        // log('暂无序列1', name: '接口：${str.substring(0, str.indexOf('?'))}/序列1的对象');
      } finally {
        log('\n\n', name: '换行');
      }
    } catch (e) {
      var str = options.path.split('/').last;
      log(convert.json.encode(json), name: '接口：$str/请求响应');
      try {
        log(convert.json.encode(json['result']['data'][0]), name: '接口：$str/序列1的对象');
      } catch (e) {
        // log('暂无序列1', name: '接口：$str/序列1的对象');
      } finally {
        log('\n\n', name: '换行');
      }
    }
  }
}

formatDouble(Map data) {
  data.keys.forEach((f) => {if (data[f] is double) data[f] = double.parse((data[f] as double).toStringAsFixed(2))});
}

/// 加密
String encryptedFun(data) {
  // aes(data)  AES加密
  final key = XYQ.Key.fromUtf8('Vw7biYp1h1GwTu3N');
  final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
  final encrypted = encrypter.encrypt(data.toString(), iv: XYQ.IV.fromLength(16));
  return encrypted.base64;
}

/// 解密
String decryptedFun(data) {
  final key = XYQ.Key.fromUtf8('Vw7biYp1h1GwTu3N');
  final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
  // final encrypted = encrypter.encrypt(data, iv: XYQ.IV.fromLength(16));
  final decrypted = encrypter.decrypt(XYQ.Encrypted.fromBase64(data), iv: XYQ.IV.fromLength(16));
  return decrypted;
}
