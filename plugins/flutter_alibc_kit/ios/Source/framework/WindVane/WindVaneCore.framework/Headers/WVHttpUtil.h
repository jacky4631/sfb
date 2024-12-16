/*
 * WVHttpUtil.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * _Nonnull const WVHttpVersion1_1;

// 标准 Http 头。
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderAccessControlAllowOrigin;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderCacheControl;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderCookie;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderVia;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderDate;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderLocation;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderReferrer;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderSetCookie;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderUserAgent;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderContentType;
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderContentLength;

// HTTP Method 头。
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderMethodPost;
// HTTP Cache-Control 头，表示不缓存。
FOUNDATION_EXPORT NSString * _Nonnull const WVHttpHeaderCacheControlNoStore;

#pragma mark - NSDictionary + WVHttpHeader

/**
 * 提供 Http 头的读取方法。
 */
@interface NSDictionary (WVHttpHeader)

/**
 * 返回 Via 头的数据，不存在则返回 nil。
 */
- (NSString * _Nullable)wvHttpHeaderVia;

/**
 * 返回 Date 头的数据，不存在则返回 nil。
 */
- (NSDate * _Nullable)wvHttpHeaderDate;

/**
 * 返回 Location 头的数据，不存在则返回 nil。
 */
- (NSString * _Nullable)wvHttpHeaderLocation;

/**
 * 返回 Referrer 头的数据，不存在则返回 nil。
 */
- (NSString * _Nullable)wvHttpHeaderReferrer;

/**
 * 返回 Set-Cookie 头的数据，不存在则返回 nil。
 */
- (NSString * _Nullable)wvHttpHeaderSetCookie;

/**
 * 返回 UserAgent 头的数据，不存在则返回 nil。
 */
- (NSString * _Nullable)wvHttpHeaderUserAgent;

/**
 * 返回 ContentType 头的数据，不存在则返回 nil。
 */
- (NSString * _Nullable)wvHttpHeaderContentType;

/**
 * 返回 ContentLength 头的数据，不存在则返回 0。
 */
- (NSUInteger)wvHttpHeaderContentLength;

@end
