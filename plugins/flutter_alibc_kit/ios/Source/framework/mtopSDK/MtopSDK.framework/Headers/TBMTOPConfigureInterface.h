//
//  TBMTOPConfigInterface.h
//  MtopSDK
//
//  Created by wuchen.xj on 2019/1/28.
//  Copyright © 2019年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * MTOP统一配置接口
 */
@protocol TBMTOPConfigureProtocol <NSObject>

/**
 *  获取配置内容，非hig级别配置，首次获取返回空，并触下载相应的配置，如果下载成功，业务方第二次调用此接口会返回远端配置
 *
 *  @param groupName     组名称，不能为nil，区分大小写
 *  @param key           配置的key，不能为nil，区分大小写
 *  @param defaultConfig 缺省值，可以为nil
 *  @param isDefault     返回的是否为缺省值，可以为nil
 *
 *  @return 配置的内容
 */
- (id)getConfigByGroupName:(NSString *)groupName
                       key:(NSString *)key
             defaultConfig:(id)defaultConfig
                 isDefault:(BOOL *)isDefault;

/**
 *  获取整个组配置(和服务端的组对应), 业务方无需调用此接口，为测试使用
 *
 *  @param groupName 配置组的名字，区分大小写
 *
 *  @return 组的配置，如为空，返回nil
 */
- (NSDictionary *)getGroupConfigByGroupName:(NSString *)groupName;

@end


/**
 * MTOP统一配置注入实现。
 */
@interface TBMTOPConfigureInterface : NSObject

+ (void)setConfigureService:(id<TBMTOPConfigureProtocol>) handler;

+ (id<TBMTOPConfigureProtocol>)configureService;

@end

NS_ASSUME_NONNULL_END
