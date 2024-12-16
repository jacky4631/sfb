/*
 * AlibcTradeError.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#ifndef AlibcError_h
#define AlibcError_h

#import <Foundation/Foundation.h>

/** 交易错误码 */
typedef NS_ENUM (NSUInteger, AlibcTradeError) {
    /** 交易链路失败 */
            AlibcErrorProcessFailed = 3001,
    /** 交易链路中用户取消了操作 */
            AlibcErrorCancelled = 3002,
    /** 交易链路中发生支付但是支付失败 */
            AlibcErrorPaymentFailed = 3003,
    /** itemId无效 */
            AlibcErrorInvalidItemID = 3004,
    /** page url为空 */
            AlibcErrorNullPageURL = 3005,
    /** shopId无效 */
            AlibcErrorInvalidShopID = 3006,
};

extern NSString *const AlibcTradeErrorDomain;

#endif /* AlibcError_h */
