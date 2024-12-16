//
//  Error.h
//  mtopext
//
//  Created by sihai on 4/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MtopSDK/TBSDKErrorRule.h>
#import <mtopext/Constants.h>


//@protocol TBSDKErrorRule;

@interface MtopError : NSObject

// http响应码
@property(assign, nonatomic) int                    httpResponseCode;

// 错误码
@property(copy, nonatomic) NSString               *code;

// 错误提示信息
@property(copy, nonatomic) NSString               *msg;

// 错误提示信息
@property(copy, nonatomic) NSString               *originalMsg;

// 子错误码
@property(copy, nonatomic) NSString               *subCode;

// 子错误提示信息
@property(copy, nonatomic) NSString               *subMsg;

// 原始的错误
@property(copy, nonatomic) NSError                *rawError;

// 新增错误映射码
@property(copy, nonatomic) NSString               *mappingCode;

// 新增透传TBUIKit错误信息
@property(strong, nonatomic) NSError                *uikitError;

// 新增420限流透出retCode错误信息
@property(copy, nonatomic) NSString               *limitFlowRawCode;

/*!
 * 判断是否成功
 */
- (BOOL) isSucceed;

/*!
 * 初始化
 */
- (instancetype)initWithHttpResponseCode:(int)httpResponseCode
                               code: (NSString *)code
                                msg:(NSString *)msg;

/*!
 * 初始化
 */
- (instancetype)initWithHttpResponseCode:(int)httpResponseCode
                               code:(NSString *)code
                                msg:(NSString *)msg
                            subCode:(NSString *)subCode
                             subMsg:(NSString *)subMsg;

/*!
 * 为兼容, 转换成老的error
 * @return
 *          id<TBSDKErrorRule>
 *              
 */
- (id<TBSDKErrorRule>)toTbsdkError;

/*!
 * 判断是否为网络错误
 * @return
 *          YES
 *          NO
 */
- (BOOL)isNetworkError;

/*!
 * 判断是否为响应错误
 * @return
 *          YES
 *          NO
 */
- (BOOL)isResponseDataParseError;

/*!
 * 构造一个成功错误码
 */
+ (MtopError *)succeed;

/**
 构造透传的NSError
 
 @param code             错误码
 @param msg              错误信息
 @param responseCode     响应码
 @param mappingCode      错误映射码
 @return 透传的NSError
 */
+ (NSError *)createRawError:(NSString *)code msg:(NSString *)msg responseCode:(NSNumber *)responseCode mappingCode:(NSString *)mappingCode;

@end
