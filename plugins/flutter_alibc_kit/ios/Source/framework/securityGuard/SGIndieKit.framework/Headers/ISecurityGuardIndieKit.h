//
//  ISecurityGuardIndieKit.h
//  SecurityGuardIndieKit
//
//  Created by lifengzhong on 15/11/5.
//  Copyright © 2015年 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardIndieKit_h
#define ISecurityGuardIndieKit_h

#if TARGET_OS_WATCH
#import <SecurityGuardSDKWatch/IndieKit/IIndieKitComponent.h>
#import <SecurityGuardSDKWatch/IndieKit/IndieKitDefine.h>
#import <SecurityGuardSDKWatch/SecurityGuardParamContext.h>
#import <SecurityGuardSDKWatch/Open/IOpenSecurityGuardPlugin.h>
#else
#import <SecurityGuardSDK/IndieKit/IIndieKitComponent.h>
#import <SecurityGuardSDK/IndieKit/IndieKitDefine.h>
#import <SecurityGuardSDK/SecurityGuardParamContext.h>
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#endif

@protocol ISecurityGuardIndieKit <NSObject, IIndieKitComponent, IOpenSecurityGuardPluginInterface>
@end


#endif /* ISecurityGuardIndieKit_h */
