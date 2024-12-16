//
//  IFCComponent.h
//  SecurityGuardMiddleTier
//
//  Created by yhN on 2019/4/3.
//  Copyright © 2019年 Li Fengzhong. All rights reserved.
//

//#ifndef IFCComponent_h
//#define IFCComponent_h

#import "IFCActionCallback.h"
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>

@protocol ISecurityGuardFCManager <NSObject, IOpenSecurityGuardPluginInterface>


@required

/**
 流量清洗组件初始化，其中key为“key_login_module” value为true或false为必传配置

 @param configs 初始化配置
 @param error 异常体现
 */
-(BOOL) setUp:(NSDictionary*) configs
        error:(NSError* __autoreleasing*)error;


/**
 请求是否需要进行流量清洗

 @param resCode 该请求返回的response code
 @param content 该请求对应response的header的kv内容
 @param headerType 目前支持mtop、apache httpclient（0）和java urlconnection（1） http response header格式
 @param error 异常体现
 @return 是否需要清洗
 */
-(BOOL) needFCProcessOrNot:(int) resCode
                   content:(NSDictionary*)content
                headerType:(int)headerType
                     error:(NSError* __autoreleasing*)error;

-(BOOL) needFCProcessOrNotV2:(int) bxLimitFlag
                     content:(NSString*)content
                       error:(NSError* __autoreleasing*)error;


/**
 进行流量清洗

 @param resCode 请求返回的reponse code
 @param content 该请求对应response的header的kv内容
 @param actionCallback 清洗结果回调
 @param headerType 目前支持mtop、apache httpclient（0）和java urlconnection（1） http response header格式
 @param error 异常体现
 */
-(BOOL) processFCContent:(int) resCode
                 content:(NSDictionary*) content
          actionCallback:(id<IFCActionCallback>)actionCallback
              headerType:(int)headerType
                   error:(NSError* __autoreleasing*)error;

-(BOOL) processFCContentV2:(NSString*) content
            actionCallback:(id<IFCActionCallback>)actionCallback
                     error:(NSError* __autoreleasing*)error;

/**
 获取插件版本号

 @param error 异常体现
 @return 中间层插件版本号
 */
-(NSString*) getPluginVersion:(NSError* __autoreleasing*) error;


@end

//#endif
