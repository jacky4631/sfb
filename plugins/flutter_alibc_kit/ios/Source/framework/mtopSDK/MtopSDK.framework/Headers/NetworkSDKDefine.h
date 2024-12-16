//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀  iTeam on 13-3-3.
//  Copyright (c) 2013年 亿刀  iTeam. All rights reserved.
//

#ifndef TBSDKNetworkSDK_Define_h
#define TBSDKNetworkSDK_Define_h

#define TBSDK_REQUEST_NOT_NETWORK           @"tbsdk request not network"    //无网络
#define TBSDK_REQUEST_TIME_OUT              @"tbsdk request timeout"        //请求超时
#define TBSDK_SERVER_TOO_MANY_REDIRECTION   @"302跳转次数过多"


#define FUNCTION_LINE [NSString stringWithFormat: @"%s %d", __FUNCTION__, __LINE__]

/** 编译设置
 *  如果以framework的方式引入NetworkSDK，kNetworkSDKIsFramework的定义不起任何作用
 *  如果源码的方式引入NetworkSDK，“TBSDKNetworkSD.h”将将产生条件编译
 */
#define kNetworkSDKIsFramework 0

/*---------------------------------post 消息定义------------------------------------------------------------*/
//自动登录失败
#define kTBSDKNetworkSDKAutoLoginIsFail @"kTBSDKNetworkSDKAutoLoginIsFail"
/*---------------------------------------------------------------------------------------------*/

    
#endif

#define kFaileSystemErrorCode                @"小二很忙，系统很累，请稍后重试"