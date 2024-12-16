/*
 * AlibcJSONModel.h 
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
#import "NSArray+AlibcJSONModel.h"
#import "NSDictionary+AlibcJSONModel.h"
#import "AlibcJSONModelKeyMapper.h"
#import "AlibcJSONModelProperty.h"
#import "AlibcJSONModelError.h"

/*
 AlibcJSONModel是json model的基类，其存在的作用是实现model属性和json之间的映射，以及自动设置等工作，使得上层model只需要声明其属性，而无需知道这些属性如何进行设置的。
 
 因为json数据中有些key和objc中的一些关键字或者属性方法名存在冲突，所以引入了一个keyMapper的概念，把json的key和model的属性名建立一个映射。
 
 model进行初始化的时候使用了一些objc rutime的功能，比如获取当前model的所有属性信息，然后再通过这些属性信息以及KVC的方式为其设置属性值。为了性能的考虑，将这些属性信息设置为model class object的关联对象，下次获取的时候直接从class object的关联对象中获取。
*/

@interface AlibcJSONModel : NSObject

+ (id)modelWithJSONDictionary:(NSDictionary *)dict;
+ (id)modelWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;

- (id)initWithJSONDictionary:(NSDictionary *)dict;
- (id)initWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;

- (void)updateWithJSONDictionary:(NSDictionary *)dict;

- (NSDictionary *)toJSONDictionary;

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON;

+ (AlibcJSONModelKeyMapper *)modelKeyMapper;

//此Dictionary的key为json对应的字段名，value为Model对应的属性名
+ (NSDictionary *)jsonToModelKeyMapDictionary;


//此Dictionary可以用来描述model容器中元素对应的类@{"propertyNameA":ClassA}
+ (NSDictionary *)modelContainerClassMapDictioanry;

//返回主动忽略的属性名的列表
+ (NSArray *)ignoredPropertyNames;

//当strictMode为YES的时候，json dictionary中的数据类型如果无法转换成对应的属性类型，则此属性不被设置,默认为NO
+ (BOOL)strictMode;

@end
