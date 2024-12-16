//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-1-28.
//  Copyright (c) 2013年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 存放所有类的Category
 *
 *
 */
@interface NSString(TBSDK_NSString_Category)

- (NSString *)tbsdkMd5;

@end

@interface NSData(TBSDK_NSData_Category)

- (NSString *)tbsdkMd5ForString;
- (NSData *)tbsdkMd5ForData;

@end
