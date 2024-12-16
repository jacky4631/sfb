//
//  SGMain.h
//  SecurityGuardMain
//
//  Created by lifengzhong on 2016/12/29.
//  Copyright © 2016年 Li Fengzhong. All rights reserved.
//

#ifndef SGMain_h
#define SGMain_h

#import <Foundation/Foundation.h>

 

#ifdef _SG_INTERNAL_VERSION_

#import <SGMain/ISecurityGuardSafeToken.h>
#import <SGMain/ISecurityGuardInitialize.h>
#import <SGMain/ISecurityGuardDataCollection.h>
#import <SGMain/ISecurityGuardStaticDataStore.h>
#import <SGMain/ISecurityGuardStaticDataEncrypt.h>
#import <SGMain/ISecurityGuardDynamicDataEncrypt.h>
#import <SGMain/ISecurityGuardDynamicDataStore.h>
#import <SGMain/ISecurityGuardSecureSignature.h>
#import <SGMain/ISecurityGuardAtlasEncrypt.h>

#endif

#import <SGMain/ISecurityGuardOpenSafeToken.h>
#import <SGMain/ISecurityGuardOpenInitialize.h>
#import <SGMain/ISecurityGuardOpenDataCollection.h>
#import <SGMain/ISecurityGuardOpenStaticDataStore.h>
#import <SGMain/ISecurityGuardOpenStaticDataEncrypt.h>
#import <SGMain/ISecurityGuardOpenDynamicDataEncrypt.h>
#import <SGMain/ISecurityGuardOpenDynamicDataStore.h>
#import <SGMain/ISecurityGuardOpenSecureSignature.h>
#import <SGMain/ISecurityGuardOpenAtlasEncrypt.h>
#import <SGMain/ISecurityGuardOpenUMID.h>
#import <SGMain/ISecurityGuardOpenStaticKeyEncrypt.h>
#import <SGMain/ISecurityGuardOpenOpenSDK.h>


#endif /* SGMain_h */
