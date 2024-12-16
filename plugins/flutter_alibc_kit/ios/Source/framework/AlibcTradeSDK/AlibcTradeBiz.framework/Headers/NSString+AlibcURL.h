/*
 * NSString+AlibcURL.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#ifndef NSString_AlibcURL_h
#define NSString_AlibcURL_h



#import <Foundation/Foundation.h>

@interface NSString (AlibcURL)

- (id)valueForUrlQueryKey:(NSString *)key;

/*!
 Parses a URL query string into a dictionary with auto encoding(UTF8 & GBK).
 @returns query dictionary
 */
- (NSDictionary *)aliQueryDictionaryByAutoDecoding;

/*!
 Parses a URL query string into a dictionary without encoding.
 @returns query dictionary
 */
- (NSDictionary *)aliQueryDictionary;

- (NSString *)aliStringByAddingURLEncodedQueryDictionary:(NSDictionary *)query;

// 对于 URL 中已有的 key, 保持URL中原有的 key, 不覆盖
- (NSString *)aliStringByAddingQueryDictionary:(NSDictionary *)query;

- (id)aliUrlEncoded;

- (NSString *)aliURLDecoding;

- (NSString *)aliTrim;

/**
 *  将 k1=v1&k2=v2 形式的字符串 转换成 @{@"k1": @"v1", @"k2": @"v2"}
 *  注意: k1=&k2=%k3=v3 会生成 @{@"k1": @"", @"k2": @"", @"k3": @"v3"}
 *
 *  @return query params dictionary
 */
- (NSMutableDictionary *)aliURLQueryStringToDictionary;

/**
 *  根据 Dictionary 中的内容, 生成 k1=v1&k2=v2 形式的字符串
 *  注意: 允许 k1=&k2=%k3=v3 这种有 key 无 value 的情况
 *
 *  @param dictionary 如 @{@"k1": @"v1", @"k2": @"v2"}
 *
 *  @return 转换生成的 dictionary 对象
 */
+ (instancetype)aliURLQueryStringWithDictionary:(NSDictionary *)dictionary;

@end

#endif /* NSString_AlibcURL_h */

