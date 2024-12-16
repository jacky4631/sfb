/*
 * AlibcTradeBenchmarkable.h 
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

#ifndef AlibcTradeBenchmarkable_h
#define AlibcTradeBenchmarkable_h

NS_ASSUME_NONNULL_BEGIN

/**
 可基准化协议
 */
@protocol AlibcTradeBenchmarkable <NSObject>

/**
 基准字段值
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 基准值
 */
@property(strong, nonatomic, readonly) id value;

- (NSDictionary *)toDictionary;

@end

#pragma mark - 指标

/**
 指标基本类
 */
@interface AlibcTradeMeasure : NSObject <AlibcTradeBenchmarkable>

/**
 指标的字段名
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 指标的对应值
 */
@property(strong, nonatomic, readwrite, nullable) NSNumber *value;


/**
 构造方法

 @param name 指标字段名
 @return 指标对象
 */
- (instancetype)initWithName:(nonnull NSString *)name;

/**
 @return @{ name : value }
 */
- (NSDictionary *)toDictionary;

@end

#pragma mark - 维度

/**
 维度基本类
 */
@interface AlibcTradeDimension : NSObject <AlibcTradeBenchmarkable>

/**
 维度的字段名
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 维度的对应值
 */
@property(strong, nonatomic, readwrite, nullable) NSString *value;

/**
 构造方法

 @param name 维度字段名
 @return 维度对象
 */
- (instancetype)initWithName:(nonnull NSString *)name;

/**
 @return @{ name : value }
 */
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END


#pragma mark - 时间指标

/**
 时间指标
 */
@interface AlibcTradeTimeMeasure : AlibcTradeMeasure

/**
 如果还没开始, 那么开始..
 */
- (void)start;


/**
 没开始就开始, 开始了就重新开始..
 */
- (void)restart;


/**
 结束并记录时长.
 */
- (void)stopThenRecord;

- (BOOL)isRecording;

@end

#endif
