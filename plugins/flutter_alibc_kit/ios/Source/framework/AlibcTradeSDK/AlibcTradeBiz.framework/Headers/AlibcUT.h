/*
 * AlibcUT.h 
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
#import <WebKit/WebKit.h>

#ifndef AlibcUT_h
#define AlibcUT_h

#define ALiTRADE_TRACE_TRACKER_ID @"aliTradesdk"

typedef NSString AlibcUTEventID;
@class WKWebView;
@class UIViewController;

FOUNDATION_EXTERN NSString *AlibcUTGlobalPropertySdkVersion;
FOUNDATION_EXTERN NSString *AlibcUTGlobalPropertyTTID;


/*
 * @brief 用于透出事件埋点
 */
FOUNDATION_EXTERN AlibcUTEventID *const AlibcUTEventID$2201;

/*
 * @brief 用于点击事件埋点
 */
FOUNDATION_EXTERN AlibcUTEventID *const AlibcUTEventID$2101;

FOUNDATION_EXTERN NSString *const AlibcUTArgsKeyYBHPSS;

FOUNDATION_EXTERN NSString *const AlibcUTArgsKeyYBHPSS_LABEL;

@interface AlibcUT : NSObject


/**
 初始化 ALiUT
 */
+ (void)initUT;


/**
 功能是否可用, 是否有 adapter 支撑功能

 @return 是否可用
 */
+ (BOOL)isAvailable;


/**
 是否三方ut

 @return 是否三方ut
 */
+ (BOOL)isThird;


/**
 添加打点记录的便捷方法

 @param page pageName
 @param label arg1
 @param interval 无效兼容字段
 @param propertyDict args
 */
+ (void)addTraceLog:(NSString *)page
              label:(NSString *)label
           interval:(NSInteger)interval
          propertys:(NSDictionary *)propertyDict;


/**
  添加打点记录的便捷方法

 @param label arg1
 @param propertyDict args
 */
+ (void)addTraceLog:(NSString *)label propertys:(NSDictionary *)propertyDict;


/**
 添加打点记录的便捷方法

 @param label arg1
 */
+ (void)addTraceLog:(NSString *)label;


/**
 添加打点记录的便捷方法

 @param eventID eventID
 @param arg1 arg1
 @param args args
 */
+ (void)addTradeLogWithEventID:(AlibcUTEventID *)eventID arg1:(NSString *)arg1 args:(NSDictionary *)args;


/**
 添加打点记录的便捷方法
 
 @param trackerID trackerID
 @param eventLabel arg1
 @param properties args
 */
+ (void)addTrackToTracker:(NSString *)trackerID eventLabel:(NSString *)eventLabel properties:(NSDictionary *)properties;


/**
 打点的标准实现

 @param trackerID track id
 @param eventID 事件 id
 @param pageName pageName
 @param arg1 arg1 == label
 @param arg2 arg2 description
 @param arg3 arg3 description
 @param args args == propertirs
 */
+ (void)addTradeLog:(NSString *)trackerID
            eventID:(NSString *)eventID
               page:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args;


/**
 供jsbridge打点

 @param dataDict dataDict
 @param pView webView
 @param pViewController vc
 @return return value
 */
+ (BOOL)h5UT:(NSDictionary *)dataDict view:(WKWebView *)pView viewController:(UIViewController *)pViewController;


/**
 设置 channel

 @param channel channel
 */
+ (void)setChannel:(NSString *)channel;


/**
 读取全局字段

 @param key 字段名
 @return 值
 */
+ (NSString *)globalPropertyForKey:(NSString *)key;


/**
 设置全局字段

 @param property 值
 @param key 字段名
 */
+ (void)setGlobalProperty:(NSString *)property forKey:(NSString *)key;

@end

@protocol AlibcUTAdapter <NSObject>

#pragma mark - Initialize

@required

- (void)initWithAppkey:(NSString *)appkey;


#pragma mark - Configure

@required
- (void)setChannel:(NSString *)channel;

@required
- (NSString *)globalPropertyForKey:(NSString *)key asTracker:(NSString *)trackerID;

@required
- (void)setGlobalProperty:(NSString *)property forKey:(NSString *)key asTracker:(NSString *)trackerID;


#pragma mark - Commit

@required
- (void)addTradeLog:(NSString *)trackerID
            eventID:(NSString *)eventID
               page:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args;

@optional
- (void)h5UT:(NSDictionary *)dataDict view:(WKWebView *)pView viewController:(UIViewController *)pViewController;

#pragma mark - Other

@optional
- (BOOL)isThird;

@end


#define AlibcNSStringify(a) @#a
#define AlibcAppendUTSuffixUtil AlibcNSStringify(_aliTradesdk_)AlibcTradeBizSDKVersion

#endif
