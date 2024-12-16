//
//  WVTypeConverter.h
//  Core
//
//  Created by lianyu.ysj on 2018/1/24.
//  Copyright © 2018年 WindVane. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/**
 提供了安全的类型转换接口，
 */

#if defined __cplusplus
extern "C" {
#endif

#define WV_SAFE_TYPE_INVOKE(NAME, VALUE, DEFAULT, ...) NAME(VALUE, DEFAULT)

/**
 安全的转换为 BOOL 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
BOOL wvSafeBOOL(id value, BOOL defaultValue);
#define WV_SAFE_BOOL(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeBOOL, VALUE, ##__VA_ARGS__, NO)

/**
 安全的转换为 NSInteger 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
NSInteger wvSafeInteger(id value, NSInteger defaultValue);
#define WV_SAFE_INTEGER(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeInteger, VALUE, ##__VA_ARGS__, 0)
	
/**
 安全的转换为 NSInteger 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定，字符串会按照十六进制解析。
 */
NSInteger wvSafeHexInteger(id value, NSInteger defaultValue);
#define WV_SAFE_HEX_INTEGER(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeHexInteger, VALUE, ##__VA_ARGS__, 0)

/**
 安全的转换为 NSUInteger 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
NSUInteger wvSafeUnsignedInteger(id value, NSUInteger defaultValue);
#define WV_SAFE_UINTEGER(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeUnsignedInteger, VALUE, ##__VA_ARGS__, 0)

/**
 安全的转换为 long long 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
long long wvSafeLongLong(id value, long long defaultValue);
#define WV_SAFE_LLONG(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeLongLong, VALUE, ##__VA_ARGS__, 0LL)

/**
 安全的转换为 unsigned long long 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
unsigned long long wvSafeUnsignedLongLong(id value, unsigned long long defaultValue);
#define WV_SAFE_ULLONG(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeUnsignedLongLong, VALUE, ##__VA_ARGS__, 0ULL)

/**
 安全的转换为 CGFloat 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
CGFloat wvSafeFloat(id value, CGFloat defaultValue);
#define WV_SAFE_FLOAT(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeFloat, VALUE, ##__VA_ARGS__, 0.0)

/**
 安全的转换为 double 类型，如果不存在或类型错误则返回默认值。
 具体的转换规则由 value 的实际类型决定。
 */
double wvSafeDouble(id value, double defaultValue);
#define WV_SAFE_DOUBLE(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeDouble, VALUE, ##__VA_ARGS__, 0.0)

/**
 安全的转换为 NSString 类型，如果不存在或类型错误则返回默认值。
 */
NSString * wvSafeString(id value, NSString * defaultValue);
#define WV_SAFE_STRING(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeString, VALUE, ##__VA_ARGS__, nil)
	
/**
 安全的转换为 NSArray 类型，如果不存在或类型错误则返回默认值。
 */
NSArray * wvSafeArray(id value, NSArray * defaultValue);
#define WV_SAFE_ARRAY(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeArray, VALUE, ##__VA_ARGS__, nil)
	
/**
 安全的转换为 NSDictionary 类型，如果不存在或类型错误则返回默认值。
 */
NSDictionary * wvSafeDictionary(id value, NSDictionary * defaultValue);
#define WV_SAFE_DICTIONARY(VALUE, ...) WV_SAFE_TYPE_INVOKE(wvSafeDictionary, VALUE, ##__VA_ARGS__, nil)

#if defined __cplusplus
};
#endif
