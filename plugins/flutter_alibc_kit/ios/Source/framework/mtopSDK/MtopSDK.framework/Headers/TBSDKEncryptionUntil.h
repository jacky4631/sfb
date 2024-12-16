//
//  TBSDKEncryptionUntil.h
//  mtopsdk
//
//  Created by sihai on 7/5/15.
//  Copyright (c) 2015 mtop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSDKEncryptionUntil : NSObject

+ (NSData *)encryptionString:(NSString *)string key:(NSString *)key;

+ (NSString *)decryptWithKey:(NSString *)key decrypDta:(NSData *)data;


@end
