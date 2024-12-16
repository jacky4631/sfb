/*
 * AlibcURLBus.h 
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
#import "AlibcURLBusContext.h"

#ifndef AlibcURLBus_h
#define AlibcURLBus_h

@class WKWebView;
@class UIViewController;

/** 处理结果 */
@interface AlibcURLProcessResult : NSObject
/** 是否过滤 */
@property(assign, nonatomic) BOOL filtered;
/** 是否处理 */
@property(assign, nonatomic) BOOL handled;
/** 结果URL */
@property(strong, nonatomic) NSURL *URL;
@end

//url匹配,getUrlRule和matchUrl只需实现一个,
@protocol AlibcURLBusMatch <NSObject>
@optional

//返回正则匹配表达式,会自动用正则做判断
- (NSArray<NSString *> *)getUrlRule;

//返回是否匹配,匹配返回YES
- (BOOL)matchUrl:(NSString *)url;
@end

@protocol AlibcURLBusHandle <AlibcURLBusMatch>
//返回YES,则url加载会被中断...返回NO,正常加载
- (BOOL)handleURL:(NSURL *)url context:(AlibcURLBusContext *)context;

@end

@protocol AlibcURLBusFilter <AlibcURLBusMatch>
//返回修改过的url,或者把参数url返回...会加载返回的url值
- (NSURL *)filterURL:(NSURL *)url context:(AlibcURLBusContext *)context;

@end


@interface AlibcURLBus : NSObject
+ (instancetype)defaultBus;


/**
 添加一个 Handle 实现

 @param handle Handle 实例
 */
- (void)addHandle:(id <AlibcURLBusHandle>)handle;


/**
 移除一个 Handle 实现

 @param handle Handle 实例
 */
- (void)removeHandle:(id <AlibcURLBusHandle>)handle;


- (void)addFilter:(id <AlibcURLBusFilter>)handle;

- (void)removeFilter:(id <AlibcURLBusFilter>)handle;


/**
 处理URL
 @param url 原始URL
 @param context 总线上下文
 @return 是否处理
 */
- (BOOL)handleURL:(NSURL *)url context:(AlibcURLBusContext *)context;

/**
 过滤并处理URL
 @param url 原始URL
 @param context 总线上下文
 @return 处理结果
 */
- (AlibcURLProcessResult *)processURL:(NSURL *)url context:(AlibcURLBusContext *)context;


- (BOOL)handleOpenURL:(NSURL *)url;


@end

#endif
