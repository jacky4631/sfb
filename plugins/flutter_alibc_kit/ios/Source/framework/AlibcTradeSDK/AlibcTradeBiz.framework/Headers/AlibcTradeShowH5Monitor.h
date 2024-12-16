/*
 * AlibcTradeShowH5Monitor.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import "AlibcTradeWebViewMonitor.h"


typedef NSString *AlibcTradeShowH5TaokeTypeMeasure;

FOUNDATION_EXPORT AlibcTradeShowH5TaokeTypeMeasure AlibcTradeShowH5TaokeTypeMeasureNoTrace; // Default value
FOUNDATION_EXPORT AlibcTradeShowH5TaokeTypeMeasure AlibcTradeShowH5TaokeTypeMeasureSyncTrace;
FOUNDATION_EXPORT AlibcTradeShowH5TaokeTypeMeasure AlibcTradeShowH5TaokeTypeMeasureAsyncTrace;

@interface AlibcTradeShowH5Monitor : AlibcTradeWebViewMonitor


@property(strong, nonatomic, readonly) AlibcTradeTimeMeasure *taokeTimeMeasure;

@property(strong, nonatomic, readonly) AlibcTradeTimeMeasure *analysisTimeMeasure;

@property(strong, nonatomic, readonly) AlibcTradeDimension *taokeTypeDimension;

@end

/**
 WKWebView AlibcTradeShowH5Monitor Category
 */
@interface WKWebView (AlibcTradeShowH5Monitor)

- (void)alibc_setShowH5Monitor:(AlibcTradeShowH5Monitor *)monitor;

- (AlibcTradeShowH5Monitor *)alibc_showH5Monitor;

@end
