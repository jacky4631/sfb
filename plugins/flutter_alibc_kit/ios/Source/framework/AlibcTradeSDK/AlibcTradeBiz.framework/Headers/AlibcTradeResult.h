/*
 * AlibcTradeResult.h 
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

@class AlibcTradePayResult;

/** 交易结果类型 */
typedef NS_ENUM (NSUInteger, AlibcTradeResultType) {
    /** 成功添加到购物车 */
            AlibcTradeResultTypeAddCard,
    /** 成功支付 */
            AlibcTradeResultTypePaySuccess
};


/** 交易结果 */
@interface AlibcTradeResult : NSObject
/** 交易结果的类型 */
@property(nonatomic, assign) AlibcTradeResultType result;
/** 支付结果,只有Result为 AlibcTradeResultTypePaySuccess时有效 */
@property(nonatomic, strong) AlibcTradePayResult *payResult;

@end



