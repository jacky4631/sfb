import 'dart:io';

abstract class AliFaceVerifyResult {
  abstract final bool isSuccess;
  final String code;

  AliFaceVerifyResult({required this.code});

  static AliFaceVerifyResult fromJson(Map data) {
    if (Platform.isAndroid) {
      return AndroidAliFaceVerifyResult(
          code: data["resultStatus"],
          errorMessage: data["errorMessage"]);
    } else if (Platform.isIOS) {
      return IosAliFaceVerifyResult(code: data["code"], reason: data["reason"]);
    } else {
      throw UnsupportedError(
          "On $Platform, ali_face_verify SDK is not supported");
    }
  }

  String asString();
}

class IosAliFaceVerifyResult extends AliFaceVerifyResult {
  final String? reason;

  @override
  bool get isSuccess => code == "1000";

  IosAliFaceVerifyResult({required super.code, this.reason});

  @override
  String asString() {
    return "{\"code\": $code,\"reason\": $reason}";
  }
}

class AndroidAliFaceVerifyResult extends AliFaceVerifyResult {
  final String? errorMessage;

  @override
  bool get isSuccess => code == "9000";

  AndroidAliFaceVerifyResult(
      {required super.code, this.errorMessage});
  @override
  String asString() {
    return "{\"code\": $code,\"errorMessage\": $errorMessage}";
  }
}
