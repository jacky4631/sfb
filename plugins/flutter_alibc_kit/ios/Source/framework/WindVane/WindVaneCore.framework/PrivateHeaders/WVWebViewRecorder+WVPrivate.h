//
//  WVWebViewRecorder+WVPrivate.h
//  WindVaneBasic
//
//  Created by lianyu.ysj on 16/3/12.
//  Copyright (c) 2015年 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindVaneCore/WVWebViewRecorder.h>

/**
 * WVWebViewRecorder 的私有接口。
 */
@interface WVWebViewRecorder (WVPrivate)

/**
 * 返回共享的实例。
 */
+ (instancetype)sharedInstance;

/**
 * 报告打开了一个 WebView。
 */
- (void)reportWebViewOpen:(UIView<WVWebViewProtocol> *)webView;

/**
 * 报告一个 WebView 的显示情况发生了改变。
 */
- (void)reportVisiblityChanged:(UIView<WVWebViewProtocol> *)webView;

/**
 报告指定 WebView 加载了 URL。

 @param webView 加载 URL 的 WebView。
 @param url 被加载的 URL。
 */
- (void)reportWebView:(UIView<WVWebViewProtocol> *)webView loadURL:(NSURL *)url;

/**
 * 报告关闭了一个 WebView。
 */
- (void)reportWebViewClose:(UIView<WVWebViewProtocol> *)webView;

/**
 同步 WKWebView 的 Cookie。
 */
- (void)syncWKWebViewCookie;

/**
 设置无效的 WKWebView delegate。
 */
- (void)setInvalidWKDelegate:(NSString *)invalidWKDelegate;

@end
