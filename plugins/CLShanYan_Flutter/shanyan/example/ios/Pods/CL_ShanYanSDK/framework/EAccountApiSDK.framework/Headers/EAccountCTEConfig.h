//
//  EAccountCTEConfig.h
//  EAccountApiSDK
//
//  Created by lvzhzh on 2019/12/4.
//  Copyright © 2019 21CN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EAccountCTEConfig : NSObject

@property (nonatomic, copy) NSString *timestampDomain;
@property (nonatomic, copy) NSString *preLoginDomain;
@property (nonatomic, copy) NSString *uploadLogDomain;

- (instancetype)initWithDefaultConfig;

@end

NS_ASSUME_NONNULL_END
