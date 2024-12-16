/*
 * WVWKWebView.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVWebViewDelegate.h"
#import "WVWebViewProtocol.h"
#import <WebKit/WebKit.h>


NS_CLASS_AVAILABLE_IOS(8_0)
@interface WVWKWebView : WKWebView <WVWebViewProtocol>

/**
 * 挂载的归属源 UIViewController
 */
@property (nonatomic, weak) UIViewController * sourceViewController;

#pragma mark - Load Request

/**
 * 当前加载的请求
 */
@property (nonatomic, readonly, copy) NSURLRequest * request;

#pragma mark - Delegate

/**
 * 当前 WebView 的委托。
 */
@property (nonatomic, weak) id<WVWebViewDelegate> windVaneDelegate;

/**
 * WKWebView 默认的 navigationDelegate 与 UIWebView 无法兼容，因此请使用 windVaneDelegate。
 */
@property (nonatomic, weak) id<WKNavigationDelegate> navigationDelegate DEPRECATED_MSG_ATTRIBUTE("请使用 windVaneDelegate");

#pragma mark - Life cycle

/**
 * [注意：必须在 ViewController 的 viewWillDisappear 中调用!!!] 释放 WebView 的服务。
 */
- (void)releaseWebViewService;

/**
 * [注意：必须在 ViewController 的 viewWillAppear 中调用!!!] 重新绑定 WebView 的服务。
 */
- (void)bindingWebViewService;

#pragma mark - JSBridge

/**
 * 是否开启 JSBridge 服务，默认为 NO。
 */
@property (nonatomic, assign, getter=isOpenLocalService) BOOL openLocalService;

/**
 执行一次 WKWebView 的 Cookie 同步。
 */
+ (void)syncCookie;

@end
