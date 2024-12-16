/*
 * WVUserConfig.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * WindVane 环境设置。
 */
typedef NS_ENUM(NSUInteger, WVEnvironment) {
	WVEnvironmentDebug = 0,  // 预发环境。
	WVEnvironmentDaily = 1,  // 日常环境。
	WVEnvironmentRelease = 2 // 线上环境。
};

/**
 * WindVane 日志级别。
 */
typedef NS_ENUM(NSInteger, WVLogLevel) {
	WVLogLevelOff = 0,    // 关闭日志。
	WVLogLevelError = 1,  // 错误日志。
	WVLogLevelWarn = 2,   // 警告日志。
	WVLogLevelInfo = 3,   // 信息日志。
	WVLogLevelDebug = 4,  // 调试日志。
	WVLogLevelVerbose = 5 // 冗余日志。
};

/**
 * WindVane 配置项目。
 */
@interface WVUserConfig : NSObject

#pragma mark - 必需配置，一定要正确设置

/**
 * 设置客户端的 AppKey。AppKey 是一串数字，可以在应用中心 http://mappcenter.alibaba-inc.com/ 申请。
 */
+ (void)setAppKey:(NSString *)appKey;

/**
 * 设置是否从安全黑匣子中自动读取 AppKey，与 setAppKey: 方法必须调用其中一个。
 */
+ (void)useSafeSecert:(BOOL)isUse;

/**
 * 获取客户端的 AppKey，默认为 @""。
 */
+ (NSString *)appKey;

/**
 * 返回 AppKey 是否全部是由数字组成的。
 */
+ (BOOL)isValidAppKey;

/**
 * 设置客户端的名称，会在 UserAgent 的 AliApp 部分带上，请务必正确设置。
 * 可以参考 阿里集团客户端 UserAgent 规范 https://lark.alipay.com/velocity_cross-end-web/docs/wiki_app-ua 。
 */
+ (void)setAppName:(NSString *)appName;

/**
 * 获取客户端的名称，默认为 @""。
 */
+ (NSString *)appName;

/**
 * 设置客户端的版本号，请与客户端的实际版本号保持一致。
 */
+ (void)setAppVersion:(NSString *)appVersion;

/**
 * 获取客户端的版本号，默认使用 info.plist 中的 CFBundleShortVersionString。
 */
+ (NSString *)appVersion;

/**
 * 设置 WindVane 环境类型。
 * WindVane 环境类型请与客户端当前环境保持一致。
 */
+ (void)setEnvironment:(WVEnvironment)environment;

/**
 * 获取 WindVane 环境类型，默认为线上环境。
 */
+ (WVEnvironment)environment;

/**
 * 返回指定环境的名称。
 */
+ (NSString *)getEnvironmentName:(WVEnvironment)env;

#pragma mark - 调试配置，建议在 DEBUG 模式下打开

/**
 * 设置是否为调试模式，会开启额外的日志、检查和提示。
 */
+ (void)setDebugMode:(BOOL)isDebugMode;

/**
 * 获取是否为调试模式，默认为 NO。
 */
+ (BOOL)isDebugMode;

/**
 * 打开 WindVane 日志输出，会输出 Debug 及以上级别日志。
 */
+ (void)openWindVaneLog;

/**
 * 设置 WindVane 日志级别。
 */
+ (void)setLogLevel:(WVLogLevel)logLevel;

/**
 * 获取 WindVane 日志级别，默认为 WVLogLevelOff。
 */
+ (WVLogLevel)logLevel;

/**
 * 设置 JavaScript 日志的级别。
 * 设置后，只会在新创建的 WebView 生效。
 */
+ (void)setJSLogLevel:(WVLogLevel)logLevel;

/**
 * 获取 JavaScript 日志的级别，默认为 WVLogLevelOff。
 */
+ (WVLogLevel)JSLogLevel;

#pragma mark - 其它配置

/**
 * 设置客户端的补充 UA，会跟在 WindVane UA 的后面。
 * 可以参考 http://h5.alibaba-inc.com/windvane/H5Standard.html 。
 */
+ (void)setAppUA:(NSString *)appUA;

/**
 * 获取客户端的补充 UA。
 */
+ (NSString *)appUA;

/**
 * 设置通过 [WebView loadRequest:] 方法加载页面时带上的默认参数。
 */
+ (void)setDefaultParamForFirstLoad:(NSString *)defaultParamForFistLoad;

/**
 * 获取通过 [WebView loadRequest:] 方法加载页面时带上的默认参数。
 */
+ (NSString *)defaultParamForFistLoad;

/**
 * 设置自定义的 HTTP 请求头，会额外添加到 WebView 发出的请求头中。
 */
+ (void)setCustomHttpHeader:(NSDictionary<NSString *, NSString *> *)header;

/**
 * 获取自定义的 HTTP 请求头，会额外添加到 WebView 发出的请求头中。
 */
+ (NSDictionary<NSString *, NSString *> *)customHttpHeader;

/**
 * 设置 TTID。
 */
+ (void)setTTid:(NSString *)ttid;

/**
 * 获取 TTID。
 */
+ (NSString *)ttid;

/**
 使用指定的 bundle 和 tableName 实现 WindVane 的本地化。
 */
+ (void)localizedWithBundle:(NSBundle *)bundle fromTable:(NSString *)table;

/**
 获取 sid。
 */
+ (NSString *)sid;

/**
 设置 sid，目前主要供支付功能使用。
 */
+ (void)setSid:(NSString *)sid;

#pragma mark - [慎用]WindVane SDK 配置

/**
 [慎用]设置是否自动更新配置。
 请仅当 WindVane 默认配置已可以满足要求，或者会自行设置 WindVane 配置的情况下使用。
 */
+ (void)setConfigAutoUpdate:(BOOL)configAutoUpdate;

/**
 获取是否自动更新配置，默认为 YES。
 */
+ (BOOL)configAutoUpdate;

/**
 [慎用]设置 WindVane 的配置基础 URL。
 仅当使用独立的 WindVane 配置域名时设置，设置时必须咨询 WindVane SDK iOS 负责人 @炼玉。
 格式类似 @"https://wvcfg.alicdn.com/bizcache/5/windvane/"
 */
+ (void)setConfigBaseURL:(NSString *)baseURL;

/**
 获取 WindVane 的配置基础 URL。
 */
+ (NSString *)configBaseURL;

#pragma mark - 已废弃，删除时间未定

// 请直接使用 setAppKey: 方法。
+ (void)setAppKey:(NSString *)key secrect:(NSString *)secrect;
// WVServer.send 接口相关配置。
+ (NSString *)appSecrect;
+ (NSString *)nickName;
+ (void)setNickName:(NSString *)nickName;
+ (BOOL)isUseSafeSecert;

@end
