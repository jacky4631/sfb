#import "FlutterAliFaceVerifyPlugin.h"
#import <AlipayVerifySDK/MPVerifySDKService.h>

__weak FlutterAliFaceVerifyPlugin* __flutterAliFaceVerifyPlugin;

@interface FlutterAliFaceVerifyPlugin()

@property (readwrite,copy,nonatomic) FlutterResult callback;

@end

@implementation FlutterAliFaceVerifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"club.openflutter/flutter_ali_face_verify"
            binaryMessenger:[registrar messenger]];
  FlutterAliFaceVerifyPlugin* instance = [[FlutterAliFaceVerifyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initService" isEqualToString:call.method]) {
    [MPVerifySDKService initSDKService];
    result(@YES);
  } else if ([@"startService" isEqualToString:call.method]) {
      self.callback = result;
      UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
      //certifyId
      NSString *certifyId = (call.arguments[@"certifyId"] == (id) [NSNull null]) ? nil : call.arguments[@"certifyId"];
      __weak FlutterAliFaceVerifyPlugin* __self = self;
      NSDictionary *extParams = call.arguments[@"extParams"];
//    NSString *result = [NSString stringWithFormat:@"结果：code: %@, reason: %@, retCodeSub = %lu, retMessageSub = %@", @(response.code), response.reason, (unsigned long)response.retCode, response.retMessageSub];

      [[MPVerifySDKService sharedInstance] verifyWith:certifyId currentCtr:rootViewController extParams:extParams onCompletion:^(ZIMResponse *response) {
          NSMutableDictionary *mDictionary = [NSMutableDictionary dictionary];
          
          
          [mDictionary setObject:[NSString stringWithFormat:@"%@", @(response.code)] forKey:@"code"];
          [mDictionary setValue:response.reason forKey:@"reason"];
          
          [__self onStartServiceReceived:mDictionary];

      }];
  }else {
      result(FlutterMethodNotImplemented);
  }
}

-(void)onStartServiceReceived:(NSDictionary*)resultDic{

    if(self.callback!=nil){
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        self.callback(mutableDictionary);
        self.callback = nil;
    }
    
}

@end
