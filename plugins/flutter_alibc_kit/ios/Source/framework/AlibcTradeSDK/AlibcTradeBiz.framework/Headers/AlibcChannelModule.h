/*
 * AlibcChannelModule.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#ifndef ALiChannelModule_h
#define ALiChannelModule_h

#import <Foundation/Foundation.h>

//添加umpChannel u_channel isvCode,ybhpss,ttid参数
@interface AlibcChannelModule : NSObject

+ (void)addChannelParam:(NSMutableDictionary *)param;

@end

#endif /* ALiChannelModule_h */
