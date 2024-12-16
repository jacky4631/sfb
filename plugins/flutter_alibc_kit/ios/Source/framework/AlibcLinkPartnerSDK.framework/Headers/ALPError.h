//
//  ALPError.h
//  ALPLinkPartnerSDK
//
//  Created by czp on 16/9/22.
//  Copyright © 2016年 czp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LinkPartnerErrorType)
{
    LINKPARTNER_ERROR_NOT_INIT            = 1,//没有初始化
    LINKPARTNER_ERROR_PARAM_MISSING       = 2,//跳转参数缺失
    LINKPARTNER_ERROR_URL_ERROR           = 3,//错误的linkKey或者跳转URL 为nil
    LINKPARTNER_ERROR_ITEMID_ILLEGAL      = 4,//参数非法,例如itemId为空或含有非数字字符
    LINKPARTNER_ERROR_SHOPID_ILLEGAL      = 5,//同上 shoopID非法
    LINKPARTNER_ERROR_H5HURL_ILLEGAL      = 6,//URL非法法, 必须为URL格式 例如http://www.taobao.com
    LINKPARTNER_ERROR_SIGN_MISSING        = 7,//sign缺失,未设置黑匣子,或者appSecret缺失
    LINKPARTNER_ERROR_NOT_INSTALL         = 8,//跳转APP未安装
    LINKPARTNER_ERROR_DEGRADE_URL_NIL     = 9,//降级地址为空，未配置降级地址
    LINKPARTNER_ERROR_DOWNLOAD_URL_NIL    = 11,//下载页地址为空，未配置下载页地址
    LINKPARTNER_ERROR_ROUTERULE_NIL       = 12,//插件路由规则为nil
};
//__attribute__((deprecated("ALPError已过期, 不再使用")))

@interface ALPError : NSObject

@property (nonatomic, assign) LinkPartnerErrorType errorCode;

+ (instancetype)initWithErrorType:(LinkPartnerErrorType)errorType;

@end
