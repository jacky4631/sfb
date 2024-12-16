//
//  MtopExtAppMonitorProtocol.h
//  mtopext
//
//  Created by sihai on 18/6/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MtopExtAppMonitorProtocol <NSObject>

/*
 * 注册性能埋点时，需要填入的参数（minValue，maxValue，contantValue）其key值固定，可通过如下三个get方法分别获取
 *
 */
+ (NSString*)GetMinKeyName;
+ (NSString*)GetMaxKeyName;
+ (NSString*)GetConstantKeyName;

/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标,详见上个接口的measures说明。
 * @param dimemsions 多维度
 dimensions说明：是一个数组，数组中存储一个NSDictionary,该NSDictionary的键为dimensionName，Value为一个可能包含constantValue的NSDictionary，如果不设置该值，则传一个内容为空的NSDictionary进来。
 * @param isCommitDetail 标记是否提交明细。需要提交明细时设置为YES，否则为NO
 */
+ (BOOL)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(NSArray*)measures dimensionSet:(NSArray*)dimensions isCommitDetail:(BOOL)detail;


/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标:
 measures说明：是一个数组，数组中存储一个NSDictionary,该NSDictionary的键为measureName，Value为一个可能包含min和max或constantValue的NSDictionary.
 * @param isCommitDetail 标记是否提交明细。需要提交明细时设置为YES，否则为NO
 */
+ (BOOL)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(NSArray*)measures isCommitDetail:(BOOL)detail;

/**
 * 提交多维度，多指标
 * @param module 监控模块
 * @param monitorPoint 监控点名称 Page+monitorPoint必须唯一
 * @param dimensionValues 维度值集合
 dimensionValues说明：为一个NSDictionary，key为dimensionName， Value为dimension的值。
 * @param measureValues 指标值集合
 measureValues说明：为一个NSDictionary，key为measureName，Value为measure的值。
 */
+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint dimensionValueSet:(NSDictionary *)dimensionValues measureValueSet:(NSDictionary *)measureValues;
@end
