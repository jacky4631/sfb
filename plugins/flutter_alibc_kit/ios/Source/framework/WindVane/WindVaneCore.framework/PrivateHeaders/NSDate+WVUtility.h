/*
 * NSDate+WVUtility.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 提供 NSDate 类的扩展方法。
 */
@interface NSDate (WVUtility)

/**
 * 获取自 1970 年 1 月 1 日以来的秒数。
 */
+ (NSTimeInterval)wvcurrentTimeInterval;

/**
 * 获取自 1970 年 1 月 1 日以来的毫秒数。
 */
+ (double)wvCurrentMilliseconds;

/**
 * 将指定的 RFC 1123 格式时间字符串转换为对应的 NSDate。
 * RFC 1123 的时间格式为 EEE, dd MMM yyyy HH:mm:ss zzz。
 */
+ (NSDate *)wvDateWithRFC1123String:(NSString *)date;

/**
 * 将指定的 RFC 6265 格式时间字符串（Cookie 时间）转换为对应的 NSDate。
 * RFC 6265 的时间格式为一套算法：https://tools.ietf.org/html/rfc6265#section-5.1.1。
 */
+ (NSDate *)wvDateWithRFC6265String:(NSString *)date;

/**
 * 获取当前日期自 1970 年 1 月 1 日以来的毫秒数。
 *
 * @return 当前日期自 1970 年 1 月 1 日以来的毫秒数。
 */
- (double)wvMillisecondsSince1970;

/**
 * 获取此日期自当前时间以来的毫秒数。
 * 如果此日期早于当前时间，那么会返回负数。
 *
 * @return 此日期自当前时间以来的毫秒数。
 */
- (double)wvMillisecondsSinceNow;

/**
 * 返回当前日期的年份。
 */
- (NSInteger)wvGetYear;

/**
 * 将当前 NSDate 转换为对应的 ISO 8601 格式日期字符串。
 * ISO 8601 的日期格式为 yyyy-MM-dd。
 */
- (NSString *)wvStringWithISO8601Format;

/**
 * 将当前 NSDate 转换为对应的 RFC 1123 格式日期字符串。
 * RFC 1123 的时间格式为 EEE, dd MMM yyyy HH:mm:ss zzz。
 */
- (NSString *)wvStringWithRFC1123Format;

#pragma mark - Date Marking

/**
 * 标记当前时间。
 *
 * @param token 当前时间的标记。
 */
+ (void)wvMarkNow:(NSString *)token;

/**
 * 检查与上一次标记是否已达到指定时间间隔。
 *
 * @param token             时间的标记。
 * @param interval          时间间隔。
 *
 * @return 如果与上一次标记已达到指定时间间隔，则为 YES；若标记不存在或未达到指定时间间隔，则为 NO。
 */
+ (BOOL)wvCheckMark:(NSString *)token withInterval:(NSTimeInterval)interval;

/**
 * 检查与上一次标记是否已达到指定时间间隔，如果已达到，则自动重新标记。
 *
 * @param token             时间的标记。
 * @param interval          时间间隔。
 *
 * @return 如果与上一次标记已达到指定时间间隔，则为 YES；若标记不存在或未达到指定时间间隔，则为 NO。
 */
+ (BOOL)wvCheckAndMark:(NSString *)token withInterval:(NSTimeInterval)interval;

@end

/**
 * 返回当前时间自 1970 年 1 月 1 日以来的秒数。
 */
NS_INLINE NSTimeInterval currentTimeInterval() {
	return [NSDate wvcurrentTimeInterval];
}

/**
 * 返回当前时间自 1970 年 1 月 1 日以来的毫秒数。
 */
NS_INLINE double currentMilliseconds() {
	return [NSDate wvCurrentMilliseconds];
}

/**
 * 返回指定 NSTimeInterval 的毫秒表示。
 */
NS_INLINE double toMilliseconds(NSTimeInterval timeInterval) {
	return timeInterval * 1000.0;
}

/**
 * 返回指定毫秒的 NSTimeInterval 表示。
 */
NS_INLINE double toTimeInterval(double milliseconds) {
	return milliseconds / 1000.0;
}

/**
 * 返回指定 NSTimeInterval 之间相差的毫秒数。
 */
NS_INLINE double millisecondsBetween(NSTimeInterval fromTime, NSTimeInterval toTime) {
	return toMilliseconds(fromTime - toTime);
}

/**
 * 返回当前时间与指定 NSTimeInterval 之间相差的毫秒数。
 */
NS_INLINE double millisecondsFromNowTo(NSTimeInterval toTime) {
	return toMilliseconds([NSDate wvcurrentTimeInterval] - toTime);
}
