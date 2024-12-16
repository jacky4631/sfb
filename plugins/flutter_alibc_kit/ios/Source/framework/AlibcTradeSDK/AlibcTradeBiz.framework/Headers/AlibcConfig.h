/*
 * AlibcConfig.h 
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

#ifndef AlibcConfig_h
#define AlibcConfig_h

/** 环境,测试和预发,只有内网有效,外部使用只能用线上环境 */
typedef NS_ENUM (NSInteger, AlibcEnvironment) {
    /** 未定义环境 */
            AlibcEnvironmentNone = -1,
    /** 测试环境 */
            AlibcEnvironmentDaily = 0,
    /** 预发环境 */
            AlibcEnvironmentPreRelease,
    /** 线上环境 */
            AlibcEnvironmentRelease
};

/** 日志级别 */
typedef NS_ENUM (NSUInteger, AlibcLogLevel) {
    /** 调试 */
            AlibcLogLevelDebug = 0,
    /** 信息 */
            AlibcLogLevelInfo = 1,
    /** */
            AlibcLogLevelPerf = 2,
    /** 警告 */
            AlibcLogLevelWarn = 3,
    /** 错误 */
            AlibcLogLevelError = 4,
};

/** SDK当前状态 */
typedef NS_ENUM (NSUInteger, AlibcSDKState) {
    /** SDK未进行初始化 */
    AlibcSDKStateUnInit = 0,
    /** SDK初始化当中 */
    AlibcSDKStateIniting = 1,
    /** SDK初始化完成 */
    AlibcSDKStateInitSucc = 2,
    /** SDK初始化失败 */
    AlibcSDKStateInitFailed = 3
};



NS_ASSUME_NONNULL_BEGIN

/** 配置 */
@interface AlibcConfig : NSObject
/** sdk初始化标识 */
@property(nonatomic,assign)AlibcSDKState sdkState;
/** sdk是否需要升级 */
@property(nonatomic,assign)BOOL isNeedUpdateSDK;
/** sdk强制升级文案 */
@property(nonatomic,copy)NSString * _Nullable errorMsg;
/** sdk是否允许唤端 */
@property(nonatomic,assign)BOOL isAllowLinkTaobao;
/** 系统环境 */
@property(atomic, assign) AlibcEnvironment environment;
/** 日志级别 */
@property(atomic, assign) AlibcLogLevel logLevel;
/** UTDID */
@property(atomic, strong) NSString *utdId;
/** appKey */
@property(atomic, strong) NSString *appKey;

/** appVersion */
@property(atomic, strong) NSString *appVersion;

/** appName */
@property(atomic, strong) NSString *appName;

/** 共享实例 */
+ (instancetype)sharedConfig;

/** 写入插件上下文 */
- (void)setValue:(nullable id)value forKey:(NSString *)key forModule:(NSString *)module;

/** 读取插件上下文 */
- (id)valueForKey:(NSString *)key forModule:(NSString *)module;

- (void)setDictionary:(NSDictionary *)dic forModule:(NSString *)module;
@end

NS_ASSUME_NONNULL_END

#endif
