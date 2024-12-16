# CL_ShanYanSDK

[![CI Status](https://img.shields.io/travis/wanglijun311@gmail.com/CL_ShanYanSDK.svg?style=flat)](https://travis-ci.org/wanglijun311@gmail.com/CL_ShanYanSDK)
[![Version](https://img.shields.io/cocoapods/v/CL_ShanYanSDK.svg?style=flat)](https://cocoapods.org/pods/CL_ShanYanSDK)
[![License](https://img.shields.io/cocoapods/l/CL_ShanYanSDK.svg?style=flat)](https://cocoapods.org/pods/CL_ShanYanSDK)
[![Platform](https://img.shields.io/cocoapods/p/CL_ShanYanSDK.svg?style=flat)](https://cocoapods.org/pods/CL_ShanYanSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
http://flash.253.com

## Requirements

## Installation

CL_ShanYanSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CL_ShanYanSDK' , '~> 2.3.6.5'
```

## 接入文档以官网http://flash.253.com 为准

## 1.初始化

方法原型

```objectivec
/**初始化*/
+(void)initWithAppId:(NSString *)appId complete:(nullable CLComplete)complete;
```

从2.3.0开始，前端不再需要appKey

**接口作用**<br />**<br />初始化SDK :传入用户的appID,获取本机运营商,读取缓存,获取运营商配置,初始化SDK

**使用场景**<br />**

- 建议在app启动时调用
- 必须在一键登录前至少调用一次
- 只需调用一次，多次调用不会多次初始化，与一次调用效果一致

**请求示例代码**<br />**<br />**ObjC**:

1. 导入闪验SDK头文件 `#import <CL_ShanYanSDK/CL_ShanYanSDK.h>`
1. 在AppDelegate中的 `didFinishLaunchingWithOptions`方法中添加初始化代码
```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
     //初始化
     [CLShanYanSDKManager initWithAppId:cl_SDK_APPID complete:nil];
    ...
}
```

**Swift**:

1. 创建混编桥接头文件并导入闪验SDK头文件 `#import <CL_ShanYanSDK/CL_ShanYanSDK.h>`
1. 在AppDelegate中的 `didFinishLaunchingWithOptions`方法中添加初始化代码

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	// 建议先检测APP登录状态，未登录再使用闪验
   ...
   //初始化        
   CLShanYanSDKManager.initWithAppId("your appID")
   ...
}
```

<a name="zWeon"></a>
## 2.预取号

方法原型

```objectivec
/**
 * 预取号（获取临时凭证）
 * 建议在判断当前用户属于未登录状态时使用，已登录状态用户请不要调用该方法
 */
+(void)preGetPhonenumber:(nullable CLComplete)complete;
```

**接口作用**

**电信、联通、移动预取号** :初始化成功后，如果当前为电信/联通/移动，将调用预取号，可以提前获知当前用户的手机网络环境是否符合一键登录的使用条件，成功后将得到用于一键登录使用的临时凭证，默认的凭证有效期60s(电信)/30min(联通)/60min(移动)。

**使用场景**

- 建议在执行一键登录的方法前，提前一段时间调用此方法，比如调一键登录的vc的viewdidload中，或者rootVC的viewdidload中，或者app启动后，此调用将有助于提高闪验拉起授权页的速度和成功率
- 不建议调用后立即调用拉起授权页方法（此方法是异步）
- 此方法需要1~2s的时间取得临时凭证，因此也不建议和拉起授权页方法一起串行调用
- 不建议频繁的多次调用和在拉起授权页后调用
- **建议在判断当前用户属于未登录状态时使用，已登录状态用户请不要调用该方法**

**请求示例代码**<br />**<br />**ObjC**:

```objectivec
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
//开发者调拉起授权页的vc
@implementation CustomLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (YourAppLoginStatus == NO) {
        //预取号
        [CLShanYanSDKManager preGetPhonenumber:nil];
        ...
    }
}
...
//拉起授权页
- (void)shanYanAuthPageLogin{
    ...
}
```

<a name="wCSyi"></a>
## 3.拉起授权页

**在预取号成功后调用**，预取号失败不建议调用。调用拉起授权页方法后将会调起运营商授权页面。该方法会拉起登录界面，**已登录状态请勿调用 。**<br />**
```objectivec
//闪验一键登录接口
+(void)quickAuthLoginWithConfigure:(CLUIConfigure *)clUIConfigure
                           timeOut:(NSTimeInterval)timeOut
               shanyanAuthPageListener:(CLComplete)shanyanAuthPageListener
                          complete:(CLComplete)complete;
```

使用场景

- 用户进行一键登录操作时，调用一键登录方法，如果初始化成功，SDK将会拉起授权页面，用户授权后，SDK将返回取号 token给到应用客户端。
- 可以在多处调用
- 需在调用预初始化方法之后调用

一键登录逻辑说明

- 存在调用预初始化时获取的临时凭证，调用一键登录方法将立即拉起授权页面
- shanyanAuthPageListener 拉起授权页监听回调
- 不存在临时凭证或临时凭证过期时(临时凭证有效期电信10min、联通60min、移动60min)，调用一键登录方法，将有一个很短的时延，待取号成功后拉起授权页面
- 取号失败时，返回失败 

请求示例代码

**ObjC**:

1. 导入闪验SDK头文件 `#import <CL_ShanYanSDK/CL_ShanYanSDK.h>`
1. 在需要使用一键登录的地方调用闪验一键登录接口
```objectivec
// 用户需要使用闪验一键登录时的方法
- (void)quickLoginBtnClick:(UIButton *)sender {

    __weak typeof(self) weakself = self;

    CGFloat screenScale = [UIScreen mainScreen].bounds.size.width/375.0;

    CLUIConfigure * baseUIConfigure = [CLUIConfigure new];
    baseUIConfigure.viewController = self;
    baseUIConfigure.clLogoImage = [UIImage imageNamed:@"your_app_logo_image"];
    //开发者自己的loading（注意后面loading的隐藏时机）
    [SVProgressHUD setContainerView:self.view];
    [SVProgressHUD show];

    //闪验一键登录接口（将拉起授权页）
	[CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure timeOut:4 shanyanAuthPageListener:^(CLCompleteResult * _Nonnull completeResult) {
        NSLog(@"拉起授权页");
    } complete:^(CLCompleteResult * _Nonnull completeResult) {
        [SVProgressHUD dismiss];
		if (completeResult.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeResult.code == 1011){
                    //用户取消登录（点返回）
                    //处理建议：如无特殊需求可不做处理，仅作为状态回调，此时已经回到当前用户自己的页面
                    [SVProgressHUD showInfoWithStatus: @"用户取消免密登录"];
                }else{
                    //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                    if (completeResult.code == 1009){
                        // 无SIM卡
                        [SVProgressHUD showInfoWithStatus:@"未能识别SIM卡"];
                    }else if (completeResult.code == 1008){
                        [SVProgressHUD showInfoWithStatus:@"请打开蜂窝移动网络"];
                    }else {
                        // 跳转验证码页面
                        [SVProgressHUD showInfoWithStatus: @"网络状况不稳定，切换至验证码登录"];
                    }
                }
            });
        }else{
			//SDK成功获取到Token
          	/** token置换手机号
            code
            */
        }
    }];  
 }
```

**Swift**:
```swift
// 用户需要使用闪验一键登录时的方法
@IBAction func quickLogin(_ sender: UIButton) {

    //定制界面
    let baseUIConfigure = CLUIConfigure()
    //requried
    baseUIConfigure.viewController = self
    baseUIConfigure.clLogoImage = UIImage.named("your_app_logo_image");

    //开发者自己的loading
    SVProgressHUD.setContainerView(self.view)
    SVProgressHUD.show()

    CLShanYanSDKManager.quickAuthLogin(with: clUIConfigure, timeOut: 4, shanyanAuthListener: { (completeResult) in
        print("拉起授权页")
    }) { (completeResult) in 
		SVProgressHUD.dismiss()
        if completeResult.error != nil {
            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式

            DispatchQueue.main.async(execute: {
                if completeResult.code == 1011 {
                    // 用户取消登录
                    //处理建议：如无特殊需求可不做处理，仅作为状态回调，此时已经回到当前用户自己的页面
                    SVProgressHUD.showInfo(withStatus: "用户取消免密登录")
                }else{
                    //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                    if completeResult.code == 1009{
                        // 无SIM卡
                        SVProgressHUD.showInfo(withStatus: "此手机无SIM卡")
                    }else if completeResult.code == 1008{
                        SVProgressHUD.showInfo(withStatus: "请打开蜂窝移动网络")
                    }else {
                        // 跳转验证码页面 
                        SVProgressHUD.showInfo(withStatus: "网络状况不稳定，切换至验证码登录")
                    }
                }
            })
        }else{
          //SDK成功获取到Token
          	
          	/** token置换手机号
            code
            */
          
            NSLog("quickAuthLogin Success:%@",completeResult.data ?? "")

            //urlStr:用户后台对接闪验后台后配置的API，以下为Demo提供的调试API及调用示例，在调试阶段可暂时调用此API，也可用此API验证后台API是否正确配置
            var urlStr : String?
            let APIString = "https://api.253.com/"

            if let telecom = completeResult.data?["telecom"] as! String?{
                switch telecom {
                case "CMCC":
                    urlStr = APIString.appendingFormat("open/flashsdk/mobile-query-m")
                    break
                case "CUCC":
                    urlStr = APIString.appendingFormat("open/flashsdk/mobile-query-u")
                    break
                case "CTCC":
                    urlStr = APIString.appendingFormat("open/flashsdk/mobile-query-t")
                    break
                default:
                    break
                }
            }

            if let urlStr = urlStr{
                let dataDict = completeResult.data as! Parameters

                Alamofire.request(urlStr, method:.post, parameters:dataDict, encoding:URLEncoding.default, headers:[:]).responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        if let json = response.result.value{
                            let jsonDict = JSON(json)
                            if jsonDict["code"].intValue == 200000{
                                let mobileName = jsonDict["data"]["mobileName"].stringValue
                                let mobileCode = StringDecryptUseDES.decryptUseDESString(mobileName, key: "tDo3Ml2K")//appKey
                                DispatchQueue.main.async(execute: {
                                    SVProgressHUD.showSuccess(withStatus: ("免密登录成功,手机号：\(mobileCode)"))
                                })
                                print(("免密登录成功,手机号：\(mobileCode)"))
                                return;
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        SVProgressHUD.showInfo(withStatus: ("免密登录失败：\(response.description)"))
                        print(("免密登录失败：\(response.description)"))
                    })
                })
            }
        }
    }
}
```
## Author

app@253.com

## License

CL_ShanYanSDK is available under the MIT license. See the LICENSE file for more info.
