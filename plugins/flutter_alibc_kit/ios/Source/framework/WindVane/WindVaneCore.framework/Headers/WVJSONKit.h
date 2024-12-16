/*
 * WVJSONKit.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface NSString (WVJSONKitDeserializing)

/**
 * 返回当前 UTF-8 json 字符串对应的对象。
 */
- (id)wvObjectFromJSONString;

@end

@interface NSData (WVJSONKitDeserializing)

/**
 * 返回当前 UTF-8 json 数据对应的对象。
 */
- (id)wvObjectFromJSONData;

@end

@interface NSArray (WVJSONKitSerializing)

/**
 * 返回当前数组对应的 UTF-8 json 字符串。
 */
- (NSString *)wvJSONString;

/**
 * 返回当前数组对应的 UTF-8 json 数据。
 */
- (NSData *)wvJSONData;

@end

// 表示三态的枚举，OC 里 BOOL 就是使用 signed char 表示的。
typedef NS_ENUM(signed char, WVTristate) {
	WVTristateNO = 0,     // 表示 否。
	WVTristateYES = 1,    // 表示 是。
	WVTristateNotSure = 2 // 表示 不确定。
};

@interface NSDictionary (WVJSONKitSerializing)

/**
 * 返回当前字典对应的 UTF-8 json 字符串。
 */
- (NSString *)wvJSONString;
/**
 * 返回当前字典对应的 UTF-8 json 数据。
 */
- (NSData *)wvJSONData;

#pragma mark - Dictionary Value

/**
 * 获取指定键的 BOOL 值，如果不存在或类型错误则返回 NO。
 */
- (BOOL)wvBoolValue:(id)key;

/**
 * 获取指定键的 BOOL 值，如果不存在或类型错误则返回默认值。
 */
- (BOOL)wvBoolValue:(id)key default:(BOOL)defaultValue;

/**
 * 获取指定键的三态枚举值，如果不存在或类型错误则返回 WVTristateNotSure。
 */
- (WVTristate)wvTristateValue:(id)key;

/**
 * 获取指定键的 NSInteger 值，如果不存在或类型错误则返回 0。
 */
- (NSInteger)wvIntegerValue:(id)key;

/**
 * 获取指定键的 NSInteger 值，如果不存在或类型错误则返回默认值。
 */
- (NSInteger)wvIntegerValue:(id)key default:(NSInteger)defaultValue;

/**
 * 获取指定键的 NSUInteger 值，如果不存在或类型错误则返回 0。
 */
- (NSUInteger)wvUnsignedIntegerValue:(id)key;

/**
 * 获取指定键的 NSUInteger 值，如果不存在或类型错误则返回默认值。
 */
- (NSUInteger)wvUnsignedIntegerValue:(id)key default:(NSUInteger)defaultValue;

/**
 * 获取指定键的 long long 值，如果不存在或类型错误则返回 0。
 */
- (long long)wvLongLongValue:(id)key;

/**
 * 获取指定键的 long long 值，如果不存在或类型错误则返回默认值。
 */
- (long long)wvLongLongValue:(id)key default:(long long)defaultValue;

/**
 * 获取指定键的 unsigned long long 值，如果不存在或类型错误则返回 0。
 */
- (unsigned long long)wvUnsignedLongLongValue:(id)key;

/**
 * 获取指定键的 unsigned long long 值，如果不存在或类型错误则返回默认值。
 */
- (unsigned long long)wvUnsignedLongLongValue:(id)key default:(unsigned long long)defaultValue;

/**
 * 获取指定键的 CGFloat 值，如果不存在或类型错误则返回 0.0。
 */
- (CGFloat)wvFloatValue:(id)key;

/**
 * 获取指定键的 CGFloat 值，如果不存在或类型错误则返回默认值。
 */
- (CGFloat)wvFloatValue:(id)key default:(CGFloat)defaultValue;

/**
 * 获取指定键的 double 值，如果不存在或类型错误则返回 0.0。
 */
- (double)wvDoubleValue:(id)key;

/**
 * 获取指定键的 double 值，如果不存在或类型错误则返回默认值。
 */
- (double)wvDoubleValue:(id)key default:(double)defaultValue;

/**
 * 获取指定键的 NSString 值，如果不存在或类型错误则返回 nil。
 */
- (NSString *)wvStringValue:(id)key;

/**
 * 获取指定键的 NSString 值，如果不存在或类型错误则返回默认值。
 */
- (NSString *)wvStringValue:(id)key default:(NSString *)defaultValue;

/**
 * 获取指定键的 NSArray 值，如果不存在或类型错误则返回 nil。
 */
- (NSArray *)wvArrayValue:(id)key;

/**
 * 获取指定键的 NSDictionary 值，如果不存在或类型错误则返回 nil。
 */
- (NSDictionary *)wvDictionaryValue:(id)key;

@end
