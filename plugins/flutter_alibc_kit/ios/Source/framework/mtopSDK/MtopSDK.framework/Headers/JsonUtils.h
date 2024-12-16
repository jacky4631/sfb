//
//  JsonUtils.h
//  mtopext
//
//  Created by sihai on 13/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

/*!
 * 字符串转换成只读json
 * @param str 字符串
 * @return 
 *          NSDictionary
 */
+ (NSDictionary*) toJson: (NSString*) str;

/*!
 * 字符串转换成只读json
 * @param str 字符串
 * @return
 *          NSDictionary
 */
+ (NSDictionary*) toJsonWithData: (NSData*) data;

/*!
 * 字符串转换成只读json
 * @param str 字符串
 * @return
 *          NSMutableDictionary
 */
+ (NSMutableDictionary*) toMutableJsonWithData: (NSData*) data;

/*!
 * 字符串转换成读写json
 * @param str 字符串
 * @return
 *          NSMutableDictionary
 */
+ (NSMutableDictionary*) toMutableJson: (NSString*) str;

/*!
 * 对象转json字符串
 * @param data 对象
 * @return
 *          NSString
 */
+ (NSString*) toJsonString: (NSObject*) data;

/*!
 * 对象转json字符串的NSData
 * @param data 对象
 * @return
 *          NSData
 */
+ (NSData*) toJsonData: (NSObject*) data;

@end
