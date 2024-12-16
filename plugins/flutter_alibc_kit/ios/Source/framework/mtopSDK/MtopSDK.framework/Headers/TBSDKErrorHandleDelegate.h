//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-1-31.
//  Copyright (c) 2013年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBSDKServer;

@protocol TBSDKErrorRule;

@protocol TBSDKErrorHandleDelegate <NSObject>

@required

//! 如果返回值不为nil，表示有业务错误，反之，表示服务器返回值没有业务错误，是一次成功的网络请求
- (id<TBSDKErrorRule>)tbsdkErrorHandleWithServer:(TBSDKServer *)server;

@end
