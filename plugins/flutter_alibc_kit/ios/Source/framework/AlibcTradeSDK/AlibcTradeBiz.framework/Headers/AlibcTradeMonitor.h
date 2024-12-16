/*
 * AlibcTradeMonitor.h 
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

#ifndef AlibcTradeMonitor_h
#define AlibcTradeMonitor_h

@class AlibcTradeMeasure;
@class AlibcTradeDimension;
@protocol AlibcTradeBenchmarkable;


/**
 性能监控器基本类
 */
@interface AlibcTradeMonitor : NSObject

/**
 监控点所在模块名
 */
@property(strong, nonatomic, readonly) NSString *moduleName;

/**
 监控点名称
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 AppKey 维度
 */
@property(strong, nonatomic, readonly) AlibcTradeDimension *appkeyDimension;


/**
 App Version 维度
 */
@property(strong, nonatomic, readonly) AlibcTradeDimension *appVersionDimension;

/**
 SDK Version 维度
 */
@property(strong, nonatomic, readonly) AlibcTradeDimension *sdkVersionDimension;

/**
 平台指标
 */
@property(strong, nonatomic, readonly) AlibcTradeDimension *platformDimension;

- (instancetype)initWithName:(NSString *)name;

- (NSDictionary *)benchmarkableDataDictionary;

- (NSArray<id <AlibcTradeBenchmarkable>> *)allBenchmarkableData;

- (void)commit;

+ (void)registerMonitor;

@end

@interface AlibcTradeDispatchGroup : NSObject

@property(nonatomic, readonly) dispatch_group_t group;

@end

#endif
