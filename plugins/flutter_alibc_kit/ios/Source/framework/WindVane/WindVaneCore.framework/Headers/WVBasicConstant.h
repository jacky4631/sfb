/*
 * WVBasicConstant.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

#pragma mark Notification

// 表示 WebView 加载的页面 URL 的键。
FOUNDATION_EXPORT NSString * _Nonnull const WVWebViewURLKey;
// 表示 WebView 页面加载失败信息的键。
FOUNDATION_EXPORT NSString * _Nonnull const WVWebViewErrorKey;

/**
 * WebView 的页面加载成功通知。
 * @WVWebViewURLKey 当前 WebView 的页面 URL。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WVWebViewFinishLoadNotification;

/**
 * WebView 的页面加载失败通知。
 * @WVWebViewURLKey   当前 WebView 的页面 URL。
 * @WVWebViewErrorKey 加载失败的错误信息。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WVWebViewFailLoadNotification;

/**
 * WebView 的切到后台通知。
 * @WVWebViewURLKey 当前 WebView 的页面 URL。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WVWebViewDisappearNotification;

/**
 * WebView 的切到前台通知。
 * @WVWebViewURLKey 当前 WebView 的页面 URL。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WVWebViewAppearNotification;

/**
 * WKWVWebView 受到用户手势操作的通知。
 */
FOUNDATION_EXPORT NSString * _Nonnull const WVWKWebViewReceiveUserActionNotification;

#pragma mark JS Event

// App 激活的 JS 事件名称。
FOUNDATION_EXPORT NSString * _Nonnull const WVEventAppActive;
// App 退到后台的 JS 事件名称。
FOUNDATION_EXPORT NSString * _Nonnull const WVEventAppBackground;
// 页面无限滚动的 JS 事件名称。
FOUNDATION_EXPORT NSString * _Nonnull const WVEventPageInfiniteScroll;
