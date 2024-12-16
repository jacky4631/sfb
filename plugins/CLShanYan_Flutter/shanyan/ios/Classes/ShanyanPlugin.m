#import "ShanyanPlugin.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
#import <AVFoundation/AVFoundation.h>
//Helpers
#import "CLShanYanCustomViewHelper.h"
#import "UIView+CLShanYanWidget.h"
#import "NSNumber+shanyanCategory.h"
#import "PlayerView.h"

@interface ShanyanPlugin ()<CLShanYanSDKManagerDelegate>
@property (nonatomic,strong)id notifObserver;

@property(nonatomic,strong)NSObject<FlutterPluginRegistrar>*registrar;

@property(nonatomic,strong)FlutterMethodChannel* channel;
@end

@implementation ShanyanPlugin

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_notifObserver];
    _notifObserver = nil;
}



+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"shanyan"
                                     binaryMessenger:[registrar messenger]];
    ShanyanPlugin* instance = [[ShanyanPlugin alloc] init];
    instance.channel = channel;
    instance.registrar = registrar;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"init" isEqualToString:call.method]){
        [self init:call complete:result];
    }else if ([@"getPhoneInfo" isEqualToString:call.method]){
        [self preGetPhonenumber:result];
    }else if ([@"openLoginAuth" isEqualToString:call.method]){
        [self quickAuthLoginWithConfigure:call.arguments complete:result];
    }else if ([@"setActionListener" isEqualToString:call.method]){
        [self setActionListener];
    }else if ([@"startAuthentication" isEqualToString:call.method]){
        [self startAuthentication:result];
    }else if ([@"finishAuthControllerCompletion" isEqualToString:call.method]){
        [self finishAuthControllerCompletion:result];
    }else if ([@"setLoadingVisibility" isEqualToString:call.method]){
        [self setLoadingVisibility:call];
    }else if ([@"setCheckBoxValue" isEqualToString:call.method]){
        [self setCheckBoxValue:call];
    }else if ([@"clearScripCache" isEqualToString:call.method]){
        [self clearScripCache];
    }else if ([@"performLoginClick" isEqualToString:call.method]){
        [self loginBtnClick];
    }else if ([@"setTimeOutForPreLogin" isEqualToString:call.method]){
        [self setPreGetPhonenumberTimeOut:call];
    }else if ([@"setInitDebug" isEqualToString:call.method]){
        [self printConsoleEnable:call];
    }else if ([@"getIEnable" isEqualToString:call.method]){
        [self getIEnable:call];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)getIEnable:(FlutterMethodCall*)call{
    NSDictionary* argv = call.arguments;
    if (argv != nil && [argv isKindOfClass:[NSDictionary class]]) {
        [CLShanYanSDKManager forbiddenNonessentialIp:![argv[@"iEnable"] boolValue]];
    }
}

- (void)printConsoleEnable:(FlutterMethodCall*)call{
    NSDictionary* argv = call.arguments;
    if (argv != nil && [argv isKindOfClass:[NSDictionary class]]) {
        [CLShanYanSDKManager printConsoleEnable:[argv[@"initDebug"] boolValue]];
    }
}

- (void)setPreGetPhonenumberTimeOut:(FlutterMethodCall*)call{
    NSDictionary* argv = call.arguments;
    if (argv != nil && [argv isKindOfClass:[NSDictionary class]]) {
        [CLShanYanSDKManager setPreGetPhonenumberTimeOut:[argv[@"timeOut"] floatValue]];
    }
}

-(void)loginBtnClick {
    [CLShanYanSDKManager loginBtnClick];
}

- (void)clearScripCache {
    [CLShanYanSDKManager clearScripCache];
}

- (void)setCheckBoxValue:(FlutterMethodCall*)call{
    NSDictionary* argv = call.arguments;
    if (argv != nil && [argv isKindOfClass:[NSDictionary class]]) {
        [CLShanYanSDKManager setCheckBoxValue:[argv[@"isChecked"] boolValue]];
    }
}
- (void)setLoadingVisibility:(FlutterMethodCall*)call {
    NSDictionary* argv = call.arguments;
    if (argv != nil && [argv isKindOfClass:[NSDictionary class]] && [argv[@"visibility"] boolValue] == NO) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CLShanYanSDKManager hideLoading];
        });
    }
}

-(void)setActionListener{
    [CLShanYanSDKManager setCLShanYanSDKManagerDelegate:self];
}
#pragma mark - CLShanYanSDKManagerDelegate
-(void)clShanYanActionListener:(NSInteger)type code:(NSInteger)code  message:(NSString *_Nullable)message{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    result[@"type"] = @(type);
    result[@"code"] = @(code);
    result[@"message"] = message;
    if (self.channel) {
        [self.channel invokeMethod:@"onReceiveAuthEvent" arguments:result];
    }
}

-(void)clShanYanSDKManagerAuthPageAfterViewDidLoad:(UIView *_Nonnull)authPageView currentTelecom:(NSString *_Nullable)telecom {
    [authPageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)init:(FlutterMethodCall*)call complete:(FlutterResult)complete{
    NSDictionary * argv = call.arguments;
    if (argv == nil || ![argv isKindOfClass:[NSDictionary class]]) {
        if (complete) {
            NSMutableDictionary * result = [NSMutableDictionary new];
            result[@"code"] = @(1001);
            result[@"message"] = @"请设置参数";
            complete(result);
        }
        return;
    }
    
    NSString * appId = argv[@"appId"];
    
    [CLShanYanSDKManager initWithAppId:appId complete:^(CLCompleteResult * _Nonnull completeResult) {
        
        if (complete) {
            complete([ShanyanPlugin completeResultToJson:completeResult]);
        }
    }];
}

- (void)preGetPhonenumber:(FlutterResult)complete{
    
    [CLShanYanSDKManager preGetPhonenumber:^(CLCompleteResult * _Nonnull completeResult) {
        if (complete) {
            complete([ShanyanPlugin completeResultToJson:completeResult]);
        }
    }];
}

-(void)quickAuthLoginWithConfigure:(NSDictionary *)clUIConfigure complete:(FlutterResult)complete{
    
    CLUIConfigure * baseUIConfigure = [self configureWithConfig:clUIConfigure];
    baseUIConfigure.viewController = [self findVisibleVC];
    
    __weak typeof(self) weakSelf = self;
    
    [CLShanYanSDKManager setCLShanYanSDKManagerDelegate:self];
    [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {
        if (complete) {
            complete([ShanyanPlugin completeResultToJson:completeResult]);
        }
        
    } oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        //一键登录回调
        if (strongSelf.channel) {
            [strongSelf.channel invokeMethod:@"onReceiveAuthPageEvent" arguments:[ShanyanPlugin completeResultToJson:completeResult]];
        }
    }];
}

+(NSString * )dictToJson:(NSDictionary *)input{
    NSError *error = nil;
    NSData *jsonData = nil;
    if (!input) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [input enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyString = nil;
        NSString *valueString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = key;
        }else{
            keyString = [NSString stringWithFormat:@"%@",key];
        }
        
        if ([obj isKindOfClass:[NSString class]]) {
            valueString = obj;
        }else{
            valueString = [NSString stringWithFormat:@"%@",obj];
        }
        
        [dict setObject:valueString forKey:keyString];
    }];
    jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] == 0 || error != nil) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

- (void)tap{ }
+ (UIFont *)fontWithSize:(NSNumber *)size blod:(NSNumber *)isBlod name:(NSString *)name{
    if (size == nil) {
        return nil;
    }
    //    NSString * fontName = @"PingFang-SC-Medium";
    //    if (name) {
    //        fontName = fontName;
    //    }
    BOOL blod = isBlod!=nil ? isBlod.boolValue : false;
    if (blod) {
        return [UIFont boldSystemFontOfSize:size.floatValue];
    }else{
        return [UIFont systemFontOfSize:size.floatValue];
    }
}

+ (UIColor *)colorWithHexStr:(NSString *)hexString {
    if (hexString == nil) {
        return nil;
    }
    if (![hexString isKindOfClass:NSString.class]) {
        return nil;
    }
    if (hexString.length == 0) {
        return nil;
    }
    @try {
        NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
        CGFloat alpha, red, blue, green;
        switch ([colorString length]) {
            case 3: // #RGB
                alpha = 1.0f;
                red   = [self colorComponentFrom: colorString start: 0 length: 1];
                green = [self colorComponentFrom: colorString start: 1 length: 1];
                blue  = [self colorComponentFrom: colorString start: 2 length: 1];
                break;
            case 4: // #ARGB
                alpha = [self colorComponentFrom: colorString start: 0 length: 1];
                red   = [self colorComponentFrom: colorString start: 1 length: 1];
                green = [self colorComponentFrom: colorString start: 2 length: 1];
                blue  = [self colorComponentFrom: colorString start: 3 length: 1];
                break;
            case 6: // #RRGGBB
                alpha = 1.0f;
                red   = [self colorComponentFrom: colorString start: 0 length: 2];
                green = [self colorComponentFrom: colorString start: 2 length: 2];
                blue  = [self colorComponentFrom: colorString start: 4 length: 2];
                break;
            case 8: // #AARRGGBB
                alpha = [self colorComponentFrom: colorString start: 0 length: 2];
                red   = [self colorComponentFrom: colorString start: 2 length: 2];
                green = [self colorComponentFrom: colorString start: 4 length: 2];
                blue  = [self colorComponentFrom: colorString start: 6 length: 2];
                break;
            default:
                return nil;
                break;
        }
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    } @catch (NSException *exception) {
        return UIColor.whiteColor;
    }
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

/**
 *int code; //返回码
 String message; //描述
 String innerCode; //内层返回码
 String innerDesc; //内层事件描述
 String token; //token
 */
+(NSDictionary *)completeResultToJson:(CLCompleteResult *)completeResult{
    NSMutableDictionary * result = [NSMutableDictionary new];
    if (completeResult.error != nil) {
        result[@"code"] = @(completeResult.code);
        result[@"message"] = completeResult.message;
        if (completeResult.innerCode != 0) {
            result[@"innerCode"] = @(completeResult.innerCode);
        }
        if ([completeResult.innerDesc isKindOfClass:NSString.class] && completeResult.innerDesc.length > 0) {
            result[@"innerDesc"] = completeResult.innerDesc;
        }
    }else{
        result[@"code"] = @(1000);
        result[@"message"] = completeResult.message;
        if (completeResult.innerCode != 0) {
            result[@"innerCode"] = @(completeResult.innerCode);
        }
        if ([completeResult.innerDesc isKindOfClass:NSString.class] && completeResult.innerDesc.length > 0) {
            result[@"innerDesc"] = completeResult.innerDesc;
        }
        if ([completeResult.data isKindOfClass:NSDictionary.class] && completeResult.data.count > 0) {
            result[@"token"] = completeResult.data[@"token"];
        }
    }
    return result;
}

-(NSString * )assetPathWithConfig:(NSString *)configureDicPath{
    NSString * key = [self.registrar lookupKeyForAsset:configureDicPath];
    NSString * path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
    if (path == nil) {
        path = @"";
    }
    return path;
}

-(CLUIConfigure *)configureWithConfig:(NSDictionary *)configureDic{
    CLUIConfigure * baseConfigure = [CLUIConfigure new];
    
    @try {
        NSNumber * isFinish = configureDic[@"isFinish"];
        {
            baseConfigure.manualDismiss = isFinish;
        }
        
        NSString * clBackgroundImg = configureDic[@"setAuthBGImgPath"];
        NSString * clBackgroundVedio = configureDic[@"setAuthBGVedioPath"];
        if (clBackgroundImg && (!clBackgroundVedio || clBackgroundVedio.length<1)) {
            baseConfigure.clBackgroundImg = [UIImage imageNamed:clBackgroundImg];
        }
        NSNumber * setPreferredStatusBarStyle = configureDic[@"setPreferredStatusBarStyle"];
        {
            if (setPreferredStatusBarStyle!=nil) {
                switch (setPreferredStatusBarStyle.intValue) {
                    case 0: default:
                        baseConfigure.clPreferredStatusBarStyle = @(UIStatusBarStyleDefault);
                        break;
                    case 1:
                        baseConfigure.clPreferredStatusBarStyle = @(UIStatusBarStyleLightContent);
                        break;
                    case 2:
                        if (@available(iOS 13.0, *)) {
                            baseConfigure.clPreferredStatusBarStyle = @(UIStatusBarStyleDarkContent);
                        }
                        break;
                }
            }
        };
        NSNumber * setStatusBarHidden = configureDic[@"setStatusBarHidden"];
        {
            baseConfigure.clPrefersStatusBarHidden = setStatusBarHidden;
        }
        NSNumber * setAuthNavHidden = configureDic[@"setAuthNavHidden"];
        {
            baseConfigure.clNavigationBarHidden = setAuthNavHidden;
        }
        NSNumber * setNavigationBarStyle = configureDic[@"setNavigationBarStyle"];
        {
            if (setNavigationBarStyle!=nil) {
                switch (setNavigationBarStyle.intValue) {
                    case 0: default:
                        baseConfigure.clNavigationBarStyle = @(UIBarStyleDefault);
                        break;
                    case 1:
                        baseConfigure.clNavigationBarStyle = @(UIBarStyleBlack);
                        break;
                }
            }
        };
        
        NSNumber * setAuthNavTransparent = configureDic[@"setAuthNavTransparent"];
        {
            baseConfigure.clNavigationBackgroundClear = setAuthNavTransparent;
        }
        
        NSString * setNavText = configureDic[@"setNavText"];
        NSString * setNavTextColor = configureDic[@"setNavTextColor"];
        NSNumber * setNavTextSize = configureDic[@"setNavTextSize"];
        if (setNavText) {
            NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
            if (setNavTextColor != nil) {
                attributes[NSForegroundColorAttributeName] = [ShanyanPlugin colorWithHexStr:setNavTextColor];
            }
            if (setNavTextSize != nil) {
                attributes[NSFontAttributeName] = [UIFont systemFontOfSize:setNavTextSize.floatValue];
            }
            baseConfigure.clNavigationAttributesTitleText = [[NSAttributedString alloc]initWithString:setNavText attributes:attributes];
        }
        
        // UIBarButtonItem * clNavigationRightControl;
        // UIBarButtonItem * clNavigationLeftControl;
        
        NSString   * clNavigationBackBtnImage = configureDic[@"setNavReturnImgPath"];
        if (clNavigationBackBtnImage) {
            baseConfigure.clNavigationBackBtnImage = [UIImage imageNamed:clNavigationBackBtnImage];
        }
        
        NSNumber  * clNavigationBackBtnHidden = configureDic[@"setNavReturnImgHidden"];
        {
            baseConfigure.clNavigationBackBtnHidden = clNavigationBackBtnHidden;
        }
        // NSValue * clNavBackBtnImageInsets;
        NSNumber * clNavBackBtnAlimentRight = configureDic[@"setNavBackBtnAlimentRight"];
        {
            baseConfigure.clNavBackBtnAlimentRight = clNavBackBtnAlimentRight;
        };;
        NSNumber * clNavigationBottomLineHidden = configureDic[@"setNavigationBottomLineHidden"];
        {
            baseConfigure.clNavigationBottomLineHidden = clNavigationBottomLineHidden;
        }
        NSString  * clNavigationTintColor  = configureDic[@"setNavigationTintColor"];;
        {
            if (clNavigationTintColor ){ baseConfigure.clNavigationTintColor = [ShanyanPlugin colorWithHexStr:clNavigationTintColor];
            }
        };
        NSString  * clNavigationBarTintColor = configureDic[@"setNavigationBarTintColor"];;
        {
            if (clNavigationBarTintColor) {
                baseConfigure.clNavigationBarTintColor = [ShanyanPlugin colorWithHexStr:clNavigationBarTintColor];
            }
        };
        NSString  * clNavigationBackgroundImage = configureDic[@"setNavigationBackgroundImage"];
        if (clNavigationBackgroundImage) {
            baseConfigure.clNavigationBackgroundImage = [UIImage imageNamed:clNavigationBackgroundImage];
        }
        NSNumber * clNavigationBarMetrics = configureDic[@"setNavigationBarMetrics"];
        {
            baseConfigure.clNavigationBarMetrics = clNavigationBarMetrics;
        };
        NSString  * clNavigationShadowImage = configureDic[@"setNavigationShadowImage"];
        if (clNavigationShadowImage) {
            baseConfigure.clNavigationShadowImage = [UIImage imageNamed:clNavigationShadowImage];
        }
        
        /**Logo*/
        NSString * clLogoImage = configureDic[@"setLogoImgPath"];
        if (clLogoImage) {
            baseConfigure.clLogoImage = [UIImage imageNamed:clLogoImage];
        }
        NSNumber * clLogoCornerRadius = configureDic[@"setLogoCornerRadius"];
        {
            baseConfigure.clLogoCornerRadius = clLogoCornerRadius;
        };
        NSNumber * clLogoHiden  = configureDic[@"setLogoHidden"];
        {
            baseConfigure.clLogoHiden = clLogoHiden;
        };
        
        NSString  * clPhoneNumberColor  = configureDic[@"setNumberColor"];;
        {
            if (clPhoneNumberColor) {
                baseConfigure.clPhoneNumberColor = [ShanyanPlugin colorWithHexStr:clPhoneNumberColor];
            }
        };
        
        NSNumber   * clPhoneNumberFont = configureDic[@"setNumberSize"];
        NSNumber * setNumberBold = configureDic[@"setNumberBold"];
        {
            if (clPhoneNumberFont!=nil) {
                baseConfigure.clPhoneNumberFont = [ShanyanPlugin fontWithSize:clPhoneNumberFont blod:setNumberBold name:nil];
            }
        };
        NSNumber * clPhoneNumberTextAlignment = configureDic[@"clPhoneNumberTextAlignment"];
        {
            //0: center 1: left 2: right
            if (clPhoneNumberTextAlignment!=nil) {
                switch (clPhoneNumberTextAlignment.integerValue) {
                    case 0:default:
                        baseConfigure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
                        break;
                    case 1:
                        baseConfigure.clPhoneNumberTextAlignment = @(NSTextAlignmentLeft);
                        break;
                    case 2:
                        baseConfigure.clPhoneNumberTextAlignment = @(NSTextAlignmentRight);
                        break;
                }
            }
        };
        
        /**按钮文字*/
        NSString   * clLoginBtnText = configureDic[@"setLogBtnText"];
        {
            baseConfigure.clLoginBtnText = clLoginBtnText;
        }
        /**按钮文字颜色*/
        NSString  * clLoginBtnTextColor = configureDic[@"setLogBtnTextColor"];;
        {
            if (clLoginBtnTextColor) {
                baseConfigure.clLoginBtnTextColor = [ShanyanPlugin colorWithHexStr:clLoginBtnTextColor];
            }
        }
        NSNumber   * setLoginBtnTextSize = configureDic[@"setLoginBtnTextSize"];
        NSNumber * setLoginBtnTextBold = configureDic[@"setLoginBtnTextBold"];
        {
            if (setLoginBtnTextSize!=nil) {
                baseConfigure.clLoginBtnTextFont = [ShanyanPlugin fontWithSize:setLoginBtnTextSize blod:setLoginBtnTextBold name:nil];
            }
        }
        /**按钮背景颜色*/
        NSString  * clLoginBtnBgColor = configureDic[@"setLoginBtnBgColor"];;
        {
            if (clLoginBtnBgColor) {
                baseConfigure.clLoginBtnBgColor = [ShanyanPlugin colorWithHexStr:clLoginBtnBgColor];
            }
        }
        
        /**按钮背景图片*/
        NSString  * clLoginBtnNormalBgImage = configureDic[@"setLoginBtnNormalBgImage"];
        if (clLoginBtnNormalBgImage) {
            baseConfigure.clLoginBtnNormalBgImage = [UIImage imageNamed:clLoginBtnNormalBgImage];
        }
        /**按钮背景高亮图片*/
        NSString  * clLoginBtnHightLightBgImage = configureDic[@"setLoginBtnHightLightBgImage"];
        if (clLoginBtnHightLightBgImage) {
            baseConfigure.clLoginBtnDisabledBgImage = [UIImage imageNamed:clLoginBtnHightLightBgImage];
        }
        /**按钮边框颜色*/
        NSString  * clLoginBtnBorderColor = configureDic[@"setLoginBtnBorderColor"];;
        {
            if (clLoginBtnBorderColor) {
                baseConfigure.clLoginBtnBgColor = [ShanyanPlugin colorWithHexStr:clLoginBtnBorderColor];
            }
        };
        /**按钮圆角 CGFloat eg.@(5)*/
        NSNumber * clLoginBtnCornerRadius = configureDic[@"setLoginBtnCornerRadius"];
        {
            baseConfigure.clLoginBtnCornerRadius = clLoginBtnCornerRadius;
        }
        /**按钮边框 CGFloat eg.@(2.0)*/
        NSNumber * clLoginBtnBorderWidth = configureDic[@"setLoginBtnBorderWidth"];;
        {
            baseConfigure.clLoginBtnBorderWidth = clLoginBtnBorderWidth;
        }
        /*隐私条款Privacy
         注： 运营商隐私条款 不得隐藏
         用户条款不限制
         **/
        /**隐私条款名称颜色：@[基础文字颜色UIColor*,条款颜色UIColor*] eg.@[[UIColor lightGrayColor],[UIColor greenColor]]*/
        NSArray<NSString*> *clAppPrivacyColor = configureDic[@"setAppPrivacyColor"];
        {
            if (clAppPrivacyColor && clAppPrivacyColor.count == 2) {
                NSString * commomTextColors = clAppPrivacyColor.firstObject;
                NSString * appPrivacyColors = clAppPrivacyColor.lastObject;
                
                if (commomTextColors && appPrivacyColors) {
                    UIColor * commomTextColor = [ShanyanPlugin colorWithHexStr:commomTextColors];
                    UIColor * appPrivacyColor = [ShanyanPlugin colorWithHexStr:appPrivacyColors];
                    if (commomTextColor && appPrivacyColor) {
                        baseConfigure.clAppPrivacyColor = @[commomTextColor,appPrivacyColor];
                    }
                }
            }
        }
        /**隐私条款文字字体*/
        NSNumber   * setPrivacyTextSize = configureDic[@"setPrivacyTextSize"];
        NSNumber * setPrivacyTextBold = configureDic[@"setPrivacyTextBold"];
        {
            if (setPrivacyTextSize!=nil) {
                baseConfigure.clAppPrivacyTextFont = [ShanyanPlugin fontWithSize:setPrivacyTextSize blod:setPrivacyTextBold name:nil];
            }
        };
        /**隐私条款文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)*/
        NSNumber * clAppPrivacyTextAlignment = configureDic[@"setAppPrivacyTextAlignment"];;
        {
            //0: center 1: left 2: right
            if (clAppPrivacyTextAlignment!=nil) {
                switch (clAppPrivacyTextAlignment.integerValue) {
                    case 0:default:
                        baseConfigure.clAppPrivacyTextAlignment = @(NSTextAlignmentCenter);
                        break;
                    case 1:
                        baseConfigure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
                        break;
                    case 2:
                        baseConfigure.clAppPrivacyTextAlignment = @(NSTextAlignmentRight);
                        break;
                }
            }
            
        };
        /**运营商隐私条款书名号 默认NO 不显示 BOOL eg.@(YES)*/
        NSNumber * clAppPrivacyPunctuationMarks = configureDic[@"setPrivacySmhHidden"];;
        {
            baseConfigure.clAppPrivacyPunctuationMarks = clAppPrivacyPunctuationMarks;
        };
        /**多行时行距 CGFloat eg.@(2.0)*/
        NSNumber* clAppPrivacyLineSpacing = configureDic[@"setAppPrivacyLineSpacing"];;
        {
            baseConfigure.clAppPrivacyLineSpacing = clAppPrivacyLineSpacing;
        };
        //        NSNumber* clAppPrivacyLineFragmentPadding = configureDic[@"setAppPrivacyLineFragmentPadding"];
        //        {
        //            if (clAppPrivacyLineFragmentPadding) {
        //                baseConfigure.clAppPrivacyLineFragmentPadding = clAppPrivacyLineFragmentPadding;
        //            }
        //        }
        /**是否需要sizeToFit,设置后与宽高约束的冲突请自行考虑 BOOL eg.@(YES)*/
        NSNumber* clAppPrivacyNeedSizeToFit = configureDic[@"setAppPrivacyNeedSizeToFit"];;
        {
            baseConfigure.clAppPrivacyNeedSizeToFit = clAppPrivacyNeedSizeToFit;
        };
        /**隐私条款--APP名称简写 默认取CFBundledisplayname 设置描述文本四后此属性无效*/
        NSString  * clAppPrivacyAbbreviatedName = configureDic[@"setAppPrivacyAbbreviatedName"];;
        {
            baseConfigure.clAppPrivacyAbbreviatedName = clAppPrivacyAbbreviatedName;
        };
        /*
         *隐私条款Y一:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
         *@[NSSting,NSURL];
         */
        NSArray * clAppPrivacyFirst = configureDic[@"setAppPrivacyFirst"];
        {
            if (clAppPrivacyFirst && clAppPrivacyFirst.count == 2) {
                NSString * name = clAppPrivacyFirst.firstObject;
                NSString * url = clAppPrivacyFirst.lastObject;
                baseConfigure.clAppPrivacyFirst = @[name,[NSURL URLWithString:url]];
            }
        }
        /*
         *隐私条款二:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
         *@[NSSting,NSURL];
         */
        NSArray * clAppPrivacySecond = configureDic[@"setAppPrivacySecond"];
        {
            if (clAppPrivacySecond && clAppPrivacySecond.count == 2) {
                baseConfigure.clAppPrivacySecond = clAppPrivacySecond;
            }
        };
        /*
         *隐私条款三:需同时设置Name和UrlString eg.@[@"条款一名称",条款一URL]
         *@[NSSting,NSURL];
         */
        NSArray * clAppPrivacyThird = configureDic[@"setAppPrivacyThird"];
        {
            if (clAppPrivacyThird && clAppPrivacyThird.count == 2) {
                baseConfigure.clAppPrivacyThird = clAppPrivacyThird;
            }
        };
        
        
        /*
         隐私协议文本拼接: DesTextFirst+运营商条款+DesTextSecond+隐私条款一+DesTextThird+隐私条款二+DesTextFourth
         **/
        /**描述文本一 default:"同意"*/
        NSString *clAppPrivacyNormalDesTextFirst = configureDic[@"setAppPrivacyNormalDesTextFirst"];;
        {
            baseConfigure.clAppPrivacyNormalDesTextFirst = clAppPrivacyNormalDesTextFirst;
        };;
        /**描述文本二 default:"和"*/
        NSString *clAppPrivacyNormalDesTextSecond = configureDic[@"setAppPrivacyNormalDesTextSecond"];;
        {
            baseConfigure.clAppPrivacyNormalDesTextSecond = clAppPrivacyNormalDesTextSecond;
        };;
        /**描述文本三 default:"、"*/
        NSString *clAppPrivacyNormalDesTextThird = configureDic[@"setAppPrivacyNormalDesTextThird"];;
        {
            baseConfigure.clAppPrivacyNormalDesTextThird = clAppPrivacyNormalDesTextThird;
        };;
        /**描述文本四 default: "并授权AppName使用认证服务"*/
        NSString *clAppPrivacyNormalDesTextFourth = configureDic[@"setAppPrivacyNormalDesTextFourth"];;
        {
            baseConfigure.clAppPrivacyNormalDesTextFourth = clAppPrivacyNormalDesTextFourth;
        };
        
        NSString *clAppPrivacyNormalDesTextLast = configureDic[@"setAppPrivacyNormalDesTextLast"];;
        {
            baseConfigure.clAppPrivacyNormalDesTextLast = clAppPrivacyNormalDesTextLast;
        };
        
        NSNumber * setOperatorPrivacyAtLast = configureDic[@"setOperatorPrivacyAtLast"];
        {
            if (setOperatorPrivacyAtLast!=nil) {
                baseConfigure.clOperatorPrivacyAtLast = setOperatorPrivacyAtLast;
            }
        }
        
        NSArray * morePrivacyArr = configureDic[@"morePrivacy"];
        if(morePrivacyArr && morePrivacyArr.count>0) {
            NSMutableArray *priArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *itemDic in morePrivacyArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
                dic[@"decollator"] = itemDic[@"midStr"]?:@"";
                dic[@"privacyName"] = itemDic[@"name"]?:@"";
                dic[@"privacyURL"] = itemDic[@"url"]?:@"";
                [priArr addObject:dic];
            }
            baseConfigure.clAppMorePrivacyArray = priArr;
        }
        
        NSString *clCheckBoxTipMsg = configureDic[@"setCheckBoxTipMsg"];
        {
            baseConfigure.clCheckBoxTipMsg = clCheckBoxTipMsg;
        };
        NSNumber *setCheckBoxTipDisable = configureDic[@"setCheckBoxTipDisable"];;
        {
            baseConfigure.clCheckBoxTipDisable = setCheckBoxTipDisable;
        };
        
        /**用户隐私协议WEB页面导航栏标题 默认显示用户条款名称*/
        // NSAttributedString * clAppPrivacyWebAttributesTitle;
        /**运营商隐私协议WEB页面导航栏标题 默认显示运营商条款名称*/
        // NSAttributedString * clAppPrivacyWebNormalAttributesTitle;
        
        //        NSString * setPrivacyNavText = configureDic[@"setPrivacyNavText"];
        NSString * setPrivacyNavTextColor = configureDic[@"setPrivacyNavTextColor"];
        NSNumber * setPrivacyNavTextSize = configureDic[@"setPrivacyNavTextSize"];
        {
            NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
            if (setPrivacyNavTextColor != nil) {
                attributes[NSForegroundColorAttributeName] = [ShanyanPlugin colorWithHexStr:setPrivacyNavTextColor];
            }
            if (setPrivacyNavTextSize != nil) {
                attributes[NSFontAttributeName] = [UIFont systemFontOfSize:setPrivacyNavTextSize.floatValue];
            }
            baseConfigure.clAppPrivacyWebAttributes = attributes;
        }
        
        
        /**隐私协议WEB页面导航返回按钮图片*/
        NSString * clAppPrivacyWebBackBtnImage = configureDic[@"setPrivacyNavReturnImgPath"];
        if (clAppPrivacyWebBackBtnImage) {
            baseConfigure.clAppPrivacyWebBackBtnImage = [UIImage imageNamed:clAppPrivacyWebBackBtnImage];
        }
        
        NSNumber * setAppPrivacyWebPreferredStatusBarStyle = configureDic[@"setAppPrivacyWebPreferredStatusBarStyle"];
        {
            if (setAppPrivacyWebPreferredStatusBarStyle!=nil) {
                if (setPreferredStatusBarStyle!=nil) {
                    switch (setPreferredStatusBarStyle.intValue) {
                        case 0: default:
                            baseConfigure.clAppPrivacyWebPreferredStatusBarStyle = @(UIStatusBarStyleDefault);
                            break;
                        case 1:
                            baseConfigure.clAppPrivacyWebPreferredStatusBarStyle = @(UIStatusBarStyleLightContent);
                            break;
                        case 2:
                            if (@available(iOS 13.0, *)) {
                                baseConfigure.clAppPrivacyWebPreferredStatusBarStyle = @(UIStatusBarStyleDarkContent);
                            }
                            break;
                    }
                }
            }
        }
        
        NSNumber * setAppPrivacyWebNavigationBarStyle = configureDic[@"setAppPrivacyWebNavigationBarStyle"];
        {
            if (setAppPrivacyWebNavigationBarStyle!=nil) {
                switch (setAppPrivacyWebNavigationBarStyle.intValue) {
                    case 0: default:
                        baseConfigure.clAppPrivacyWebNavigationBarStyle = @(UIBarStyleDefault);
                        break;
                    case 1:
                        baseConfigure.clAppPrivacyWebNavigationBarStyle = @(UIBarStyleBlack);
                        break;
                }
            }
        }
        
        NSString * setAppPrivacyWebNavigationTintColor = configureDic[@"setAppPrivacyWebNavigationTintColor"];
        {
            if (setAppPrivacyWebNavigationTintColor) {
                baseConfigure.clAppPrivacyWebNavigationTintColor = [ShanyanPlugin colorWithHexStr:setAppPrivacyWebNavigationTintColor];
            }
        }
        NSString * setAppPrivacyWebNavigationBarTintColor = configureDic[@"setAppPrivacyWebNavigationBarTintColor"];
        {
            if (setAppPrivacyWebNavigationBarTintColor) {
                baseConfigure.clAppPrivacyWebNavigationBarTintColor = [ShanyanPlugin colorWithHexStr:setAppPrivacyWebNavigationBarTintColor];
            }
        }
        NSString * setAppPrivacyWebNavigationBackgroundImage = configureDic[@"setAppPrivacyWebNavigationBackgroundImage"];
        if (setAppPrivacyWebNavigationBackgroundImage) {
            baseConfigure.clAppPrivacyWebNavigationBackgroundImage = [UIImage imageNamed:setAppPrivacyWebNavigationBackgroundImage];
        }
        NSString * setAppPrivacyWebNavigationShadowImage = configureDic[@"setAppPrivacyWebNavigationShadowImage"];
        if (setAppPrivacyWebNavigationShadowImage) {
            baseConfigure.clAppPrivacyWebNavigationShadowImage = [UIImage imageNamed:setAppPrivacyWebNavigationShadowImage];
        }
        
        /*SLOGAN
         注： 运营商品牌标签("中国**提供认证服务")，不得隐藏
         **/
        /**slogan文字字体*/
        NSNumber   * setSloganTextSize = configureDic[@"setSloganTextSize"];
        NSNumber * setSloganTextBold = configureDic[@"setSloganTextBold"];
        {
            if (setSloganTextSize!=nil) {
                baseConfigure.clSloganTextFont = [ShanyanPlugin fontWithSize:setSloganTextSize blod:setSloganTextBold name:nil];
            }
        };;
        /**slogan文字颜色*/
        NSString * clSloganTextColor = configureDic[@"setSloganTextColor"];;
        {
            if (clSloganTextColor) {
                baseConfigure.clSloganTextColor = [ShanyanPlugin colorWithHexStr:clSloganTextColor];
            }
        };
        /**slogan文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)*/
        NSNumber * clSlogaTextAlignment = configureDic[@"setSloganTextAlignment"];;
        {
            //0: center 1: left 2: right
            if (clSlogaTextAlignment!=nil) {
                switch (clSlogaTextAlignment.integerValue) {
                    case 0:default:
                        baseConfigure.clSlogaTextAlignment = @(NSTextAlignmentCenter);
                        break;
                    case 1:
                        baseConfigure.clSlogaTextAlignment = @(NSTextAlignmentLeft);
                        break;
                    case 2:
                        baseConfigure.clSlogaTextAlignment = @(NSTextAlignmentRight);
                        break;
                }
            }
        };
        
        NSNumber * setSloganTextHidden = configureDic[@"setSloganTextHidden"];
        {
            if (setSloganTextHidden!=nil) {
                baseConfigure.clSloganTextHidden = setSloganTextHidden;
            }
        }
        
        /*ShanyanSLOGAN
         注： 运营商品牌标签("创蓝253提供认证服务")，不得隐藏
         **/
        /**slogan文字字体*/
        NSNumber   * setShanYanSloganTextSize = configureDic[@"setShanYanSloganTextSize"];
        NSNumber * setShanYanSloganTextBold = configureDic[@"setShanYanSloganTextBold"];
        {
            if (setShanYanSloganTextSize!=nil) {
                baseConfigure.clShanYanSloganTextFont = [ShanyanPlugin fontWithSize:setShanYanSloganTextSize blod:setShanYanSloganTextBold name:nil];
            }
        };;
        /**slogan文字颜色*/
        NSString * setShanYanSloganTextColor = configureDic[@"setShanYanSloganTextColor"];
        {
            if (setShanYanSloganTextColor) {
                baseConfigure.clShanYanSloganTextColor = [ShanyanPlugin colorWithHexStr:clSloganTextColor];
            }
        };
        /**slogan文字对齐方式 NSTextAlignment eg.@(NSTextAlignmentCenter)*/
        NSNumber * setShanYanSlogaTextAlignment = configureDic[@"setShanYanSloganTextAlignment"];;
        {
            //0: center 1: left 2: right
            if (setShanYanSlogaTextAlignment!=nil) {
                switch (setShanYanSlogaTextAlignment.integerValue) {
                    case 0:default:
                        baseConfigure.clShanYanSloganTextAlignment = @(NSTextAlignmentCenter);
                        break;
                    case 1:
                        baseConfigure.clShanYanSloganTextAlignment = @(NSTextAlignmentLeft);
                        break;
                    case 2:
                        baseConfigure.clShanYanSloganTextAlignment = @(NSTextAlignmentRight);
                        break;
                }
            }
        };
        
        NSNumber * setShanYanSloganHidden = configureDic[@"setShanYanSloganHidden"];
        {
            if (setShanYanSloganHidden!=nil) {
                baseConfigure.clShanYanSloganHidden = setShanYanSloganHidden;
            }
        }
        
        /*CheckBox
         *协议勾选框，默认选中且在协议前显示
         *可在sdk_oauth.bundle中替换checkBox_unSelected、checkBox_selected图片
         *也可以通过属性设置选中和未选择图片
         **/
        /**协议勾选框（默认显示,放置在协议之前）BOOL eg.@(YES)*/
        NSNumber *clCheckBoxHidden = configureDic[@"setCheckBoxHidden"];;
        {
            baseConfigure.clCheckBoxHidden = clCheckBoxHidden;
        };
        /**协议勾选框默认值（默认不选中）BOOL eg.@(YES)*/
        NSNumber *clCheckBoxValue = configureDic[@"setPrivacyState"];;
        {
            baseConfigure.clCheckBoxValue = clCheckBoxValue;
        };
        /**协议勾选框 尺寸 NSValue->CGSize eg.[NSValue valueWithCGSize:CGSizeMake(25, 25)]*/
        NSArray *clCheckBoxSize = configureDic[@"setCheckBoxWH"];
        {
            if (clCheckBoxSize && clCheckBoxSize.count == 2) {
                CGFloat width = [clCheckBoxSize.firstObject floatValue];
                CGFloat height = [clCheckBoxSize.lastObject floatValue];
                baseConfigure.clCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(width, height)];
            }
        }
        /**协议勾选框 UIButton.image图片缩进 UIEdgeInset eg.[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)]*/
        NSArray *clCheckBoxImageEdgeInsets = configureDic[@"setCheckBoxImageEdgeInsets"];
        {
            if (clCheckBoxImageEdgeInsets && clCheckBoxImageEdgeInsets.count == 4) {
                CGFloat top = [clCheckBoxImageEdgeInsets[0] floatValue];
                CGFloat left = [clCheckBoxImageEdgeInsets[1]  floatValue];
                CGFloat bottom = [clCheckBoxImageEdgeInsets[2]  floatValue];
                CGFloat right = [clCheckBoxImageEdgeInsets[3]  floatValue];
                baseConfigure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
            }
        }
        /**协议勾选框 设置CheckBox顶部与隐私协议控件顶部对齐 YES或大于0生效 eg.@(YES)*/
        NSNumber *clCheckBoxVerticalAlignmentToAppPrivacyTop = configureDic[@"setCheckBoxVerticalAlignmentToAppPrivacyTop"];;
        {
            baseConfigure.clCheckBoxVerticalAlignmentToAppPrivacyTop = clCheckBoxVerticalAlignmentToAppPrivacyTop;
        };
        /**协议勾选框 设置CheckBox顶部与隐私协议控件竖向中心对齐 YES或大于0生效 eg.@(YES)*/
        NSNumber *clCheckBoxVerticalAlignmentToAppPrivacyCenterY = configureDic[@"setCheckBoxVerticalAlignmentToAppPrivacyCenterY"];
        {
            baseConfigure.clCheckBoxVerticalAlignmentToAppPrivacyCenterY = clCheckBoxVerticalAlignmentToAppPrivacyCenterY;
        };
        /**协议勾选框 非选中状态图片*/
        NSString  *clCheckBoxUncheckedImage = configureDic[@"setUncheckedImgPath"];
        if (clCheckBoxUncheckedImage) {
            baseConfigure.clCheckBoxUncheckedImage = [UIImage imageNamed:clCheckBoxUncheckedImage];
        }
        /**协议勾选框 选中状态图片*/
        NSString  *clCheckBoxCheckedImage = configureDic[@"setCheckedImgPath"];
        if (clCheckBoxCheckedImage) {
            baseConfigure.clCheckBoxCheckedImage = [UIImage imageNamed:clCheckBoxCheckedImage];
        }
        
        /*Loading*/
        /**Loading 大小 CGSize eg.[NSValue valueWithCGSize:CGSizeMake(50, 50)]*/
        NSArray *clLoadingSize = configureDic[@"setLoadingSize"];
        {
            if (clLoadingSize && clLoadingSize.count == 2) {
                CGFloat width = [clLoadingSize.firstObject floatValue];
                CGFloat height = [clLoadingSize.lastObject floatValue];
                baseConfigure.clLoadingSize = [NSValue valueWithCGSize:CGSizeMake(width, height)];
            }
        };
        /**Loading 圆角 float eg.@(5) */
        NSNumber *clLoadingCornerRadius = configureDic[@"setLoadingCornerRadius"];
        {
            baseConfigure.clLoadingCornerRadius = clLoadingCornerRadius;
        };
        /**Loading 背景色 UIColor eg.[UIColor colorWithRed:0.8 green:0.5 blue:0.8 alpha:0.8]; */
        NSString *clLoadingBackgroundColor = configureDic[@"setLoadingBackgroundColor"];
        {
            if (clLoadingBackgroundColor) {
                baseConfigure.clLoadingBackgroundColor = [ShanyanPlugin colorWithHexStr:clLoadingBackgroundColor];;
            }
        };
        /**UIActivityIndicatorViewStyle eg.@(UIActivityIndicatorViewStyleWhiteLarge)*/
        //    NSNumber *clLoadingIndicatorStyle = configureDic[@"clLoadingIndicatorStyle"];
        //    {
        //        baseConfigure.clLoadingIndicatorStyle = clLoadingIndicatorStyle;
        //    };
        baseConfigure.clLoadingIndicatorStyle = @(UIActivityIndicatorViewStyleWhite);
        
        /**Loading Indicator渲染色 UIColor eg.[UIColor greenColor]; */
        NSString *clLoadingTintColor = configureDic[@"setLoadingTintColor"];;
        {
            if (clLoadingTintColor) {
                baseConfigure.clLoadingTintColor = [ShanyanPlugin colorWithHexStr:clLoadingTintColor];
            }
        };
        
        /**横竖屏*/
        /*是否支持自动旋转 BOOL*/
        NSNumber * shouldAutorotate = configureDic[@"setShouldAutorotate"];
        {
            baseConfigure.shouldAutorotate = shouldAutorotate;
        };
        /*支持方向 UIInterfaceOrientationMask
         - 如果设置只支持竖屏，只需设置clOrientationLayOutPortrait竖屏布局对象
         - 如果设置只支持横屏，只需设置clOrientationLayOutLandscape横屏布局对象
         - 横竖屏均支持，需同时设置clOrientationLayOutPortrait和clOrientationLayOutLandscape
         */
        NSNumber * supportedInterfaceOrientations = configureDic[@"supportedInterfaceOrientations"];
        {
            /**支持方向
             * 0:UIInterfaceOrientationMaskPortrait
             * 1:UIInterfaceOrientationMaskLandscapeLeft
             * 2:UIInterfaceOrientationMaskLandscapeRight
             * 3:UIInterfaceOrientationMaskPortraitUpsideDown
             * 4:UIInterfaceOrientationMaskLandscape
             * 5:UIInterfaceOrientationMaskAll
             * 6:UIInterfaceOrientationMaskAllButUpsideDown
             * */
            if (supportedInterfaceOrientations!=nil) {
                switch (supportedInterfaceOrientations.integerValue) {
                    case 0:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskPortrait);
                        break;
                    case 1:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskLandscapeLeft);
                        break;
                    case 2:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskLandscapeRight);
                        break;
                    case 3:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskPortraitUpsideDown);
                        break;
                    case 4:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskLandscape);
                        break;
                    case 5:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskAll);
                        break;
                    case 6:
                        baseConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskAllButUpsideDown);
                        break;
                    default:
                        break;
                }
            }
        };
        /*默认方向 UIInterfaceOrientation*/
        NSNumber * preferredInterfaceOrientationForPresentation = configureDic[@"preferredInterfaceOrientationForPresentation"];
        {
            /**偏好方向
             * -1:UIInterfaceOrientationUnknown
             * 0:UIInterfaceOrientationPortrait
             * 1:UIInterfaceOrientationPortraitUpsideDown
             * 2:UIInterfaceOrientationLandscapeLeft
             * 3:UIInterfaceOrientationLandscapeRight
             * */
            //偏好方向默认Portrait preferredInterfaceOrientationForPresentation: Number(5),
            if (preferredInterfaceOrientationForPresentation!=nil) {
                switch (preferredInterfaceOrientationForPresentation.integerValue) {
                    case 0:
                        baseConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationPortrait);
                        break;
                    case 1:
                        baseConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationPortraitUpsideDown);
                        break;
                    case 2:
                        baseConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationLandscapeLeft);
                        break;
                    case 3:
                        baseConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationLandscapeRight);
                        break;
                    default:
                        baseConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationUnknown);
                        break;
                }
            }
        };
        
        /**以窗口方式显示授权页
         */
        /**以窗口方式显示 BOOL, default is NO */
        NSNumber * clAuthTypeUseWindow  = configureDic[@"setAuthTypeUseWindow"];
        {
            baseConfigure.clAuthTypeUseWindow = clAuthTypeUseWindow;
        };
        /**窗口圆角 float*/
        NSNumber * clAuthWindowCornerRadius = configureDic[@"setAuthWindowCornerRadius"];
        {
            baseConfigure.clAuthWindowCornerRadius = clAuthWindowCornerRadius;
        };
        
        /**clAuthWindowModalTransitionStyle系统自带的弹出方式 仅支持以下三种
         UIModalTransitionStyleCoverVertical 底部弹出
         UIModalTransitionStyleCrossDissolve 淡入
         UIModalTransitionStyleFlipHorizontal 翻转显示
         */
        NSNumber * clAuthWindowModalTransitionStyle = configureDic[@"setAuthWindowModalTransitionStyle"];
        {
            if (clAuthWindowModalTransitionStyle!=nil) {
                switch (clAuthWindowModalTransitionStyle.intValue) {
                    case 0: default:
                        baseConfigure.clAuthWindowModalTransitionStyle = @(UIModalTransitionStyleCoverVertical);
                        break;
                    case 1:
                        baseConfigure.clAuthWindowModalTransitionStyle = @(UIModalTransitionStyleFlipHorizontal);
                        break;
                    case 2:
                        baseConfigure.clAuthWindowModalTransitionStyle = @(UIModalTransitionStyleCrossDissolve);
                        break;
                }
            }
        };
        
        NSNumber * setAuthWindowModalPresentationStyle = configureDic[@"setAuthWindowModalPresentationStyle"];
        {
            if (setAuthWindowModalPresentationStyle!=nil) {
                switch (setAuthWindowModalPresentationStyle.intValue) {
                    case 0: default:
                        baseConfigure.clAuthWindowModalPresentationStyle = @(UIModalPresentationFullScreen);
                        break;
                    case 1:
                        baseConfigure.clAuthWindowModalPresentationStyle = @(UIModalPresentationOverFullScreen);
                        break;
                    case 2:
                        if (@available(iOS 13.0, *)) {
                            baseConfigure.clAuthWindowModalPresentationStyle = @(UIModalPresentationAutomatic);
                        }
                        break;
                }
            }
        };
        NSNumber * setAppPrivacyWebModalPresentationStyle = configureDic[@"setAppPrivacyWebModalPresentationStyle"];
        {
            if (setAppPrivacyWebModalPresentationStyle!=nil) {
                switch (setAppPrivacyWebModalPresentationStyle.intValue) {
                    case 0: default:
                        baseConfigure.clAppPrivacyWebModalPresentationStyle = @(UIModalPresentationFullScreen);
                        break;
                    case 1:
                        baseConfigure.clAppPrivacyWebModalPresentationStyle = @(UIModalPresentationOverFullScreen);
                        break;
                    case 2:
                        if (@available(iOS 13.0, *)) {
                            baseConfigure.clAppPrivacyWebModalPresentationStyle = @(UIModalPresentationAutomatic);
                        }
                        break;
                }
            }
        };
        
        NSNumber * setAuthWindowOverrideUserInterfaceStyle = configureDic[@"setAuthWindowOverrideUserInterfaceStyle"];
        {
            if (setAuthWindowOverrideUserInterfaceStyle!=nil) {
                if (@available(iOS 13.0, *)) {
                    switch (setAuthWindowOverrideUserInterfaceStyle.integerValue) {
                        case 0: default:
                            baseConfigure.clAuthWindowOverrideUserInterfaceStyle = @(UIUserInterfaceStyleUnspecified);
                            break;
                        case 1:
                            baseConfigure.clAuthWindowOverrideUserInterfaceStyle = @(UIUserInterfaceStyleLight);
                            break;
                        case 2:
                            baseConfigure.clAuthWindowOverrideUserInterfaceStyle = @(UIUserInterfaceStyleDark);
                            break;
                    }
                }
            }
        }
        
        NSNumber * setAuthWindowPresentingAnimate = configureDic[@"setAuthWindowPresentingAnimate"];
        {
            if (setAuthWindowPresentingAnimate!=nil) {
                baseConfigure.clAuthWindowPresentingAnimate = setAuthWindowPresentingAnimate;
            }
        }
        
        
        //自定义控件
        NSArray * clCustomViewArray = configureDic[@"widgets"];
        if (clCustomViewArray) {
            
            //导航栏控件
            for (NSDictionary * clCustomDict in clCustomViewArray) {
                NSString * type = clCustomDict[@"type"];
                NSString * navPosition = clCustomDict[@"navPosition"];
                if ([navPosition isEqualToString:@"navleft"] || [navPosition isEqualToString:@"navright"]) {
                    //导航栏控件
                    
                    NSString * widgetId = clCustomDict[@"widgetId"];
                    NSNumber * isFinish = clCustomDict[@"isFinish"];
                    
                    CLShanYanCustomViewCongifure * customViewConfigure = [self customViewConfigureWithDict:clCustomDict];
                    
                    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]init];
                    
                    if ([type isEqualToString:@"TextView"]) {
                        
                        UILabel * customLabel = [CLShanYanCustomViewHelper customLabelWithCongifure:customViewConfigure];
                        
                        customLabel.widgetId = widgetId;
                        
                        NSNumber * clLayoutWidth = clCustomDict[@"width"];
                        NSNumber * clLayoutHeight = clCustomDict[@"height"];
                        
                        customLabel.frame = CGRectMake(0, 0, clLayoutWidth.floatValue, clLayoutHeight.floatValue);
                        
                        [barButtonItem setCustomView:customLabel];
                        
                    }else if ([type isEqualToString:@"ImageView"]){
                        
                        UIImageView * customImageView = [CLShanYanCustomViewHelper customImageViewWithCongifure:customViewConfigure];
                        
                        customImageView.widgetId = widgetId;
                        
                        NSNumber * clLayoutWidth = clCustomDict[@"width"];
                        NSNumber * clLayoutHeight = clCustomDict[@"height"];
                        
                        customImageView.frame = CGRectMake(0, 0, clLayoutWidth.floatValue, clLayoutHeight.floatValue);
                        
                        [barButtonItem setCustomView:customImageView];
                        
                    }else if ([type isEqualToString:@"Button"]){
                        
                        UIButton * custonButton = [CLShanYanCustomViewHelper customButtonWithCongifure:customViewConfigure];
                        
                        custonButton.widgetId = widgetId;
                        custonButton.isFinish = isFinish.boolValue;
                        
                        [custonButton addTarget:self action:@selector(customButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
                        
                        NSNumber * clLayoutWidth = clCustomDict[@"width"];
                        NSNumber * clLayoutHeight = clCustomDict[@"height"];
                        
                        custonButton.frame = CGRectMake(0, 0, clLayoutWidth.floatValue, clLayoutHeight.floatValue);
                        
                        [barButtonItem setCustomView:custonButton];
                    }
                    
                    if (barButtonItem.customView) {
                        if ([navPosition isEqualToString:@"navleft"]) {
                            baseConfigure.clNavigationLeftControl = barButtonItem;
                        }
                        if ([navPosition isEqualToString:@"navright"]) {
                            baseConfigure.clNavigationRightControl = barButtonItem;
                        }
                    }
                    
                }
            }
            
            //授权页自定义控件
            __weak typeof(self)weakSelf = self;
            baseConfigure.customAreaView = ^(UIView * _Nonnull customAreaView) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    for (NSDictionary * clCustomDict in clCustomViewArray) {
                        
                        NSString * type = clCustomDict[@"type"];
                        NSString * navPosition = clCustomDict[@"navPosition"];
                        if ([navPosition isEqualToString:@"navleft"] || [navPosition isEqualToString:@"navright"]) {
                            //导航栏控件跳过
                            continue;
                        }
                        NSString * widgetId = clCustomDict[@"widgetId"];
                        NSNumber * isFinish = clCustomDict[@"isFinish"];
                        
                        CLShanYanCustomViewCongifure * customViewConfigure = [strongSelf customViewConfigureWithDict:clCustomDict];
                        
                        if ([type isEqualToString:@"TextView"]) {
                            
                            UILabel * customLabel = [CLShanYanCustomViewHelper customLabelWithCongifure:customViewConfigure];
                            
                            customLabel.widgetId = widgetId;
                            
                            [customAreaView addSubview:customLabel];
                            
                            [ShanyanPlugin setConstraint:customAreaView targetView:customLabel contrains:clCustomDict];
                            
                        }else if ([type isEqualToString:@"ImageView"]){
                            
                            UIImageView * customImageView = [CLShanYanCustomViewHelper customImageViewWithCongifure:customViewConfigure];
                            
                            customImageView.widgetId = widgetId;
                            
                            [customAreaView addSubview:customImageView];
                            
                            [ShanyanPlugin setConstraint:customAreaView targetView:customImageView contrains:clCustomDict];
                            
                        }else if ([type isEqualToString:@"Button"]){
                            
                            UIButton * custonButton = [CLShanYanCustomViewHelper customButtonWithCongifure:customViewConfigure];
                            
                            custonButton.widgetId = widgetId;
                            custonButton.isFinish = isFinish.boolValue;
                            
                            [custonButton addTarget:strongSelf action:@selector(customButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
                            
                            [customAreaView addSubview:custonButton];
                            
                            [ShanyanPlugin setConstraint:customAreaView targetView:custonButton contrains:clCustomDict];
                            
                        }
                    }
                    NSString *clBackgroundVedio = configureDic[@"setAuthBGVedioPath"];
                    if (clBackgroundVedio) {
                        NSString *path = [[NSBundle mainBundle] pathForResource:clBackgroundVedio ofType:@"mp4"];
                        if (path) {
                            NSURL *url = [NSURL fileURLWithPath:path];
                            if (url) {
                                PlayerView *playerView = [[PlayerView alloc] init];
                                [customAreaView addSubview:playerView];
                                playerView.translatesAutoresizingMaskIntoConstraints = NO;
                                NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.];
                                left.active = YES;
                                NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.];
                                top.active = YES;
                                NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.];
                                right.active = YES;
                                NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.];
                                bottom.active = YES;
                                [customAreaView updateConstraintsIfNeeded];
                                [customAreaView sendSubviewToBack:playerView];
                                
                                AVPlayerItem *playeItem = [[AVPlayerItem alloc] initWithURL:url];
                                AVPlayer *player = [AVPlayer playerWithPlayerItem:playeItem];
                                
                                AVPlayerLayer *playerLayer = (AVPlayerLayer *)playerView.layer;
                                playerLayer.player = player;
                                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                                [player play];
                                [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
                                    CMTime time  = CMTimeMake(0, 1);
                                    [player seekToTime:time];
                                    [player play];
                                }];
                                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
                                    if(player) [player pause];
                                }];
                                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
                                    if(player) [player play];
                                }];
                            }
                        }
                        
                    }
                });
            };
        }
        
        /**弹窗的MaskLayer，用于自定义窗口形状*/
        // CALayer * clAuthWindowMaskLayer;
        
        NSDictionary * clOrientationLayOutPortraitDict = configureDic[@"layOutPortrait"];
        NSDictionary * clOrientationLayOutLandscapeDict = configureDic[@"layOutLandscape"];
        
        if (clOrientationLayOutPortraitDict.count > 0) {
            CLOrientationLayOut * clOrientationLayOutPortrait = [self clOrientationLayOutPortraitWithConfigure:clOrientationLayOutPortraitDict];
            baseConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;
        }
        if (clOrientationLayOutLandscapeDict.count > 0) {
            CLOrientationLayOut * clOrientationLayOutLandscape = [self clOrientationLayOutLandscapeWithConfigure:clOrientationLayOutLandscapeDict];
            baseConfigure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.userInfo);
    }
    return baseConfigure;
}

//自定义控件事件
-(void)customButtonClicked:(UIButton *)sender{
    
    NSMutableDictionary * result = [NSMutableDictionary new];
    result[@"widgetId"] = sender.widgetId;
    result[@"isFinish"] = @(sender.isFinish);
    if (self.channel) {
        [self.channel invokeMethod:@"onReceiveClickWidgetEvent" arguments:result];
    }
    
    
    if (sender.isFinish) {
        [CLShanYanSDKManager finishAuthControllerCompletion:nil];
    }
}

-(CLShanYanCustomViewCongifure *)customViewConfigureWithDict:(NSDictionary *)clCustomDict{
    
    if (clCustomDict == nil) {
        return nil;
    }
    
    @try {
        CLShanYanCustomViewCongifure * customViewConfigure = [[CLShanYanCustomViewCongifure alloc]init];
        
        //    NSString * widgetId = clCustomDict[@"widgetId"];
        ////    customViewConfigure.widgetId = widgetId;
        //
        //    NSNumber * isFinish = clCustomDict[@"isFinish"];
        //    if (isFinish) {
        ////        customViewConfigure.isFinish = isFinish.boolValue;
        //    }
        
        /**文字颜色*/
        UIColor  * clTextColor = [ShanyanPlugin colorWithHexStr:clCustomDict[@"textColor"]];
        if (clTextColor) {
            customViewConfigure.button_textColor = clTextColor;
            customViewConfigure.label_textColor = clTextColor;
        }
        NSNumber   * textFont = clCustomDict[@"textFont"];
        if (textFont!=nil) {
            customViewConfigure.button_titleLabelFont = [UIFont systemFontOfSize:textFont.floatValue];
            customViewConfigure.label_font = [UIFont systemFontOfSize:textFont.floatValue];
        }
        NSString * textContent = clCustomDict[@"textContent"];
        if (textContent) {
            customViewConfigure.button_textContent = textContent;
            customViewConfigure.label_text = textContent;
        }
        
        NSNumber * numberOfLines = clCustomDict[@"numberOfLines"];
        if (customViewConfigure) {
            customViewConfigure.button_numberOfLines = numberOfLines;
            customViewConfigure.label_numberOfLines = numberOfLines;
        }
        
        NSString * clButtonImage = clCustomDict[@"image"];
        if (clButtonImage) {
            //UIButton
            customViewConfigure.button_image = [UIImage imageNamed:clButtonImage];
            //UIImageView
            customViewConfigure.imageView_image = [UIImage imageNamed:clButtonImage];
        }
        
        
        NSString * clButtonBackgroundImage = clCustomDict[@"backgroundImgPath"];
        if (clButtonBackgroundImage) {
            customViewConfigure.button_backgroundImage = [UIImage imageNamed:clButtonBackgroundImage];
        }
        
        
        //UIView通用
        UIColor * backgroundColor = [ShanyanPlugin colorWithHexStr: clCustomDict[@"backgroundColor"]];
        if (backgroundColor) {
            customViewConfigure.backgroundColor = backgroundColor;
        }
        
        //UILabel
        NSNumber * textAlignment = clCustomDict[@"textAlignment"];
        if (textAlignment!=nil) {
            customViewConfigure.label_textAlignment = textAlignment;
        }
        
        //CALayer通用
        NSNumber * cornerRadius = clCustomDict[@"cornerRadius"];
        //            NSNumber * masksToBounds =  clCustomDict[@"masksToBounds"];
        if (cornerRadius!=nil) {
            customViewConfigure.layer_cornerRadius = cornerRadius;
            customViewConfigure.layer_masksToBounds = @(YES);
        }
        UIColor * borderColor = [ShanyanPlugin colorWithHexStr:clCustomDict[@"borderColor"]];
        if (borderColor) {
            customViewConfigure.layer_borderColor = borderColor.CGColor;
            customViewConfigure.layer_masksToBounds = @(YES);
        }
        
        NSNumber * borderWidth = clCustomDict[@"borderWidth"];
        if (borderWidth!=nil) {
            customViewConfigure.layer_borderWidth = borderWidth;
            customViewConfigure.layer_masksToBounds = @(YES);
        }
        
        
        
        return customViewConfigure;
    } @catch (NSException *exception) {
        
    }
}


+(void)setConstraint:(UIView * )superView targetView:(UIView *)subView contrains:(NSDictionary * )dict{
    
    @try {
        NSNumber * clLayoutLeft = dict[@"left"];
        NSNumber * clLayoutTop = dict[@"top"];
        NSNumber * clLayoutRight = dict[@"right"];
        NSNumber * clLayoutBottom = dict[@"bottom"];
        NSNumber * clLayoutWidth = dict[@"width"];
        NSNumber * clLayoutHeight = dict[@"height"];
        NSNumber * clLayoutCenterX = dict[@"centerX"];
        NSNumber * clLayoutCenterY = dict[@"centerY"];
        
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (clLayoutWidth != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:clLayoutWidth.floatValue];
            c.active = YES;
        }
        
        if (clLayoutHeight != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:clLayoutHeight.floatValue];
            c.active = YES;
        }
        
        if (clLayoutLeft != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:clLayoutLeft.floatValue];
            c.active = YES;
        }
        
        if (clLayoutTop != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0f constant:clLayoutTop.floatValue];
            c.active = YES;
        }
        
        if (clLayoutRight != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0f constant:clLayoutRight.clShanYanNegative.floatValue];
            c.active = YES;
        }
        
        if (clLayoutBottom != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:clLayoutBottom.clShanYanNegative.floatValue];
            c.active = YES;
        }
        
        if (clLayoutCenterX != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:clLayoutCenterX.floatValue];
            c.active = YES;
        }
        
        if (clLayoutCenterY != nil) {
            NSLayoutConstraint * c = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:clLayoutCenterY.floatValue];
            c.active = YES;
        }
        
        [superView updateConstraintsIfNeeded];
    } @catch (NSException *exception) {
        
    }
}


-(CLOrientationLayOut *)clOrientationLayOutPortraitWithConfigure:(NSDictionary *)layOutPortraitDict{
    if (layOutPortraitDict == nil) {
        return CLOrientationLayOut.clDefaultOrientationLayOut;
    }
    
    CLOrientationLayOut * clOrientationLayOutPortrait = [CLOrientationLayOut new];
    
    NSNumber * clLayoutLogoLeft     = layOutPortraitDict[@"setLogoLeft"];
    NSNumber * clLayoutLogoTop      = layOutPortraitDict[@"setLogoTop"];
    NSNumber * clLayoutLogoRight    = layOutPortraitDict[@"setLogoRight"];
    NSNumber * clLayoutLogoBottom   = layOutPortraitDict[@"setLogoBottom"];
    NSNumber * clLayoutLogoWidth    = layOutPortraitDict[@"setLogoWidth"];
    NSNumber * clLayoutLogoHeight   = layOutPortraitDict[@"setLogoHeight"];
    NSNumber * clLayoutLogoCenterX  = layOutPortraitDict[@"setLogoCenterX"];
    NSNumber * clLayoutLogoCenterY  = layOutPortraitDict[@"setLogoCenterY"];
    
    clOrientationLayOutPortrait.clLayoutLogoLeft = clLayoutLogoLeft;
    clOrientationLayOutPortrait.clLayoutLogoTop = clLayoutLogoTop;
    clOrientationLayOutPortrait.clLayoutLogoRight = clLayoutLogoRight.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutLogoBottom = clLayoutLogoBottom.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutLogoWidth = clLayoutLogoWidth;
    clOrientationLayOutPortrait.clLayoutLogoHeight = clLayoutLogoHeight;
    clOrientationLayOutPortrait.clLayoutLogoCenterX = clLayoutLogoCenterX;
    clOrientationLayOutPortrait.clLayoutLogoCenterY = clLayoutLogoCenterY;
    
    /**手机号显示控件*/
    //layout 约束均相对vc.view
    NSNumber * clLayoutPhoneLeft    = layOutPortraitDict[@"setNumFieldLeft"];;
    NSNumber * clLayoutPhoneTop     = layOutPortraitDict[@"setNumFieldTop"];;
    NSNumber * clLayoutPhoneRight   = layOutPortraitDict[@"setNumFieldRight"];;
    NSNumber * clLayoutPhoneBottom  = layOutPortraitDict[@"setNumFieldBottom"];;
    NSNumber * clLayoutPhoneWidth   = layOutPortraitDict[@"setNumFieldWidth"];;
    NSNumber * clLayoutPhoneHeight  = layOutPortraitDict[@"setNumFieldHeight"];;
    NSNumber * clLayoutPhoneCenterX = layOutPortraitDict[@"setNumFieldCenterX"];;
    NSNumber * clLayoutPhoneCenterY = layOutPortraitDict[@"setNumFieldCenterY"];;
    clOrientationLayOutPortrait.clLayoutPhoneLeft = clLayoutPhoneLeft;
    clOrientationLayOutPortrait.clLayoutPhoneTop = clLayoutPhoneTop;
    clOrientationLayOutPortrait.clLayoutPhoneRight = clLayoutPhoneRight.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutPhoneBottom = clLayoutPhoneBottom.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutPhoneWidth = clLayoutPhoneWidth;
    clOrientationLayOutPortrait.clLayoutPhoneHeight = clLayoutPhoneHeight;
    clOrientationLayOutPortrait.clLayoutPhoneCenterX = clLayoutPhoneCenterX;
    clOrientationLayOutPortrait.clLayoutPhoneCenterY = clLayoutPhoneCenterY;
    /*一键登录按钮 控件
     注： 一键登录授权按钮 不得隐藏
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutLoginBtnLeft     = layOutPortraitDict[@"setLogBtnLeft"];
    NSNumber * clLayoutLoginBtnTop      = layOutPortraitDict[@"setLogBtnTop"];
    NSNumber * clLayoutLoginBtnRight    = layOutPortraitDict[@"setLogBtnRight"];
    NSNumber * clLayoutLoginBtnBottom   = layOutPortraitDict[@"setLogBtnBottom"];
    NSNumber * clLayoutLoginBtnWidth    = layOutPortraitDict[@"setLogBtnWidth"];
    NSNumber * clLayoutLoginBtnHeight   = layOutPortraitDict[@"setLogBtnHeight"];
    NSNumber * clLayoutLoginBtnCenterX  = layOutPortraitDict[@"setLogBtnCenterX"];
    NSNumber * clLayoutLoginBtnCenterY  = layOutPortraitDict[@"setLogBtnCenterY"];
    clOrientationLayOutPortrait.clLayoutLoginBtnLeft = clLayoutLoginBtnLeft;
    clOrientationLayOutPortrait.clLayoutLoginBtnTop = clLayoutLoginBtnTop;
    clOrientationLayOutPortrait.clLayoutLoginBtnRight = clLayoutLoginBtnRight.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutLoginBtnBottom = clLayoutLoginBtnBottom.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutLoginBtnWidth = clLayoutLoginBtnWidth;
    clOrientationLayOutPortrait.clLayoutLoginBtnHeight = clLayoutLoginBtnHeight;
    clOrientationLayOutPortrait.clLayoutLoginBtnCenterX = clLayoutLoginBtnCenterX;
    clOrientationLayOutPortrait.clLayoutLoginBtnCenterY = clLayoutLoginBtnCenterY;
    /*隐私条款Privacy
     注： 运营商隐私条款 不得隐藏， 用户条款不限制
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutAppPrivacyLeft   = layOutPortraitDict[@"setPrivacyLeft"];
    NSNumber * clLayoutAppPrivacyTop    = layOutPortraitDict[@"setPrivacyTop"];
    NSNumber * clLayoutAppPrivacyRight  = layOutPortraitDict[@"setPrivacyRight"];
    NSNumber * clLayoutAppPrivacyBottom = layOutPortraitDict[@"setPrivacyBottom"];
    NSNumber * clLayoutAppPrivacyWidth  = layOutPortraitDict[@"setPrivacyWidth"];
    NSNumber * clLayoutAppPrivacyHeight = layOutPortraitDict[@"setPrivacyHeight"];
    NSNumber * clLayoutAppPrivacyCenterX= layOutPortraitDict[@"setPrivacyCenterX"];
    NSNumber * clLayoutAppPrivacyCenterY= layOutPortraitDict[@"setPrivacyCenterY"];
    clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = clLayoutAppPrivacyLeft;
    clOrientationLayOutPortrait.clLayoutAppPrivacyTop = clLayoutAppPrivacyTop;
    clOrientationLayOutPortrait.clLayoutAppPrivacyRight = clLayoutAppPrivacyRight.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = clLayoutAppPrivacyBottom.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutAppPrivacyWidth = clLayoutAppPrivacyWidth;
    clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = clLayoutAppPrivacyHeight;
    clOrientationLayOutPortrait.clLayoutAppPrivacyCenterX = clLayoutAppPrivacyCenterX;
    clOrientationLayOutPortrait.clLayoutAppPrivacyCenterY = clLayoutAppPrivacyCenterY;
    /*Slogan 运营商品牌标签："认证服务由中国移动/联通/电信提供" label
     注： 运营商品牌标签，不得隐藏
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutSloganLeft   = layOutPortraitDict[@"setSloganLeft"];
    NSNumber * clLayoutSloganTop    = layOutPortraitDict[@"setSloganTop"];
    NSNumber * clLayoutSloganRight  = layOutPortraitDict[@"setSloganRight"];
    NSNumber * clLayoutSloganBottom = layOutPortraitDict[@"setSloganBottom"];
    NSNumber * clLayoutSloganWidth  = layOutPortraitDict[@"setSloganWidth"];
    NSNumber * clLayoutSloganHeight = layOutPortraitDict[@"setSloganHeight"];
    NSNumber * clLayoutSloganCenterX= layOutPortraitDict[@"setSloganCenterX"];
    NSNumber * clLayoutSloganCenterY= layOutPortraitDict[@"setSloganCenterY"];
    clOrientationLayOutPortrait.clLayoutSloganLeft = clLayoutSloganLeft;
    clOrientationLayOutPortrait.clLayoutSloganTop = clLayoutSloganTop;
    clOrientationLayOutPortrait.clLayoutSloganRight = clLayoutSloganRight.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutSloganBottom = clLayoutSloganBottom.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutSloganWidth = clLayoutSloganWidth;
    clOrientationLayOutPortrait.clLayoutSloganHeight = clLayoutSloganHeight;
    clOrientationLayOutPortrait.clLayoutSloganCenterX = clLayoutSloganCenterX;
    clOrientationLayOutPortrait.clLayoutSloganCenterY = clLayoutSloganCenterY;
    
    /*ShanYanSlogan 运营商品牌标签："认证服务由中国移动/联通/电信提供" label
     注： 运营商品牌标签，不得隐藏
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutShanYanSloganLeft   = layOutPortraitDict[@"setShanYanSloganLeft"];
    NSNumber * clLayoutShanYanSloganTop    = layOutPortraitDict[@"setShanYanSloganTop"];
    NSNumber * clLayoutShanYanSloganRight  = layOutPortraitDict[@"setShanYanSloganRight"];
    NSNumber * clLayoutShanYanSloganBottom = layOutPortraitDict[@"setShanYanSloganBottom"];
    NSNumber * clLayoutShanYanSloganWidth  = layOutPortraitDict[@"setShanYanSloganWidth"];
    NSNumber * clLayoutShanYanSloganHeight = layOutPortraitDict[@"setShanYanSloganHeight"];
    NSNumber * clLayoutShanYanSloganCenterX= layOutPortraitDict[@"setShanYanSloganCenterX"];
    NSNumber * clLayoutShanYanSloganCenterY= layOutPortraitDict[@"setShanYanSloganCenterY"];
    clOrientationLayOutPortrait.clLayoutShanYanSloganLeft = clLayoutShanYanSloganLeft;
    clOrientationLayOutPortrait.clLayoutShanYanSloganTop = clLayoutShanYanSloganTop;
    clOrientationLayOutPortrait.clLayoutShanYanSloganRight = clLayoutShanYanSloganRight.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutShanYanSloganBottom = clLayoutShanYanSloganBottom.clShanYanNegative;
    clOrientationLayOutPortrait.clLayoutShanYanSloganWidth = clLayoutShanYanSloganWidth;
    clOrientationLayOutPortrait.clLayoutShanYanSloganHeight = clLayoutShanYanSloganHeight;
    clOrientationLayOutPortrait.clLayoutShanYanSloganCenterX = clLayoutShanYanSloganCenterX;
    clOrientationLayOutPortrait.clLayoutShanYanSloganCenterY = clLayoutShanYanSloganCenterY;
    
    /**窗口模式*/
    /**窗口中心：CGPoint X Y*/
    NSNumber * clAuthWindowOrientationCenterX = layOutPortraitDict[@"setAuthWindowOrientationCenterX"];
    NSNumber * clAuthWindowOrientationCenterY = layOutPortraitDict[@"setAuthWindowOrientationCenterY"];
    if (clAuthWindowOrientationCenterX && clAuthWindowOrientationCenterY) {
        clOrientationLayOutPortrait.clAuthWindowOrientationCenter = [NSValue valueWithCGPoint:CGPointMake(clAuthWindowOrientationCenterX.floatValue, clAuthWindowOrientationCenterY.floatValue)];
    }
    
    /**窗口左上角：frame.origin：CGPoint X Y*/
    NSNumber * clAuthWindowOrientationOriginX = layOutPortraitDict[@"setAuthWindowOrientationOriginX"];
    NSNumber * clAuthWindowOrientationOriginY = layOutPortraitDict[@"setAuthWindowOrientationOriginY"];
    if (clAuthWindowOrientationCenterX && clAuthWindowOrientationOriginY) {
        clOrientationLayOutPortrait.clAuthWindowOrientationOrigin = [NSValue valueWithCGPoint:CGPointMake(clAuthWindowOrientationOriginX.floatValue, clAuthWindowOrientationOriginY.floatValue)];
    }
    /**窗口大小：宽 float */
    NSNumber * clAuthWindowOrientationWidth = layOutPortraitDict[@"setAuthWindowOrientationWidth"];
    {
        clOrientationLayOutPortrait.clAuthWindowOrientationWidth = clAuthWindowOrientationWidth;
    }
    /**窗口大小：高 float */
    NSNumber * clAuthWindowOrientationHeight= layOutPortraitDict[@"setAuthWindowOrientationHeight"];
    {
        clOrientationLayOutPortrait.clAuthWindowOrientationHeight = clAuthWindowOrientationHeight;
    }
    return clOrientationLayOutPortrait;
}

-(CLOrientationLayOut *)clOrientationLayOutLandscapeWithConfigure:(NSDictionary *)layOutLandscapeDict{
    if (layOutLandscapeDict == nil) {
        return CLOrientationLayOut.clDefaultOrientationLayOut;
    }
    
    CLOrientationLayOut * clOrientationLayOutLandscape = [CLOrientationLayOut new];
    
    NSNumber * clLayoutLogoLeft     = layOutLandscapeDict[@"clLayoutLogoLeft"];
    NSNumber * clLayoutLogoTop      = layOutLandscapeDict[@"clLayoutLogoTop"];
    NSNumber * clLayoutLogoRight    = layOutLandscapeDict[@"clLayoutLogoRight"];
    NSNumber * clLayoutLogoBottom   = layOutLandscapeDict[@"clLayoutLogoBottom"];
    NSNumber * clLayoutLogoWidth    = layOutLandscapeDict[@"clLayoutLogoWidth"];
    NSNumber * clLayoutLogoHeight   = layOutLandscapeDict[@"clLayoutLogoHeight"];
    NSNumber * clLayoutLogoCenterX  = layOutLandscapeDict[@"clLayoutLogoCenterX"];
    NSNumber * clLayoutLogoCenterY  = layOutLandscapeDict[@"clLayoutLogoCenterY"];
    
    clOrientationLayOutLandscape.clLayoutLogoLeft = clLayoutLogoLeft;
    clOrientationLayOutLandscape.clLayoutLogoTop = clLayoutLogoTop;
    clOrientationLayOutLandscape.clLayoutLogoRight = clLayoutLogoRight.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutLogoBottom = clLayoutLogoBottom.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutLogoWidth = clLayoutLogoWidth;
    clOrientationLayOutLandscape.clLayoutLogoHeight = clLayoutLogoHeight;
    clOrientationLayOutLandscape.clLayoutLogoCenterX = clLayoutLogoCenterX;
    clOrientationLayOutLandscape.clLayoutLogoCenterY = clLayoutLogoCenterY;
    
    /**手机号显示控件*/
    //layout 约束均相对vc.view
    NSNumber * clLayoutPhoneLeft    = layOutLandscapeDict[@"clLayoutPhoneLeft"];;
    NSNumber * clLayoutPhoneTop     = layOutLandscapeDict[@"clLayoutPhoneTop"];;
    NSNumber * clLayoutPhoneRight   = layOutLandscapeDict[@"clLayoutPhoneRight"];;
    NSNumber * clLayoutPhoneBottom  = layOutLandscapeDict[@"clLayoutPhoneBottom"];;
    NSNumber * clLayoutPhoneWidth   = layOutLandscapeDict[@"clLayoutPhoneWidth"];;
    NSNumber * clLayoutPhoneHeight  = layOutLandscapeDict[@"clLayoutPhoneHeight"];;
    NSNumber * clLayoutPhoneCenterX = layOutLandscapeDict[@"clLayoutPhoneCenterX"];;
    NSNumber * clLayoutPhoneCenterY = layOutLandscapeDict[@"clLayoutPhoneCenterY"];;
    clOrientationLayOutLandscape.clLayoutPhoneLeft = clLayoutPhoneLeft;
    clOrientationLayOutLandscape.clLayoutPhoneTop = clLayoutPhoneTop;
    clOrientationLayOutLandscape.clLayoutPhoneRight = clLayoutPhoneRight.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutPhoneBottom = clLayoutPhoneBottom.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutPhoneWidth = clLayoutPhoneWidth;
    clOrientationLayOutLandscape.clLayoutPhoneHeight = clLayoutPhoneHeight;
    clOrientationLayOutLandscape.clLayoutPhoneCenterX = clLayoutPhoneCenterX;
    clOrientationLayOutLandscape.clLayoutPhoneCenterY = clLayoutPhoneCenterY;
    /*一键登录按钮 控件
     注： 一键登录授权按钮 不得隐藏
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutLoginBtnLeft     = layOutLandscapeDict[@"clLayoutLoginBtnLeft"];
    NSNumber * clLayoutLoginBtnTop      = layOutLandscapeDict[@"clLayoutLoginBtnTop"];
    NSNumber * clLayoutLoginBtnRight    = layOutLandscapeDict[@"clLayoutLoginBtnRight"];
    NSNumber * clLayoutLoginBtnBottom   = layOutLandscapeDict[@"clLayoutLoginBtnBottom"];
    NSNumber * clLayoutLoginBtnWidth    = layOutLandscapeDict[@"clLayoutLoginBtnWidth"];
    NSNumber * clLayoutLoginBtnHeight   = layOutLandscapeDict[@"clLayoutLoginBtnHeight"];
    NSNumber * clLayoutLoginBtnCenterX  = layOutLandscapeDict[@"clLayoutLoginBtnCenterX"];
    NSNumber * clLayoutLoginBtnCenterY  = layOutLandscapeDict[@"clLayoutLoginBtnCenterY"];
    clOrientationLayOutLandscape.clLayoutLoginBtnLeft = clLayoutLoginBtnLeft;
    clOrientationLayOutLandscape.clLayoutLoginBtnTop = clLayoutLoginBtnTop;
    clOrientationLayOutLandscape.clLayoutLoginBtnRight = clLayoutLoginBtnRight.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutLoginBtnBottom = clLayoutLoginBtnBottom.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutLoginBtnWidth = clLayoutLoginBtnWidth;
    clOrientationLayOutLandscape.clLayoutLoginBtnHeight = clLayoutLoginBtnHeight;
    clOrientationLayOutLandscape.clLayoutLoginBtnCenterX = clLayoutLoginBtnCenterX;
    clOrientationLayOutLandscape.clLayoutLoginBtnCenterY = clLayoutLoginBtnCenterY;
    /*隐私条款Privacy
     注： 运营商隐私条款 不得隐藏， 用户条款不限制
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutAppPrivacyLeft   = layOutLandscapeDict[@"clLayoutAppPrivacyLeft"];
    NSNumber * clLayoutAppPrivacyTop    = layOutLandscapeDict[@"clLayoutAppPrivacyTop"];
    NSNumber * clLayoutAppPrivacyRight  = layOutLandscapeDict[@"clLayoutAppPrivacyRight"];
    NSNumber * clLayoutAppPrivacyBottom = layOutLandscapeDict[@"clLayoutAppPrivacyBottom"];
    NSNumber * clLayoutAppPrivacyWidth  = layOutLandscapeDict[@"clLayoutAppPrivacyWidth"];
    NSNumber * clLayoutAppPrivacyHeight = layOutLandscapeDict[@"clLayoutAppPrivacyHeight"];
    NSNumber * clLayoutAppPrivacyCenterX= layOutLandscapeDict[@"clLayoutAppPrivacyCenterX"];
    NSNumber * clLayoutAppPrivacyCenterY= layOutLandscapeDict[@"clLayoutAppPrivacyCenterY"];
    clOrientationLayOutLandscape.clLayoutAppPrivacyLeft = clLayoutAppPrivacyLeft;
    clOrientationLayOutLandscape.clLayoutAppPrivacyTop = clLayoutAppPrivacyTop;
    clOrientationLayOutLandscape.clLayoutAppPrivacyRight = clLayoutAppPrivacyRight.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutAppPrivacyBottom = clLayoutAppPrivacyBottom.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutAppPrivacyWidth = clLayoutAppPrivacyWidth;
    clOrientationLayOutLandscape.clLayoutAppPrivacyHeight = clLayoutAppPrivacyHeight;
    clOrientationLayOutLandscape.clLayoutAppPrivacyCenterX = clLayoutAppPrivacyCenterX;
    clOrientationLayOutLandscape.clLayoutAppPrivacyCenterY = clLayoutAppPrivacyCenterY;
    /*Slogan 运营商品牌标签："认证服务由中国移动/联通/电信提供" label
     注： 运营商品牌标签，不得隐藏
     **/
    //layout 约束均相对vc.view
    NSNumber * clLayoutSloganLeft   = layOutLandscapeDict[@"clLayoutSloganLeft"];
    NSNumber * clLayoutSloganTop    = layOutLandscapeDict[@"clLayoutSloganTop"];
    NSNumber * clLayoutSloganRight  = layOutLandscapeDict[@"clLayoutSloganRight"];
    NSNumber * clLayoutSloganBottom = layOutLandscapeDict[@"clLayoutSloganBottom"];
    NSNumber * clLayoutSloganWidth  = layOutLandscapeDict[@"clLayoutSloganWidth"];
    NSNumber * clLayoutSloganHeight = layOutLandscapeDict[@"clLayoutSloganHeight"];
    NSNumber * clLayoutSloganCenterX= layOutLandscapeDict[@"clLayoutSloganCenterX"];
    NSNumber * clLayoutSloganCenterY= layOutLandscapeDict[@"clLayoutSloganCenterY"];
    clOrientationLayOutLandscape.clLayoutSloganLeft = clLayoutSloganLeft;
    clOrientationLayOutLandscape.clLayoutSloganTop = clLayoutSloganTop;
    clOrientationLayOutLandscape.clLayoutSloganRight = clLayoutSloganRight.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutSloganBottom = clLayoutSloganBottom.clShanYanNegative;
    clOrientationLayOutLandscape.clLayoutSloganWidth = clLayoutSloganWidth;
    clOrientationLayOutLandscape.clLayoutSloganHeight = clLayoutSloganHeight;
    clOrientationLayOutLandscape.clLayoutSloganCenterX = clLayoutSloganCenterX;
    clOrientationLayOutLandscape.clLayoutSloganCenterY = clLayoutSloganCenterY;
    
    /**窗口模式*/
    /**窗口中心：CGPoint X Y*/
    NSNumber * clAuthWindowOrientationCenterX = layOutLandscapeDict[@"clAuthWindowOrientationCenterX"];
    NSNumber * clAuthWindowOrientationCenterY = layOutLandscapeDict[@"clAuthWindowOrientationCenterY"];
    if (clAuthWindowOrientationCenterX && clAuthWindowOrientationCenterX) {
        clOrientationLayOutLandscape.clAuthWindowOrientationCenter = [NSValue valueWithCGPoint:CGPointMake(clAuthWindowOrientationCenterX.floatValue, clAuthWindowOrientationCenterY.floatValue)];
    }
    
    /**窗口左上角：frame.origin：CGPoint X Y*/
    NSNumber * clAuthWindowOrientationOriginX = layOutLandscapeDict[@"clAuthWindowOrientationOriginX"];
    NSNumber * clAuthWindowOrientationOriginY = layOutLandscapeDict[@"clAuthWindowOrientationOriginY"];
    if (clAuthWindowOrientationCenterX && clAuthWindowOrientationOriginY) {
        clOrientationLayOutLandscape.clAuthWindowOrientationOrigin = [NSValue valueWithCGPoint:CGPointMake(clAuthWindowOrientationOriginX.floatValue, clAuthWindowOrientationOriginY.floatValue)];
    }
    /**窗口大小：宽 float */
    NSNumber * clAuthWindowOrientationWidth = layOutLandscapeDict[@"clAuthWindowOrientationWidth"];
    {
        clOrientationLayOutLandscape.clAuthWindowOrientationWidth = clAuthWindowOrientationWidth;
    }
    /**窗口大小：高 float */
    NSNumber * clAuthWindowOrientationHeight= layOutLandscapeDict[@"clAuthWindowOrientationHeight"];
    {
        clOrientationLayOutLandscape.clAuthWindowOrientationHeight = clAuthWindowOrientationHeight;
    }
    return clOrientationLayOutLandscape;
}

- (void)finishAuthControllerCompletion:(FlutterResult)completion{
    [CLShanYanSDKManager finishAuthControllerAnimated:YES
                                           Completion:^{
        if (completion) {
            completion(nil);
        }
    }];
}


-(void)startAuthentication:(FlutterResult)authenticationListener{
    [CLShanYanSDKManager mobileCheckWithLocalPhoneNumberComplete:^(CLCompleteResult * _Nonnull completeResult) {
        if (authenticationListener) {
            authenticationListener([ShanyanPlugin completeResultToJson:completeResult]);
        }
    }];
}




// 获取栈顶 UIViewController
- (UIViewController *)findVisibleVC {
    UIViewController *visibleVc = nil;
    UIWindow *visibleWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (!window.hidden && !visibleWindow) {
            visibleWindow = window;
        }
        if ([UIWindow instancesRespondToSelector:@selector(rootViewController)]) {
            if ([window rootViewController]) {
                visibleVc = window.rootViewController;
                break;
            }
        }
    }
    
    return visibleVc ?: [[UIApplication sharedApplication].delegate window].rootViewController;
}
@end
