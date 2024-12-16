/*
 * AlibcMonitorUtil.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#ifndef ALiMonitorUtil_h
#define ALiMonitorUtil_h

#define MONITOR_MODULE @"BCTradeSDK"

@interface AlibcMonitorUtil : NSObject

+ (instancetype)shareInstance;

/**
 * 注册性能监控点
 @param monitor 监控点，例：@"init"
 */
//-(void)registMonitorPoint:(ALiMonitor*)monitor;



/**
 *  记录业务操作成功接口
 *
 *  @param module   模块名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @arg 附加参数，用于做横向扩展
 */
- (void)commitSuccessWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint arg:(NSString *)arg;

/**
 *  记录业务操作失败接口
 *
 *  @param module   模块名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @param errorCode 错误码，若为MTOP请求则传MTOP的错误码,否则请业务方对错误进行分类编码,方便统计错误类型占比
 *  @param errorMsg  错误信息，若位MTOP请求则传MTOP的错误信息, 否则请业务方自己描述错误, 方便自己查找原因
 *  @arg 附加参数，用于做横向扩展
 */
- (void)commitFailWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg;


/**
 * 提交多维度，多指标
 * @param monitor    监控模块
 */
//-(void)commitWithMonitor:(ALiMonitor*)monitor;

/**
 * 开始监控
 * @param key 计算时间的标示符，不能重复
 * @return 是否加入监控，key重复，会覆盖
 */
//-(BOOL)beginTimeMonitor:(NSString*)key;

/**
 * 结束监控，清楚监控key
 * @param key ，计算时间的标示符，必须有begin，否则返回0
 * @return 返回耗时，毫秒数
 */
//-(NSString*)endTimeMonitor:(NSString*)key;

/**
 * 清除所有监控key
 */
//-(void)clearAllTimeMonitor;

/**
 * 清除指定监控key
 */
//-(void)clearTimeMonitor:(NSString*)key;

@end

@class AlibcTradeMonitor;

@protocol AlibcTradeAppMonitorAdapter <NSObject>

- (void)commit:(AlibcTradeMonitor *)monitor;

- (void)commitSuccessWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint arg:(NSString *)arg;

- (void)commitFailWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg;

- (void)registerMonitor:(AlibcTradeMonitor *)monitor;

@end



#endif /* ALiMonitorUtil_h */
