//
//  ISecurityGuardOpenNoCaptcha.h
//  SecurityGuardNoCaptcha
//
//  Created by lifengzhong on 15/11/9.
//  Copyright © 2015年 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenNoCaptcha_h
#define ISecurityGuardOpenNoCaptcha_h

#if TARGET_OS_WATCH
#import <SecurityGuardSDKWatch/Open/OpenNoCaptcha/IOpenNoCaptchaComponent.h>
#import <SecurityGuardSDKWatch/Open/OpenNoCaptcha/OpenNoCaptchaDefine.h>
#import <SecurityGuardSDKWatch/Open/IOpenSecurityGuardPlugin.h>
#else
#import <SecurityGuardSDK/Open/OpenNoCaptcha/IOpenNoCaptchaComponent.h>
#import <SecurityGuardSDK/Open/OpenNoCaptcha/OpenNoCaptchaDefine.h>
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#endif

@protocol ISecurityGuardOpenNoCaptcha <NSObject, IOpenNoCaptchaComponent, IOpenSecurityGuardPluginInterface>

@end


#endif /* ISecurityGuardOpenNoCaptcha_h */
