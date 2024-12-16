//
//  ALBBUser.h
//  AlibabaAuthSDK
//
//  Created by Bangzhe Liu on 6/17/16.
//  Copyright © 2016 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBUser : NSObject

/** 昵称 */
@property (nonatomic, copy, readonly) NSString *nick;
/** 头像地址 */
@property (nonatomic, copy, readonly) NSString *avatarUrl;

@property (nonatomic, copy, readonly) NSString *openId;
@property (nonatomic, copy, readonly) NSString *openSid;
@property (nonatomic, copy, readonly) NSString *topAccessToken;
@property (nonatomic, copy, readonly) NSString *topAuthCode;

- (instancetype)initWithNick:(NSString *)nick avatarUrl:(NSString *)avatarUrl openId:(NSString *)openId openSid:(NSString *)openSid topAccessToken:(NSString *)topAccessToken topAuthCode:(NSString*)authCode;


@end
