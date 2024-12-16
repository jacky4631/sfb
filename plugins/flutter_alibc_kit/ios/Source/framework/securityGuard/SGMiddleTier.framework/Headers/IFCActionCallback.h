//
//  IFCActionCallback.h
//  SecurityGuardMiddleTier
//
//  Created by yhN on 2019/4/3.
//  Copyright © 2019年 Li Fengzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCAction.h"

@protocol IFCActionCallback <NSObject>

-(void) onPreAction:(long)sessionId
              hasUI:(BOOL)hasUI;

-(void) onAction:(long)sessionId
      mainAction:(FCMainAction)mainAction
       subAction:(long)subAction
      actionInfo:(NSDictionary*)actionInfo;

@end
