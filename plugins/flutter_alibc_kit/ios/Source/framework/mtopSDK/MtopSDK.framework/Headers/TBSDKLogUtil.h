//
//  Created by wuchen.xj on 1/28/19.
//  Copyright (c) 2019 Taobao. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 * 日志级别
 */
typedef enum {
    kMTOPLogLevelNone   = 0,
    kMTOPLogLevelDebug  = 1,
    kMTOPLogLevelInfo   = 2,
    kMTOPLogLevelWarn   = 3,
    kMTOPLogLevelError  = 4
} TBMTOPLogLevel;

/**
 * 日志入口
 */
@interface TBSDKLogUtil : NSObject

+ (void)log:(TBMTOPLogLevel)level file:(const char *)file line:(int)line msg:(NSString *)fmt, ...;

@end

/**
 * 原来的C接口
 */

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /**
     * 开关openSDK的log
     */
    void openSDKSwitchLog(BOOL logCtr);
    
    /**
     * 打印 log 宏
     */
#define MTOP_LOGD(...)    [TBSDKLogUtil log:kMTOPLogLevelDebug file:__FILE__ line:__LINE__ msg:__VA_ARGS__]
    
#define MTOP_LOGI(...)    [TBSDKLogUtil log:kMTOPLogLevelInfo file:__FILE__ line:__LINE__ msg:__VA_ARGS__]
    
#define MTOP_LOGW(...)    [TBSDKLogUtil log:kMTOPLogLevelWarn file:__FILE__ line:__LINE__ msg:__VA_ARGS__]
    
#define MTOP_LOGE(...)    [TBSDKLogUtil log:kMTOPLogLevelError file:__FILE__ line:__LINE__ msg:__VA_ARGS__]
    
#ifdef __cplusplus
}
#endif
