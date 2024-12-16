import 'package:flutter_ali_face_verify/flutter_ali_face_verify.dart';

import 'flutter_ali_face_verify_platform_interface.dart';

class FlutterAliFaceVerify {

  /// 建议开发者在 App 运行初期尽早调用初始化代码，如隐私政策同意后的最早期。
  Future<bool> initService() {
    return FlutterAliFaceVerifyPlatform.instance.initService();
  }

  /// 数据字段映射参考官方文档，目前应该只能支持基本类型。
  /// page_url在不同平台上可能不一样。具体需要自己研究，比如在Android可能是url。
  /// bizCode只在Android上有用。
  Future<AliFaceVerifyResult> startService(
      {required String certifyId, BizCode? bizCode,Map<String, String> extParams = const {}}) {
    Map<String,String> param = {};
    if(bizCode != null){
      param["bizCode"] = bizCode.value;
    }
    param.addAll(extParams);
    return FlutterAliFaceVerifyPlatform.instance
        .startService(certifyId: certifyId, extParams: param);
  }
}
