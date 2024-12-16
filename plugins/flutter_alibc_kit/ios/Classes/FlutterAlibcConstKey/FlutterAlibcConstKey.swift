//
//  FlutterAlibcConstKey.swift
//  flutter_alibc
//
//  Created by xing.wu on 2021/5/15.
//

import Foundation

struct FlutterAlibcConstKey {
    static let ErrorCode :String = "errorCode"
    static let ErrorMessage:String  = "errorMessage"
    static let Data: String = "data"
    //    随便定义一个数组，如果等于他就是空
    static let EmptyNum : NSNumber = NSNumber(integerLiteral: 5285)
    //    定义一些返回用的方法名
    enum CallBackString:String{
        case AlibcTaobaoLogin = "AlibcTaobaoLogin"
        case AlibcTaokeLogin = "AlibcTaokeLogin"
        case AlibcTaokeLoginForCode = "AlibcTaokeLoginForCode"
        case AlibcOpenURL = "AlibcOpenURL"
        case AlibcOpenCar = "AlibcOpenCar"
        case AlibcOpenDetail = "AlibcOpenDetail"
        case AlibcOpenShop = "AlibcOpenShop"
    }
}
