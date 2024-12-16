//
//  TBSDKConfiguration.h
//  mtopext
//
//  mtop setting 统一入口
//
//  Created by wuchen.xj on 02/15/2019.
//  Copyright (c) 2019年 Taobao. All rights reserved..
//

#import <Foundation/Foundation.h>
#import <MtopSDK/TBSDKThreadSafeMutableDictionary.h>
#import <MtopSDK/TBSDKMTOPEnvConfig.h>
#import <mtopext/TBSDKAccountInfo.h>

#pragma mark - 环境定义

/**
 * 环境类型。
 */
typedef NS_ENUM(NSUInteger,TBSDKEnvironment) {
    
    /**
     * 正式环境
     */
    TBSDKEnvironmentRelease = 4,
    
    /**
     * 预发环境
     */
    TBSDKEnvironmentDebug = 1,
    
    /**
     * 日常环境
     */
    TBSDKEnvironmentDaily = 2,
    
    /**
     * 日常二套环境(废弃)
     */
    TBSDKEnvironmentDailyTwo DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除")
    
};


#pragma mark - 配置接口定义
/**
 * 实体类存储着TBSDK的配置信息。
 */
@interface TBSDKConfiguration : NSObject


/**
 * 是否使用安全保镖, 二三方版本强制为YES
 */
@property (nonatomic, assign) BOOL  safeSecret;


/**
 * 在使用安全保镖的情况下，如果存在多张安全图片的场景，指定当前实例使用哪张图片。
 * 例如安全图片文件名为：yw_1222.jpg 或 yw_1222_mwua.jpg , 其中前者的auth code 为 “”，
 * 后者的auth code 为 “mwua”，所有安全图片均以 yw_1222 为前缀。
 */
@property (nonatomic, strong) NSString  *authCode;


/**
 * App Key.
 * 若 useSecurityGuard=NO，该值需要上层自己来设置；否则SDK根据环境和authCode自动通过
 * 无线保镖SDK读取出存储在安全图片中的appkey.
 */
@property (nonatomic, copy) NSString    *appKey;



/**
 * App Secret.
 * 若 useSecurityGuard=NO，该值需要上层自己来设置；否则SDK根据环境和appKey自动通过
 * 无线保镖SDK读取出存储在安全图片中的appSecret.
 */
@property (nonatomic, strong) NSString  *appSecret;


/**
 * 自定义从安全图片中指定位置读取appkey.
 * 正常情况下，一张安全图片中同时存在三个环境的appkey, 线上、预发、日常，分别存储在安全图片的
 * 内部 index 为 0、1、2 的位置，SDK 会自动根据当前环境取对应位置上的appkey。但若业务需要
 * 自定义在指定索引位置读取，则可以通过该参数来设置。
 *
 * 因涉及无线保镖，故该参数只在 useSecurityGuard=YES 的情况下有效.
 */
@property (nonatomic, assign) NSUInteger    appkeyIndex;


/**
 * 网关给设备分配的ID, SDK启动时自动异步获取，在获取成功前，取上一次的缓存值。
 */
@property (nonatomic, copy) NSString    *deviceID;



/**
 * App版本号。
 * 用户可自定义，如未自定义，自动读取主bundle版本号。
 */
@property (nonatomic, copy) NSString  *appVersion;



/**
 * 无线埋点的 ttid (渠道号)。
 */
@property (nonatomic, copy) NSString    *wapTTID;


/**
 * 当前MTOP网关，默认情况下，其值为：
 * 线上：acs.m.taobao.com
 * 预发：acs.wapa.taobao.com
 * 日常：acs.waptest.taobao.com
 *
 * 若业务需要自定义域名，可直接覆写该变量。注意，若业务自己覆写，则需要自行处理线上、预发、日常三个不同环境。
 */
@property (nonatomic, strong)   NSString    *gatewayDomain;



/**
 * 本地时间与服务器的时间差(秒)，TBSDK负责联网获取
 * 注意，只有 kMtopInner 类型网关才有此能力。
 */
@property (nonatomic, assign) NSTimeInterval  timestampOffset;


/**
 * MTOP 多套测试环境配置.
 * 若该参数>0, 报文中会增加 tb_eagleeyex_scm_project 头。
 */
@property (nonatomic, copy) NSString    *tproject;


/**
 * MTOP 测试环境配置.
 * 若该参数有值, 报文中会增加 x-debug-id 头。
 */
@property (nonatomic, copy) NSString    *debugId;


/**
 * 协议能力flag, 报文中 x-features 头。内部生成。
 */
@property(atomic, assign, readonly)  uint64_t features;


/**
 * UTDID
 */
@property (nonatomic, copy) NSString *utdid;


/**
 * UID
 */
@property (nonatomic, copy) NSString *uid;


/**
 * 经纬度，报文中 x-location 头。
 */
@property (nonatomic, assign) double longitude;


/**
 * 经纬度，报文中 x-location 头。
 */
@property (nonatomic, assign) double latitude;


/**
 * 设置是否支持开放用户, 影响 x-features 头
 * 注: 为何变量名叫 OpenAccsOut ? 笔误？MTOP 迷案....
 */
@property (assign, nonatomic) BOOL supportOpenAccsOut;


/**
 * 全局错误信息，请慎用
 */
@property (nonatomic, copy) NSString *customErrorMessage;


/**
 * 全局扩展参数和data参数平级
 */
@property (nonatomic, strong) TBSDKThreadSafeMutableDictionary  *globalExtData;


/**
 * 交易单元域名列表，由外部初始化时设置。
 * index 0 : 线上环境
 * index 1 : 预发环境
 * index 2 : 日常环境
 */
@property (nonatomic, strong) NSArray   *tradeUnitDomains;



/**
 * 是否关闭获取deviceID能力.默认为NO.
 * 某些网关(例如Lazada) 没有获取deviceId的能力，设置为YES关闭该能力。
 */
@property (nonatomic, assign) BOOL  isDisableNewDeviceID;



/**
 * 是否关闭获取deviceID能力.默认为NO.
 * 某些网关(例如Lazada) 没有获取deviceId的能力，设置为YES关闭该能力。
 */
@property (nonatomic, assign) BOOL  isSwitchOffGetServerTime;



/**
 * 是否开启HTTPS, 默认YES.
 * YES: mtop http url 以 'https://' 开头；
 * NO: mtop http url 以 'http://' 开头.
 * 注意：若该变量为 NO，会强制全局为 http；若该变量设置为 YES, 请求维度仍可单独降级为 http.
 */
@property (nonatomic, assign) BOOL  enableHttps;



/**
 * 自定义SDK 网络错误文案。若非国际化要求，需要特定编码文本，请不要设置该文案。
 */
@property (nonatomic, copy)  NSString   *networkErrorMsg;



/**
 * 自定义SDK 防刷限流错误文案。若非国际化要求，需要特定编码文本，请不要设置该文案。
 */
@property (nonatomic, copy)  NSString   *flowLimitErrorMsg;



/**
 * 自定义SDK 服务端错误文案。若非国际化要求，需要特定编码文本，请不要设置该文案。
 */
@property (nonatomic, copy)  NSString   *serviceErrorMsg;



/**
 *  MTOP请求关联的当前VC 或 页面名称
 */
@property(atomic, copy) NSString    *pageName;



/**
 * MTOP请求关联的当前请求的 URL
 */
@property(atomic, copy) NSString    *pageUrl;



/**
 * 运行时存放了与登录相关账户信息，如uid、sid
 */
@property (nonatomic, strong) TBSDKAccountInfo  *accountInfo DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");;

/**
 *  ISV需要用到
 */
@property (nonatomic, copy) NSString    *securityAppKey;



/**
 * 以下废弃参数
 */
@property (nonatomic, assign) TBSDKEnvironment environment DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");
@property (nonatomic, copy) NSString    *appName DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");
@property (nonatomic, copy) NSString    *topAPIURL DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");
@property (nonatomic, copy) NSString    *wapAPIURL DEPRECATED_MSG_ATTRIBUTE("使用 gatewayDomain 代替");
@property (nonatomic, copy) NSString    *mtopOriginalUrl DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");
@property (nonatomic, copy) NSString    *topOriginalUrl DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");
@property (nonatomic, copy) NSString    *wapAPISecurityURL DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");
@property (nonatomic, copy) NSString    *defaultDomain DEPRECATED_MSG_ATTRIBUTE("使用 gatewayDomain 代替");


/**
 * 获取默认配置，默认配置类型为二方类型 kTypeInner. 该方法线程安全。
 * 说明，为了避免业务配置到错误的类型configure，推荐使用新API: shareInstanceWithType: 来获取对象。
 * @return 配置实例
 */
+ (instancetype)shareInstance DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");


/**
 * 通过实例ID来获取对应实例。其中已经内置ID为 MTOP_ID_INNER 与 MTOP_ID_OPEN 实例, 如果需要新增实例，请通过
 * mtopsdk_configuration.plist 配置文件来新增实例，只有在 plist 中注册过的ID，才可以使用。配置文件配置规则(示例)如下：
 *
 * ROOT (dictionary)
 *  |---ExternalInstances (dictionary)
 *            |---- @"id1":@"0" (0 表示该实例类型为二方实例)
 *            |-----@"id2":@"1" (1 表示该实例类型为三方实例)
 *
 * 注意：ID为 MTOP_ID_INNER 与 MTOP_ID_OPEN 实例不可在配置文件中修改类型，已经分别设置为二方、三方实力。若不是
 *      MTOP_ID_INNER 与 MTOP_ID_OPEN，且名称未在plist中注册，返回nil.
 *
 * @param Id 索引MTOP实例的KEY值。可以为 MTOP_ID_INNER/MTOP_ID_OPEN 或者定义在 mtopsdk_configuration.plist 中
 * @return MTOP实例。若非内置实例且名称未注册，则返回nil.
 */
+ (instancetype) shareInstanceWithID:(NSString *)Id;


/**
 * 获取当前实例ID。
 */
- (NSString *)ID;


/**
 * 获取当前实例类型。
 */
- (MtopType)type;


/**
 * 打开全站https(默认全站开启HTTPS)
 * 该功能为历史功能，目前已经全面切为全站HTTTPS, 已废弃。
 */
- (void) enableAllSiteHttps DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");



/**
 * 关闭全站https(默认全站开启HTTPS)
 * 该功能为历史功能，目前已经全面切为全站HTTTPS, 已废弃。
 */
- (void) disableAllSiteHttps DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");



/**
 * 开启白盒秘钥
 * 该功能为历史功能，目前已经全站开启白盒秘钥, 该配置已废弃。
 */
- (void) enableWhiteSecurity DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");



/**
 * 关闭白盒秘钥
 * 该功能为历史功能，目前已经全站开启白盒秘钥, 该配置已废弃。
 */
- (void) unableWhiteSecurity DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");



/**
 * 设置一个应用级别的请求头, 注意 设置的值不会被持久化，只是在应用生命周期内有效
 * @param key 参数名称
 * @param value 参数值
 *
 */
- (void) setApplicationRequestHeader: (NSString*) value forKey: (NSString*) key;



/**
 * 获取一个应用级别的请求头的值
 * @param name 参数名称
 * @return setApplicationRequestHeader设置的值
 */
- (NSString*) getApplicationRequestHeader: (NSString*) name;



/**
 * 获取当前的应用级别的请求头
 * @return 全部KV
 */
- (NSDictionary*) getCurrentApplicationRequestHeader;



/**
 * 移除一个应用级别的请求头
 * @param name
 *
 */
- (void) removeApplicationRequestHeader: (NSString*) name;



/**
 * 移除所以应用级别的请求头
 * @param name
 *
 */
- (void) removeAllApplicationRequestHeader;



/**
 * 设置一个应用级别的请求但不需要URL-Encoding的头, 注意 设置的值不会被持久化，只是在应用生命周期内有效
 * @param key 参数名称
 * @param value 参数值
 *
 */
- (void) setApplicationRequestHeaderWithoutEncoding: (NSString*) value forKey: (NSString*) key;




/**
 * 获取当前的应用级别的请求头
 * @return 全部KV
 */
- (NSDictionary*) getCurrentApplicationRequestHeaderWithoutEncoding;



/**
 * 从磁盘加载配置参数
 */
- (void) loadAVCV;



/**
 *  获取当前发送MTOP请求所在VC
 */
- (NSString*)currentPageName;



/**
 *  获取当前发送MTOP请求所在容器访问的URL
 */
- (NSString*)currentPageUrl;



/**
 * 设置环境. 该参数只有类型为二方(kTypeInner)时起作用，其有两层作用：
 *
 * 1）指定网关: 在二方环境中，阿里的默认的做法都是分为线上、预发、日常三套环境，不同环境指向不同的网关域名，
 *   若为二方环境，这些域名都已经内置，APP只要设置环境即可；
 * 2）指定Appkey/Appsecrect: 在二方环境中, 为保证安全，其Appkey/Appsecrect一般都是保存在无线保镖的
 *   的安全文件中，SDK 通过该参数，可以直接通过无线保镖SDK读取所需要的Appkey，以及加签等动作。
 *
 * 若为三方(kTypeOpen)类型，则该参数忽略。
 */
+ (void)setEnvironment:(TBSDKEnvironment)env;



/**
 * 当前环境
 */
+ (TBSDKEnvironment)currentEnvironment;


/**
 * 全局默认实例ID。
 * 该值从 MTOP SDK 配置文件 mtopsdk_configuration.plist 中的 DefaultID 字段读取，若没有该配置文件，
 * 默认返回 MTOP_ID_INNER。该参数在 mtopsdk_configuration.plist 文件中配置:
 *
 * Root (Dictionary)
 *  |
 *  |---DefaultID : @"INNER" (@"INNER" 内置二方实例; @“OPEN” 内置三方实例；或其他自定义实例 )
 */
+ (NSString *)defaultID;


//! 请将api字符串转换为小写
+ (void)addEcodeSignAPI:(NSArray *)API;

+ (NSDate *)timeStampFixedWithServer;


@end
