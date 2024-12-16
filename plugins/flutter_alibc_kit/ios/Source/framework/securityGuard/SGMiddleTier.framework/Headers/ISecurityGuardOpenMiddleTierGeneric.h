//
//  ISecurityGuardOpenMiddleTierGeneric.h
//  SecurityGuardMiddleTier
//
//  Created by chenkong.zh on 2019/03/31.
//  Copyright © 2019年 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenMiddleTierGeneric_h
#define ISecurityGuardOpenMiddleTierGeneric_h


#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>

@protocol ISecurityGuardOpenMiddleTierGeneric <NSObject, IOpenSecurityGuardPluginInterface>

/**
 *  init MiddleTier Generic Cponent
 *  @param paramDict <NSString, object> paras
 *    "auth_code"            : (NSString*)       [optional] if not set, default search yw_1222.jpg and yw_1222_mwua.jpg
 *  @return init result
 */
-(BOOL) init:(NSDictionary*) paramDict
       error:(NSError* __autoreleasing*)error;


/**
 *  get signature
 *  @param paramDict <NSString, object> paras
 *    "data"                : (NSData*)         [required] data need to be signed;
 *    "appkey"              : (NSString*)       [required] appkey for sign
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *  @return sign result dictionary
 *    "x-sign"              : (NSString*)       [required] sign result
 *    "x-sign_ext1"         : (NSString*)       [optinal] sign extend result
 *    "..."                 : (NSString*)       [optinal] sign extend resultN
 */
-(NSDictionary*) getSign:(NSDictionary*) paramDict
                   error:(NSError* __autoreleasing*)error;


/**
 *  get mini-wua
 *  @param paramDict <NSString, object> paras
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *    "extend_paras"        : (NSDictionary*)   [optional] extra datas e.g. api name, page id, ..
 *  @return risk control result dictionary
 *    "x-miniwua"           : (NSString*)       [required] mini wua string result
 *    "x-miniwua_ext1"      : (NSString*)       [optional] wsg extra risk control data1
 *    "x-miniwua_ext2"      : (NSString*)       [optional] wsg extra risk control data2
 *    "..."                 : (NSString*)       [optional] wsg extra risk control dataN
 */
-(NSDictionary*) getMiniWua:(NSDictionary*) paramDict
                      error:(NSError* __autoreleasing*)error;

/**
 *  get vmp signature with wua
 *  @param paramDict <NSString, object> paras
 *    "data"                : (NSData*)         [required] data need to be signed
 *    "env"                 : (NSNumber*)       [optional] 0:online, 1:pre, 2:daily if not set default set online
 *  @return wua result content
 *    @"wua"                : (NSString*)       [required] wua data for risk control
 *    @"wua_ext1"           : (NSString*)       [optional] extra wua data1 for risk control
 *    @"wua_ext2"           : (NSString*)       [optional] extra wua data2 for risk control
 *    "..."                 : (NSString*)       [optional] extra wua dataN for risk control
 */
-(NSDictionary*) getWua:(NSDictionary*) paramDict
                  error:(NSError* __autoreleasing*)error;

@end


#endif /* ISecurityGuardOpenMiddleTieaGeneric_h */
