//
//  AfterFilter.h
//  mtopext
//
//  Created by sihai on 11/12/14.
//  Copyright (c) 2014 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mtopext/MtopExtResponse.h>
#import <mtopext/MtopExtRequest.h>
#import <mtopext/MtopService.h>
#import <mtopext/FilterResult.h>

@protocol AfterFilter <NSObject>

/**
 * 通过具体的MTOP实例构建filter.
 */
- (instancetype)initWithService:(MtopService*) service;

/**
 * 获取filter的名字
 * @return
 *              NSString
 */
- (NSString*) getName;

/**
 * 处理请求和响应
 * @param request
 * @param response
 * @param result
 */
- (void) handle: (MtopExtRequest*) request response: (MtopExtResponse*) response result: (FilterResult*) result;

@end
