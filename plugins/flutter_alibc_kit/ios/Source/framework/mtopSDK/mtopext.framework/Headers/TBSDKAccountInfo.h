//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 iTeam on 13-4-7.
//  Copyright (c) 2013年 亿刀 Iteam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mtopext/MtopAuthProtocol.h>
#import <mtopext/LoginProtocol.h>


@protocol IAccountSource <NSObject>

- (id<LoginProtocol>) loginModule;
- (id<MtopAuthProtocol>) authModule;

@end

@interface TBSDKAccountInfo : NSObject

/**
 * 一下参数只有二方有效
 */
@property (nonatomic, strong) NSString                                          *appToken;
@property (nonatomic, strong) NSString                                          *pubkey;
@property (nonatomic, strong) NSString                                          *topSession;
@property (nonatomic, strong) NSString                                          *nick;
@property (nonatomic, strong) NSString                                          *userId;
@property (nonatomic, strong) NSString                                          *loginToken;
@property (nonatomic, strong) NSString                                          *ecode;
@property (nonatomic, strong) NSString                                          *logintime;
@property (nonatomic, strong) id                                                cookies;
@property (nonatomic, strong) NSString                                          *ssoToken;
@property (nonatomic, strong) NSString                                          *loginKey;
@property (nonatomic, strong) NSString                                          *password;
@property (nonatomic, strong) NSString                                          *sidInvalidTime;
@property (nonatomic)         BOOL                                              isSidInvalid;

/**
 * 一下参数只有三方有效
 */
@property (atomic, strong)    NSString                                          *openToken;

/**
 * 一下参数二三方均有效
 */
@property (nonatomic, strong) NSString                                          *sid;

/**
 * 每个实例均有自己的Accout，不再是单例，该接口废弃。
 */
+ (TBSDKAccountInfo *)shareInstance DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");

/**
 * 每个实例均有自己的Accout，不再是单例，该接口废弃。
 */
+ (BOOL)isLoggedIn DEPRECATED_MSG_ATTRIBUTE("为保证代码兼容性，暂未删除");

- (instancetype)initWithSource:(id<IAccountSource>)source;

- (BOOL)isLogin;

- (NSString *)fetchAuthToken:(AuthParamObj *)authParam;

@end
