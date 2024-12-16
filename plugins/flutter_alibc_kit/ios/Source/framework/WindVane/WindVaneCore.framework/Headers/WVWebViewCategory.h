/*
 * WVWebViewCategory.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVWebViewBasicProtocol.h"
#import <WebKit/WebKit.h>

#pragma mark - WKWebViewCategory

/**
 * 针对 WKWebview 的 Category.
 */
@interface WKWebView (WVWKWebViewCategory) <WVWebViewBasicProtocol>

/**
 * 加载指定的请求，并选择是否添加默认参数（由 [WVUserConfig setDefaultParamForFirstLoad:] 设置）。
 */
- (void)loadRequest:(NSURLRequest *)request withDefaultParam:(BOOL)useDefaultParam;

/**
 * 加载指定的 URL。
 */
- (void)loadURL:(NSString *)url;

/**
 * 加载指定的 URL，并选择是否添加默认参数（由 [WVUserConfig setDefaultParamForFirstLoad:] 设置）。
 */
- (void)loadURL:(NSString *)url withDefaultParam:(BOOL)useDefaultParam;

/**
 * 向当前 WebView 发送事件，并返回事件是否被 JS 取消默认行为。
 * 允许在任意线程调用，并总是在主线程回调。
 */
- (void)dispatchEvent:(NSString *)eventName withParam:(id)param withCallback:(void (^)(NSString * eventName, BOOL isPreventDefault))callback;

// 执行 JavaScript 字符串，同步执行。
// 已废弃，请使用 [WKWebView evaluateJavaScript:completionHandler:] 方法。
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script DEPRECATED_ATTRIBUTE;

@end
