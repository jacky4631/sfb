/*
 * WVBasic.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVUserConfig.h>

/**
 * 初始化 WindVane Basic 模块。
 * WindVane 基础 WebView 库，提供了一些 WebView 相关基础功能，包括 WebView、JSBridge、URLInterceptor、ViewController、StandardEventModal 模块。
 */
@interface WVBasic : NSObject

/**
 * 初始化 WindVane Basic 模块，会自动初始化 WindVane Core 模块。
 */
+ (void)setup;

#pragma mark - UserAgent

/**
 返回浏览器的默认 UserAgent。
 
 @return 该方法第一次调用时的默认 UserAgent。
 */
+ (NSString *)defaultUserAgent;

/**
 返回 WindVane 的 UserAgent。
 
 @return WindVane 的 UserAgent。
 */
+ (NSString *)userAgent;

/**
 要求 WindVane 不要影响客户端的全局 UserAgent，在 WebView 自有 UserAgent 修改失败时，可能会导致 UserAgent 缺失 AliApp 和 WindVane 标记。
 */
+ (void)doNotChangeUserAgent;

/**
 修改全局 UserAgent，多次调用只有第一次生效。
 没有特殊必要请不要调用此方法来修改全局 UserAgent，WindVane 会优先使用 WebView 级别的 UserAgent，避免对非 WindVane 的 WebView 产生影响。
 */
+ (void)changeUserAgent;

#pragma mark - ScrollIndicator

/**
 * 获取默认是否显示垂直滚动条指示器。
 */
+ (BOOL)showsVerticalScrollIndicator;

/**
 * 设置默认是否显示垂直滚动条指示器，默认为 YES。
 */
+ (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator;

#pragma mark - JavaScript Log

/**
 * 获取 JavaScript 日志的级别，默认为 WVLogLevelOff。
 */
+ (WVLogLevel)JSLogLevel;

/**
 * [仅限 DEBUG 包]设置 JavaScript 日志的级别。
 * 设置后，只会在新创建的 WebView 生效。
 */
+ (void)setJSLogLevel:(WVLogLevel)logLevel;

#pragma mark - Xcode8 Compatible

/**
 在 iOS11 上对 Xcode8 打包的模式做兼容，仍在使用 Xcode8 编译的客户端必须设置。
 */
+ (void)xcode8Compatible;

/**
 获取是否在 iOS11 上对 Xcode8 打包的模式做兼容。
 */
+ (BOOL)isXcode8Compatible;

#pragma mark - 其它设置（功能验证）

/**
 设置额外的配置。
 */
+ (void)setExternalConfig:(NSDictionary *)externalConfig;

/**
 获取额外的配置。
 */
+ (NSDictionary *)externalConfig;

#pragma mark - 已废弃，预计于 2020.05 移除

/**
 只要开启了 [WVURLProtocolService setSupportWKURLProtocol:YES]，就会自动同步 cookie 和补充 POST Body。
 不再支持手动设置。
 */
+ (BOOL)syncWKWebViewCookie DEPRECATED_ATTRIBUTE;
+ (void)setSyncWKWebViewCookie:(BOOL)syncWKWebViewCookie DEPRECATED_ATTRIBUTE;
+ (BOOL)fixWKWebViewPostBody DEPRECATED_ATTRIBUTE;
+ (void)setFixWKWebViewPostBody:(BOOL)fixWKWebViewPostBody DEPRECATED_ATTRIBUTE;

@end
