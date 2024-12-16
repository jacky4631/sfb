/*
 * WVURLProtocolService.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

// WindVane 请求重写的阶段。
typedef NS_ENUM(NSInteger, WVRequestPhase) {
	// 请求导航阶段（WebView shouldStartLoadWithRequest），此时重写会导致 WebView 重新加载请求。
	WVRequestPhaseNavigation DEPRECATED_MSG_ATTRIBUTE("导航阶段重写改为使用 WVRequestInterceptor，不再使用 WVRequestRewriterProtocol"),
	// 请求加载阶段（NSURLRequest startLoading），此时重写只会改变实际加载的内容。
	WVRequestPhaseLoading,
};

/**
 * WindVane 的请求重写器。
 */
@protocol WVRequestRewriterProtocol <NSObject>

/**
 * 重写指定的请求。
 * !! 请务必保证此方法稳定、健壮，否则会对所有 Web 页面造成影响 !!
 *
 * @param request 要重写的请求。
 *
 * @return 如果重写了请求，则为 YES，否则为 NO。
 */
- (BOOL)rewrite:(NSMutableURLRequest *)request phase:(WVRequestPhase)phase;

@end

/**
 * WindVane 的 URLProtocol 服务。
 */
@interface WVURLProtocolService : NSObject

/**
 * 注册一个请求重写器。
 *
 * @param rewriter 要注册的请求重写器。
 */
+ (void)registerRequestRewriter:(id<WVRequestRewriterProtocol>)rewriter;

/**
 * 注册要拦截请求的 UserAgent 标记，具有改标记的 UserAgent 可以使用 WindVane 提供的预加载功能。
 *
 * @param userAgentMark 要拦截请求的 UserAgent 标记。
 */
+ (void)registerUserAgentMark:(NSString *)userAgentMark;

/**
 * 返回是否支持 WKWebView 的 NSURLProtocol 拦截。
 */
+ (BOOL)supportWKURLProtocol;

/**
 * 设置是否支持 WKWebView 的 NSURLProtocol 拦截。
 */
+ (void)setSupportWKURLProtocol:(BOOL)supportWKURLProtocol;

@end
