//
//  WVURLProtocolProcessor.h
//  Core
//
//  Created by lianyu on 2019/4/24.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 WVURLProtocol 的处理器，目前仅用于 Ariver。
 */
@protocol WVURLProtocolProcessor <NSObject>

@required

+ (BOOL)canInitWithRequest:(NSURLRequest * _Nonnull)request;
- (instancetype _Nonnull)initWithRequest:(NSURLRequest * _Nonnull)request cachedResponse:(NSCachedURLResponse * _Nonnull)cachedResponse client:(id<NSURLProtocolClient> _Nonnull)client;
- (void)startLoading;
- (void)stopLoading;

@end
