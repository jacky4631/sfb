//
//  TBSDKMtopSecruityEnumMapping.h
//  MtopSDK
//
//  Created by jiangpan on 2017/12/21.
//  Copyright © 2017年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  umid 使用的环境变量定义 MTOP内部映射
 */
typedef NS_ENUM(NSInteger,SDP_ENVIRONMENT_MTOP) {
    /**
     *  线上环境
     */
    SDP_ENVIRONMENT_ONLINE_MTOP = 0,
    /**
     *  预发布环境
     */
    SDP_ENVIRONMENT_PRE_MTOP,
    /**
     *  日常环境
     */
    SDP_ENVIRONMENT_DAILY_MTOP,
    /**
     *  美国线上环境
     */
    SDP_ENVIRONMENT_ONLINE_US_MTOP,
    /**
     *  未设置
     */
    SDP_ENVIRONMENT_UNSET_MTOP
    
};

/**
 *  使用默认的人机格式，没有特定需求使用此flag
 */
extern int const OPEN_SECURITYBODY_FLAG_FORMAT_DEFAULT_MTOP;

/**
 *  通用人机格式
 */
extern int const OPEN_SECURITYBODY_FLAG_FORMAT_GENERAL_MTOP;

/**
 *  mini 人机格式
 */
extern int const OPEN_SECURITYBODY_FLAG_FORMAT_MINI_MTOP;

///**
// *  alipay 人机格式
// */
//extern int const OPEN_SECURITYBODY_FLAG_FORMAT_ALIPAY;

/**
 *  使用 白盒加密人机数据，没有特别需求不要指定
 */
extern int const OPEN_SECURITYBODY_FLAG_CRYPTOR_ATLAS_MTOP;

/**
 *  人机的环境标识，线上
 */
extern int const OPEN_SECURITYBODY_ENV_ONLINE_MTOP;

/**
 *  人机的环境标识，预发
 */
extern int const OPEN_SECURITYBODY_ENV_PRE_MTOP;

/**
 *  人机的环境标识，日常
 */
extern int const OPEN_SECURITYBODY_ENV_DAILY_MTOP;


#pragma mark 签名接口入参

/**
 *  签名接口入参key，top, umid签名使用
 */
extern NSString* const OPEN_KEY_SIGN_INPUT_MTOP;

/**
 *  seedkey，top 签名使用
 */
extern NSString* const OPEN_KEY_SIGN_SEEDKEY_MTOP;

/**
 *  atlaskey，atlas 签名使用
 */
extern NSString* const OPEN_KEY_SIGN_ATLAS_MTOP;

/**
 *  签名调用中，OpenSecurityGuardParamContex中requestType参数中使用到的值
 */

/**
 *  top签名
 */
extern NSInteger const OPEN_ENUM_SIGN_TOP_MTOP;

/**
 *  umid签名
 */
extern NSInteger const OPEN_ENUM_SIGN_UMID_MTOP;

/**
 *  原始top签名(无seekKey)
 */
extern NSInteger const OPEN_ENUM_SIGN_TOP_OLD_MTOP;

/**
 *  common hmac sha1签名
 */
extern NSInteger const OPEN_ENUM_SIGN_COMMON_HMAC_SHA1_MTOP;

/**
 *  common md5签名
 */
extern NSInteger const OPEN_ENUM_SIGN_COMMON_MD5_MTOP;

/**
 *  atlas签名
 */
extern NSInteger const OPEN_ENUM_SIGN_ATLAS_MTOP;

/**
 *  带模拟器检测功能的hmac-sha1签名
 */
extern NSInteger const OPEN_ENUM_SIGN_SIM_HMAC_SHA1_MTOP;

/**
 *  Fast atlas签名 签名String长度50
 */
extern NSInteger const OPEN_ENUM_SIGN_ATLAS_FAST_MTOP;

/**
 *  Fast atlas签名2
 */
extern NSInteger const OPEN_ENUM_SIGN_ATLAS_FAST2_MTOP;

/**
 *  xiami签名
 */
extern NSInteger const OPEN_ENUM_SIGN_XIAMI_MTOP;

/**
 *  无效签名类型
 */
extern NSInteger const OPEN_ENUM_SIGN_INVALID_MTOP;

