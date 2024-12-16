/*
 * AlibcURLDispatchHelper.h 
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
#import "AlibcTradeSDKDefines.h"
#import "AlibcURLBusRequest.h"
#import "AlibcUrlhandleResult.h"

@interface AlibcURLDispatchHelper : NSObject

/** 共享实例 */
+ (instancetype)sharedDispatchHelper;

/**
 过滤并处理request
 @param request 页面打开request
 @return 处理结果
 */
- (AlibcUrlhandleResult *)processRequest:(AlibcURLBusRequest *)request;

@end
