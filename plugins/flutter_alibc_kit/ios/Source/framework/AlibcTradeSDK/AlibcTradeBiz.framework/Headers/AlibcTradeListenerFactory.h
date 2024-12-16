/*
 * AlibcTradeListenerFactory.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeCommonSDK 
 * 版本号：5.0.0.0
 * 发布时间：2020-01-03
 * 开发团队：阿里巴巴百川
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Listener 的工厂，相同 Protocol 的 Listener 只允许注册一个。
*/
@interface AlibcTradeListenerFactory : NSObject

/**
 注册指定的 Listener。
 */
+ (void)registerHandler:(id _Nonnull)handler withProtocol:(Protocol * _Nonnull)protocol;

/**
 注册指定的 Listener 类。
 
 @param singleton 是否是单例。如果为 YES，会将首次调用创建的实例保存起来；如果为 NO，会每次返回一个新实例。
 */
+ (void)registerHandlerClass:(Class _Nonnull)handlerClass isSingleton:(BOOL)singleton withProtocol:(Protocol * _Nonnull)protocol;

/**
 移除指定 Protocol 的 Listener。
 */
+ (void)unregisterHandlerWithProtocol:(Protocol * _Nonnull)protocol;

/**
 获取与指定 Protocol 关联的 Listener。
 */
+ (id _Nullable)handlerForProtocol:(Protocol * _Nonnull)protocol;

@end

NS_ASSUME_NONNULL_END
