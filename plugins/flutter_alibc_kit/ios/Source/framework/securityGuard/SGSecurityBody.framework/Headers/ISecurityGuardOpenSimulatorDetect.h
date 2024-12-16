//
//  ISecurityGuardOpenSimulatorDetect.h
//  SecurityGuardMain
//
//  Created by lifengzhong on 15/11/10.
//  Copyright © 2015年 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenSimulatorDetect_h
#define ISecurityGuardOpenSimulatorDetect_h

#if TARGET_OS_WATCH
#import <SecurityGuardSDKWatch/Open/OpenSimulatorDetect/IOpenSimulatorDetectComponent.h>
#import <SecurityGuardSDKWatch/Open/IOpenSecurityGuardPlugin.h>
#else
#import <SecurityGuardSDK/Open/OpenSimulatorDetect/IOpenSimulatorDetectComponent.h>
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#endif

@protocol ISecurityGuardOpenSimulatorDetect <NSObject, IOpenSimulatorDetectComponent, IOpenSecurityGuardPluginInterface>

@end

#endif /* ISecurityGuardOpenSimulatorDetect_h */
