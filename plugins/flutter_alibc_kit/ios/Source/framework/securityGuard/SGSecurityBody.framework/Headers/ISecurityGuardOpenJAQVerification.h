//
//  ISecurityGuardOpenJAQVerification.h
//  SecurityGuardSecurityBody
//
//  Created by lifengzhong on 15/11/9.
//  Copyright © 2015年 Li Fengzhong. All rights reserved.
//

#ifndef ISecurityGuardOpenJAQVerification_h
#define ISecurityGuardOpenJAQVerification_h

#if TARGET_OS_WATCH
#import <SecurityGuardSDKWatch/Open/IOpenSecurityGuardPlugin.h>
#else
#import <SecurityGuardSDK/Open/IOpenSecurityGuardPlugin.h>
#endif

@protocol ISecurityGuardOpenJAQVerification <NSObject, IOpenSecurityGuardPluginInterface>

/**
 *  聚安全防控接口
 *
 *  @param info           其他需要的信息，以key-v形式存于info中，可选
 *  @param timeout        接口调用超时时间，单位秒，最大不超过22，最小不小于1
 *
 *  @return 聚安全服务器返回的安全token
 */
- (NSString*) doJAQVerfificationSync: (NSDictionary*) info
                             timeout: (NSInteger) timeout;


@end


#endif /* ISecurityGuardOpenJAQVerification_h */
