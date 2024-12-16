/*
 * WVStandardEventCenter.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <WindVaneBasic/WindVaneBasic.h>

/**
 * WindVane 标准事件中心。
 */
@interface WVStandardEventCenter : NSObject

/**
 * 注册全局事件。
 */
+ (void)setup;

/**
 * 发送 JS 事件到指定 WebView。
 * 也可以直接使用 [webView dispatchEvent:withParam:withCallback:] 方法。
 *
 * @param eventName 要发送的事件名称。
 * @param eventData 要发送的事件数据。
 * @param webView   要发送事件到的 WebView。
 */
+ (void)postNotificationToJS:(NSString * _Nonnull)eventName withEventData:(NSDictionary * _Nullable)eventData withWebView:(UIView<WVWebViewBasicProtocol> * _Nonnull)webView;

/**
 * 发送 JS 事件到所有 WebView。
 *
 * @param eventName 要发送的事件名称。
 * @param eventData 要发送的事件数据。
 */
+ (void)postNotificationToJS:(NSString * _Nonnull)eventName withEventData:(NSDictionary * _Nullable)eventData;

@end
