//
//  TBSDKProgressDelegate.h
//  TBSDK
//
//  Created by 亿刀 on 14-3-6.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBSDKConnection;

@protocol TBSDKProgressDelegate <NSObject>

@optional

// These methods are used to update UIProgressViews (iPhone OS) or NSProgressIndicators (Mac OS X)
// If you are using a custom progress delegate, you may find it easier to implement didReceiveBytes / didSendBytes instead
#if TARGET_OS_IPHONE
- (void)setProgress:(float)newProgress;
#else
- (void)setDoubleValue:(double)newProgress;
- (void)setMaxValue:(double)newMax;
#endif

// Called when the request receives some data - bytes is the length of that data
- (void)request:(TBSDKConnection *)connection didReceiveBytes:(long long)bytes;

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(TBSDKConnection *)connection didSendBytes:(long long)bytes;

// Called when a request needs to change the length of the content to download
- (void)request:(TBSDKConnection *)connection incrementDownloadSizeBy:(long long)newLength;

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(TBSDKConnection *)connection incrementUploadSizeBy:(long long)newLength;

@end
