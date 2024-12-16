//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-7-10.
//  Copyright (c) 2013年 亿刀. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBSDKRequest;

@protocol TBSDKRequestProgressProtocol <NSObject>

@optional

- (void)setProgress:(float)newProgress;

// Called when the request receives some data - bytes is the length of that data
- (void)request:(TBSDKRequest *)request didReceiveBytes:(long long)bytes;

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(TBSDKRequest *)request didSendBytes:(long long)bytes;

// Called when a request needs to change the length of the content to download
- (void)request:(TBSDKRequest *)request incrementDownloadSizeBy:(long long)newLength;

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(TBSDKRequest *)request incrementUploadSizeBy:(long long)newLength;


@end
