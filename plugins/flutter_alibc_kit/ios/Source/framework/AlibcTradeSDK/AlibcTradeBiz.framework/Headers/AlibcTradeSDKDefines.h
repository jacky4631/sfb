/*
 * AlibcTradeSDKDefines.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#ifndef AlibcTradeSDKDefines_h
#define AlibcTradeSDKDefines_h

#import "AlibcTradeResult.h"

/*
 * trackParam 参数key说明
 */
#define track_scm @"scm"
#define track_pvid @"pvid"
#define track_isv_code @"isv_code"
/**
 *  打开页面的类型
 *  暂定 Native>小程序>h5
 */
typedef NS_ENUM(NSUInteger, AlibcOpenPageResultType) {
    /** 跳手淘 */
    AlibcOpenPageResultTypeNative,
    /** h5展示 */
    AlibcOpenPageResultTypeH5
};

/**
 *  URL 来源
 */
typedef NS_ENUM(NSUInteger, AlibcUrlSourceType) {
    /**API */
    AlibcUrlFromApi,
    /** h5 */
    AlibcUrlFromWeb
};

typedef void (^AlibcTradeProcessSuccessCallback)(AlibcTradeResult *__nullable result);

typedef void (^AlibcTradeProcessFailedCallback)(NSError *__nullable error);

#endif /* AlibcTradeSDKDefines_h */
