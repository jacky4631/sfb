//
//  MtopService.h
//  mtopext
//
//  mtop api 调用统一入口
//
//  Created by sihai on 4/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mtopext/MtopExtRequestDelegate.h>
#import <mtopext/MtopExtRequest.h>
#import <mtopext/MtopExtResponse.h>
#import <mtopext/LoginProtocol.h>
#import <mtopext/TBSDKConfiguration.h>
#import <mtopext/TBSDKAccountInfo.h>

/**
 * 内置二方MTOP实例ID
 */
#define MTOP_ID_INNER     @"INNER"


/**
 * 内置三方MTOP实例ID
 */
#define MTOP_ID_OPEN      @"OPEN"


/**
 * MTOP 实例接口。MTOP 支持多实例，目前支持2种类型(MtopType)，每一种类型均可创建多个实例，不同的实例以不同ID识别。
 *
 * 注意：该类型禁止被继承。
 */
@interface MtopService : NSObject


/**
 * 获取默认实例，默认返回ID为 MTOP_ID_INNER（二方类型）的实例。但是可以通过配置文件 mtopsdk_configuration.plist
 * 来设置默认返回类型。配置文件配置规则(示例)如下：
 *
 * Root (Dictionary)
 *  |
 *  |---DefaultID : @"INNER" (@"INNER" 内置二方实例; @“OPEN” 内置三方实例；或其他自定义实例 )
 *
 * @return MTOP实例
 */
+ (nullable instancetype) getInstance;



/**
 * 通过实例ID来获取对应实例。其中已经内置ID为 MTOP_ID_INNER 与 MTOP_ID_OPEN 实例, 如果需要新增实例，请通过
 * mtopsdk_configuration.plist 配置文件来新增实例，只有在 plist 中注册过的ID，才可以使用。配置文件配置规则(示例)如下：
 *
 * ROOT (dictionary)
 *  |---ExternalInstances (dictionary)
 *            |---- @"id1":@"0" (0 表示该实例类型为二方实例)
 *            |-----@"id2":@"1" (1 表示该实例类型为三方实例)
 *
 * 注意：ID为 MTOP_ID_INNER 与 MTOP_ID_OPEN 实例不可在配置文件中修改类型，已经分别设置为二方、三方实力。若不是
 *      MTOP_ID_INNER 与 MTOP_ID_OPEN，且名称未在plist中注册，返回nil.
 *
 * @param Id 索引MTOP实例的KEY值。可以为 MTOP_ID_INNER/MTOP_ID_OPEN 或者定义在 mtopsdk_configuration.plist 中
 * @return MTOP实例。若非内置实例且名称未注册，则返回nil.
 */
+ (nullable instancetype) getInstanceWithID:(nonnull NSString *)Id;


/**
 * 获取指定类型的实例。该接口废弃，使用 getInstanceWithName: 接口代替，kTypeInner对应 MTOP_ID_INNER，
 * kTypeOpen 对应 MTOP_ID_OPEN。
 *
 * @param type, 指定二方(kTypeInner) 或三方(kTypeOpen)
 * @return MTOP实例。若该类型未创建，则会同步创建一新实例。
 */
+ (nullable instancetype) getInstanceWithType:(MtopType)type DEPRECATED_MSG_ATTRIBUTE("请使用[getInstanceWithID:]替换");


/**
 * 兼容原三方API，返回三方实例，ID为 MTOP_ID_OPEN. 该方法线程安全。
 *
 * @return MTOP三方实例
 */
+ (nullable instancetype) shareInstance DEPRECATED_MSG_ATTRIBUTE("兼容原三方API");


/**
 * 当前实例的配置
 */
- (nonnull TBSDKConfiguration *)configuration;


/**
 * 当前实例ID。
 */
- (nonnull NSString *)ID;


/**
 * 当前实例类型。
 */
- (MtopType)type;


/**
 * 安装一个自定义的登录模块
 * 在请求API时, 判断本地无session时, 会调用该模块进行登录, 或者服务端返回session效时会调用该模块进行登录, 登录成功后重放失败请求。
 * 在登录的过程中, 有需要登录请求的API的请求会被 pending 到队列, 然后在登录成功后重放, 会登录失败后直接失败
 *
 * @param module, 登陆模块的实现
 */
- (void) installCustomLoginModule:(nonnull id<LoginProtocol>)module;

/**
 * 安装一个自定义的授权模块
 * 在请求API时, 判断本地无AUTH时, 会调用该模块进行登录, 或者服务端返回AUTH无效时会调用该模块进行登录, 登录成功后重放失败请求。
 * 在登录的过程中, 有需要登录请求的API的请求会被 pending 到队列, 然后在登录成功后重放, 会登录失败后直接失败
 *
* @param module, 授权模块的实现
 */
- (void) installCustomAuthModule:(nonnull id<MtopAuthProtocol>)module;


/**
 * 获取当前实例上的登录接口
 */
- (nonnull id<LoginProtocol>) loginModule;


/**
 * 获取当前实例上的鉴权接口
 */
- (nonnull id<MtopAuthProtocol>) authModule;


/**
 * 获取账户信息
 */
- (nullable TBSDKAccountInfo *)currentAccount;

/*!
 * 安装防刷delegate
 * @param delegate
 */
// TO DO
//- (id<FloodProtectionDelegate>) installFloodProtectionDelegate: (id<FloodProtectionDelegate>) delegate;


/**
 * 同步调用API
 *
 * @param request
 * @return MtopExtResponse API响应
 */
- (nullable MtopExtResponse*) sync_call: (nonnull MtopExtRequest*) request;


/**
 * 异步调用API
 *
 * @param request
 * @param delegate
 *
 */
- (void)async_call:(nonnull MtopExtRequest *)request;

/**
 * 异步调用API
 *
 * @param request
 * @param delegate
 *
 */
- (void) async_call: (nonnull MtopExtRequest*) request delegate: (nullable id<MtopExtRequestDelegate>) delegate;


/**
 * 异步调用API, 跳过startFilter之前的filter
 *
 * @param request
 * @param delegate
 * @param startFilter
 *
 */
- (void) async_call:(nonnull MtopExtRequest*) request delegate: (nullable id<MtopExtRequestDelegate>) delegate startFilter: (nullable NSString*) startFilter;

/**
 * 提供一个便捷的方法, 同步调用没有参数的API
 * 
 * @param apiName       API名称
 * @param apiVersion    API版本
 * @return MtopExtResponse API响应
 */
- (nullable MtopExtResponse*) sync_call: (nonnull NSString*) apiName apiVersion: (nonnull NSString*) apiVersion;


/**
 * 提供一个便捷的方法, 同步调用API
 *
 * @param apiName       API名称
 * @param apiVersion    API版本
 * @param bizParameters API业务参数
 * @return MtopExtResponse API响应
 */
- (nullable MtopExtResponse*) sync_call: (nonnull NSString*) apiName apiVersion: (nonnull NSString*) apiVersion bizParameters: (nullable NSDictionary*) bizParameters;

#pragma mark 新增mtop添加／删除全局header以及query参数接口

/**
 * 添加一个全局http请求头(不做URLENCODE)
 *
 * @param value     HTTP头value, 请不要做urlencode, 底层会统一做的
 * @param key       HTTP头key
 */
- (void) addCustomHttpHeader: (nonnull NSString*) value forKey: (nonnull NSString*) key;


/**
 * 添加一个全局http请求头
 * @param value     HTTP头value, 请不要做urlencode, 底层会统一做的
 * @param key       HTTP头key
 */
- (void) addHttpHeader: (nonnull NSString*) value forKey: (nonnull NSString*) key;


/**
 * 提供一个移除全局自定义请求头的方法
 */
- (void)removHttpHeader:(nonnull NSString *)key;


/**
 * 添加一个全局扩展参数和data参数平级
 * @param value     参数值
 * @param key       参数名
 */
- (void) addExtParameter: (nonnull id) value forKey: (nonnull NSString*) key;


/**
 * 移除一个全局扩展参数
 * @param key
 */
- (void) removeExtParameter: (nonnull NSString*) key;


@end
