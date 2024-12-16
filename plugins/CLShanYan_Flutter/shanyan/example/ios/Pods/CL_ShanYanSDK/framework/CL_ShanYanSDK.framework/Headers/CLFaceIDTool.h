//
//  CLFaceIDTool.h
//  CL_ShanYanSDK
//
//  Created by KevinChien on 2020/7/24.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "CLCompleteResult.h"

NS_ASSUME_NONNULL_BEGIN

/// 设备的生物验证方式状态
typedef NS_ENUM(NSInteger, CLFaceIDDeviceSupportState) {
    /// 设备不支持生物验证
    CLFaceIDDeviceSupportStateNotAvailable =0,
    
   /// 设备支持生物验证 但尚未未设置
    CLFaceIDDeviceSupportStateNotEnrolled,
    
    /// 识别错误次数过多 被锁定(需要重新输入手机密码解锁后才可以使用)
    CLFaceIDDeviceSupportStateLockout,
    
   /// 设备支持TouchID验证
    CLFaceIDDeviceSupportStateTouchID,
    
    /// 设备支持FaceID验证
    CLFaceIDDeviceSupportStateFaceID,
};

typedef NS_ENUM(NSInteger, CLFaceIDErrorCode) {
    
    /// 系统不支持
    CLFaceIDErrorCodeNotAvailable,
    
    /// 设备支持生物验证 但尚未未设置
    CLFaceIDErrorCodeNotEnrolled,
    
    /// 识别错误次数过多 被锁定(需要重新输入手机密码解锁后才可以使用)
    CLFaceIDErrorCodeLockout,
    
    /// 验证账号为空
    CLFaceIDErrorCodeFailedNULLAccount,
    
   /// 验证失败
    CLFaceIDErrorCodeFailed,
    
    /// 用户取消
    CLFaceIDErrorCodeUserCancel,
    
    /// 被系统中断 如别的应用进前台，当前应用进如后台
    CLFaceIDErrorCodeSystemCancel,
    
    /// 系统TouchID/FaceID 发生变更 ，绑定失效
    CLFaceIDErrorCodeDataChange,
};

/// 需要执行的业务类型
typedef NS_ENUM(NSInteger ,CLFaceIDAuthType) {
    
    /// 绑定
    CLFaceIDAuthTypeBound = 0,
    
    /// 验证
    CLFaceIDAuthTypeAuth,
};

@interface CLFaceIDTool : NSObject

+ (CLFaceIDTool *)shareInstance;

/// 生物识别类型检测，判断设备支持哪种认证方式
-(CLFaceIDDeviceSupportState )clBiometricsTypeCheck;

/// 判断该账户是否绑定过 生物识别
/// @param accountInfo      账号信息(每个账户唯一)
-(BOOL)isHadBoundAccountInfo:(NSString *)accountInfo;

/// 生物识别 绑定/验证
/// @param faceIDAuthType   业务类型
/// @param accountInfo      账号信息
/// @param desc             业务描述
/// @param complete         回调信息
-(void)clStartAuthWithCLFaceIDAuthType:(CLFaceIDAuthType )faceIDAuthType
                           accountInfo:(NSString *)accountInfo
                           description:(NSString *)desc
                              complete:(void (^) (BOOL success ,NSError *error))complete;

@end

NS_ASSUME_NONNULL_END
