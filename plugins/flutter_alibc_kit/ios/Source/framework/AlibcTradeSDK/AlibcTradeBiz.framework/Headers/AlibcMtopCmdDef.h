/*
 * AlibcMtopCmdDef.h 
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
//#import "AlibcMtopCmd.h"

// mtop命令查询地址:max.m.taobao.com

//aid url 转链
@interface AlibcMtopTaokeAidConvert : AlibcMtopCmd

@end

//淘客同步换url
@interface AlibcMtopTaokeSclick : AlibcMtopCmd

@end

//淘客异步打点
@interface AlibcMtopTaokeAsync : AlibcMtopCmd

@end

//订单状态查询
@interface AlibcMtopPayQuery : AlibcMtopCmd

@end

//授权
@interface AlibcMtopAuthGetToken : AlibcMtopCmd

@end

//激励任务列表 & 单任务详情
@interface AlibcMtopGetTask : AlibcMtopCmd

@end
