//    '########'########::'######:'########:'##:::'##:
//    ... ##..::##.... ##'##... ##:##.... ##:##::'##::
//    ::: ##::::##:::: ##:##:::..::##:::: ##:##:'##:::
//    ::: ##::::########:. ######::##:::: ##:#####::::
//    ::: ##::::##.... ##:..... ##:##:::: ##:##. ##:::
//    ::: ##::::##:::: ##'##::: ##:##:::: ##:##:. ##::
//    ::: ##::::########:. ######::########::##::. ##:
//    :::..::::........:::......::........::..::::..::
//
//  Created by 亿刀 on 13-10-9.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBSDKUTProtocol <NSObject>

//=====================================基础统计=====================================

/**
 * @brief                       预初始化.
 *
 * @warning                     必需:是
 *
 *                              调用顺序:第一个被调用.
 *
 *                              最佳位置:didFinishLaunchingWithOptions
 *
 *                              *Important:* 这个方法必须是最先被调用,该方法调用之后,所有的设置类方法方可调用.
 *
 *
 */
+(void) preInit;

/**
 * @brief                       设置应用标识以及应用密钥.
 *
 * @param          appKey       应用标识.
 *
 * @param          appSecret    应用标识对应的密钥.
 *
 * @warning                     必需:是
 *
 *                              调用顺序:preInit->setKey.
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *
 *
 */
+(void) setKey: (NSString *)appKey appSecret:(NSString *)appSecret;

/**
 * @brief                       设置渠道标识,能够在统计数据的时候区分来源渠道.
 *
 * @param          channel      渠道标识.
 *
 * @warning                     必需:可选,如果需要渠道统计
 *
 *                              调用说明:如需要把统计的内容分渠道做细分,必须调用,如91渠道,360渠道.
 *
 *                              调用顺序:preInit->setChannel.
 *
 *                              最佳实践:[UT setChannel:@"700002"]
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *
 */
+(void) setChannel : (NSString *) channel;

/**
 * @brief                       关闭埋点记录的友好翻译,展示原始数据格式.
 *
 * @warning                     必需:可选,如需要对数据进行渠道细分
 *
 *                              调用说明:调用本接口,TraceContent显示的数据既为线上存储的内容
 *
 *                              调用顺序:preInit->turnOffLogFriendly.
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *
 */
+(void) turnOffLogFriendly;

/**
 * @brief                       开启NavigationController的自动页面统计,包括页面进入,页面离开.
 *
 * @param          excludePages 不希望被自动统计的controller列表.
 *
 * @warning                     必需:可选,如果希望自动统计NavigationController
 *
 *                              调用顺序:preInit->turnOnGlobalNavigationTrack.
 *
 *                              最佳实践:[UT turnOnGlobalNavigationTrack:[[NSArray alloc]initWithObjects:@"NetworkController", nil]];非ARC请自己加autoRelease
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *                              *Important:* 这里的excludePages数组中名称必须为完整的controller名称,如:TestController.
 *                              这里excludePages的场景,我们希望埋点的用户只用在这些页面有特定的埋点场景,如定制args参数。
 *                              排除之后的页面,不受SDK调度,您可以在页面中埋一些个性化的需求
 *
 *
 */
+(void) turnOnGlobalNavigationTrack:(NSArray *) excludePages;

/**
 * @brief                       关闭CrashHandler.
 *                              CrashHandler为应用出现异常时候的自动错误捕获组件.
 *
 * @warning                     必需:可选,如果需要关闭CrashHandler
 *
 *                              调用说明:默认开启.
 *
 *                              调用顺序:preInit->turnOffCrashHandler.
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *
 */
+(void) turnOffCrashHandler;

/**
 * @brief                       开启调试日志开关,可以详细的看到埋点内容以及其它日志.
 *
 * @warning                     必需:可选,如果需要调试埋点
 *
 *                              调用说明:显示埋点以及一些提示性的内容的全面日志.
 *
 *                              调用顺序:preInit->turnDebug.
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *
 */
+(void) turnOnDebug;

/**
 * @brief                       初始化,使得SDK真正开始工作.
 *
 * @warning                     必需:是
 *
 *                              调用说明:默认:异步调用.
 *
 *                              调用顺序:preInit->init.
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后
 *
 *
 */
+(void) init;

/**
 * @brief                       反初始化SDK,调用之后SDK无法继续进行埋点统计.
 *
 * @warning                     必需:可选
 *
 *                              调用说明:释放SDK.
 *
 *                              调用顺序:preInit->init->uninit.
 *
 *                              最佳位置:applicationWillTerminate
 *
 *
 */
+(void) uninit;



//=====================================初级入门：用户相关=====================================

/**
 * @brief                       统计用户登录/登出.
 *
 * @param          usernick     用户昵称,如 AAAAAA
 *
 * @warning                     必需:希望埋上
 *
 *                              调用顺序:preInit->init->updateUserAccount.
 *
 *                              最佳实践:用户登录:[UT updateUserAccount:@"*******A"].
 *                              用户切换:[UT updateUserAccount:@"*******B"].
 *                              用户注销:[UT updateUserAccount:@""].
 *
 *                              最佳位置:成功或失败的登录API返回之后
 *
 *                              *Important:* 登录/切换/登出埋点必须是登录Api调用成功之后调用,反之会统计虚高
 *
 *
 */
+(void) updateUserAccount:(NSString *) usernick;

/**
 * @brief                       updateUserAccount接口的扩展版本,支持参数定制.
 *
 * @param      usernick         用户昵称
 *
 * @param      dict             需要传递到args中去的kv参数对
 *
 *                              调用说明:dict中的参数反映在我们采集数据的args字段中,每个参数对用','分隔.
 *
 *                              调用顺序:preInit->init->updateUserAccount.
 *
 *
 */
+(void) updateUserAccount:(NSString *) usernick
                     args:(NSDictionary *) dict;

/**
 * @brief                       统计用户注册.
 *
 * @param          usernick     用户昵称,如 "AAAAAA"
 *
 * @warning                     最佳建议:有的话,希望埋上
 *
 *                              调用顺序:preInit->init->userRegister.
 *
 *                              *Important:* 必须是注册Api调用成功之后调用,反之会统计虚高
 *
 *
 */

+(void) userRegister:(NSString *) usernick;

/**
 * @brief                       userRegister接口的扩展版本,支持参数定制.
 *
 * @param          usernick     用户昵称
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:dict中的参数反映在我们采集数据的args字段中,每个参数对用','分隔.
 *
 *                              调用顺序:preInit->init->userRegister.
 *
 *                              最佳实践:[UT userRegister:@"******"]
 *
 *                              最佳位置:注册API成功返回之后
 *
 *
 */
+(void) userRegister:(NSString *) usernick args:(NSDictionary *) dict;




//=====================================进阶：页面,控件以及相关=====================================

/**
 * @brief                       使用简单的页面名.
 *
 * @warning                     调用说明:大家在定义页面名称的时候,很多都会采用如NetworkController等字样的名称,我们这个接口会统一把如NetworkController简化为Network.
 *                              这个针对全局的NavigationController也有效
 *
 *                              最佳建议:新使用用户,请务必用上,老用户,也希望慢慢的用上
 *
 *                              调用顺序:preInit->useSimplePageName.
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *                              *Important:* 页面必须是"Controller"结尾的,要不不会有作用。
 *
 *
 */
+(void) useSimplePageName;

/**
 * @brief                       绑定一个自定义的页面名到指定的页面对象上去.
 *
 * @param          dict         页面需要绑定的名称列表
 *
 * @warning                     调用说明:如一个页面叫TestController,我们需要埋点的时候,自动用Custom为页面名称,这样你只需把TestController为key,Custom为value即可,SDK会自动替换.
 *
 *                              调用顺序:preInit->bindPageName.
 *
 *                              最佳实践:[UT bindPageName:[NSDictionary dictionaryWithObjectsAndKeys:@"Coustom",@"NetworkController",nil]];
 *
 *                              最佳位置:didFinishLaunchingWithOptions,preInit之后,init之前
 *
 *
 */
+(void) bindPageName:(NSDictionary *) dict;

/**
 * @brief                       统计页面进入.
 *
 * @param          pageName     页面名称
 *
 * @warning                     调用说明:每个可以展现的页面都有进入和离开等生命周期,页面进入,意思就是进入了某个页面的时候。除了被自动覆盖的Controller之外的
 *
 *                              调用顺序:preInit->init->pageEnter.
 *
 *                              最佳实践:[UT pageEnter:@"Welcome"],不能出现非字母之外的字符,每个单词的首字母都大写,最好不要出现Page,Controller,View等关键词
 *
 *                              最佳位置:页面的viewWillAppear中,自定义的页面框架除外
 *
 *                              *Important:* 必须是在页面的进入生命周期里
 *
 *
 */
+(void) pageEnter:(NSObject *) pageName;

/**
 * @brief                       页面进入的扩展版本.
 *
 * @param          pageName     页面名称
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 页面必须埋上,除自动页面埋点之外
 *
 *                              调用说明:dict中的参数反映在我们采集数据的args字段中,每个参数对用','分隔.
 *
 *                              调用顺序:preInit->init->pageEnter.
 *
 *                              最佳实践:[UT pageEnter:@"Welcome" args:[NSDictionary dictionaryWithObjectsAndKeys:@"v1",@"k1",@"v2",@"k2",nil]],不能出现非字母之外的字符,每个单词的首字母都大写,最好不要出现Page,Controller,View等关键词
 *
 *                              最佳位置:页面的viewWillAppear中,自定义的页面框架除外
 *
 *
 */
+(void) pageEnter:(NSObject *) pageName args:(NSDictionary *) dict;

/**
 * @brief                       统计页面离开.
 *
 * @param          pageName     页面名称
 *
 * @warning                     调用说明:每个可以展现的页面都有进入和离开等生命周期,页面离开,意思就是离开了某个页面的时候。除了被自动覆盖的Controller之外的
 *
 *                              调用顺序:preInit->init->pageLeave.
 *
 *                              最佳实践:[UT pageLeave:@"Welcome"],不能出现非字母之外的字符,每个单词的首字母都大写,最好不要出现Page,Controller,View等关键词
 *
 *                              最佳位置:页面的viewWillDisappear中,自定义的页面框架除外
 *
 *                              *Important:* 必须是在页面的进入生命周期里,如viewDidUnload,自定义的页面框架除外
 *
 *
 */
+(void) pageLeave:(NSObject *) pageName;

/**
 * @brief                       页面离开的扩展版本.
 *
 * @param          pageName     页面名称
 *
 * @param          args         需要传递到args中去的kv参数对
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 必须配对pageEnter出现
 *
 *                              调用说明:dict中的参数反映在我们采集数据的args字段中,每个参数对用','分隔.
 *
 *                              调用顺序:preInit->init->pageLeave.
 *
 *                              最佳实践:[UT pageLeave:@"Welcome" args:[NSDictionary dictionaryWithObjectsAndKeys:@"v1",@"k1",@"v2",@"k2",nil]],不能出现非字母之外的字符,每个单词的首字母都大写,最好不要出现Page,Controller,View等关键词
 *
 *                              最佳位置:页面的viewWillDisappear中,自定义的页面框架除外
 *
 *
 */
+(void) pageLeave:(NSObject *) pageName args:(NSDictionary *) dict;

/**
 * @brief                       统计控件点击.
 *
 * @param          controlName  控件名称
 *
 * @warning                     *Important:* 埋点所在的页面必须埋点pageEnter,自动页面埋点除外
 *
 *                              最佳建议:页面中的元素尽量全部打点,提高统计精度
 *
 *                              调用顺序:preInit->init->ctrlClicked.
 *
 *                              最佳实践:[UT ctrlClicked:@"Buy"];控件名称必须是全英文,每个单词的首字母大写,建议不包含button,list,listitem等控件相关的名称
 *
 *                              最佳位置:页面中
 *
 *
 */
+(void) ctrlClicked:(NSString *)controlName;

/*! DEPRECATED */
+(void) ctrlClicked:(NSString *)controlName onPage:(NSObject *) pageName;

/**
 * @brief                       控件点击的扩展版本.
 *
 * @param          controlName  控件名称
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 点所在的页面必须埋点pageEnter,自动页面埋点除外
 *
 *                              最佳建议:页面中的元素尽量全部打点,提高统计精度
 *
 *                              调用说明:dict中的参数反映在我们采集数据的args字段中,每个参数对用','分隔.
 *
 *                              调用顺序:preInit->init->ctrlClicked.
 *
 *                              最佳实践:[UT ctrlClicked:@"Buy" args:[NSDictionary dictionaryWithObjectsAndKeys:@"yes",@"check",nil]];控件名称必须是全英文,每个单词的首字母大写,建议不包含button,list,listitem等控件相关的名称
 *
 *                              最佳位置:页面中
 *
 *
 */
+(void) ctrlClicked:(NSString *)controlName args:(NSDictionary *) dict;
/*! DEPRECATED */
+(void) ctrlClicked:(NSString *)controlName onPage:(NSObject *) pageName args:(NSDictionary *) dict;

/**
 * @brief                       统计列表项选中.
 *
 * @param          controlName  控件名称
 *
 * @param          andIndex     选中的列表项索引
 *
 * @warning                     *Important:* 埋点所在的页面必须埋点pageEnter,自动页面埋点除外
 *
 *                              最佳建议:页面中的元素尽量全部打点,提高统计精度
 *
 *                              调用顺序:preInit->init->itemSelected.
 *
 *                              最佳实践:[UT itemSelected:@"Goods" andIndex:5];控件名称必须是全英文,每个单词的首字母大写,建议不包含button,list,listitem等控件相关的名称
 *
 *                              最佳位置:页面中
 *
 *
 */
+(void) itemSelected:(NSString *)controlName
            andIndex:(int) index;

/*! DEPRECATED */
+(void) itemSelected:(NSString *)controlName
              onPage:(NSObject *) pageName
            andIndex:(int) index;


/**
 * @brief                       控件列表项选中的扩展版本.
 *
 * @param          controlName  控件名称
 *
 * @param          andIndex     选中的列表项索引
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 埋点所在的页面必须埋点pageEnter,自动页面埋点除外
 *
 *                              最佳建议:页面中的元素尽量全部打点,提高统计精度
 *
 *                              调用说明:dict中的参数反映在我们采集数据的args字段中,每个参数对用','分隔.
 *
 *                              调用顺序:preInit->init->itemSelected.
 *
 *                              最佳实践:[UT itemSelected:@"Goods" andIndex:5 args:[NSDictionary dictionaryWithObjectsAndKeys:@"yes",@"itemSelected",nil]];控件名称必须是全英文,每个单词的首字母大写,建议不包含button,list,listitem等控件相关的名称
 *
 *                              最佳位置:页面中
 *
 *
 */
+(void) itemSelected:(NSString *)controlName
            andIndex:(int) index
                args:(NSDictionary *) dict;

/*! DEPRECATED */
+(void) itemSelected:(NSString *)controlName
              onPage:(NSObject *) pageName
            andIndex:(int) index
                args:(NSDictionary *) dict;

+(void) updatePageProperties:(NSObject *) pPageName properties:(NSDictionary *) pProperties;

/**
 * @brief                       强制上传,可以把当前打点的数据紧急上传.
 *
 * @warning                     *Important:* 紧急数据,需要提高上传率的,手工调用,这里提醒一下,会增加一次上传过程
 *
 *                              调用说明:当我们迫切希望当前埋点的数据紧急被上传,那么我们就需要使用这个接口,让埋点立即被上传.
 *
 *                              调用顺序:preInit->init->forceUpload.
 *
 *                              最佳位置:紧急数据埋点之后
 *
 *
 */
+(void) forceUpload;

/**
 * @brief                       统计GPS信息.
 *
 * @param          pageName     GPS采集的页面,和pageEnter里说明的规范一致
 *
 * @param          longitude    经度
 *
 * @param          latitude     纬度
 *
 * @warning                     *Important:* 有采集,就务必调用本接口
 *
 *                              调用说明:在使用客户端的时候,很多应用会采集用户的经纬度信息.
 *
 *                              调用顺序:preInit->init->updateGPSInfo.
 *
 *                              最佳位置:获取经纬度之后
 *
 *
 */
+(void) updateGPSInfo:(NSString *) pageName
            longitude:(double) longitude
             latitude:(double) latitude;

/**
 * @brief                       统计GPS信息的扩展版本.
 *
 * @param          pageName     GPS采集的页面,和pageEnter里说明的规范一致
 *
 * @param          longitude    经度
 *
 * @param          latitude     纬度
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 有采集,就务必调用本接口
 *
 *                              调用说明:在使用客户端的时候,很多应用会采集用户的经纬度信息.
 *
 *                              调用顺序:preInit->init->updateGPSInfo.
 *
 *                              最佳位置:获取经纬度之后
 *
 *
 */
+(void) updateGPSInfo:(NSString *) pageName
            longitude:(double)longitude
             latitude:(double) latitude
                 args:(NSDictionary *) dict;




//=====================================进阶：Push效果统计=====================================

/**
 * @brief                       统计Push消息到达客户端.
 *
 * @param          pushName     Push名称
 *
 * @warning                     *Important:* 客户端内有自己的Push体系,务必埋点
 *
 *                              调用说明:这个消息到达指客户端程序收到线上推送的消息.走ios的push通道,这个方法不需要使用.
 *
 *                              调用顺序:preInit->init->pushArrive.
 *
 *                              最佳位置:客户端程序收到Push通知
 *
 *
 */
+(void) pushArrive:(NSString *) pushName;

/**
 * @brief                       统计Push消息到达客户端.
 *
 * @param          pushName     Push名称
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 客户端内有自己的Push体系,务必埋点
 *
 *                              调用说明:这个消息到达指客户端程序收到线上推送的消息.走ios的push通道,这个方法不需要使用.
 *
 *                              调用顺序:preInit->init->pushArrive.
 *
 *                              最佳位置:客户端程序收到Push通知
 *
 *
 */
+(void) pushArrive:(NSString *) pushName args:(NSDictionary *) dict;

/**
 * @brief                       统计Push消息被展现.
 *
 * @param          pushName     Push名称
 *
 * @warning                     *Important:* 客户端内有自己的Push体系,务必埋点
 *
 *                              调用说明:Push消息展现在某个地方,让用户看到.走ios的push通道,这个方法不需要使用.
 *
 *                              调用顺序:preInit->init->pushDisplay.
 *
 *                              最佳位置:客户端要做展现操作的时候
 *
 *
 */
+(void) pushDisplay:(NSString *) pushName;

/**
 * @brief                       统计Push消息被展现.
 *
 * @param          pushName     Push名称
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 客户端内有自己的Push体系,务必埋点
 *
 *                              调用说明:Push消息展现在某个地方,让用户看到.走ios的push通道,这个方法不需要使用.
 *
 *                              调用顺序:preInit->init->pushDisplay.
 *
 *                              最佳位置:客户端要做展现操作的时候
 *
 *
 */
+(void) pushDisplay:(NSString *) pushName args:(NSDictionary *) dict;

/**
 * @brief                       统计Push消息点击.
 *
 * @param          pushName     Push名称
 *
 * @warning                     *Important:* 客户端内有自己的Push体系,务必埋点
 *
 *                              调用说明:Push消息在展现被用户看到之后,接着被点击了.
 *
 *                              调用顺序:preInit->init->pushView.
 *
 *                              最佳位置:Push内容被点击之后
 *
 *
 */
+(void) pushView:(NSString *) pushName;

/**
 * @brief                       统计Push消息点击.
 *
 * @param          pushName     Push名称
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     *Important:* 客户端内有自己的Push体系,务必埋点
 *
 *                              调用说明:Push消息在展现被用户看到之后,接着被点击了.
 *
 *                              调用顺序:preInit->init->pushView.
 *
 *                              最佳位置:Push内容被点击之后
 *
 *
 */
+(void) pushView:(NSString *) pushName args:(NSDictionary *) dict;

/**
 * @brief                       统计关键词搜索.
 *
 * @param          keywork      关键词
 *
 * @param          underCategory 关键词所属的分类
 *
 * @warning                     调用说明:如进入了搜索页面,点击搜索按钮搜索了某个关键词.
 *
 *                              调用顺序:preInit->init->searchKeyword.
 *
 *                              最佳位置:搜索关键词之后
 *
 *
 */
+(void) searchKeyword:(NSString *) keyword underCategory:(NSString *) category;

/**
 * @brief                       统计关键词搜索扩张版本.
 *
 * @param          keywork      关键词
 *
 * @param          underCategory 关键词所属的分类
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:如进入了搜索页面,点击搜索按钮搜索了某个关键词.
 *
 *                              调用顺序:preInit->init->searchKeyword.
 *
 *                              最佳位置:搜索关键词之后
 *
 *
 */
+(void) searchKeyword:(NSString *) keyword underCategory:(NSString *) category args:(NSDictionary *) dict;

/**
 * @brief                       统计内容分享.
 *
 * @param          content      分享内容
 *
 * @param          underCategory 内容所属的分类
 *
 * @warning                     调用说明:如新浪微博分享.
 *
 *                              调用顺序:preInit->init->share.
 *
 *                              最佳位置:分享之后
 *
 *
 */
+(void) share:(NSString *) content underCategory:(NSString *) category;

/**
 * @brief                       统计内容分享.
 *
 * @param          content      分享内容
 *
 * @param          underCategory 内容所属的分类
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:如新浪微博分享.
 *
 *                              调用顺序:preInit->init->share.
 *
 *                              最佳位置:分享之后
 *
 *
 */

+(void) share:(NSString *) content underCategory:(NSString *) category args:(NSDictionary *) dict;




//=====================================高级：Native与WebView相结合=====================================

/**
 * @brief                       更新UTSID到Cookie,调用接口之后,能够把url对应的页面数据和本地数据关联起来.
 *
 * @param          url          需要种植utsid的url地址.
 *
 * @warning                     调用说明:我们在进行Native与Webview数据进行交叉统计的时候,需要有一个关联的主键,就是utsid.
 *
 *                              调用顺序:preInit->init->updateUTSIDToCookie.
 *
 *                              最佳位置:打开Webview的时候,在request之前
 *
 *
 */
+(void) updateUTSIDToCookie:(NSString *) url;

/**
 * @brief                       更新业务内容到Cookie,调用之后,能够把业务参数携带到url对应的页面的cookie中去.
 *
 * @param          url          需要种植utkey的Url
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:更新业务到Cookie中去,字段为utkey,内容为urlEncode(业务Key)=urlEncode(业务内容),urlEncode(业务Key2)=urlEncode(业务内容2)....
 *
 *                              调用顺序:preInit->init->updateUTCookie.
 *
 *                              最佳实践:[UT updateUTCookie:@"http://www.google.com" dict:[NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"key1",@"value2",@"key2",nil]];
 *
 *                              最佳位置:打开Webview的时候,在request之前
 *
 */
+(void) updateUTCookie:(NSString *) url dict:(NSDictionary *) dict;




//=====================================高级：交易相关=====================================

/**
 * @brief                       统计交易.
 *
 * @param          orderID      订单ID
 *
 * @warning                     调用说明:在交易下单的时候,我们需要把生成的订单号,我们需要通过这个接口去记录.
 *
 *                              调用顺序:preInit->init->trade.
 *
 *                              最佳位置:交易下单生成订单ID之后
 *
 *
 */
+(void) trade:(NSString *) orderID;

/**
 * @brief                       统计交易.
 *
 * @param          orderID      订单ID
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:在交易下单的时候,我们需要把生成的订单号,我们需要通过这个接口去记录.
 *
 *                              调用顺序:preInit->init->trade.
 *
 *                              最佳位置:交易下单生成订单ID之后
 *
 *
 */
+(void) trade:(NSString *) orderID args:(NSDictionary *) dict;




//=====================================高级：自定义埋点=====================================

/**
 * @brief                       普通自定义埋点.
 *
 * @param          eventId      事件ID，使用前，需要在我们的网站去登记
 *
 * @param          dict         事件携带的属性
 *
 * @warning                     调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(NSString *) eventId dict:(NSDictionary *) pDict;

/**
 * @brief                       时长自定义埋点[开始].
 *
 * @param          eventId      事件ID，使用前，需要在我们的网站去登记，开始和结束必须使用相同的EventID
 *
 * @param          dict         事件携带的属性
 *
 * @warning                     时长统计的EventID必须有且仅有一个路径，也就是全局只能用一次，并且不能把时长和普通的混用
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEventBegin:(NSString *) eventId dict:(NSDictionary *) pDict;

/**
 * @brief                       时长自定义埋点[结束].
 *
 * @param          eventId      事件ID，使用前，需要在我们的网站去登记，开始和结束必须使用相同的EventID。
 *
 * @param          dict         事件携带的属性
 *
 * @warning                     时长统计的Event必须有且仅有一个路径，也就是全局只能用一次，并且不能把时长和普通的混用
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEventEnd:(NSString *) eventId dict:(NSDictionary *) pDict;


/**
 * @brief                       自定义埋点(DEPRECATED).
 *
 * @param          eventId      行为ID,若需要使用,需要和我们沟通
 *
 * @warning                     调用说明:我们可以自主的控制埋点的格式以及内容,eventId这个参数对应行为记录的eventid.
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(int)eventId;/*! DEPRECATED */

/**
 * @brief                       自定义埋点(DEPRECATED).
 *
 * @param          eventId      行为ID,若需要使用,需要和我们沟通
 *
 * @param          arg1         参数1
 *
 * @warning                     调用说明:我们可以自主的控制埋点的格式以及内容,eventId这个参数对应行为记录的eventid,arg1对应行为记录的arg1.
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1;/*! DEPRECATED */

/**
 * @brief                       自定义埋点(DEPRECATED).
 *
 * @param          eventId      行为ID,若需要使用,需要和我们沟通
 *
 * @param          arg1         参数1
 *
 * @param          arg2         参数2
 *
 * @warning                     调用说明:我们可以自主的控制埋点的格式以及内容,eventId这个参数对应行为记录的eventid,arg1对应行为记录的arg1,依次类推.
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2;/*! DEPRECATED */

/**
 * @brief                       自定义埋点(DEPRECATED).
 *
 * @param          eventId      行为ID,若需要使用,需要和我们沟通
 *
 * @param          arg1         参数1
 *
 * @param          arg2         参数2
 *
 * @param          arg3         参数3
 *
 * @warning                     调用说明:我们可以自主的控制埋点的格式以及内容,eventId这个参数对应行为记录的eventid,arg1对应行为记录的arg1,依次类推.
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3;/*! DEPRECATED */

/**
 * @brief                       自定义埋点(DEPRECATED).
 *
 * @param          eventId      行为ID,若需要使用,需要和我们沟通
 *
 * @param          arg1         参数1
 *
 * @param          arg2         参数2
 *
 * @param          arg3         参数3
 *
 * @param          args         参数s
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:我们可以自主的控制埋点的格式以及内容,eventId这个参数对应行为记录的eventid,arg1对应行为记录的arg1,依次类推.
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3 args:(NSDictionary *) dict;/*! DEPRECATED */


+ (void)commitEvent:(NSObject *)page
            eventID:(int)eventID
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *) dict;/*! DEPRECATED */




//=====================================其它=====================================

/**
 * @brief                       获取SDK生成的设备唯一标识.
 *
 * @warning                     调用说明:这个设备唯一标识是持久的,并且格式安全,iOS6以及以下,多应用互通.
 *
 *                              调用顺序:utdid任意时刻都可以调用.
 *
 * @return                      24字节的设备唯一标识.
 */
+(NSString *) utdid;

/**
 * @brief                       获取SDK生成的会话ID.
 *
 * @warning                     调用说明:SDK初始化完成之后,会分配一个唯一的会话ID.
 *
 *                              调用顺序:SDK 异步init完成之后.
 *
 *
 * @return                      格式:"utdid_appkey_timestamp".
 */
+(NSString *) utsid;

// 开启安全黑匣子支持
+(void) turnOnSecuritySDKSupport;


@end
