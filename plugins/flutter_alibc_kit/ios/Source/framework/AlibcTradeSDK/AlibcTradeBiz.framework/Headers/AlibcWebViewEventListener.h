/*
 * AlibcWebViewEventListener.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

#import "AlibcMultiDelegates.h"

#ifndef AlibcWebViewEventListener_h
#define AlibcWebViewEventListener_h

/**
 AlibcWebViewEventListener 协议, 添加到 #import "AlibcWebViewEventListener.h"AlibcWebViewEventListenerCenter 的实例需要服从这个协议
 */
@protocol AlibcWebViewEventListener <NSObject>

@optional

/**
 前面的参数同
 */

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/**
 WebView 开始加载
 */
- (void)webViewDidStartLoad:(WKWebView *)webView;

/**
 WebView 结束加载
 */
- (void)webViewDidFinishLoad:(WKWebView *)webView;

/**
 WebView 加载失败
 
 @param error error instance
 */
- (void)webView:(WKWebView *)webView didFailLoadWithError:(NSError *)error;

@end


/**
 WebView 回调事件的监听中心
 */
@interface AlibcWebViewEventListenerCenter : AlibcMultiDelegates <AlibcWebViewEventListener>


/**
 监听中心的默认实现
 */
@property(class, readonly, strong) AlibcWebViewEventListenerCenter *defaultCenter;

@end

#endif
