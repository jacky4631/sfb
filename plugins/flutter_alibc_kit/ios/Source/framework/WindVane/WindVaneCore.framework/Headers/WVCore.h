/*
 * WVCore.h
 *
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 初始化 WindVane Core 模块。
 */
@interface WVCore : NSObject

/**
 初始化 WindVane Core 模块。
 */
+ (void)setup;

/**
 WindVane 的初始化时间。
 */
+ (NSTimeInterval)initTime;

#pragma mark - UserAgent

/**
 返回浏览器的默认 UserAgent。

 @return 该方法第一次调用时的默认 UserAgent。
 */
+ (NSString * _Nonnull)defaultUserAgent;

/**
 返回 WindVane 的 UserAgent。
 
 @return WindVane 的 UserAgent。
 */
+ (NSString * _Nonnull)userAgent;

/**
 要求 WindVane 不要影响客户端的全局 UserAgent，在 WebView 自有 UserAgent 修改失败时，可能会导致 UserAgent 缺失 AliApp 和 WindVane 标记。
 */
+ (void)doNotChangeUserAgent;

/**
 修改全局 UserAgent，多次调用只有第一次生效。
 没有特殊必要请不要调用此方法来修改全局 UserAgent，WindVane 会优先使用 WebView 级别的 UserAgent，避免对非 WindVane 的 WebView 产生影响。
 */
+ (void)changeUserAgent;

#pragma mark - 其它设置（开关）

/**
 设置额外的配置。
 */
+ (void)setExternalConfig:(NSDictionary * _Nullable)externalConfig;

/**
 获取额外的配置。
 */
+ (NSDictionary * _Nonnull)externalConfig;

/**
 获取额外的 BOOL 配置。
 */
+ (BOOL)externalBOOLConfig:(NSString * _Nonnull)configKey default:(BOOL)defaultValue;

@end
