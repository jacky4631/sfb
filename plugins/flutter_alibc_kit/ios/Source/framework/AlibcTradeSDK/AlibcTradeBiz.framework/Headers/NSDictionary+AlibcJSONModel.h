/*
 * NSDictionary+AlibcJSONModel.h 
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

@interface NSDictionary(AlibcJSONModel)

/*!
 将JSON转过来的一个字典中的每一个key都转换成相应类型的model对象，不支持嵌套
 转换过程为:
 {key1:{},key2:{}} ===> {key1:m1,key2:m2}
 
 当然每一个key所对应的value转换后的model类型须为同一个类型
 */
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass;
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass strictMode:(BOOL)strictMode;

- (NSDictionary *)toJSONDictionary;

@end
