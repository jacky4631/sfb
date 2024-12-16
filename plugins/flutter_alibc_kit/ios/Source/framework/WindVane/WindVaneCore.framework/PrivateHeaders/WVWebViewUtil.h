/*
 * WVWebViewUtil.h
 *  
 * Created by WindVane.
 * Copyright (c) 2014年 阿里巴巴-无线事业部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * WebView 的工具类。
 */
@interface WVWebViewUtil : NSObject

/**
 * 自动补全 URL Schema。
 */
+ (void)completeUrlScheme:(NSURLRequest *)request withCallback:(void (^)(NSURLRequest *))callback;

/**
 * 缩短 URL 长度。
 */
+ (NSString *)shortenUrl:(NSString *)urlString toLength:(NSUInteger)maxLength;

@end
