/*
 * AlibcURLRequestParam.h 
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
#import "AlibcLinkPartnerBridge.h"
#import "AlibcTradeShowParams.h"
#import "AlibcTradeSDKDefines.h"
#import "AlibcURLBusContext.h"

@interface AlibcURLRequestParam : NSObject

// 原始URL
@property(nonatomic,strong)NSString *url;

// webView加载被事先转链标识
@property(nonatomic,assign)BOOL isConvertUrl;

// 当isConvertUrl = YES且urlSource == web 时，此时url路由匹配使用此值
@property(nonatomic,copy)NSString *originalUrl;

// 业务标识 (detail/shop/.../unkown)
@property(nonatomic,copy)NSString *bizCode;

// 打开方式参数
@property(nonatomic,strong)AlibcTradeShowParams *showParams;

// 链路跟踪参数
@property(nonatomic,strong) NSMutableDictionary *trackParam;

// 交易相关数据
@property(nonatomic,strong) id tradeData;

// 淘客参数
@property(nonatomic,strong)AlibcTradeTaokeParams *taokeParams;

// h5承载容器
@property(nonatomic, strong) WKWebView *webview;

// 跳转发起来源页面
@property(nonatomic, strong) UIViewController *sourceViewController;

// url 来源
@property(nonatomic,assign)AlibcUrlSourceType urlSource;

// h5 二跳专用
@property(nonatomic, strong)AlibcURLBusContext *context;

@end

