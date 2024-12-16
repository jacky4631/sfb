/*
 * WVWebViewRecorder.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "WVWebViewProtocol.h"

/**
 * WebView 相关信息的记录。
 */
@interface WVWebViewRecorder : NSObject

/**
 * 返回当前的 WebView 相关信息。
 */
+ (NSDictionary * _Nonnull)currentWebViewInfo;

/**
 * 返回所有 WebView。
 * 该数组包含 WebView 的强引用，不允许直接做强引用。
 */
+ (NSArray<UIView<WVWebViewProtocol> *> * _Nonnull)allWebView;

/**
 * 返回所有顶层 WebView。
 * 可见性为 WVWebViewVisiblilityUnknown 或 WVWebViewVisible。
 * 该数组包含 WebView 的强引用，不允许直接做强引用。
 */
+ (NSArray<UIView<WVWebViewProtocol> *> * _Nonnull)topWebView;

@end
