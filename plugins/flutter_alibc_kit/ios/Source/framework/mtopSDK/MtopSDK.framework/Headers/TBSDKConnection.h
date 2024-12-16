//
//  TBSDKConnection.h
//  TBSDK
//
//  Created by 亿刀 on 14-3-6.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSDKConnectionProtocol.h"


@protocol TBSDKProgressDelegate;
@protocol TBSDKConnectionDelegate;

//和ASI对应轻易不要修改
typedef enum _TBSDKNetworkErrorType {
    TBSDKConnectionFailureErrorType = 1,
    TBSDKRequestTimedOutErrorType = 2,
    TBSDKAuthenticationErrorType = 3,
    TBSDKRequestCancelledErrorType = 4,
    TBSDKUnableToCreateRequestErrorType = 5,
    TBSDKInternalErrorWhileBuildingRequestType  = 6,
    TBSDKInternalErrorWhileApplyingCredentialsType  = 7,
	TBSDKFileManagementError = 8,
	TBSDKTooMuchRedirectionErrorType = 9,
	TBSDKUnhandledExceptionError = 10,
	TBSDKCompressionError = 11,
    TBSDKACCSError = 12,
	
} TBSDKNetworkErrorType;


@interface TBSDKConnection : NSObject

@property (weak,nonatomic) id<TBSDKProgressDelegate>uploadProgressDelegate;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, assign) TBSDKCachePolicy cachePolicy;

@property (weak,nonatomic) id <TBSDKCacheDelegate> downloadCache;

@property (weak,nonatomic) id <TBSDKProgressDelegate> downloadProgressDelegate;

@property (assign, nonatomic) NSTimeInterval timeOutSeconds;

@property (nonatomic, strong) NSDictionary *responseHeaders;

@property (nonatomic, strong) NSMutableDictionary *requestHeaders;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, weak) id<TBSDKConnectionDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *requestCookies;

@property (nonatomic, strong) NSData *responseData;

@property (nonatomic, strong) NSString *responseString;

@property (nonatomic, assign) NSStringEncoding responseEncoding;

@property (assign,nonatomic) int responseStatusCode;

@property (assign,nonatomic) TBSDKPostFormat postFormat;

@property (strong,nonatomic) NSMutableArray *fileData;

@property (strong,nonatomic) NSHTTPURLResponse *response;

@property (strong,nonatomic) NSMutableData *postBody;

@property (atomic,assign) BOOL isFinished;

@property (assign,nonatomic) BOOL unHostedByNetWork;

// 打点判断是否是http
@property (nonatomic, assign) BOOL isHttp;

@property (nonatomic, strong) NSMutableArray *postData;

@property (nonatomic, assign) int postGzipSize;

// ut dataset dictionary
@property (nonatomic, strong) NSDictionary *utDict;
@property (nonatomic, assign) CFAbsoluteTime networkEndTime;

// 新增统计打点error
@property (nonatomic,strong) NSError *rawError;


+ (instancetype)requestWithURL:(NSURL *)newURL;

+ (void) cancelAll;

- (instancetype)initWithURL:(NSURL *)newURL;

- (void)setPostValue:(id<NSObject>)value forKey:(NSString *)key;

- (void)addRequestHeader:(NSString *)header value:(NSString *)value;

- (void)addCustomRequestHeader:(NSString *)header value:(NSString *)value; // 新增添加自定义请求头(通过该接口添加的请求头不做urlencode)

- (void)startAsynchronous;

- (void)startSynchronous;

- (void)clearDelegatesAndCancel;

- (void)addData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;


@end
