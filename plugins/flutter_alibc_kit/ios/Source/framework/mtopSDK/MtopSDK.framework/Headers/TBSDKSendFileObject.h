//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-6-26.
//  Copyright (c) 2013年 亿刀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSDKSendFileObject : NSObject

@property (nonatomic, strong) NSData*   data;
@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) NSString* key;

/*!
 * 初始化一个文件上传对象
 * @param data          文件数据
 * @param fileName      本地文件名
 * @param forKey        form field key
 * @return
 *                  TBSDKSendFileObject
 */
- (TBSDKSendFileObject*) initWithData: (NSData*) data fileName: (NSString*) fileName forKey: (NSString*) key;

@end
