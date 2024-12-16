/*
 * NSData+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface NSData (WVUtility)

#pragma mark - Base64

/**
 * 从指定 Base64 编码字符串返回 NSData。
 */
+ (NSData *)wvDataWithBase64EncodedString:(NSString *)string;

/**
 * 返回使用 Base64 编码后的字符串，允许指定换行宽度。
 */
- (NSString *)wvBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

/**
 * 返回使用 Base64 编码后的字符串。
 */
- (NSString *)wvBase64EncodedString;

#pragma mark - MD5

/**
 * 返回当前数据的 MD5 结果。
 */
- (NSString *)wvMD5;

@end
