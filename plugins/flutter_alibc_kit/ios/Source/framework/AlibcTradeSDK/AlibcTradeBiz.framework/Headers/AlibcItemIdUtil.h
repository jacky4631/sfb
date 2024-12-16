//
//  AlibcItemIdUtil.h
//  AlibcTradeBiz
//
//  Created by Yueyang Gu on 2022/8/9.
//  Copyright © 2022 xzj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlibcItemIdUtil : NSObject

+ (NSNumber *)itemIdDecodingFromOpenId:(NSString *)openId error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
