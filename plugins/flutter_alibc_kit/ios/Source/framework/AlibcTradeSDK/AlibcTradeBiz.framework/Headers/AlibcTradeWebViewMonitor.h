/*
 * AlibcTradeWebViewMonitor.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

@import UIKit;
#import "AlibcWebViewEventListener.h"

@class AlibcTradeTimeMeasure;

@interface AlibcTradeWebViewMonitor : AlibcTradeMonitor <AlibcWebViewEventListener>

@property(strong, nonatomic, readonly) AlibcTradeDimension *pageTypeDimension;

/**
 URL 加载时间的维度
 */
@property(strong, nonatomic, readonly) AlibcTradeTimeMeasure *loadTimeMeasure;

/**
 URL 加载时间的维度
 */
@property(strong, nonatomic, readonly) AlibcTradeTimeMeasure *handleTimeMeasure;


/**
 打开页面总时间的维度
 */
@property(strong, nonatomic, readonly) AlibcTradeTimeMeasure *allTimeMeasure;

@end



//@class AlibcTradePage;

/**
 WKWebView AlibcTradeWebViewMonitor Category
 */
@interface WKWebView (AlibcTradeWebViewMonitor)

- (void)alibc_setWebViewMonitor:(AlibcTradeWebViewMonitor *)monitor;

- (AlibcTradeWebViewMonitor *)alibc_webViewMonitor;

- (BOOL)alibc_needToCommitUsability;

- (void)alibc_setNeedToCommitUsability:(BOOL)need;

- (NSString *)alibc_loadedByPage;

- (void)alibc_setLoadedByPage:(NSString *)pageCode;

@end
