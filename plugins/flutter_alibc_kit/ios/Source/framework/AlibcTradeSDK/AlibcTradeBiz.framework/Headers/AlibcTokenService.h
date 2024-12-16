/*
 * AlibcTokenService.h 
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

#ifndef AlibcTokenService_h
#define AlibcTokenService_h

typedef void(^TokenRequestCallback)(NSError *_Nullable error, NSString *_Nullable dataObj);


@interface AlibcTokenService : NSObject
@property(nonatomic, strong) NSString *_Nullable token;
@property(nonatomic, strong) NSDate *_Nullable expire;
@property(nonatomic, strong) NSDate *_Nullable lastUpdate;


+ (nonnull instancetype)sharedInstantce;

- (nullable NSString *)getLocalToken;

- (void)setTokenInvalid;

- (void)getRemoteToken:(nonnull NSArray<NSString *> *)list callBack:(nonnull TokenRequestCallback)callBack;

@end

#endif
