/*
 * WVCommonUtil.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVUserConfig.h"
#import <Foundation/Foundation.h>

// 判断是否是调试模式的宏。
#define WV_DEBUG [WVUserConfig isDebugMode]
// 返回指定名称 selector 的字符串。
#define WV_SEL_NAME(NAME) (NSStringFromSelector(@selector(NAME)))
// 将多行字面量转换为 char *，圆括号必须匹配。
#define WV_LITERAL_TO_STRING(...) #__VA_ARGS__
#define WV_LITERAL_VALUE_TO_STRING(...) WV_LITERAL_TO_STRING(__VA_ARGS__)
// 将多行字面量转换为 NSString *，圆括号必须匹配。
#define WV_LITERAL_TO_NSSTRING(...) @ #__VA_ARGS__
#define WV_LITERAL_VALUE_TO_NSSTRING(...) WV_LITERAL_TO_NSSTRING(__VA_ARGS__)
// 符号函数。
#define SGN_IMPL(X, L) ({ __typeof__(X) __NSX_PASTE__(__x,L) = (X); (__NSX_PASTE__(__x,L) < 0) ? -1 : (__NSX_PASTE__(__x,L) > 0); })
#define SGN(X) SGN_IMPL(X, __COUNTER__)

/**
 * 返回两个浮点数是否相等。
 */
NS_INLINE BOOL doubleEquals(double x, double y) {
	return fabs(x - y) < DBL_EPSILON;
}

/**
 * 返回指定浮点数是否为零。
 */
NS_INLINE BOOL doubleEqualToZero(double x) {
	return fabs(x) < DBL_EPSILON;
}

/**
 * 将弧度转换为角度。
 */
NS_INLINE double rad2deg(double radians) {
	return radians * 180.0 / M_PI;
}

// WindVane 网络状态。
typedef NS_ENUM(NSInteger, WVNetworkStatus) {
	WVNetworkStatusNone = 0, // 无网络。
	WVNetworkStatusWiFi = 1, // WiFi 网络。
	WVNetworkStatus2G = 2,   // 2G 网络。
	WVNetworkStatus3G = 3,   // 3G 网络。
	WVNetworkStatus4G = 4,   // 4G 网络。
	WVNetworkStatusWWAN = 5  // 未知非 WiFi 网络（无法区分 2G/3G/4G）。
};

// URL 的内容类型，其中 WVURLContentMediumSecurity 需要业务方自行设置，其它会自动根据 Domain 配置决定。
typedef NS_OPTIONS(NSInteger, WVURLContentType) {
	WVURLContentForbidden = -1,          // 要被禁止的内容。
	WVURLContentInsecurity = 1 << 0,     // 不安全的内容（未知的三方域名）。
	WVURLContentLowSecurity = 1 << 1,    // 低安全的内容（白名单内的三方域名）。
	WVURLContentMediumSecurity = 1 << 2, // 中级安全的内容（较为受控的三方域名）。
	WVURLContentHighSecurity = 1 << 3,   // 高安全的内容（Ali 域名）。
};

@interface WVCommonUtil : NSObject

#pragma mark - Number Util

/**
 * 返回一个随机的 double。
 *
 * @return 一个随机的 double 值，其范围为 [0, 1)。
 */
+ (double)randomDouble;

/**
 * 返回一个随机无符号整数。
 *
 * @return 一个随机的无符号整数，其范围为 [0, max)。
 */
+ (NSUInteger)randomUnsignedInteger:(NSUInteger)max;

#pragma mark - Domain Check

/**
 * 返回指定 URL 的内容类型。
 */
+ (WVURLContentType)getURLContentType:(NSString *)url;

/**
 * 检查是否是 Ali 安全域名。
 */
+ (BOOL)checkIsSecurityDomain:(NSString *)url;

/**
 * 检查是否是三方域名。
 */
+ (BOOL)checkIsThirdPartyDomain:(NSString *)url;

/**
 * 检查是否是黑名单域名。
 */
+ (BOOL)checkIsForbiddenDomain:(NSString *)url;

#pragma mark - String Util

/**
 * 利用时间戳、计数器、硬件地址产生的全局唯一标识。
 */
+ (NSString *)UUIDString;

/**
 * 修复直接将 JSON 字符串作为 js 使用时，\u2028 和 \u2029 导致 JS 报错的问题。
 */
+ (NSString *)fixJSON2JSBug:(NSString *)json;

/**
 * 返回指定的状态码是否表示成功。
 *
 * @param statusCode 要判断的状态码。
 *
 * @return 如果指定的状态码表示成功，则为 YES；否则为 NO。
 */
+ (BOOL)isStatusCodeSuccess:(NSInteger)statusCode;

@end

#pragma mark - Perform Block

#if defined __cplusplus
extern "C" {
#endif

/**
 如果当前已经是主线程，那么直接调用；否则在主线程异步调用指定 Block。
 */
void WVPerformBlockOnMainThread(dispatch_block_t block);

/**
 在主线程同步调用指定的 Block。
 */
void WVPerformBlockSyncOnMainThread(dispatch_block_t block);

/**
 在后台线程异步调用指定 Block。
 */
void WVPerformBlockOnGlobalThread(dispatch_block_t block);

/**
 在指定 queue 同步调用指定 Block。
 */
void WVPerformBlockSyncOnQueue(dispatch_queue_t queue, dispatch_block_t block);

#if defined __cplusplus
};
#endif
