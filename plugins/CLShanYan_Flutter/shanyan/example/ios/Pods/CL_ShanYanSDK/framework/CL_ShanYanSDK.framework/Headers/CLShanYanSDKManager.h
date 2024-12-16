//
//  CLShanYanSDKManager.h
//  CL_ShanYanSDK
//
//  Created by wanglijun on 2018/10/29.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CLCompleteResult.h"
#import "CLUIConfigure.h"

@protocol CLShanYanSDKManagerDelegate <NSObject>

@optional

/// 授权页面已经显示的回调
/// @param authPageView     授权页view
/// @param telecom          当前运营商类型
- (void)clShanYanSDKManagerAuthPageAfterViewDidLoad:(UIView *_Nonnull)authPageView
                                    currentTelecom:(NSString *_Nullable)telecom ;

/// 授权页面将要显示的回调 ViewDidLoad即将全部执行完毕的最后时机
/// @param authPageVC       授权页
/// @param telecom          当前运营商类型
/// @param object           授权页相关内容信息
/// @param userInfo         授权页相关UI控件字典，用法见demo
-   (void)clShanYanSDKManagerAuthPageCompleteViewDidLoad:(UIViewController *_Nonnull)authPageVC
                                          currentTelecom:(NSString *_Nullable)telecom
                                                  object:(NSObject *_Nullable)object
                                                userInfo:(NSDictionary *_Nullable)userInfo;

/// 授权页面将要显示的回调（ViewWillAppear）
/// @param authPageVC       授权页
/// @param telecom          当前运营商类型
/// @param object           授权页相关内容信息
/// @param userInfo         授权页相关UI控件字典，用法见demo
- (void)clShanYanSDKManagerAuthPageCompleteViewWillAppear:(UIViewController *_Nonnull)authPageVC
                                           currentTelecom:(NSString *_Nullable)telecom
                                                   object:(NSObject *_Nullable)object
                                                 userInfo:(NSDictionary *_Nullable)userInfo;

/// 授权页vc alloc init 注：此时authPageVC.navigationController为nil
/// @param authPageVC       授权页
/// @param telecom          当前运营商类型
/// @param object           授权页相关内容信息
/// @param userInfo         授权页相关UI控件字典，用法见demo
- (void)clShanYanSDKManagerAuthPageCompleteInit:(UIViewController *_Nonnull)authPageVC
                                 currentTelecom:(NSString *_Nullable)telecom
                                         object:(NSObject*_Nullable)object
                                       userInfo:(NSDictionary*_Nullable)userInfo;

/// 授权页vc 将要被present； 将要调用[uiconfigure.viewcontroller  present:authPageVC animation:completion:]
/// @param authPageVC       授权页
/// @param telecom          当前运营商类型
/// @param object           授权页相关内容信息
/// @param userInfo         授权页相关UI控件字典，用法见demo
- (void)clShanYanSDKManagerAuthPageWillPresent:(UIViewController *_Nonnull)authPageVC
                                currentTelecom:(NSString *_Nullable)telecom
                                        object:(NSObject *_Nullable)object
                                      userInfo:(NSDictionary *_Nullable)userInfo;

/// 统一事件监听方法
/// @param type             事件类型（1：隐私协议点击， 2：协议勾选框点击，3："一键登录"按钮点击）
/// @param code             事件对应序号  type=1时：code：0,1,2,3（协议页序号），message：协议名|当前运营商类型
///                                     type=2时：code：0,1（0为未选中，1为选中）
///                                     type=3时：code：0,1（0为协议勾选框未选中，1为选中）
/// @param message          说明：type=1时：message：协议名_当前运营商类型
- (void)clShanYanActionListener:(NSInteger)type
                           code:(NSInteger)code
                        message:(NSString *_Nullable)message;



/// 协议点击回调  （clAppPrivacyCustomWeb设置为YES时有效）
/// 处理跳转自定义webview逻辑。如：[authPageVC.navigationController pushViewController:xxVC animated:YES];
/// @param privacyName      协议名称
/// @param URLString        协议链接
/// @param authPageVC       导航控制器
- (void)clShanYanPrivacyListener:(NSString *_Nonnull)privacyName
                      privacyURL:(NSString *_Nonnull)URLString
                        authPage:(UIViewController *_Nonnull)authPageVC;

@end




NS_ASSUME_NONNULL_BEGIN

@interface CLShanYanSDKManager : NSObject

/// 设置点击协议代理
/// @param delegate         代理
+ (void)setCLShanYanSDKManagerDelegate:(id<CLShanYanSDKManagerDelegate>)delegate;

/// 初始化
/// @param appId            闪验后台申请的appId
/// @param complete         预初始化回调block（⚠️在子线程中回调）
+ (void)initWithAppId:(NSString *)appId
             complete:(nullable CLComplete)complete;

///**
// 设置初始化超时 单位:s
// 大于0有效
// 建议4s左右，默认4s
// */
//+ (void)setInitTimeOut:(NSTimeInterval)initTimeOut;

/// 设置预取号超时 单位:s（大于0有效；建议4s左右，默认4s）
/// @param preGetPhoneTimeOut 预取号超时时间
+ (void)setPreGetPhonenumberTimeOut:(NSTimeInterval)preGetPhoneTimeOut;

/// 当无蜂窝网络（拔出SIM卡/切换SIM卡,网络切换期间/或者直接关闭流量开关）是否使用之前的取号缓存
/// @param isUseCache       YES/NO  默认YES   设置为NO  获取SIM实时的预取号，无蜂窝网络、或者蜂窝网络不稳定则无法取号成功
+ (void)setPreGetPhonenumberUseCacheIfNoCellularNetwork:(BOOL)isUseCache;

/// 预取号
/// 此调用将有助于提高闪验拉起授权页的速度和成功率
/// 建议在一键登录前调用此方法，比如调一键登录的vc的viewdidload中
/// 不建议在拉起授权页后调用
/// 以 if (completeResult.error == nil) 为判断成功的依据，而非返回码
/// @param complete         回调block（⚠️在子线程中回调）
+ (void)preGetPhonenumber:(nullable CLComplete)complete;

/// 一键登录拉起内置授权页&获取Token
/// @param clUIConfigure    闪验授权页参数配置
/// @param complete         回调block（⚠️在子线程中回调）
+ (void)quickAuthLoginWithConfigure:(CLUIConfigure *)clUIConfigure
                           complete:(nonnull CLComplete)complete;

/// 一键登录拉起内置授权页&获取Token( 区分拉起授权页之前和之后的回调)
/// @param clUIConfigure    闪验授权页参数配置
/// @param openLoginAuthListener    拉起授权页监听：拉起授权页面成功或失败的回调，拉起成功或失败均触发。当拉起失败时，oneKeyLoginListener不会触发。此回调的内部触发时机是presentViewController:的完成block（⚠️在子线程中回调）
/// @param oneKeyLoginListener      一键登录监听：拉起授权页成功后的后续操作回调，包括点击SDK内置的(非外部自定义)取消登录按钮，以及点击本机号码一键登录的回调。点击授权页自定义按钮不触发此回调（⚠️在子线程中回调）
+ (void)quickAuthLoginWithConfigure:(CLUIConfigure *)clUIConfigure
              openLoginAuthListener:(CLComplete)openLoginAuthListener
                oneKeyLoginListener:(CLComplete)oneKeyLoginListener;

/// 关闭授权页
/// 注：内部实现为调用系统方法dismissViewcontroller:complete； 若授权页未拉起或已关闭，此方法调用无效果
/// @param flag             dismissViewcontroller`Animated, default is YES.
/// @param completion       dismissViewcontroller`completion（⚠️在子线程中回调。）
+ (void)finishAuthControllerAnimated:(BOOL)flag
                          Completion:(void(^_Nullable)(void))completion;

/// 关闭授权页
/// @param completion       关闭回调（⚠️在子线程中回调）
+ (void)finishAuthControllerCompletion:(void(^_Nullable)(void))completion;

/// 返回授权页内置导航控制器（生命周期与授权页一致）
+ (UINavigationController *)authNavigationController;

/// 设置checkBox勾选状态
/// @param isSelect         勾选状态：YES：为勾选
+ (void)setCheckBoxValue:(BOOL)isSelect;

/// 手动触发一键登录按钮点击（授权页存在时调用）
+ (void)loginBtnClick;

/// 隐藏一键登录loading
+ (void)hideLoading;

/// 本机号认证获取token
/// @param complete         本机号认证回调（⚠️在子线程中回调）
+ (void)mobileCheckWithLocalPhoneNumberComplete:(CLComplete)complete;

/// 模式控制台日志输出控制（默认关闭）
/// @param enable           开关参数
+ (void)printConsoleEnable:(BOOL)enable;

/// 获取当前流量卡运营商，结果仅供参考（CTCC：电信、CMCC：移动、CUCC：联通、UNKNOW：未知）
/// 使用xcode14.3+在iOS16.4+返回UNKNOW时不准确
+ (NSString *)getOperatorType;

/// 清除预取号缓存
+ (void)clearScripCache;

/// 禁止日志上报SIM卡数量（默认禁止）
/// @param allow YES：允许上报 NO：禁止上报
+ (void)allowSimCounts:(BOOL)allow;

/// 禁止日志上报获取IP（默认允许）
/// @param forbidden        YES:禁止 NO:允许
+ (void)forbiddenNonessentialIp:(BOOL)forbidden;

/// 禁止日志上报(默认开启)  此接口需要在初始化之前调用,否则配置不生效
/// @param forbidden        YES:禁止上报 NO:允许上报
+ (void)forbiddenFullLogReport:(BOOL)forbidden;

/// 当前环境是否满足预取号
/// 使用xcode14.3+在iOS16.4+返回YES时可能不准确
+ (BOOL)checkAuthEnable;

/// 当前SIM卡数量
+ (NSInteger)currentSimCounts;

/// 获取当前SDK版本号
+ (NSString *)clShanYanSDKVersion;

@end

NS_ASSUME_NONNULL_END
