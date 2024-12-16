//
//  TBSDKConnectionProtocol.h
//  TBSDK
//
//  Created by 亿刀 on 14-3-6.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBSDKCacheDelegate;
@protocol TBSDKProgressDelegate;
@protocol TBSDKConnectionDelegate;

//和ASI对应轻易不要修改
typedef enum _TBSDKCachePolicy
{
	TBSDKUseDefaultCachePolicy = 0,
    
	TBSDKDoNotReadFromCacheCachePolicy = 1,
    
	TBSDKDoNotWriteToCacheCachePolicy = 2,
    
	TBSDKAskServerIfModifiedWhenStaleCachePolicy = 4,
    
	TBSDKAskServerIfModifiedCachePolicy = 8,
    
	TBSDKOnlyLoadIfNotCachedCachePolicy = 16,
    
	TBSDKDontLoadCachePolicy = 32,
    
	TBSDKFallbackToCacheIfLoadFailsCachePolicy = 64
} TBSDKCachePolicy;

typedef enum _TBSDKPostFormat
{
    TBSDKMultipartFormDataPostFormat = 0,
    TBSDKURLEncodedPostFormat = 1
} TBSDKPostFormat;


@protocol TBSDKConnectionProtocol <NSObject>

@property (unsafe_unretained) id<TBSDKProgressDelegate>uploadProgressDelegate;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, unsafe_unretained) TBSDKCachePolicy cachePolicy;

@property (unsafe_unretained) id <TBSDKCacheDelegate> downloadCache;

@property (unsafe_unretained, nonatomic) NSTimeInterval timeOutSeconds;

@property (nonatomic, strong) NSDictionary *responseHeaders;

@property (nonatomic, strong) NSMutableDictionary *requestHeaders;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, weak) id<TBSDKConnectionDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *requestCookies;

@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, strong) NSString *responseString;

@property (nonatomic, unsafe_unretained) NSStringEncoding responseEncoding;

@property (assign,readonly) int responseStatusCode;

@property (unsafe_unretained) TBSDKPostFormat postFormat;

@property (nonatomic, strong) NSMutableArray *postData;

+ (id)requestWithURL:(NSURL *)newURL;

- (void)setPostValue:(id<NSObject>)value forKey:(NSString *)key;

- (void)addRequestHeader:(NSString *)header value:(NSString *)value;

- (void)startAsynchronous;

- (void)startSynchronous;

- (void)clearDelegatesAndCancel;

- (void)addData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

@end
