/*
 * AlibcMtopCmd.h 
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

#ifndef AlibcMtopCmd_h
#define AlibcMtopCmd_h

@interface AlibcMtopCmd : NSObject

@property(nonatomic, strong) NSString *_Nonnull name; // mtop命令
@property(nonatomic, strong) NSString *_Nonnull version; //版本,默认是@"1.0"
@property(nonatomic, assign) BOOL needLogin;             //是否需要登录,默认值:NO
@property(nonatomic, assign) BOOL needAuth;              //是否需要授权,默认值:NO
@property(nonatomic, assign) BOOL needWUA;    //是否需要人机识别,默认是NO
@property(nonatomic, assign) BOOL needPost;
@property(nonatomic, assign) NSInteger sessionExpireType; // 0: AutologinAndManualLogin 1: AutoLoginOnly
@property(nonatomic, strong) NSDictionary * _Nullable extParams;
@property(nonatomic, strong) NSDictionary * _Nullable extHeaders;


//
@property(nonatomic, copy) NSString * _Nullable ttid;// ttid

+ (nonnull instancetype)cmd;

@end

#endif
