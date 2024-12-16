//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 14-4-21.
//  Copyright (c) 2014年 亿刀. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

#import "MtopExtRequest.h"

#define kCacheControlMaxAgeKey @"kCacheControlMaxAgeKey"
#define kCacheControlOfKey @"kCacheControlOfKey"

@interface TBSDKCacheHelper : NSObject

/*!
 *
 */
+ (NSDictionary *)scanEtagMaxAgeAndOf:(NSString *)cacheControl;

/*!
 * 通过MtopExtRequest的cache key
 * @param request
 * @return
 *          cache key
 */
+ (NSString*) getCacheKeyWithRequest: (MtopExtRequest*) request;

/*!
 * 通过MtopExtRequest的限流的cache key
 * @param request
 * @return
 *          cache key
 */
+ (NSString*) getThresholdCacheKeyWithRequest: (MtopExtRequest*) request;


@end
