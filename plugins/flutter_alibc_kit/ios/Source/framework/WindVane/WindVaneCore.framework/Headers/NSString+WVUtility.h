/*
 * NSString+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 返回表示指定整数的字符串。
 */
NS_INLINE NSString * WVStringFromInteger(NSInteger value) {
	return [NSString stringWithFormat:@"%ld", (long)value];
}

/**
 * 返回表示指定整数的字符串。
 */
NS_INLINE NSString * WVStringFromUnsignedInteger(NSUInteger value) {
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
}

/**
 * 返回表示指定整数的字符串。
 */
NS_INLINE NSString * WVStringFromLongLong(long long value) {
	return [NSString stringWithFormat:@"%lld", value];
}

/**
 * 返回表示指定整数的字符串。
 */
NS_INLINE NSString * WVStringFromUnsignedLongLong(unsigned long long value) {
	return [NSString stringWithFormat:@"%llu", value];
}

/**
 * 返回表示指定浮点数的字符串。
 */
NS_INLINE NSString * WVStringFromDouble(double value) {
	return [NSString stringWithFormat:@"%f", value];
}

/**
 * 返回表示指定指针的字符串。
 */
NS_INLINE NSString * WVStringFromPointer(id value) {
	return [NSString stringWithFormat:@"%p", value];
}

/**
 * 提供 NSString 类的扩展方法。
 */
@interface NSString (WVUtility)

#pragma mark - Test

/**
 * 检查指定的字符串是否是空字符串或 nil。
 */
+ (BOOL)wvIsBlank:(NSString *)str;

#pragma mark - Finding

/**
 * 查找指定字符串第一次出现的位置。
 *
 * @param string 要查找的字符串。
 *
 * @return 指定字符串第一次出现的位置，如果未找到则返回 NSNotFound。
 */
- (NSUInteger)wvIndexOfString:(NSString *)string;

/**
 * 查找指定字符串第一次出现的位置。
 *
 * @param string  要查找的字符串。
 * @param options 字符串查找选项。
 *
 * @return 指定字符串第一次出现的位置，如果未找到则返回 NSNotFound。
 */
- (NSUInteger)wvIndexOfString:(NSString *)string options:(NSStringCompareOptions)options;

/**
 * 从指定索引开始，查找指定字符串第一次出现的位置。
 *
 * @param string     要查找的字符串。
 * @param startIndex 要开始查找的索引。
 *
 * @return 指定字符串第一次出现的位置，如果未找到则返回 NSNotFound。
 */
- (NSUInteger)wvIndexOfString:(NSString *)string start:(NSUInteger)startIndex;

/**
 * 从指定索引开始，查找指定字符串第一次出现的位置。
 *
 * @param string     要查找的字符串。
 * @param options    字符串查找选项。
 * @param startIndex 要开始查找的索引。
 *
 * @return 指定字符串第一次出现的位置，如果未找到则返回 NSNotFound。
 */
- (NSUInteger)wvIndexOfString:(NSString *)string options:(NSStringCompareOptions)options start:(NSUInteger)startIndex;

/**
 * 从指定索引开始，查找指定字符集中的字符第一次出现的位置。
 *
 * @param set   要查找的字符集。
 *
 * @return 字符集中的字符第一次出现的位置，如果未找到则返回 NSNotFound。
 */
- (NSUInteger)wvIndexOfCharacterFromSet:(NSCharacterSet *)set;

/**
 * 从指定索引开始，查找指定字符集中的字符第一次出现的位置。
 *
 * @param set   要查找的字符集。
 * @param start 查找的起始索引。
 *
 * @return 字符集中的字符第一次出现的位置，如果未找到则返回 NSNotFound。
 */
- (NSUInteger)wvIndexOfCharacterFromSet:(NSCharacterSet *)set startWith:(NSUInteger)start;

/**
 * 从指定范围的第一个字符，查找指定字符集中的字符连续出现的范围。
 *
 * @param set   要查找的字符集。
 * @param range 要查找的字符范围。
 *
 * @return 指定字符集中的字符连续出现的范围，如果未出现则返回 {range.location, 0}。
 */
- (NSRange)wvRangeOfConsecutiveCharacterFromSet:(NSCharacterSet *)set range:(NSRange)range;

#pragma mark - URL

/**
 * 返回经过 URL 编码后的字符串，供编码查询参数使用。
 */
- (NSString *)wvStringByURLEncoded;

/**
 * 返回经过 URL 解码后的字符串，供解码查询参数使用。
 */
- (NSString *)wvStringByURLDecoded;

#pragma mark - Unicode

/**
 * 返回经过 Unicode 解码后的字符串，将 @"\\U5404\\U500b\\U90fd" 这样的字符串转换成原始字符。
 */
- (NSString *)wvStringByUnicodeDecoded;

#pragma mark - Base64

/**
 * 返回 Base64 解码后的数据。
 */
- (NSData *)wvBase64DecodedData;

#pragma mark - MD5

/**
 * 返回当前字符串的 MD5 结果。
 */
- (NSString *)wvMD5;

@end
