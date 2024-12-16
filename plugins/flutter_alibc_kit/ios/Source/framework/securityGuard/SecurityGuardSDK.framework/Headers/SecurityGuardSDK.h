//
//  SecurityGuardSDK.h
//  SecurityGuardMain
//
//  Created by lifengzhong on 2016/12/29.
//  Copyright © 2016年 Li Fengzhong. All rights reserved.
//

#ifndef SecurityGuardSDK_h
#define SecurityGuardSDK_h

#import <Foundation/Foundation.h>

 

#ifdef _SG_INTERNAL_VERSION_

#import <SecurityGuardSDK/SecurityGuardManager.h>
#import <SecurityGuardSDK/SecurityGuardParamContext.h>
#import <SecurityGuardSDK/DP.h>

#import <SecurityGuardSDK/Initialize/IInitializeComponent.h>
#import <SecurityGuardSDK/AtlasEncrypt/IAtlasEncryptComponent.h>
#import <SecurityGuardSDK/NoCaptcha/INoCaptchaComponent.h>
#import <SecurityGuardSDK/NoCaptcha/NoCaptchaDefine.h>
#import <SecurityGuardSDK/UATrace/IUATraceComponent.h>
#import <SecurityGuardSDK/DynamicDataEncrypt/IDynamicDataEncryptComponent.h>
#import <SecurityGuardSDK/SecurityDNS/ISecurityDNSComponent.h>
#import <SecurityGuardSDK/StaticDataEncrypt/IStaticDataEncryptComponent.h>
#import <SecurityGuardSDK/StaticDataEncrypt/StaticDataEncryptDefine.h>
#import <SecurityGuardSDK/SimulatorDetect/ISimulatorDetectComponent.h>
#import <SecurityGuardSDK/DataCollection/IDataCollectionComponent.h>
#import <SecurityGuardSDK/RootDetect/IRootDetectComponent.h>
#import <SecurityGuardSDK/SecurityBody/ISecurityBodyComponent.h>
#import <SecurityGuardSDK/StaticDataStore/IStaticDataStoreComponent.h>
#import <SecurityGuardSDK/StaticDataStore/StaticDataStoreDefine.h>
#import <SecurityGuardSDK/DynamicDataStore/IDynamicDataStoreComponent.h>
#import <SecurityGuardSDK/IndieKit/IIndieKitComponent.h>
#import <SecurityGuardSDK/IndieKit/IndieKitDefine.h>
#import <SecurityGuardSDK/SecureSignature/ISecureSignatureComponent.h>
#import <SecurityGuardSDK/SecureSignature/SecureSignatureDefine.h>

#else

#import <SecurityGuardSDK/JAQ/SecurityCipher.h>
#import <SecurityGuardSDK/JAQ/SecuritySignature.h>
#import <SecurityGuardSDK/JAQ/SecurityStorage.h>
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>
#import <SecurityGuardSDK/JAQ/SimulatorDetect.h>

#endif

#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#import <SecurityGuardSDK/Open/OpenSecurityGuardManager.h>
#import <SecurityGuardSDK/Open/OpenSecurityGuardParamContext.h>
#import <SecurityGuardSDK/Open/OpenUMID/IOpenUMIDComponent.h>
#import <SecurityGuardSDK/Open/OpenStaticKeyEncrypt/IOpenStaticKeyEncryptComponent.h>
#import <SecurityGuardSDK/Open/OpenStaticKeyEncrypt/OpenStaticKeyEncryptDefine.h>
#import <SecurityGuardSDK/Open/OpenStaticDataStore/IOpenStaticDataStoreComponent.h>
#import <SecurityGuardSDK/Open/OpenStaticDataStore/OpenStaticDataStoreDefine.h>
#import <SecurityGuardSDK/Open/OpenStaticDataEncrypt/IOpenStaticDataEncryptComponent.h>
#import <SecurityGuardSDK/Open/OpenStaticDataEncrypt/OpenStaticDataEncryptDefine.h>
#import <SecurityGuardSDK/Open/OpenSimulatorDetect/IOpenSimulatorDetectComponent.h>
#import <SecurityGuardSDK/Open/OpenSecurityBody/IOpenSecurityBodyComponent.h>
#import <SecurityGuardSDK/Open/OpenSecurityBody/OpenSecurityBodyDefine.h>
#import <SecurityGuardSDK/Open/OpenSecureSignature/IOpenSecureSignatureComponent.h>
#import <SecurityGuardSDK/Open/OpenSecureSignature/OpenSecureSignatureDefine.h>
#import <SecurityGuardSDK/Open/OpenOpenSDK/IOpenOpenSDKComponent.h>
#import <SecurityGuardSDK/Open/OpenNoCaptcha/IOpenNoCaptchaComponent.h>
#import <SecurityGuardSDK/Open/OpenNoCaptcha/OpenNoCaptchaDefine.h>
#import <SecurityGuardSDK/Open/OpenInitialize/IOpenInitializeComponent.h>
#import <SecurityGuardSDK/Open/OpenDynamicDataStore/IOpenDynamicDataStoreComponent.h>
#import <SecurityGuardSDK/Open/OpenDynamicDataEncrypt/IOpenDynamicDataEncryptComponent.h>
#import <SecurityGuardSDK/Open/OpenDataCollection/IOpenDataCollectionComponent.h>
#import <SecurityGuardSDK/Open/OpenAtlasEncrypt/IOpenAtlasEncryptComponent.h>




#endif /* SecurityGuardSDK_h */
