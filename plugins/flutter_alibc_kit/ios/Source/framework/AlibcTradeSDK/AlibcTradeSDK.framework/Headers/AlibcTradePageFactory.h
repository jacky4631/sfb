/*
 * AlibcTradePageFactory.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>


@protocol AlibcTradePage <NSObject>

@end


NS_ASSUME_NONNULL_BEGIN

/** 页面工厂类,用于构造各类要显示的page */
@interface AlibcTradePageFactory : NSObject
/**
 * 创建URL指定页面
 *
 * @param url     地址
 *
 * @return URL指定页面
 */
+ (id <AlibcTradePage>)page:(NSString *)url;

/**
 * 创建商品真实ID或者混淆(open)ID对应的详情页面
 * 
 * @param itemId   商品真实ID或者混淆(open)ID
 *
 * @return 详情页面
 */
+ (id <AlibcTradePage>)itemDetailPage:(NSString *)itemId;

/**
 * 创建我的购物车页面
 *
 * @return 我的购物车页面
 */
+ (id <AlibcTradePage>)myCartsPage;

/**
 * 创建我的订单列表页面
 *
 * @param status 所要展示订单的订单状态
 *  0: 为全部订单
 *  1: 为待付款订单
 *  2: 为待发货订单
 *  3: 为待收货订单
 *  4: 为待评价订单
 * @param isAllOrder  是否显示全部订单
 *
 *  YES: 显示全部订单
 *  NO : 显示ISV自己创建的订单
 *
 * @return 我的订单列表页面
 */
+ (id <AlibcTradePage>)myOrdersPage:(NSInteger)status isAllOrder:(BOOL)isAllOrder;

/**
 * 创建店铺页面
 *
 * @param shopId 店铺ID
 *
 * @return 店铺页面
 */
+ (id <AlibcTradePage>)shopPage:(NSString *)shopId;

/**
 * 创建添加到购物车页面
 *
 * @param itemId   商品真实ID或者混淆(open)ID
 *
 * @return 店铺页面
 */
+ (id <AlibcTradePage>)addCartPage:(NSString *)itemId;

@end

NS_ASSUME_NONNULL_END

