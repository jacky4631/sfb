/*
 * AlibcAuthViewController.h 
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


typedef void (^AUTHVIEW_COMPLETION_HANDLER)(BOOL isSuccessful, NSString *token);

typedef void (^AUTHVIEW_CANCELATION_HANDLER)();

@interface AlibcAuthViewController : NSObject
@property(nonatomic, copy) NSArray<NSString *> *hintList;
@property(nonatomic, copy) NSString *apiName;
@property(nonatomic, copy) NSString *apiVersion;
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;


@property(nonatomic, copy) AUTHVIEW_COMPLETION_HANDLER completionHandler;
@property(nonatomic, copy) AUTHVIEW_CANCELATION_HANDLER cancelationHandler;

- (void)  showAuth:(NSArray<NSString *> *)hintList
 completionHandler:(AUTHVIEW_COMPLETION_HANDLER)completionHandler
cancelationHandler:(AUTHVIEW_CANCELATION_HANDLER)cancelationHandler;

- (void)  showAuth:(NSString *)apiName
           version:(NSString *)version
 completionHandler:(AUTHVIEW_COMPLETION_HANDLER)completionHandler
cancelationHandler:(AUTHVIEW_CANCELATION_HANDLER)cancelationHandler;

@end
