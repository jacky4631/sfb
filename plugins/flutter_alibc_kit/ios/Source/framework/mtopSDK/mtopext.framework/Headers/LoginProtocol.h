//
//  LoginProtocol.h
//  mtopext
//
//  接入mtop登录模块需要实现的接口
//
//  Created by sihai on 17/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 手淘 session 字段
 */
#define SESSION_KEY_SID                 @"sid"
#define SESSION_KEY_USER_ID             @"userId"
#define SESSION_KEY_NICK                @"nick"
#define SESSION_KEY_ECODE               @"ecode"
#define SESSION_KEY_LOGIN_TOKEN         @"loginToken"
#define SESSION_KEY_SSO_TOKEN           @"ssoToken"
#define SESSION_KEY_COOKIE              @"cookie"
#define SESSION_KEY_SID_INVALID_TIME    @"sidInvalidTime"
#define SESSION_KEY_LOGIN_TIME          @"loginTime"
#define SESSION_KEY_COOKIE_SSO_DOMAINS  @"cookiesSSODomains"
#define SESSION_KEY_OPEN_TOKEN          @"authToken"

/**
 * 登录标记
 */
typedef enum {
    LoginOptionAutoLoginOnly = 1                     ,  // 只走AutoLogin，失败什么都不做！
    LoginOptionAutoLoginAndManualLogin               ,  // 先走AutoLogin，失败再拉登录页面
} LoginOption;


/**
 * 登录成功回调
 * @param isSuccessful  YES表示登录成功(auto login或者manual login)，NO表示登录失败（只可能发生在LoginOptionAutoLoginOnly）
 * @param loginResult   登录成功的情况下返回的登录结果（包含登录态）
 */
typedef void (^LOGIN_COMPLETION_HANDLER) (BOOL isSuccessful, NSDictionary* loginResult);

/**
 * 登录取消回调
 * @param flags   用户手动取消登录页面
 */
typedef void (^LOGIN_CANCELATION_HANDLER) (void);

/**
 * 登录交互回调 (兼容优酷实现逻辑)
 * @param isNeedLogin  YES表示需要拉起登录，NO表示不需要拉起登录
 */
typedef void (^LOGIN_INTERACTIVE_BLOCK) (BOOL isNeedLogin);


@protocol LoginProtocol <NSObject>

@optional

/*!
 * 判断当前用户是否有登录会话
 * @return
 *          YES     本地有会话且本地判断会话未过期，但服务端可能判定会话无效
 *          NO      本地无会话或本地判断会话已过期
 */
- (BOOL) isValidLogin;

- (BOOL) isValidLogin:(NSDictionary *)userInfo;

/*
 * 触发登录操作
 * @param loginOption         登录选项 参看 <code>LoginOption</code>
 * @param completionHandler   登录成功后回调
 * @param cancelationHandler  登录用户取消后回调
 */
- (void) loginWithLoginOption:(LoginOption)loginOption
            completionHandler:(LOGIN_COMPLETION_HANDLER)completionHandler
           cancelationHandler:(LOGIN_CANCELATION_HANDLER)cancelationHandler;

/*
 * 基本同上，一般业务方不要使用此方法，需要使用此方法，请联系@寻弦
 * @param extraInfoDict 额外参数
 */
- (void) loginWithLoginOption:(LoginOption)loginOption
                    extraInfo:(NSDictionary *)extraInfoDict
            completionHandler:(LOGIN_COMPLETION_HANDLER)completionHandler
           cancelationHandler:(LOGIN_CANCELATION_HANDLER)cancelationHandler;


/*!
 * 获取当前登录会话信息
 * @return
 *          会话信息
 *                  sid         ->  session id                (NSString*)
 *                  userId      ->  用户id                     (NSString*)
 *                  ecode       ->  ecode                      (NSString*)
 *                  nick        ->  用户nick                      (NSString*)
 *                  loginToken  ->  登录令牌                       (NSString*)
 *                  ssoToken    ->  sso令牌                       (NSString*)
 *                  topSession  ->  top授权                       (NSString*)
 *                  cookie      ->  cookie                         (NSString*)
 *                  ......
 */
- (NSDictionary *) currentSession;


- (NSDictionary *) currentSession:(NSDictionary *)userInfo;

/*!
 * 返回当前LoginCenter是否已经在处理登录行为
 * @return YES 已经有在处理中的登录行为
 *         NO  没有正在处理的登录行为
 */
- (BOOL) isProcessingLogin;

/*!
 * 标识本地session已经失效
 */
- (void) markInvalidLogin;

/**
 * !!!!!!!!该方法优酷兼容专用，非优酷请勿实现!!!!!!!!
 * 标识本地session已经失效 (兼容优酷实现逻辑)
 * @param  errorMsg   会话过期详细错误
 * @param  block      登录交互回调
 */
- (void) markInvalidLoginWithErrorCode:(NSDictionary *)errorMsg loginInteractiveBlock:(LOGIN_INTERACTIVE_BLOCK)block;

/**
 * 登出
 */
- (void) logout;

@end
