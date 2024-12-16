/*
 * AlibcTradeEnv.h 
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

#ifndef ALiTradeEnv_h
#define ALiTradeEnv_h

NS_ASSUME_NONNULL_BEGIN

/** 地址 */
@interface AlibcTradeEnv : NSObject
/** 真实ID商品详情页地址 */
+ (nullable NSString *)itemURLWithItemType:(NSString *)itemID;

/** 迷你商品详情页地址 */
+ (nullable NSString *)miniItemURLWithItemID:(NSString *)itemID;

/** 直接加购页地址 */
+ (nullable NSString *)addCardURL:(NSString *)itemID;

/** 购物车地址 */
+ (nullable NSString *)cartURL;

/** 我的订单地址 */
+ (nullable NSString *)myOrdersURLWithTabCode:(NSString *)tabCode condition:(nullable NSString *)condition;

/** 店铺页地址 */
+ (nullable NSString *)shopURLWithShopID:(nonnull NSString *)shopID;

/** 淘宝首页 */
+ (nullable NSString *)taobaoHomeURL;

/** 配置服务端host地址(营造维护) */
+ (nullable NSString *)configServerHost;

/** 配置新电商配置服务端host地址 */
+ (nullable NSString *)configNewTradeServerHost;
@end

NS_ASSUME_NONNULL_END

#endif //ALiTradeEnv_h
