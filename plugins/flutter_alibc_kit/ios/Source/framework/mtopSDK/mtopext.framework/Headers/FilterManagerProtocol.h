//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                                      _oo0oo_
//                                     o8888888o
//                                     88" . "88
//                                     (| -_- |)
//                                     0\  =  /0
//                                   ___/`---'\___
//                                 .' \\|     |// '.
//                                / \\|||  :  |||// \
//                               / _||||| -:- |||||- \
//                              |   | \\\  -  /// |   |
//                              | \_|  ''\---/''  |_/ |
//                              \  .-\__  '-'  ___/-. /
//                            ___'. .'  /--.--\  `. .'___
//                         ."" '<  `.___\_<|>_/___.' >' "".
//                        | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//                        \  \ `_.   \_ __\ /__ _/   .-` /  /
//                    =====`-.____`.___ \_____/___.-`___.-'=====
//                                      `=---='
//
//                              佛祖保佑         永无BUG
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//  FilterFetchProtocol.h
//  mtopext
//
//  Created by wuchen.xj on 2019/1/7.
//  Copyright © 2019年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mtopext/MtopExtRequest.h>
#import <mtopext/MtopExtResponse.h>
#import <mtopext/AfterFilter.h>
#import <mtopext/BeforeFilter.h>
#import <mtopext/MtopService.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 责任链接口定义。无论二方或三方，其责任链管理器实现，均按该接口来实现。
 */
@protocol FilterManagerProtocol <NSObject>


/**
 * 构建具体的责任链管理器。
 *
 * @param service 具体的MTOP实例。
 */
- (instancetype)initWithService:(nonnull MtopService*) service;


/**
 * 前置处理。请求在未发出去前，MtopService调用该接口处理请求。
 *
 * @param request 请求对象。
 * @return FilterResult，处理结果。
 */
- (nonnull FilterResult*) doBefore: (nonnull MtopExtRequest*) request;


/**
 * 前置处理。请求在未发出去前，MtopService调用该接口处理请求。
 *
 * @param request 请求对象。
 * @param filterName 若 mtopext 指定从责任链某个节点处处理。
 * @return FilterResult，处理结果。
 */
- (nonnull FilterResult*) doBefore: (nonnull MtopExtRequest*) request startFilter:(nullable NSString*) filterName;


/**
 * 后置处理。请求返回后的处理, MtopService调用该接口处理请求与返回结果。
 *
 * @param request，请求对象。
 * @param response，返回对象。
 *
 * @return FilterResult，处理结果。
 */
- (nonnull FilterResult*) doAfter: (nonnull MtopExtRequest*) request response:(nonnull MtopExtResponse*) response;

@end

NS_ASSUME_NONNULL_END
