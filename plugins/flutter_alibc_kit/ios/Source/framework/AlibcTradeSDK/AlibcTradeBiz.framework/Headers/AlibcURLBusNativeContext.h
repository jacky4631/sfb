/*
 * AlibcURLBusNativeContext.h 
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
#import <WebKit/WebKit.h>
#import "AlibcTradeTaokeParams.h"

/**
 拉起手淘失败后的处理策略
 
 - AlibcNativeFailModeJumpH5: 当拉起手淘/天猫失败, 则在 webview 中跳转对应 H5 (可自定义)页面; 默认选项
 - AlibcNativeFailModeJumpDownloadPage: 当拉起手淘/天猫失败, 则跳转对应 App 下载页面
 - AlibcNativeFailModeNone: 当拉起手淘/天猫失败, 不做额外操作
 */
typedef NS_ENUM(NSInteger, AlibcNativeFailMode) {
    AlibcNativeFailModeJumpH5 = 0,
    AlibcNativeFailModeJumpDownloadPage = 1,
    AlibcNativeFailModeNone = 2,
};

@interface AlibcURLBusNativeContext : NSObject

// parentVC
@property(nonatomic,strong)UIViewController *sourceViewController;

// 拉端URL
@property(nonatomic,copy)NSString *url;

// bizCode (detail/shop/.../unkown)
@property(nonatomic,copy)NSString *bizCode;

// 拉起目标客户端
@property(nonatomic,copy)NSString *linkKey;

// 拉端失败策略
@property(nonatomic,assign)AlibcNativeFailMode failMode;

// aid转链需要
@property(nonatomic,strong) WKWebView *webview;

// 淘客参数
@property(nonatomic,strong)AlibcTradeTaokeParams *taokeParams;


// 是否需要push
@property(nonatomic,assign) BOOL isNeedPush;


// 交易相关数据
@property(nonatomic,strong) id tradeData;


// 用户传参
@property(nonatomic,copy)NSDictionary *param;


// itemId
@property(nonatomic,copy)NSString *itemId;

//shopId
@property(nonatomic,copy)NSString *shopId;

// isAid
@property(nonatomic,assign)BOOL isAid;

// 是否被转链
@property(nonatomic,assign)BOOL isConvertUrl;

// 是否是二跳webView
@property(nonatomic,assign)BOOL isFromWeb;

@end
