//
//  MtopBridgePlugin.h
//  mtopext
//
//  Created by jiangpan on 17/2/14.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <WindVane/WindVane.h>

#define MSG_TIME_OUT        @"MP_TIME_OUT"

#define SESSION_OPTION_AUTOLOGIN                        @"AutoLoginOnly"
#define SESSION_OPTION_AUTOLOGIN_AND_MANUAL_LOGIN       @"AutoLoginAndManualLogin"

#define WVP_API             @"api"
#define WVP_VERSION         @"v"
#define WVP_NEEDLOGIN       @"needLogin"
#define WVP_DATA            @"data"
#define WVP_METHOD          @"method"
#define WVP_DATATYPE        @"dataType"
#define WVP_SECTYPE         @"secType"
#define WVP_TIMEOUT         @"timeout"
#define WVP_EXTHEADERS      @"ext_headers"
#define WVP_TTID            @"ttid"
#define WVP_PAGEURL         @"pageUrl"
#define WVP_USERAGENT       @"user-agent"
#define WVP_SESSIONOPTION   @"sessionOption"
#define WVP_EXTQUERYS       @"ext_querys"
#define WVP_MPHOST          @"mpHost"
#define WVP_INSTANCEID      @"instanceid"

typedef void(^callBack)(NSDictionary *result);

@interface MtopBridgePlugin : NSObject

+ (instancetype)sharedInstance;

/**
 * 设置 windvane mtop插件默认实例Id
 */
+ (void)setWVDefaultInstanceId:(NSString *)instanceID;


/**
 *  windvane mtop插件默认实例Id
 */
+ (NSString *)defaultWVInstanceId;



- (void)removeRequest:(NSString *)requestId;

/**
 *  请求MTOP API 新规范
 *  parameters[@"api"]              -> apiName         API 名称
 *  parameters[@"v"]                -> apiVersion      API 版本
 *  parameters[@"needLogin"]        -> needLogin     接口是否需要登录(Boolean)
 *  parameters[@"sessionOption"]    -> Session 失效时的操作 'AutoLoginOnly',只做自动登录;'AutoLoginAndManualLogin'：先做自动登录,若失败则唤起登录界面
 *  parameters[@"data"]             -> 接口业务参数，JSON 对象
 *  parameters[@"method"]           -> method 请求是使用 'GET' 还是 'POST'
 *  parameters[@"dataType"]         -> 返加结果的数据类型：1. 'json'：全部数值会被转为 String 2. 'origialjson'：标准的数据类(默认‘originaljson’)
 *  parameters[@"secType"]          -> 安全保镖生成人机识别参数类型：0：不加签 1：使用MTOPSDK内部对应的默认wua生成逻辑
 *  parameters[@"timeout"]          -> 定时-1 或 不传 (nil) 表示不设置定时器，定时器限制 请求在走缓存后，第二次回掉是否回掉，超时，不回调, 单位毫秒(默认20000ms)
 *  parameters[@"ext_headers"]       -> 自定义请求Headers
 *  parameters[@"ttid"]             -> 上层H5设置ttid覆盖native的
 *  parameters[@"pageUrl"]          -> 当前页面url地址
 *  parameters[@"user-agent"]       -> 自定义请求User-Agent
 *  parameters[@"ext_querys"]       -> 自定义请求Querys
 *  parameters[@"mpHost"]           -> H5 mtop请求通过JSBridge发起native mtop请求的自定义域名
 *  parameters[@"instanceId"]       -> MTOP实例ID
 *  parameters[@"instanceTag"]      -> MTOP实例Tag  (Tag与ID唯一标识一个实例)
 */


/**
 MtopBridge发送MTOP请求

 @param param                   MTOP请求标准参数
 @param callBack                MTOP请求回调
 @param ext                     扩展参数(目前主要兼容windvane)
 */
- (void)sendMtopRequest:(NSDictionary *)param
               callBack:(callBack)callBack
                    ext:(NSDictionary *)ext;

@end
