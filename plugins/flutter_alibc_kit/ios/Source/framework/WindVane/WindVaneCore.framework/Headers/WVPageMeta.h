/*
 * WVPageMeta.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class WVPageMeta;

/**
 * 页面元数据发生改变的回调。
 *
 * @param pageMeta    全部页面元数据。
 * @param changedMeta 发生改变的页面元数据的键。
 * @param initial     是否是当前页面的首次元数据回调。
 */
typedef void (^WVPageMetaChanged)(WVPageMeta * _Nonnull pageMeta, NSSet<NSString *> * _Nonnull changedMeta, BOOL initial);

/**
 * 当前页面的元数据。
 * 支持两种形式：<meta name="key" content="value"> 或 <meta id="key" value="value">
 */
@interface WVPageMeta : NSObject

/**
 * 返回指定名称的 meta。
 *
 * @param name meta 的名称。
 *
 * @return 指定名称的 meta。
 */
- (NSString * _Nullable)objectForName:(NSString * _Nonnull)name;

/**
 * 返回指定键的 meta。
 *
 * @param key meta 的键。
 *
 * @return 指定键的 meta。
 */
- (NSString * _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)key;

/**
 * 添加指定的 meta 改变监听。
 *
 * @param observer meta 改变的监听。
 */
- (void)addObserver:(WVPageMetaChanged _Nonnull)observer;

/**
 * 移除指定的 meta 改变监听。
 *
 * @param observer meta 改变的监听。
 */
- (void)removeObserver:(WVPageMetaChanged _Nonnull)observer;

/**
 移除全部的 meta 改变监听。
 */
- (void)removeAllObservers;

#pragma mark - 提取元数据

/**
 * 返回指定名称 meta 的布尔值。
 *
 * @param name meta 的名称。
 *
 * @return 指定名称 meta 的布尔值。
 */
- (BOOL)boolValue:(NSString * _Nonnull)name;

/**
 * 返回指定名称 meta 的布尔值。
 *
 * @param name         meta 的名称。
 * @param defaultValue 默认值。
 *
 * @return 指定名称 meta 的布尔值。
 */
- (BOOL)boolValue:(NSString * _Nonnull)name default:(BOOL)defaultValue;

/**
 * 返回指定名称 meta 的 unsigned long long 值。
 *
 * @param name         meta 的名称。
 *
 * @return 指定名称 meta 的 unsigned long long 值。
 */
- (unsigned long long)unsignedLongLongValue:(NSString * _Nonnull)name;

/**
 * 返回指定名称 meta 的 unsigned long long 值。
 *
 * @param name         meta 的名称。
 * @param defaultValue 默认值。
 *
 * @return 指定名称 meta 的 unsigned long long 值。
 */
- (unsigned long long)unsignedLongLongValue:(NSString * _Nonnull)name default:(unsigned long long)defaultValue;

@end
