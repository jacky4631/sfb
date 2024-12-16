/*
 * AlibcConfigService.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "AlibcTradeTaokeParams.h"
#import "AlibcTradeSDKConfigModel.h"
#import "AlibcTradeSDKESConfigModel.h"


#ifndef AlibcConfigService_h
#define AlibcConfigService_h
#define YBHPSS @"ybhpss" //全链路打通数据参数

@interface AlibcConfigService : NSObject

+ (instancetype)sharedConfig;

- (void)updateConfig;

/*包含ttid的拼装规则*/
@property(nonatomic, readonly) NSString *ttid;
@property(nonatomic, strong) NSString *isvVersion;
@property(nonatomic, copy, readwrite) NSString *channelName;
@property(nonatomic, copy, readwrite) NSString *channelType;
@property(nonatomic, readonly) NSString *channel;
@property(nonatomic, strong) NSString *alizfRequestSender;


// 全局授权登录重试次数
@property(nonatomic, assign)NSInteger reTryCount;
// 已经重试次数
@property(nonatomic, assign)NSInteger hasRryCount;

//全局淘客参数
@property(nonatomic, strong) AlibcTradeTaokeParams *taokeParams;
/* isvCode，tag*/
@property(atomic, strong) NSString *isvCode;

/** 系统版本信息,SDK版本 */
@property(atomic, copy) NSString *sdkVersion;

//淘客打点是否使用同步换url的方式
- (BOOL)isSyncForTaoke;

// 默认YES.
- (BOOL)isNeedAlizfNative;

//设置是否检测WebView
- (void)setNeedAlizfNative:(BOOL)need;

//是否登陆降级(不触发登陆了)
- (BOOL)isLoginDegarade;

//设置是否同步打点
- (void)setIsSyncForTaoke:(BOOL)isSync;

//存储所有需要isv设置的配置
- (void)setIsvConfig:(id)value forKey:(NSString *)key;

- (NSString *)isvConfigForKey:(NSString *)key;

- (void)setExtUserAgent:(NSString *)extUserAgent;

- (NSString *)extUserAgent;

- (void)setBCUserAgent:(NSString *)BCUserAgent;

- (NSString *)BCUserAgent;

- (void)setNormalUserAgent:(NSString *)normalUserAgent;

- (NSString *)normalUserAgent;

// 电商配置信息
- (AlibcTradeSDKConfigModel *)getTradeSDKConfig;

// 电商套件页面配置信息
- (AlibcTradeSDKESConfigModel *)getESTradeConfig;

// SDK func
- (NSError *)testSDKFunc:(NSString *)func;

// allow link
- (NSError *)testLinkFunc;

@end
#endif //AlibcConfigService_h
