/*
 * AlibcMsgBus.h 
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

#ifndef AlibcMsgBus_h
#define AlibcMsgBus_h

typedef NS_ENUM(NSInteger, MsgBusItemType) {
    MsgBusItemTypeFilter,  //过滤器
    MsgBusItemTypeTop, //top监听,首先被串行通知,通知完后才通知normal
    MsgBusItemTypeNormal  //普通监听,并发通知
};


@interface AlibcMsgBus : NSObject
+ (instancetype)sharedInstance;

- (void)registerNotify:(NSString *)eventID target:(NSObject *)target action:(SEL)action dataType:(Class)dataType mainThread:(BOOL)bMain type:(MsgBusItemType)type;

- (void)registerNotify:(NSString *)eventID target:(NSObject *)target action:(SEL)action dataType:(Class)dataType1 dataType:(Class)dataType2 mainThread:(BOOL)bMain type:(MsgBusItemType)type;

- (void)registerNotify:(NSString *)eventID target:(NSObject *)target action:(SEL)action dataType:(Class)dataType1 dataType:(Class)dataType2 dataType:(Class)dataType3 mainThread:(BOOL)bMain type:(MsgBusItemType)type;


- (void)unregisterEventNotifyByTarget:(NSString *)eventID target:(NSObject *)target;

- (BOOL)fireEventNotify:(NSString *)eventID data:(id)data;

- (BOOL)fireEventNotify:(NSString *)eventID data1:(id)data1 data2:(id)data2;

- (BOOL)fireEventNotify:(NSString *)eventID data1:(id)data1 data2:(id)data2 data3:(id)data3;

@end

#endif
