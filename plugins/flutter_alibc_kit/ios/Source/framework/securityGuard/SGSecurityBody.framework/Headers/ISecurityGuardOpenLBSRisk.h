//
//  ISecurityGuardOpenLBSRisk.h
//  SecurityGuardSecurityBody
//
//  Created by chenkong.zh on 2019/03/14.
//  Copyright © 2018 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenLBSRisk_h
#define ISecurityGuardOpenLBSRisk_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#if TARGET_OS_WATCH
#import <SecurityGuardSDKWatch/SecurityBody/ISecurityBodyComponent.h>
#import <SecurityGuardSDKWatch/Open/IOpenSecurityGuardPlugin.h>
#else
#import <SecurityGuardSDK/Open/OpenSecurityBody/IOpenSecurityBodyComponent.h>
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#endif

@protocol ISecurityGuardOpenLBSRisk <NSObject, IOpenSecurityGuardPluginInterface>

// 已废弃
/**
 * 初始化LBS风控模块的Manager, 创建LVM实例
 *
 * @param dict 所有参数都放到字典里面，避免后续如果有参数扩展需要改接口的情况出现，字典可以持续扩展参数
 *      "authCode"          : (NSString*)  [required] 保镖为业务方分配的标识id，与bianry一一对应
 *      "binary"            : (NSdata*)    [optional] 存储待执行的bianry code的二进制
 *      "maxLocationCnt"    : (NSNumber*)  [optional] 最大支持上传的Location数量可自定义的有效区间为[3, 20],缺省值=3
 *      "reset"             : (NSNumber*)  [optional] 重新初始化，此时binary为非空，加载新的binary code
 * @param error 错误
 *
 * @return YES succees, NO failure
 */
- (BOOL) initLbsManager: (NSDictionary*)dict
                  error: (NSError* __autoreleasing*)error;

// 已废弃
/**
 * 存储应用获取的Location信息。
 *
 * @param locations 位置信息，GCJ02 坐标系
 * @param error 错误码
 * @return YES succees, NO failure
 */
- (BOOL) putLocationData: (CLLocation*) locations
                   error: (NSError* __autoreleasing*)error;

// 已废弃
/**
 * 获取位置风险信息。
 *
 * @param env 线上0，预发1，日常0
 * @param error 错误码
 * @return 获取位置信息+风控数据
 */
- (NSString *) getLocationData:(int)env
                         error:(NSError* __autoreleasing*)error;
// 已废弃
/**
 * 重置 Location 信息。
 *
 * @return YES succees, NO failure
 */
- (BOOL) clearLocationData: (NSError* __autoreleasing*)error;


@end

#endif /* ISecurityGuardOpenLBSRisk_h */
