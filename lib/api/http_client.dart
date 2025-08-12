import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/utils/logger_util.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late Dio _dio;

  // API配置
  final String baseUrl = 'https://openapi.dataoke.com/api';
  final String appKey = '5ce9171d31c89'; // 替换为你的appKey
  final String appSecret = '6ee86bf8d3795dfa48d48d6125532517'; // 替换为你的appSecret

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加日志拦截器
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }

    // 添加验签拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 生成验签参数
        String nonce = _generateNonce();
        String timestamp = _getTimestamp();
        String signature = _generateSignature(nonce, timestamp);

        // 添加公共参数
        options.queryParameters.addAll({
          'appKey': appKey,
          'nonce': nonce,
          'timer': timestamp,
          'signRan': signature,
          'version': 'v2.1.2',
        });

        return handler.next(options);
      },
    ));
  }

  // 生成6位随机数
  String _generateNonce() {
    return (100000 + DateTime.now().microsecond % 900000).toString();
  }

  // 获取毫秒级时间戳
  String _getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // 生成签名
  String _generateSignature(String nonce, String timestamp) {
    // 按照文档要求拼接字符串：appKey=xxx&timer=xxx&nonce=xxx&key=xxx
    String signStr = 'appKey=$appKey&timer=$timestamp&nonce=$nonce&key=$appSecret';

    // MD5加密并转大写
    var content = const Utf8Encoder().convert(signStr);
    var digest = md5.convert(content);
    return digest.toString().toUpperCase();
  }

  // 发送GET请求
  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    try {
      // 发送请求 (验签参数由拦截器自动添加)
      Response response = await _dio.get(
        path,
        queryParameters: params,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 发送POST请求
  Future<dynamic> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) async {
    try {
      // 发送请求 (验签参数由拦截器自动添加)
      Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 获取商品列表示例方法
  Future<dynamic> getGoodsList({String keyWords = '', int sort = 0, String pageId = '1', int pageSize = 20}) async {
    Log.e(keyWords);

    return await get('/goods/get-dtk-search-goods', params: {
      'keyWords': keyWords,
      'sort': sort,
      'pageId': pageId,
      'pageSize': pageSize,
    });
  }
}
