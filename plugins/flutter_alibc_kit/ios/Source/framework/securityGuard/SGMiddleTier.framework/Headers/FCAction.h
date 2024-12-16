//
//  FCAction.h
//  SecurityGuardMiddleTier
//
//  Created by yhN on 2019/4/3.
//  Copyright © 2019年 Li Fengzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FC_SUCCESS, //异常请求，验证成功，无需重发
    
    FC_FAIL,   //异常请求，无需进一步处理
    
    FC_CANCEL, //用户取消验证
    
    FC_RETRY,   //异常请求，验证成功，需要重发
    
    FC_TIMEOUT  //清洗超时
    
} FCMainAction;

typedef enum {
    
    FC_WUA = (1), //重发需要带WUA,业务方需要在重发前调用虚机签名接口
    
    FC_NC = (1<<1), //需要NC滑动验证
    
    FC_FL = (1<<2), //限流，不需要重发
    
    FC_LOGIN = (1<<3), // 拉登录
    
    FC_DENY = (1<<4)  //拒绝
} FCSubAction;
