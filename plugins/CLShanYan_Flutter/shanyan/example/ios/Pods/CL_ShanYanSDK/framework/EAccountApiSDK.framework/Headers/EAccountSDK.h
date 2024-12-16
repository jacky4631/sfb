//
//  EAccountSDK.h
//  EAccountSDKNetwork
//
//  Created by thy on 2018/6/23.
//  Copyright © 2018年 21CN. All rights reserved.
//

/**
 定制版SDK v4.5.0 20230518
 */

#import <Foundation/Foundation.h>
#import "EAccountPreLoginConfigModel.h"
#import "EAccountCTEConfig.h"

/**
 声明一个block
 @param resultDic 网络返回的data的解析结果
 */
typedef   void (^successHandler) (NSDictionary * _Nonnull resultDic);

/**
 声明一个block
 @param error 网络返回的错误或者其它错误
 */
typedef   void (^failureHandler) (NSError * _Nonnull error);

@interface EAccountSDK : NSObject

/**
 初始化SDK
 @param appKey 接入方在账号平台领取的appId
 @param appSecrect 接入方在账号平台领取的appSecrect
 */
+ (void)initWithSelfKey:(NSString * _Nonnull)appKey
              appSecret:(NSString * _Nonnull)appSecrect;

/**
 *@description 预登录接口
 @param model 接口超时时间配置
 */

+ (void)requestPRELogin:(EAccountPreLoginConfigModel * _Nonnull)model
             completion:(nonnull successHandler)completion
                failure:(nonnull failureHandler)fail;

/**
 控制台日志输出控制（默认关闭）
 @param enable 开关参数
 */
+ (void)printConsoleEnable:(BOOL)enable;

/**
@description   获取当前流量卡运营商信息
@return NSString    "CT"    中国电信 / "CM"     中国移动 / "CU"     中国联联通 / "UN"    未知
*/
+ (NSString *)getOperatorType;

/**
@description   是否开启蜂窝数据
*/
+ (BOOL)isCellularDataEnable;

/**
 @description 预登录接口 已废弃
 @param apiTimeoutInterval 接口超时时间，传0或者小于0的数，则默认为3s
 */
+ (void)requestPreLogin:(NSTimeInterval)apiTimeoutInterval
             completion:(nonnull successHandler)completion
                failure:(nonnull failureHandler)fail DEPRECATED_MSG_ATTRIBUTE("Please use `requestPRELogin:completion:failure:` instead");

/**
 @description 预登录接口 已废弃
 @param apiTimeoutInterval 接口超时时间，传0或者小于0的数，则默认为3s
 */
+ (void)getMobileCodeWithTimeout:(NSTimeInterval)apiTimeoutInterval
                      completion:(nonnull successHandler)completion
                         failure:(nonnull failureHandler)fail DEPRECATED_MSG_ATTRIBUTE("Please use `requestPreLogin:completion:failure:` instead");

+ (void)setDomainName:(EAccountCTEConfig * _Nonnull)config;

#pragma -mark ----------------other method-----------------------

+ (void)startReportLog:(NSMutableDictionary * _Nonnull)logDic;

@end
