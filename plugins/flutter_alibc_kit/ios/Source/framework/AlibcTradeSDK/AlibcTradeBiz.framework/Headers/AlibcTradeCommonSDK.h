/*
 * AlibcTradeCommonSDK.h 
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

#ifndef AlibcTradeCommonSDK_h
#define AlibcTradeCommonSDK_h

@interface AlibcTradeCommonSDK : NSObject
/**
 *  初始化函数,初始化成功后方可正常使用SDK中的功能
 *
 *  @param onSuccess 初始化成功的回调
 *  @param onFailure 初始化失败的回调
 */
+ (void)asyncInitWithSuccess:(void (^)())onSuccess
                     failure:(void (^)(NSError *error))onFailure;

@end


@interface AlibcTradeCommonSDK (Settings)

/**
 *  设置环境
 */
+ (void)setEnv:(AlibcEnvironment)env;

/**
 *  获取当前环境对象
 */
+ (AlibcEnvironment)getEnv;


/**
 开启 Debug 模式日志
 */
+ (void)setDebugLogOpen:(BOOL)isDebugLogOpen;

@end

#endif
