//
//  AVMPSignature.h
//  SecurityGuardSDK
//
//  Created by chenkong on 30/11/2016.
//  Copyright © 2016 Li Fengzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JAQAVMPSignature : NSObject

typedef NS_ENUM(NSInteger, SignType) {
    JAQ_SIGNTYPE_MWUA = 0,
    JAQ_SIGNTYPE_HMACSHA1 = 1
};


+ (BOOL) initialize;

+ (NSData*) avmpSign: (NSInteger) signType
               input: (NSData*) input;

+ (BOOL) uninitialize;

@end
