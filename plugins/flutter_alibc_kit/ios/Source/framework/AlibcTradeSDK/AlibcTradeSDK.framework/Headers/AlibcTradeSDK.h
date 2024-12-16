/*
 * AlibcTradeSDK.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import "AlibcTradePageFactory.h"
#import "AlibcTradeService.h"
#import <AlibcTradeBiz/AlibcTradeShowParams.h>

#define AlibcTradeSDKVersion @"4.1.0.4"

/// @brief 登录通知
extern NSString *const ALBCTradeNotificationUserLoggedIn;
/// @brief 登出通知
extern NSString *const ALBCTradeNotificationUserLoggedOut;

@interface AlibcTradeSDK : NSObject

/**
 *  AlibcTradeSDK 的单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  初始化函数,初始化成功后方可正常使用SDK中的功能
 *
 *  @param onSuccess 初始化成功的回调
 *  @param onFailure 初始化失败的回调
 */
- (void)asyncInitWithSuccess:(void (^)())onSuccess
                     failure:(void (^)(NSError *error))onFailure;

/**
 *  获取service对象,该对象包含大部分Trade相关的方法
 */
- (id<AlibcTradeService>)tradeService;

/**
 * App 回跳处理, 适用于 iOS 9 以下的回调接口

 @param application application
 @param url url
 @param sourceApplication sourceApplication
 @param annotation annotation
 @return handled or nor
 */
- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation;

/**
 * App 回跳处理, 适用于 iOS 9 起的回调接口

 @param annotation annotation
 @param url url
 @param options options
 @return handled or nor
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options
    NS_AVAILABLE_IOS(9_0);

@end

@interface AlibcTradeSDK (Settings)

- (void)setDebugLogOpen:(BOOL)isDebugLogOpen;

/**
 *  设置环境
 */
- (void)setEnv:(AlibcEnvironment)env;

/*
 *  设置是否对淘客使用同步打点
 *  默认的淘客打点方式,sdk会自己选择合适的方式,调用该接口与否不影响打点,建议开发者不要调用自己配置
 *  只有跟阿里妈妈申请了高分润的才需要设为同步
 *
 *  @param isSync 是否对淘客使用同步打点
 */
- (void)setIsSyncForTaoke:(BOOL)isSync;

/**
 *  设置三方App版本,可用于标识App版本
 *
 *  @param version 版本字段
 */
- (void)setIsvVersion:(NSString *)version;

/**
 *  设置三方App名称,可用于标识App
 *
 */
- (void)setIsvAppName:(NSString *)appName;

/**
 *  设置App标识字段,和isvcode同义,可用于区分使用本SDK的具体三方App
 *
 *  @param code isv code 字段
 */
- (void)setISVCode:(NSString *)code;

/**
 *  设置默认淘客参数
 *
 *  @param param 传入一个配置好的AlibcTradeTaokeParams作为默认淘客参数,详见 AlibcTradeTaokeParams.h
 */

- (void)setTaokeParams:(AlibcTradeTaokeParams *)param;

/**
 *  设置渠道信息,渠道专享价专用.
 *
 *  @param type 渠道类型
 *  @param name 渠道名
 */
- (void)setChannel:(NSString *)type name:(NSString *)name;

/**
 *  开启接口免授权模式,
 *  请不要随便设置,没有在后台申请相关的权限的,开启后会导致网络请求失败
 *
 */
- (void)enableAuthVipMode;

/**
 *  设置是否需要 Native AliZf 接口
 *
 *  @param shouldUseAlizf 是否需要 Native AliZf 接口
 */
- (void)setShouldUseAlizfNative:(BOOL)shouldUseAlizfNative;

@end
