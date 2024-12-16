/*
 * WVWebViewDelegate.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVUserConfig.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WVWebViewProtocol;
@class WVWKWebView;

/**
 * WindVane 的 WebView 委托。
 */
@protocol WVWebViewDelegate <NSObject, WKNavigationDelegate>

@optional

/**
 * 在加载指定请求之前调用。
 *
 * @return 如果要加载指定的请求，则返回 YES；否则返回 NO。
 */
- (BOOL)webView:(UIView<WVWebViewProtocol> *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType;

/**
 * 在将要加载指定请求时调用。
 */
- (void)webView:(UIView<WVWebViewProtocol> *)webView didStartProvisionalNavigation:(NSURLRequest *)request;

/**
 * 在开始加载新页面前调用。
 */
- (void)webViewDidStartLoad:(UIView<WVWebViewProtocol> *)webView;

/**
 * 在页面加载完毕后调用。
 */
- (void)webViewDidFinishLoad:(UIView<WVWebViewProtocol> *)webView;

/**
 * 在页面加载失败时调用。
 */
- (void)webView:(UIView<WVWebViewProtocol> *)webView didFailLoadWithError:(NSError *)error;

/**
 * 在接收到 JS 的 console 日志或错误信息时调用。
 * 需要全局或 WebView 主动开启 JSLog 级别，才能接收 console 日志。
 */
- (void)webView:(UIView<WVWebViewProtocol> *)webView didReceiveJSLog:(NSString *)log level:(WVLogLevel)level;

/**
 * 在 WKWebView 的页面内容处理被终止时调用，一般是 WKWebView 的进程意外退出导致的。
 * WVWKWebView 已默认对页面做了 reload 操作，请不要再次调用 reload。
 */
- (void)webViewWebContentProcessDidTerminate:(WVWKWebView *)webView;

@end

/**
 * 旧委托，由于拼写错误，已不再建议使用。
 */
@protocol WindVaneUIWbeViewDelegate <WVWebViewDelegate>
@end
