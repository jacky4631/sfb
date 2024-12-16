/*
 * WVRequestInterceptor.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVNavigation.h"
#import "WVWebViewProtocol.h"
#import <Foundation/Foundation.h>

/**
 表示 WebView 的通用请求拦截器协议，可以在客户端的 WebView 中做通用拦截。
 */
@protocol WVRequestInterceptorProtocol <NSObject>

@required

/**
 是否拦截指定请求。

 @param webView    当前 WebView
 @param request    当前请求
 @param navigation 当前导航信息

 @return 如果要拦截指定请求，由拦截器处理，则为 YES；否则为 NO，由 WebView 自行处理。
 */
- (BOOL)webView:(UIView<WVWebViewProtocol> * _Nonnull)webView canInterceptRequest:(NSURLRequest * _Nonnull)request withNavigation:(WVNavigation * _Nonnull)navigation;

@end

/**
 表示 WebView 的请求拦截器，可以在客户端的 WebView 中做通用拦截。
 */
@interface WVRequestInterceptor : NSObject

/**
 注册一个前置请求拦截器，会在 WebView Delegate 之前执行拦截。

 @param interceptor 要注册的请求拦截器。
 */
+ (void)registerPreRequestInterceptor:(id<WVRequestInterceptorProtocol> _Nonnull)interceptor;

/**
 注册一个后置请求拦截器，会在 WebView Delegate 之后执行拦截。

 @param interceptor 要注册的请求拦截器。
 */
+ (void)registerRequestInterceptor:(id<WVRequestInterceptorProtocol> _Nonnull)interceptor;

@end
