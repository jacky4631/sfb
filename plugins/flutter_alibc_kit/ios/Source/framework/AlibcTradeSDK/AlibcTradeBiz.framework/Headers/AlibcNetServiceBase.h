/*
 * AlibcNetServiceBase.h 
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
#import "AlibcNetPacket.h"

#ifndef AlibcNetServiceBase_h
#define AlibcNetServiceBase_h

#define AMP_NET_ERROR_TIME_OUT 118

@interface AlibcNetServiceBase : NSObject
@property(nonatomic, assign) NSTimeInterval timeoutSeconds;

- (BOOL)processPacket:(AlibcNetPacket *)packet;

- (BOOL)processJSPacket:(AlibcNetPacket *)packet;

- (void)netJSPacketSuccess:(AlibcNetPacket *)packet data:(id)data;

- (void)netJSPacketFail:(AlibcNetPacket *)packet error:(id)error;

- (void)netPacketSuccess:(AlibcNetPacket *)packet data:(id)data;

- (void)netPacketFail:(AlibcNetPacket *)packet error:(AlibcNetError *)error;

//子类重载该函数,执行真实发送 ,其他的不要乱重载
- (BOOL)performSend:(AlibcNetPacket *)packet;

- (BOOL)performJSSend:(AlibcNetPacket *)packet;

- (BOOL)shouldRetry:(NSError *)error;
@end

#endif
