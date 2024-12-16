//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-2-19.
//  Copyright (c) 2013年 亿刀. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TBSDKErrorRule <NSObject>

@required
@property (nonatomic, copy) NSString                                          *errorCode;

@property (nonatomic, copy) NSString                                          *msg;

@optional
@property (nonatomic, copy)  NSString                                         *sub_code;

@property (nonatomic, copy)  NSString                                         *sub_msg;

@property (nonatomic, strong)  NSDictionary                                     *args;

@property (nonatomic, strong)  NSDictionary                                     *raw;

//开发调试使用的参数，用户存放代码出错的位置(__FUNCTION__, __LINE__)
@property (nonatomic, copy) NSString                                          *errorLocation;

@property (nonatomic, strong) NSError                                           *error;

@property (nonatomic, copy) NSString                                          *mappingCode;

// 新增透传TBUIKit错误信息
@property (nonatomic, strong) NSError                                           *uikitError;

// 新增420限流透出retCode错误信息
@property (nonatomic, copy) NSString                                          *limitFlowRawCode;

@end
