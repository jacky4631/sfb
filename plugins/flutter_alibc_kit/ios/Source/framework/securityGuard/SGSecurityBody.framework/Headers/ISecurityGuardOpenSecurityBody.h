//
//  ISecurityOpenGuardSecurityBody.h
//  SecurityGuardOpenSecurityBody
//
//  Created by lifengzhong on 15/11/9.
//  Copyright © 2015年 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenSecurityBody_h
#define ISecurityGuardOpenSecurityBody_h

#if TARGET_OS_WATCH
#import <SecurityGuardSDKWatch/Open/OpenSecurityBody/IOpenSecurityBodyComponent.h>
#import <SecurityGuardSDKWatch/Open/IOpenSecurityGuardPlugin.h>
#else
#import <SecurityGuardSDK/Open/OpenSecurityBody/IOpenSecurityBodyComponent.h>
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#endif

@protocol ISecurityGuardOpenSecurityBody <NSObject, IOpenSecurityBodyComponent, IOpenSecurityGuardPluginInterface>

@end

#endif /* ISecurityGuardOpenSecurityBody_h */
