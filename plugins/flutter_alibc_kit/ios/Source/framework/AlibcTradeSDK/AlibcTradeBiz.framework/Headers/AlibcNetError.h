/*
 * AlibcNetError.h 
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

#ifndef AlibcNetError_h
#define AlibcNetError_h

@interface AlibcError : NSError

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code msg:(NSString *)msg;

@end

FOUNDATION_EXPORT NSString *const AlibcNetErrorCodeMtopNotAvailable;

@interface AlibcNetError : NSObject

/**
 *  错误码
 */
@property(nonatomic, copy) NSString *code;

/**
 *  错误信息
 */
@property(nonatomic, copy) NSString *msg;

/**
 *  原始错误对象
 */
@property(nonatomic, strong) NSError *rawError;

/**
 *  是否取消了登录
 */
@property(assign, nonatomic) BOOL isLoginCancel;

/**
 *  是否取消了授权
 */
@property(assign, nonatomic) BOOL isAuthCancel;

@end

#endif
