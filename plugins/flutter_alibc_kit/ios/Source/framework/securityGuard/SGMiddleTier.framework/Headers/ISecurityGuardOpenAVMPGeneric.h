//
//  ISecurityGuardOpenAVMPGeneric.h
//  SecurityGuardMiddleTier
//
//  Created by GeorgePei on 7/6/16.
//  Copyright © 2016 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenAVMPGeneric_h
#define ISecurityGuardOpenAVMPGeneric_h

#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#include <stdbool.h>


@interface AVMPGenericInstance : NSObject

+ (id) createBool: (bool) data;
+ (id) createInt32: (int32_t) data;
+ (id) createInt64: (int64_t) data;
+ (id) createFloat: (float) data;
+ (id) createDouble: (double) data;
+ (id) createString: (NSString*) data;
+ (id) createMutableByteArray: (NSMutableData*) data;
+ (id) createByteArray: (NSData*) data;


+ (id) getReturnTypeBool;
+ (id) getReturnTypeInt32;
+ (id) getReturnTypeInt64;
+ (id) getReturnTypeFloat;
+ (id) getReturnTypeDouble;
+ (id) getReturnTypeString;
+ (id) getReturnTypeByteArray;



- (id) invokeAVMP: (NSString*) idunctionName
       returnType:(id) returnType, ...;

- (id) invokeAVMP2: (NSString*) idunctionName
       returnType:(id) returnType, ...;

@end





@protocol ISecurityGuardOpenAVMPGeneric <NSObject, IOpenSecurityGuardPluginInterface>

- (AVMPGenericInstance*) createAVMPInstance: (NSString*) authCode
                                   byteCodeName:(NSString*) bcName;

-(BOOL) destroyAVMPInstance: (AVMPGenericInstance*) instance;


@end

#endif /* ISecurityGuardOpenAVMPGeneric_h */
