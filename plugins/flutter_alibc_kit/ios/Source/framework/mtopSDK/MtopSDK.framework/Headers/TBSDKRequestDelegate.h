//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-1-30.
//  Copyright (c) 2013年 Taobao. All rights reserved.
//

#import "TBSDKRequest.h"

@protocol TBSDKRequestDelegate <NSObject>

@optional
- (void)requestStarted:(TBSDKRequest *)request;
- (void)request:(TBSDKRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(TBSDKRequest *)request;
- (void)requestFailed:(TBSDKRequest *)request;
- (void)request:(TBSDKRequest *)request didReceiveData:(NSData *)data;
- (void)request:(TBSDKRequest *)request didLoadCacheResponseHeader:(NSDictionary *)responseHeader body:(NSString *)responseString;
- (NSArray *)requestSaveCache:(TBSDKRequest *)request responseHeader:(NSDictionary *)responseHeader body:(NSString *)responseDataString;


@end

@protocol TBSDKRequestDataSource <NSObject>

@required

- (NSURL *)requestURL;

@optional

- (NSDictionary *)requestPostValue;

- (BOOL)reuquestIsPost;

- (NSArray *)requestPostData;

- (NSDictionary *)httpRequestHeader;


@end
