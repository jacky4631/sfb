//
//  MtopExtRequestHelper.h
//  mtopext
//
//  Created by sihai on 24/6/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MtopExtRequest.h"
#import "MtopExtResponse.h"

@interface MtopExtRequestHelper : NSObject

+ (void) startedCallback: (MtopExtRequest*) request;

+ (void) succeedCallback: (MtopExtRequest*) request response: (MtopExtResponse*) response;

+ (void) failedCallback: (MtopExtRequest*) request response: (MtopExtResponse*) response;

@end
