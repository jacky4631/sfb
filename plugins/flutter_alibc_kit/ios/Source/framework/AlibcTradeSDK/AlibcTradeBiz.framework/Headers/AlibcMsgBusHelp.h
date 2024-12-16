/*
 * AlibcMsgBusHelp.h 
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
#import <UIKit/UIKit.h>

#ifndef AlibcMsgBusHelp_h
#define AlibcMsgBusHelp_h

/**
 Filter和top,是串行通知,通知结束后并发通知普通notify
 **/

/**
//所有notify/topNotify的action都是sel:(id)data
//所有notify/topNotify2的action都是sel:(id)data1 data2:(id)data2
//所有notify/topNotify3的action都是sel:(id)data1 data2:(id)data2 data3:(id)data3

//所有Filter的action都是sel:(id)data stop:(BOOL*)bStop
//所有Filter2的action都是sel:(id)data1 data2:(id)data2 stop:(BOOL*)bStop
//所有Filter3的action都是sel:(id)data1 data2:(id)data2 data3:(id)data3 stop:(BOOL*)bStop
 */

#define MSGBUS_RECEIVER(eventId, function, dataclass) [self registerEventNotify:eventId action:@selector(function) dataClass:[dataclass class]];
#define MSGBUS_RECEIVER2(eventId, function, dataclass1, dataclass2) [self registerEventNotify:eventId action:@selector(function) dataClass1:[dataclass1 class] dataClass2:[dataclass2 class]];
#define MSGBUS_RECEIVER3(eventId, function, dataclass1, dataclass2, dataclass3) [self registerEventNotify:eventId action:@selector(function) dataClass1:[dataclass1 class] dataClass2:[dataclass2 class] dataClass3:[dataclass3 class]];


#define MSGBUS_TOP_RECEIVER(eventId, function, dataclass) [self registerEventTopNotify:eventId action:@selector(function) dataClass:[dataclass class]];
#define MSGBUS_TOP_RECEIVER2(eventId, function, dataclass1, dataclass2) [self registerEventTopNotify:eventId action:@selector(function) dataClass1:[dataclass1 class] dataClass2:[dataclass2 class]];
#define MSGBUS__TOP_RECEIVER3(eventId, function, dataclass1, dataclass2, dataclass3) [self registerEventTopNotify:eventId action:@selector(function) dataClass1:[dataclass1 class] dataClass2:[dataclass2 class] dataClass3:[dataclass3 class]];


#define MSGBUS_RECEIVER_FILTER(eventId, function, dataclass) [self registerEventFilter:eventId action:@selector(function) dataClass:[dataclass class]];
#define MSGBUS_RECEIVER_FILTER2(eventId, function, dataclass1, dataclass2) [self registerEventFilter:eventId action:@selector(function) dataClass1:[dataclass1 class] dataClass2:[dataclass2 class]];
#define MSGBUS_RECEIVER_FILTER3(eventId, function, dataclass1, dataclass2, dataclass3) [self registerEventFilter:eventId action:@selector(function) dataClass1:[dataclass1 class] dataClass2:[dataclass2 class] dataClass3:[dataclass3 class]];


@protocol AMPMsgBusHelpProtocol <NSObject>

- (void)registerEventFilter:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass:(nonnull Class)dataClass;

- (void)registerEventFilter:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass1:(nonnull Class)dataClass1 dataClass2:(nonnull Class)dataClass2;

- (void)registerEventFilter:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass1:(nonnull Class)dataClass1 dataClass2:(nonnull Class)dataClass2 dataClass3:(nonnull Class)dataClass3;

- (void)registerEventTopNotify:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass:(nonnull Class)dataClass;

- (void)registerEventTopNotify:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass1:(nonnull Class)dataClass1 dataClass2:(nonnull Class)dataClass2;

- (void)registerEventTopNotify:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass1:(nonnull Class)dataClass1 dataClass2:(nonnull Class)dataClass2 dataClass3:(nonnull Class)dataClass3;

- (void)registerEventNotify:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass:(nonnull Class)dataClass;

- (void)registerEventNotify:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass1:(nonnull Class)dataClass1 dataClass2:(nonnull Class)dataClass2;

- (void)registerEventNotify:(nonnull NSString *)eventID action:(nonnull SEL)action dataClass1:(nonnull Class)dataClass1 dataClass2:(nonnull Class)dataClass2 dataClass3:(nonnull Class)dataClass3;

@end

//MSGBUG_FILTER,都是注册在专用线程上.
//MSGBUS_RECEIVER,继承自AMPMsgBusHelp的,都是注册在专用线程上(非并发执行),
@interface AlibcMsgBusHelp : NSObject <AMPMsgBusHelpProtocol>

@end

//继承自AMPMsgBusUIHelp的,都是注册在ui主线程上..
@interface AlibcMsgBusUIHelp : UIViewController <AMPMsgBusHelpProtocol>

@end

#endif
