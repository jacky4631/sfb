/*
 * NSArray+AlibcJSONModel.h 
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

@interface NSArray(AlibcJSONModel)

/*!
 将JSON转过来的一个数组转换成相应的model类型的数组，支持多级内嵌的模式
 简单的形式，字典的数组转换成model的数组:
 [{},{},{}] ===> [m1,m2,m3]
 
 也可能是nested的数组
 [[{},{}],[{},{}],[{}]] ===> [[m1,m2],[m3,m4],[m5]]
 
 从上面也可以看出局限性，就是数组或者内嵌数组中的元素转换后的目标model类型必须是同种类型
 
 strictMode 严格模式就是只有当每一个element能转成modelClass的对象的时候才会进行转换，否则会被忽略
 */
- (NSArray *)modelArrayWithClass:(Class)modelClass;
- (NSArray *)modelArrayWithClass:(Class)modelClass strictMode:(BOOL)strictMode;

- (NSArray *)toJSONArray;

@end
