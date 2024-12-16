//
//  SecurityGuardMiddleTier.h
//  SecurityGuardMiddleTier
//
//  Created by chenkong.zh on 2019/03/31.
//  Copyright © 2016年 Li Fengzhong. All rights reserved.
//

#ifndef SGMiddleTier_h
#define SGMiddleTier_h

#import <Foundation/Foundation.h>

#import <SGMiddleTier/ISecurityGuardOpenMiddleTierGeneric.h>
#import <SGMiddleTier/ISecurityGuardOpenUnifiedSecurity.h>
#import <SGMiddleTier/SecurityGuardOpenMiddleTierDefine.h>
#import <SGMiddleTier/FCAction.h>
#import <SGMiddleTier/FCConstantDefine.h>
#import <SGMiddleTier/ISecurityGuardFCManager.h>
#import <SGMiddleTier/IFCActionCallback.h>
#import <SGMiddleTier/ICustomUIUtil.h>

 

#ifdef _SG_INTERNAL_VERSION_

#else
    #import <SGMiddleTier/JAQAVMPSignature.h>
#endif

#import <SGMiddleTier/ISecurityGuardOpenAVMPGeneric.h>
#import <SGMiddleTier/ISecurityGuardOpenAVMPSafeToken.h>
#import <SGMiddleTier/ISecurityGuardOpenAVMPSoftCert.h>


#endif /* SGMiddleTier_h */
