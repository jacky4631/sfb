/*
 * WVConstant.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

#pragma mark Version

/* WindVane Version */
/****************************************************/
#define WINDVANE_VERSION_ORIGIN_VALUE 8.5.0
#define WINDVANE_VERSION @"8.5.0"
/****************************************************/

#pragma mark - Constant

// 时间常量，单位是秒。
FOUNDATION_EXPORT const NSTimeInterval WVMinite;
FOUNDATION_EXPORT const NSTimeInterval WVHour;
FOUNDATION_EXPORT const NSTimeInterval WVDay;
FOUNDATION_EXPORT const NSTimeInterval WVWeek;

// 磁盘空间常量，单位是 byte。
FOUNDATION_EXPORT const double WVKilobytes;
FOUNDATION_EXPORT const double WVMegabytes;
FOUNDATION_EXPORT const double WVGigabytes;

/*
 * Deprecated Macros
 * #define HTTP_SCHEME @"http://"
 * #define HTTPS_SCHEME @"https://"
 * #define PROTOCOL_SCHEME @"hybrid://"
 * #define WV_JS_EVENT_APP_ACTIVE WVEventAppActive
 * #define WV_JS_EVENT_APP_BACKGROUND WVEventAppBackground
 * #define WV_JS_EVENT_PAGE_INFINITESCROLL WVEventPageInfiniteScroll
 * #define WV_JS_EVENT_APP_ACTIVI WVEventAppActive
 * #define MINITE WVMinite
 * #define HALF_HOUR (WVHour / 2)
 * #define HOUR WVHour
 * #define DAY WVDay
 * #define WEEK WVWeek
*/
