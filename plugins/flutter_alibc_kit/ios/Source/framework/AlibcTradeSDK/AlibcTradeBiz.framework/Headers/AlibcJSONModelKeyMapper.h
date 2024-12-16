/*
 * AlibcJSONModelKeyMapper.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface AlibcJSONModelKeyMapper : NSObject

//映射字典自身的key为json的字段名，value为model的属性名
- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey;
- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey;

@end
