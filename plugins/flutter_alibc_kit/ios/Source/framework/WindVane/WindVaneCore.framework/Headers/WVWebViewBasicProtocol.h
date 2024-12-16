/*
 * WVWebViewBasicProtocol.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVJavaScriptExecutor.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 包含了 WebView 基本功能的协议。
 */
@protocol WVWebViewBasicProtocol <WVJavaScriptExecutor>

/**
 * 与 WebView 关联的 UIScrollView。
 */
@property (nonatomic, readonly, strong, nonnull) UIScrollView * scrollView;

#pragma mark - Loading

/**
 * 加载指定的请求。
 */
- (void)loadRequest:(NSURLRequest * _Nonnull)request;

/**
 * 加载指定的 HTML 字符串和 URL，必须指定可用的 URL。
 */
- (void)loadHTMLString:(NSString * _Nonnull)string baseURL:(NSURL * _Nullable)baseURL;

/**
 * 加载指定的请求，并选择是否添加默认参数（由 [WVUserConfig setDefaultParamForFirstLoad:] 设置）。
 */
- (void)loadRequest:(NSURLRequest * _Nonnull)request withDefaultParam:(BOOL)useDefaultParam;

/**
 * 加载指定的 URL。
 */
- (void)loadURL:(NSString * _Nonnull)url;

/**
 * 加载指定的 URL，并选择是否添加默认参数（由 [WVUserConfig setDefaultParamForFirstLoad:] 设置）。
 */
- (void)loadURL:(NSString * _Nonnull)url withDefaultParam:(BOOL)useDefaultParam;

/**
 * 停止加载。
 */
- (void)stopLoading;

/**
 * 重新加载。
 */
- (void)reload;

/**
 * WebView 当前加载的 URL，是主页面的 URL，而非 iframe。
 */
@property (nonatomic, copy, readonly, nullable) NSURL * URL;

/**
 * WebView 是否正在加载内容。
 */
@property (nonatomic, assign, readonly, getter=isLoading) BOOL loading;

#pragma mark - Navigating

/**
 * 后退历史记录。
 */
- (void)goBack;

/**
 * 前进历史记录。
 */
- (void)goForward;

/**
 * 是否可以后退历史记录。
 */
@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;

/**
 * 是否可以前进历史记录。
 */
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;

/**
 * 向当前 WebView 发送事件，并返回事件是否被 JS 取消默认行为。
 * 允许在任意线程调用，并总是在主线程回调。
 */
- (void)dispatchEvent:(NSString * _Nonnull)eventName withParam:(id _Nullable)param withCallback:(void (^_Nullable)(NSString * _Nonnull eventName, BOOL preventDefault))callback;

// 【不建议使用】执行 JavaScript 字符串，同步执行。
- (NSString * _Nullable)stringByEvaluatingJavaScriptFromString:(NSString * _Nonnull)script DEPRECATED_MSG_ATTRIBUTE("请使用 evaluateJavaScript:completionHandler: 方法");

#pragma mark - Identifier

/**
 * 获取 WebView 当前页面的唯一标识。
 */
- (NSString * _Nonnull)pageIdentifier;

/**
 * 设置 WebView 当前页面的唯一标识。
 */
- (void)setPageIdentifier:(NSString * _Nonnull)pageIdentifier;

@end
