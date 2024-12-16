import Flutter
import UIKit

public class SwiftFlutterAlibcPlugin: NSObject, FlutterPlugin {
    
    var alibchandler : FlutterAlibcHandle? = nil;
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_alibc", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAlibcPlugin()
        instance.alibchandler = FlutterAlibcHandle(channel: channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // result("iOS " + UIDevice.current.systemVersion)
        if call.method == "getPlatformVersion"{
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "initAlibc"{
            alibchandler?.initAlibc(call: call, result: result)
        } else if call.method == "loginTaoBao" {
            alibchandler?.loginTaoBao(call: call, result: result)
        } else if call.method == "taoKeLogin" {
            alibchandler?.openByAsyncWebView(call: call, result: result, callBackString: FlutterAlibcConstKey.CallBackString.AlibcTaokeLogin.rawValue)
        } else if call.method == "loginOut" {
            alibchandler?.loginOut(call: call, result: result)
        } else if call.method == "taoKeLoginForCode" {
            alibchandler?.openByAsyncWebView(call: call, result: result, callBackString: FlutterAlibcConstKey.CallBackString.AlibcTaokeLoginForCode.rawValue)
        } else if call.method == "openByUrl" {
            alibchandler?.openByUrl(call: call, result: result, callBackString: FlutterAlibcConstKey.CallBackString.AlibcOpenURL.rawValue)
        } else if call.method == "openItemDetail"{
            alibchandler?.openItemDetail(call: call, result: result, callBackString: FlutterAlibcConstKey.CallBackString.AlibcOpenDetail.rawValue)
        } else if call.method == "openShop"{
            alibchandler?.openShop(call: call, result: result, callBackString: FlutterAlibcConstKey.CallBackString.AlibcOpenShop.rawValue)
        } else if call.method == "openCart"{
            alibchandler?.openCart(call: call, result: result, callBackString: FlutterAlibcConstKey.CallBackString.AlibcOpenCar.rawValue)
        } else if call.method == "syncForTaoke"{
            alibchandler?.syncForTaoke(call: call, result: result)
        } else if call.method == "useAlipayNative"{
            alibchandler?.useAlipayNative(call: call, result: result)
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
    //    MARK:- 百川处理应用跳转
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        if !(AlibcTradeSDK.sharedInstance()?.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation))! {
            return true
        }
        return false
    }
    //IOS9.0 系统新的处理openURL 的API
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if #available(iOS 9.0, *) {
            var op : [String : Any] = [:];
            for (key,value) in options {
                op[key.rawValue] = value
            }
            
            //          转换
            let isHandledByALBBSDK : Bool = (AlibcTradeSDK.sharedInstance()?.application(application, open: url, options: op))!;
            
            //            let isHandledByALBBSDK : Bool = (AlibcTradeSDK.sharedInstance()?.application(application, open: url, options:[:]))!
            
            return isHandledByALBBSDK
        } else {
            // Fallback on earlier versions
            //处理其他app跳转到自己的app，如果百川处理过会返回YES
        }
        
        return false
    }
}
