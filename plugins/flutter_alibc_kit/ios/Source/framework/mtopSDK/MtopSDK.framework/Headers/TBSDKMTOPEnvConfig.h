//
//  TBSDKMTOPEnvConfig.h
//  MtopSDK
//
//  Created by wuchen.xj on 2019/1/22.
//  Copyright © 2019年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 默认 MTOP 网关域名，分别为线上、预发、日常
 */
#define DEFAULT_MTOP_GATEWAY_RELEASE    @"acs.m.taobao.com"
#define DEFAULT_MTOP_GATEWAY_DEBUG      @"acs.wapa.taobao.com"
#define DEFAULT_MTOP_GATEWAY_DAILY      @"acs.waptest.taobao.com"


/**
 * MTOP 环境类型
 */
typedef NS_ENUM(NSInteger,MtopEnvironment) {
    environmentDebug =  1,     // 预发环境
    environmentDaily,          // 日常环境
    environmentDailyTwo,       // 日常二套环境
    environmentRelease         // 正式环境
};


typedef NS_OPTIONS(NSUInteger, MtopType) {
    kTypeInner  = 0,
    kTypeOpen   = 1
};

/**
 * 签名接口
 */
@protocol TBSDKSignProtocol <NSObject>

/**
 * 老签名接口v5.1
 */
- (NSString *)signWithAppkey:(NSString *)appkey
                withAuthCode:(NSString *)authcode
                 withApiName:(NSString *)apiName
              withApiVersion:(NSString *)apiVersion
                    withData:(NSDictionary *)data
                 withHeaders:(NSDictionary *)headers;

/**
 * 新签名接口v6.2/6.3
 */
- (NSDictionary *)getSecurityFactors:(NSString *)appkey
                        withAuthCode:(NSString *)authcode
                         withApiName:(NSString *)apiName
                      withApiVersion:(NSString *)apiVersion
                            withData:(NSDictionary *)data
                         withHeaders:(NSDictionary *)headers
                          withUseWua:(BOOL)useWua
                     withEnvironment:(NSInteger)env;
@end


/**
 * 底层MTOPSDK环境配置
 */
@interface TBSDKMTOPEnvConfig : NSObject



/**
 * 是否使用安全保镖, 二三方版本强制为YES
 */
@property (nonatomic, assign)   BOOL    useSecurityGuard;


/**
 * 在使用安全保镖的情况下，如果存在多张安全图片的场景，指定当前实例使用哪张图片。
 * 例如安全图片文件名为：yw_1222.jpg 或 yw_1222_mwua.jpg , 其中前者的auth code 为 “”，
 * 后者的auth code 为 “mwua”，所有安全图片均以 yw_1222 为前缀。
 */
@property (nonatomic, strong)   NSString    *authCode;


/**
 * App Key.
 * 若 useSecurityGuard=NO，该值需要上层自己来设置；否则SDK根据环境和authCode自动通过
 * 无线保镖SDK读取出存储在安全图片中的appkey.
 */
@property (nonatomic, strong)   NSString    *appkey;


/**
 * App Secret.
 * 若 useSecurityGuard=NO，该值需要上层自己来设置；否则SDK根据环境和appKey自动通过
 * 无线保镖SDK读取出存储在安全图片中的appSecret.
 */
@property (nonatomic, strong)   NSString    *appSecret;


/**
 * 自定义从安全图片中指定位置读取appkey.
 * 正常情况下，一张安全图片中同时存在三个环境的appkey, 线上、预发、日常，分别存储在安全图片的
 * 内部 index 为 0、1、2 的位置，SDK 会自动根据当前环境取对应位置上的appkey。但若业务需要
 * 自定义在指定索引位置读取，则可以通过该参数来设置。
 *
 * 因涉及无线保镖，故该参数只在 useSecurityGuard=YES 的情况下有效.
 */
@property (nonatomic, assign)   NSUInteger  appkeyIndex;


/**
 * 当前MTOP网关，默认情况下，其值为：
 * 线上：DEFAULT_MTOP_GATEWAY_RELEASE
 * 预发：DEFAULT_MTOP_GATEWAY_DEBUG
 * 日常：DEFAULT_MTOP_GATEWAY_DAILY
 *
 * 若业务需要自定义域名，可直接覆写该变量。注意，若业务自己覆写，则需要自行处理线上、预发、日常三个不同环境。
 */
@property (nonatomic, strong)   NSString    *gatewayDomain;



/**
 * 业务配置版本号，用于交易单元化持久化配置
 */
@property (atomic, copy)    NSString    *appConfVersion;


/**
 * 交易单元域名列表，由外部初始化时设置。
 * index 0 : 线上环境
 * index 1 : 预发环境
 * index 2 : 日常环境
 */
@property (atomic, strong)   NSArray *tradeUnitDomainList;


/**
 * 交易API列表
 */
@property (atomic, strong)  NSArray *needUpdateTradeUnitList;


/**
 * 是否开启HTTPS, 默认YES.
 * YES: mtop http url 以 'https://' 开头；
 * NO: mtop http url 以 'http://' 开头.
 * 注意：若该变量为 NO，会强制全局为 http；若该变量设置为 YES, 请求维度仍可单独降级为 http.
 */
@property (nonatomic, assign)   BOOL    enableHttps;


/**
 * 登录态下，当前用户UID
 */
@property (nonatomic, strong)   NSString    *uid;


/**
 * 该接口废弃。
 */
@property (nonatomic, strong)   NSString    *customMtopRequestURL DEPRECATED_MSG_ATTRIBUTE("请使用 gatewayDomain 代替");


/**
 * 该接口废弃。
 */
@property (nonatomic, assign) MtopEnvironment   environment DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");


/**
 * 该接口废弃。
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
 * 设置环境。
 */
+ (void)setEnvironment:(MtopEnvironment)env;


/**
 * 获取环境。
 */
+ (MtopEnvironment)currentEnvironment;


/**
 * 获取当前实例ID。
 */
- (NSString *)ID;


/**
 * appkey
 */
- (NSString *)appkey;


/**
 * UTDID
 */
- (NSString *)readUtdid;


/**
 * 重新从磁盘加载交易单元配置信息
 */
- (void)fetchTradeUnitListFromDisk;


/**
 * 签名实现注入。
 * 注意：同一个实例，只准在初始化中注入一次，不容许重复注入！
 */
- (void)setupSignHandler:(id<TBSDKSignProtocol>)handler;


/**
 * 签名接口。
 */
- (id<TBSDKSignProtocol>)signHandler;


/**
 * 工具函数, URL Encoding.
 */
+ (NSString *)urlEncodeString:(NSString *) string;

@end
