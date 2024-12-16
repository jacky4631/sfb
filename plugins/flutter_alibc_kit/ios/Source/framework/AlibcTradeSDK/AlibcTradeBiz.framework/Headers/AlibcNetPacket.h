/*
 * AlibcNetPacket.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.9
 * 发布时间：2019-10-31
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "AlibcNetError.h"

#ifndef AlibcNetPacket_h
#define AlibcNetPacket_h

//*******使用须知
//函数是给子类重载用的; block是给外部调用者设置的,子类自己不要用


typedef NS_ENUM(long, ALiNetPriority) {
    ALiNetPriorityHigh = 1,  //高,马上发送
    ALiNetPriorityNormal,    //普通,发送任务多时,可能等待200ms(等待时可以合并请求)
    ALiNetPriorityLow,   //低,等待200ms后发送,供合并请求
};

typedef NS_ENUM(long, AlibcNetPacketStatus) {
    AlibcNetPacketStatusNormal = 1,//请求未处理
    AlibcNetPacketStatusSendng,    //发送中
    AlibcNetPacketStatusSuccess,   //请求成功
    AlibcNetPacketStatusFail,      //请求失败
};

typedef void (^SuccessAction)(id netData);   //发送成功
typedef void (^ErrorAction)(AlibcNetError *error);   //发送失败
typedef void (^ErrorJSAction)(id error);   //发送失败

//mtop请求包头定义
@interface AlibcNetPacketHttpHeader : NSObject
@property(nonatomic, copy) NSString *cmd; //mtop命令
@property(nonatomic, copy) NSString *version; //版本,默认值"1.0"
@property(nonatomic, assign) BOOL needPost;    //是否用post,默认是YES
@property(nonatomic, assign) BOOL needLogin;    //是否需要login,默认是NO
@property(nonatomic, assign) BOOL needAuth;    //是否需要授权,默认是NO
@property(nonatomic, assign) BOOL needWua;    //是否需要人机,默认是NO
@property(nonatomic, assign) NSInteger sessionExpireType; // 0 AutoLoginAndMaunlLogin 1 AutoLoginOnly

@property(nonatomic, copy) NSString *bizId; //组件id,默认不需要填,组件发起的才需要填
@property(nonatomic, copy) NSString *ttid;// 不设置 用默认百川的ttid

@property(nonatomic, strong) NSDictionary *extHeaders;

- (instancetype)initWithCmd:(NSString *)cmd;
@end

//......
@interface AlibcNetPacket<ObjectType> : NSObject
@property(nonatomic, assign) NSUInteger retryTime;  //发送重试次数,默认(0),不重试  最大重试5次
@property(nonatomic, assign) ALiNetPriority priority;  //默认值(AMPNetPriorityNormal)

//****** 下面变量,是netservice维护的, ******//
@property(nonatomic, assign) NSUInteger retryCount;  //当前是第几次重试,网络层用..子类不要动,切忌
@property(nonatomic, assign) AlibcNetPacketStatus status;

//block,只供外部使用者设置,子类不要用;
@property(nonatomic, copy) SuccessAction successAction;
@property(nonatomic, copy) ErrorAction failAction;
@property(nonatomic, copy) ErrorJSAction failJSAction;


//**************供子类重载用的
//Mtop发送相关
- (AlibcNetPacketHttpHeader *)generateMtopHeader;

- (NSDictionary *)generateMtopBody;

- (NSDictionary *)generateMtopExtParams;

//重试通知, 如果有需要在这里修改内部数据 ,否则不用管,retryCount是第几次(1开始)
//retryAction时,可以改变netType,这样重试的时候,可以改变通道方式.比如第一次用accs的,重发的时候用mtop
- (void)retryAction:(NSUInteger)retryCount;

//剔除sendPacke中自己已经在请求中部分.如果全部剔除完,返回YES,sendPacke会被丢弃(参考AMPBatchGetUserPacket)
- (BOOL)filterNewPacket:(__kindof AlibcNetPacket *)sendPack;

//等待队列,请求合并..合并待发送的包,返回YES,sendPacke会被丢弃
- (BOOL)conbineWaitingPacket:(__kindof AlibcNetPacket *)sendPack;

//打点逻辑,如果retry时每次都要打点,重载这个..一般的成功失败打点直接successAction,failAction里挂载打点即可..
- (void)trackActionSuccess:(BOOL)isSuccess error:(AlibcNetError *)error duration:(double)durationMillisecond;


//**********给子类用的辅助函数
//是否有效,用户切换后则无效  .没事不要重载修改
- (BOOL)isValued;

- (BOOL)sendPacket;

- (BOOL)sendJSPacket;

@end

#endif
