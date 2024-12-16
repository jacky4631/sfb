//
//  SecurityProtocol.h
//  mtopsdk
//
//  安全保镖遵守的协议
//
//  Created by sihai on 10/9/14.
//  Copyright (c) 2014 mtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSDKMtopSecurityEnumMapping.h"

#define KEY_AUTH_CODE       @"authCode"
#define KEY_DATA            @"data"
#define KEY_APPKEY          @"appkey"
#define KEY_ENV             @"env"
#define KEY_EXTEND_PARAS    @"extendParas"
#define KEY_USE_WUA         @"useWua"
#define KEY_X_SIGN          @"x-sign"
#define KEY_X_UMT           @"x-umt"
#define KEY_X_MINI_WUA      @"x-mini-wua"
#define KEY_X_SGEXT         @"x-sgext"
#define KEY_X_WUA           @"wua"

@protocol SecurityProtocol <NSObject>

/**
 *  获取OpenSecurityGuardManager全局单例对象
 *
 *  @return OpenSecurityGuardManager全局对象
 */
+ (id) getInstance;

+ (id) getReturnTypeByteArray;

+ (id) createInt32: (int32_t) data;

+ (id) createByteArray: (NSData*) data;

+ (id) createString: (NSString*) data;

+ (id) createMutableByteArray: (NSMutableData*) data;

- (id) invokeAVMP: (NSString*) idunctionName
       returnType:(id) returnType, ...;
/**
 *  根据传入的 protocol 获取接口
 *
 *  @param protocol 要获取的 interface
 *
 *  @return 返回的实现 protocol 的对象
 */
- (id) getInterface: (Protocol*) protocol;

- (id) createAVMPInstance: (NSString*) authCode
             byteCodeName:(NSString*) bcName;

/**
 *  获取静态数据存储接口
 *
 *  @return 返回静态数据存储接口，失败时nil
 */
- (id) getStaticDataStoreComp;

/**
 *  获取安全签名接口
 *
 *  @return 返回签名接口，失败时nil
 */
- (id) getSecureSignatureComp;

/**
 *  获取UMID接口
 *
 *  @return 返回UMID接口，失败返回nil
 */
- (id) getUMIDComp;

/**
 *  根据传入的参数生成参数结构体对象
 *
 *  @param appKey      appkey，应用当前使用的appkey
 *  @param paramDict   存储业务参数的dictionary对象
 *  @param requestType 请求类型
 *
 *  @return 生成的参数结构体对象, autorelease对象
 */
+ (id) createParamContextWithAppKey: (NSString*) appKey
                          paramDict: (NSDictionary*) paramDict
                        requestType: (NSInteger) requestType;

/**
 *  发起签名请求
 *
 *  @param paramContext 包含签名所需要参数的结构体对象
 *
 *  @param authCode SDK的授权码，不传或为空串，使用默认加密文件
 *
 *  @return 签名值，失败时返回nil
 */
- (NSString*) signRequest: (id) paramContext
                 authCode: (NSString*) authCode;

/**
 *  根据index找到对应的appkey（index从0开始，按在无线保镖网站生成加密文件时填写的顺序排列）
 *
 *  @param index key的顺序
 *
 *  @param authCode SDK的授权码，不传或为空串，使用默认加密文件
 *
 *  @return index对应的appkey，调用失败时返回nil
 */
- (NSString*) getAppKey: (NSNumber*) index
               authCode: (NSString*) authCode;

/**
 *  获取OpenSecurityBodyComp全局单例对象
 *
 *  @return OpenSecurityBodyComp全局对象
 */
- (id) getSecurityBodyComp;

/**
 *  返回UMID Token，长度为32的字符串
 *
 *  @return 如果失败，返回内容为24个0的字符串
 */
- (NSString*) getSecurityToken;

/**
 *  初始化umid
 *
 *  @param appKey   appkey，注意此值要与 dpEnv 对应，线上环境对应传线上的 appkey，以此类推
 *  @param sdpEnv   接入应用当前的环境，包括线上，预发，线上
 *  @param authCode 授权码，指定umid使用哪个加密文件，注意入参appkey在authCode对应的图片中要存在
 *  @param handler 初始化结果回调，本函数必须在主线程内完成（推荐在 appdelegate中，应用启动时调用）
 *
 */
- (BOOL) initUMID: (NSString*) appKey
      environment: (SDP_ENVIRONMENT_MTOP) sdpEnv
         authCode: (NSString*) authCode
          handler: (void (^) (NSString* securityToken, NSError* error)) handler;

/**
 获取风控参数
 
 @param timeStamp 时间戳，要与携带人机识别参数的请求中的timestamp对应
 @param appKey 计算人机识别参数时对应的appkey（可以与初始化时的appkey不一致）
 @param authCode 授权码，手淘中传nil (安全图片yw_1222_xxx.jpg的图片，参数就传xxx)
 @param extendParam 扩展信息，可为nil
 @param flag 控制人机识别获取到的具体数据内容
 @param env 环境信息
 @param error 错误信息
 @return 用户昵称，获取失败返回nil
 */
- (NSString*) getSecurityBodyDataEx: (NSString*) timeStamp
                             appKey: (NSString*) appKey
                           authCode:(NSString*) authCode
                        extendParam:(NSString*) extendParam
                               flag:(int) flag
                                env:(int) env
                              error:(NSError *__autoreleasing*) error;


@end


/********************************************************************************************************************
 *                                         无线保镖新接口, 后续所有签名均迁移到该接口
 ********************************************************************************************************************/

@protocol TBSecurityGuardOpenMiddleTierGenericProtocol <NSObject>

/**
 *  init MiddleTier Generic Cponent
 *  @param paramDict <NSString, object> paras
 *    "auth_code"            : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *  @return init result
 */
-(BOOL) init:(NSDictionary*) paramDict
       error:(NSError* __autoreleasing*)error;


/**
 *  get signature
 *  @param paramDict <NSString, object> paras
 *    "data"                : (NSData*)         [required] data need to be signed;
 *    "appkey"              : (NSString*)       [required] appkey for sign
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *    "auth_code"           : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *  @return sign result dictionary
 *    "x-sign"              : (NSString*)       [required] sign result
 *    "x-sign_ext1"         : (NSString*)       [optinal] sign extend result
 *    "..."                 : (NSString*)       [optinal] sign extend resultN
 */
-(NSDictionary*) getSign:(NSDictionary*) paramDict
                   error:(NSError* __autoreleasing*)error;


/**
 *  get mini-wua
 *  @param paramDict <NSString, object> paras
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *    "auth_code"           : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *    "extend_paras"        : (NSDictionary*)   [optional] extra datas e.g. api name, page id, ..
 *  @return risk control result dictionary
 *    "x-miniwua"           : (NSString*)       [required] mini wua string result
 *    "x-miniwua_ext1"      : (NSString*)       [optional] wsg extra risk control data1
 *    "x-miniwua_ext2"      : (NSString*)       [optional] wsg extra risk control data2
 *    "..."                 : (NSString*)       [optional] wsg extra risk control dataN
 */
-(NSDictionary*) getMiniWua:(NSDictionary*) paramDict
                      error:(NSError* __autoreleasing*)error;

/**
 *  get vmp signature with wua
 *  @param paramDict <NSString, object> paras
 *    "data"                : (NSData*)         [required] data need to be signed
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *    "auth_code"           : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *  @return wua result content
 *    @"wua"                : (NSString*)       [required] wua data for risk control
 *    @"wua_ext1"           : (NSString*)       [optional] extra wua data1 for risk control
 *    @"wua_ext2"           : (NSString*)       [optional] extra wua data2 for risk control
 *    "..."                 : (NSString*)       [optional] extra wua dataN for risk control
 */
-(NSDictionary*) getWua:(NSDictionary*) paramDict
                  error:(NSError* __autoreleasing*)error;


@end

/********************************************************************************************************************
 *                                         无线保镖新接口, 后续所有签名均迁移到该接口
 ********************************************************************************************************************/

@protocol TBSecurityGuardOpenUnifiedProtocol <NSObject>

/**
 *  init MiddleTier Generic Cponent
 *  @param paramDict <NSString, object> paras
 *    "auth_code"            : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *  @return init result
 */
-(BOOL) init:(NSDictionary*) paramDict error:(NSError* __autoreleasing*)error;


/**
 *  get all security factors with only one function call
 *
 *  @param paramDict <NSString, object> paras
 *    "appkey"              : (NSString*)       [required] appkey for sign
 *    "data"                : (NSString*)       [required] data need to be signed;
 *    "useWua"              : (NSNumber*)       [required] get wua or not (BOOL)value;
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *    "authCode"            : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *    "extendParas"         : (NSDictionary*)   [optional] extra datas e.g. api name, page id, ..
 *  @return sign result dictionary
 *    "x-sign"              : (NSString*)       [required] sign result
 *    "x-miniwua"           : (NSString*)       [required] mini wua string result
 *    "wua"                 : (NSString*)       [optional] only required when call with high risk business, like [MTOP-SDK useWua]
 *    "wsg-ext1"            : (NSString*)       [optional] extend wsg result1
 *    "wsg-ext2"            : (NSString*)       [optional] extend wsg result2
 */
-(NSDictionary*) getSecurityFactors:(NSDictionary*) paramDict error:(NSError* __autoreleasing*)error;

@end
