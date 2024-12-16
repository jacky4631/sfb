/*
 * AlibcLog.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

#ifndef AlibcLog_h
#define AlibcLog_h

#ifdef DEBUG
#define BCAssert(condition, info) \
do { \
@try { \
if (!(condition)) { \
if(tbim_check_debugger() == 0){      \
TLOG_ERROR(info)\
[NSException raise:@"Assert" format:@"%@",info];} \
else {TLOG_ALERT(info)} \
} \
}\
@catch (NSException *exception) {} \
} while (0);
#else
#define BCAssert(condition, info) \
do { \
if (!(condition)) {TLOG_ERROR(info)}\
} while (0);
#endif

#ifdef DEBUG
#define BCAssert_F(condition, frmt, ...) \
do { \
@try { \
if (!(condition)) { \
if(tbim_check_debugger() == 0){ \
TLOG_ERROR_F(frmt,##__VA_ARGS__) \
[NSException raise:@"Assert" format:@"Assert"];} \
else {TLOG_ALERT_F(frmt,##__VA_ARGS__)} \
} \
}\
@catch (NSException *exception) {} \
} while (0);
#else
#define BCAssert_F(condition, frmt, ...) \
do { \
if (!(condition)) { \
TLOG_ERROR_F(frmt,##__VA_ARGS__) \
} \
} while (0);
#endif

#define TLOG_ALERT(info) [[AlibcLog GetInstance] showAssertAlert:__FILE__ funcName:__func__ line: __LINE__ msg:info];
#define TLOG_ALERT_F(fmt, ...) [[AlibcLog GetInstance] showAssertAlert:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];


#define TLOG_DEBUG_EMPTY [[AlibcLog GetInstance] logDebugMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];
#define TLOG_INFO_EMPTY  [[AlibcLog GetInstance] logInfoMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];
#define TLOG_WARN_EMPTY [[AlibcLog GetInstance] logWarnMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];
#define TLOG_ERROR_EMPTY [[AlibcLog GetInstance] logErrorMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];

#define TLOG_DEBUG(info) [[AlibcLog GetInstance] logDebugMsg:__FILE__  funcName:__func__ line:__LINE__ msg:info];
#define TLOG_INFO(info)  [[AlibcLog GetInstance] logInfoMsg:__FILE__ funcName:__func__ line:__LINE__ msg:info];
#define TLOG_WARN(info)  [[AlibcLog GetInstance] logWarnMsg:__FILE__  funcName:__func__ line: __LINE__ msg:info];
#define TLOG_ERROR(info) [[AlibcLog GetInstance] logErrorMsg:__FILE__  funcName:__func__ line: __LINE__ msg:info];

#define TLOG_DEBUG_F(fmt, ...) [[AlibcLog GetInstance] logDebugMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TLOG_INFO_F(fmt, ...)  [[AlibcLog GetInstance] logInfoMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TLOG_WARN_F(fmt, ...) [[AlibcLog GetInstance] logWarnMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TLOG_ERROR_F(fmt, ...) [[AlibcLog GetInstance] logErrorMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];


int tbim_check_debugger();


@interface AlibcLog : NSObject

+ (instancetype)GetInstance;

- (NSString *)getLogFilePath;

- (void)showAssertAlert:(const char *)file funcName:(const char *)func line:(int)line msg:(NSString *)msg;

- (void)logDebugMsg:(const char *)file funcName:(const char *)func line:(int)line msg:(NSString *)msg;

- (void)logInfoMsg:(const char *)file funcName:(const char *)func line:(int)line msg:(NSString *)msg;

- (void)logWarnMsg:(const char *)file funcName:(const char *)func line:(int)line msg:(NSString *)msg;

- (void)logErrorMsg:(const char *)file funcName:(const char *)func line:(int)line msg:(NSString *)msg;

- (void)setDebugLogOpen:(BOOL)isDebugLogOpen;
@end

#endif
