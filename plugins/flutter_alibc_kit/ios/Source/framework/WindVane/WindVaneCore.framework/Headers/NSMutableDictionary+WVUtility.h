/*
 * NSMutableDictionary+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 提供 NSMutableDictionary 类的扩展方法。
 */
@interface NSMutableDictionary (WVUtility)

/**
 * 从指定字典中复制指定键的值。
 */
- (void)wvCopyValueFrom:(NSDictionary *)dict withKey:(id<NSCopying>)key;

/**
 * 将指定字典中当前字典中不包含的键，添加到当前字典中。
 */
- (void)wvAddNewEntriesFromDictionary:(NSDictionary *)otherDictionary;

/**
 * 移除指定指定键的对象。
 */
- (void)wvRemoveObjectForKey:(id<NSCopying>)key;

/**
 * 为字典设置指定的键值对，已对 nil 进行检查。
 */
- (void)wvSetNullable:(id)value forKey:(id<NSCopying>)key;

@end
