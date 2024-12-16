//
//  ObjectPool.h
//  mtopext
//
//  Created by sihai on 5/12/14.
//  Copyright (c) 2014 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectPool : NSObject

/*!
 * 获取实例
 * @return
 *              MtopServerPool
 */
+ (ObjectPool*) getInstance;

/*!
 * pending
 * @param obj
 * @param timeout
 * @return
 *              obj id
 */
- (NSString*) pending: (id) obj timeout: (long) timeout;

/*!
 * 移除之前pending的对象
 * @param oid
 */
- (void) remove: (NSString*) oid;

@end
