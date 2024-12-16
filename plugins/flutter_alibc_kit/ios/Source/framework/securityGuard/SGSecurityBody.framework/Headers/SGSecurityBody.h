//
//  SGSecurityBody.h
//  SecurityGuardMain
//
//  Created by lifengzhong on 2016/12/29.
//  Copyright © 2016年 Li Fengzhong. All rights reserved.
//

#ifndef SGSecurityBody_h
#define SGSecurityBody_h

#import <Foundation/Foundation.h>

 

#ifdef _SG_INTERNAL_VERSION_

#import <SGSecurityBody/ISecurityGuardRootDetect.h>
#import <SGSecurityBody/ISecurityGuardSecurityBody.h>
#import <SGSecurityBody/ISecurityGuardSimulatorDetect.h>
#import <SGSecurityBody/ISecurityGuardPageTrack.h>
#else

#import <SGSecurityBody/ISecurityGuardOpenJAQVerification.h>

#endif

#import <SGSecurityBody/ISecurityGuardOpenSecurityBody.h>
#import <SGSecurityBody/ISecurityGuardOpenSimulatorDetect.h>
#import <SGSecurityBody/ISecurityGuardOpenLBSRisk.h>

#endif /* SGSecurityBody_h */
