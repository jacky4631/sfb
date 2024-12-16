//
//  ALSLExtensions.h
//  AlibcLinkPartnerSDK
//
//  Created by 诺夏 on 2019/3/13.
//  Copyright © 2019 czp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ALSL)

/**
 *  URL编码
 */
- (NSString * _Nullable)alsl_encode;

/**
 *  URL解码
 */
- (NSString * _Nullable)alsl_decode;

/**
 *  获取URL中的参数
 */
- (NSDictionary * _Nullable)alsl_urlparams;

/**
 * Base64编码
 */
- (NSString * _Nullable)alsl_base64Encoded;

/**
 *  MD5加密
 */
- (NSString * _Nullable)alsl_md5;

@end

@interface NSDictionary (ALSL)

/**
 *  JSONObject 转 JSONString
 */
- (NSString *_Nullable)alsl_jsonString;

@end
