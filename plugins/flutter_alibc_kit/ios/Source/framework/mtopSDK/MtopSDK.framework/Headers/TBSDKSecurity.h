//
//  TBSDKSecurity.h
//  mtopsdk
//
//  Created by sihai on 10/9/14.
//  Copyright (c) 2014 mtop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSDKSecurity : NSObject

/**
 * 获取共享的单例
 *
 */
+ (TBSDKSecurity*) instance;


/**
 * 通过AVMP获取MWUA
 * @paraml input 白盒签名
 */

- (NSString *)getMwua:(NSString *)input;

/**
 * @param timestamp             时间戳
 * @param appkey                appkey
 * @param flag                  生成不同类型Wua的标识位
 *
 */
- (NSString*) wua: (NSString*) timestamp
           appkey: (NSString*) appkey
         authCode: (NSString*) authCode
             flag: (int)flag;

/**
 * security type for hmac-sha1
 *
 * @param text                secret context
 * @param secret              secret key
 */
+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret;

/**
 * 获取 mini wua
 * @param extParam 安全需要的额外参数
 @return 获取人机识别标识 mini wua
 */
- (NSString *)fetchMiniWua:(NSDictionary *)extParam;


/**
 mtop环境映射保镖环境

 @return 安全保镖当前环境
 */
- (int)envMapToSecurityGuardEnv;


/**
 *  根据传入的 protocol 获取接口. 无线保镖接口封装。
 *  @param protocol 要获取的 interface
 *  @return 返回的实现 protocol 的对象
 */
- (id) getInterface: (Protocol*) protocol;

@end

