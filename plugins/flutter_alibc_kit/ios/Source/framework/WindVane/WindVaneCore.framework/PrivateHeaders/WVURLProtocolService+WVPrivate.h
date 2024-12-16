/*
 * WVURLProtocolService.h
 *  
 * Created by WindVane.
 * Copyright (c) 2014年 阿里巴巴-无线事业部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVURLProtocolService.h>
#import "WVURLProtocolProcessor.h"

/**
 CacheHandler 的 userInfo 中保存额外 header 的键。
 */
FOUNDATION_EXPORT NSString * const WVURLProtocolExternalHeadersKey;

/**
 缓存的来源的键。
 */
FOUNDATION_EXPORT NSString * const WVURLProtocolCacheFromTypeKey;

/**
 * WVURLProtocol 的数据来源。
 */
typedef NS_ENUM(NSInteger, WVURLProtocolReadFromType) {
	/**
	 * 走网络。
	 */
	WVURLProtocolReadFromNetwork = 1,
	/**
	 * 走内存缓存。
	 */
	WVURLProtocolReadFromMemoryCache = 22,
	/**
	 * 走磁盘缓存。
	 */
	WVURLProtocolReadFromDiskCache = 23,
	// 预加载来源
	// 来自 PackageApp。
	// ZCacheResourceFromPackageApp = 3,
	// 来自 ZCache 1.0。
	// ZCacheResourceFromZCache1 = 4,
	// 来自解 Combo。
	// ZCacheResourceFromCombo = 8,
	// 来自 ZCache 2.0。
	// ZCacheResourceFromZCache2 = 9,
};

/**
 * WVURLProtocolService 的私有方法。
 */
@interface WVURLProtocolService (WVPrivate)

#pragma mark - Scheme

/**
 * 注册会被拦截的 Scheme。
 *
 * @param scheme 会被拦截的 Scheme。
 */
+ (void)registerScheme:(NSString *)scheme;

/**
 * 返回指定请求的 Scheme 是否会被拦截。
 */
+ (BOOL)containsScheme:(NSURLRequest *)request;

#pragma mark - Rewriter

/**
 * 重写指定的请求，后注册的重写器会先被调用。
 */
+ (BOOL)rewrite:(NSMutableURLRequest *)request;

#pragma mark - UserAgent

/**
 * 返回指定请求是否包含 UserAgent 标记。
 *
 * @param request     要检查的请求。
 * @param checkCustom 是否检查自定义 UserAgent 标记。
 */
+ (BOOL)containsUserAgentMark:(NSURLRequest *)request checkCustom:(BOOL)checkCustom;

#pragma mark - PageRequest

/**
* 将指定请求标记为页面 URL。
*/
+ (void)markAsPageURL:(NSString *)urlString;

/**
 * 返回指定的 URL 是否表示页面 URL。
 * 如果返回了 YES，就会移除此页面的标记。
 */
+ (BOOL)isPageURL:(NSString *)urlString;

#pragma mark - WVURLProtocolProcessor

/**
 注册指定的 URLProtocolProcessor 类，仅限 ARiver 使用。
 */
+ (void)registerURLProtocolProcessorClass:(Class<WVURLProtocolProcessor>)processorClass;

/**
 返回注册指定的 URLProtocolProcessor 类，仅限 ARiver 使用。
 */
+ (Class<WVURLProtocolProcessor>)registeredURLProtocolProcessorClass;

@end
