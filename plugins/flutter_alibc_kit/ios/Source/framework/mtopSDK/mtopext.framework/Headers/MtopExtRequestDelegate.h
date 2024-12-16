//
//  ApiCallback.h
//  mtopext
//
//  API请求回调

//  Created by sihai on 4/11/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mtopext/Constants.h>

@class MtopExtRequest;
@class MtopExtResponse;

/*!
 * 请求开始, 回调block
 * @param request
 */
typedef void (^MtopExtRequestStarted)(MtopExtRequest* request);

/*!
 * 请求失败, 回调block
 * @param request
 */
typedef void (^MtopExtRequestFailed)(MtopExtResponse* response);

/*!
 * 请求成功, 回调block
 * @param request
 */
typedef void (^MtopExtRequestSucceed)(MtopExtResponse* response);

@protocol MtopExtRequestDelegate<NSObject>

/*!
 * 请求开始执行时回调 (开始发送网络请求)
 *
 */
@optional
-(void) started: (MtopExtRequest*) request;

/*!
 * 失败回调, 注意: 我们用的是主线程回调
 * @param response   response.error 是错误信息
 */
-(void) failed: (MtopExtResponse*) response;

/*!
 * 成功回调, 注意: 我们用的是主线程回调
 * @param response   response.error 是错误信息
 */
-(void) succeed: (MtopExtResponse*) response;

@end
