/*
 * AlibcTradeBizSDK.h 
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
#import "AlibcConfig.h"

#ifndef AlibcTradeBizSDK_h
#define AlibcTradeBizSDK_h

#define AlibcTradeBizSDKVersion @"4.1.0.4"


@interface AlibcTradeBizSDK : NSObject

/**
 *  初始化函数,初始化成功后方可正常使用SDK中的功能
 *
 *  @param onSuccess 初始化成功的回调
 *  @param onFailure 初始化失败的回调
 */
+ (void)asyncInitWithSuccess:(void (^)())onSuccess
                     failure:(void (^)(NSError *error))onFailure;
@end


@interface AlibcTradeBizSDK (Settings)

/**
 *  设置环境
 */
+ (void)setEnv:(AlibcEnvironment)env;


/**
 开启/关闭 Debug 模式日志

 @param isDebugLogOpen 开启/关闭
 */
+ (void)setDebugLogOpen:(BOOL)isDebugLogOpen;


/**
 上层需要运行时获取 SDK Version 时，可以使用这个接口获取

 @return AlibcTradeBizSDKVersion
 */
+ (NSString *)getSDKVersion;

@end

#endif //AlibcTradeBizSDK_h
