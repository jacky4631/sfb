//
//  FlutterAlibcTools.swift
//  flutter_alibc
//
//  Created by xing.wu on 2021/5/15.
//

import Foundation

class FlutterAlibcTools: NSObject {
    class func isNil(_ string: String?) -> Bool {
        if string == nil {
            return true
        }

        if (string is NSNull) {
            return true
        }
        return (string?.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0) == 0
    }
    
    //  Converted to Swift 5.1 by Swiftify v5.1.33915 - https://objectivec2swift.com/
    class func dictionary(withJsonString jsonString: String?) -> [AnyHashable : Any]? {
        if jsonString == nil {
            return nil
        }

        let jsonData = jsonString?.data(using: .utf8)
        var err: Error?
        var dic: [AnyHashable : Any]? = nil
        do {
            if let jsonData = jsonData {
                dic = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [AnyHashable : Any]
            }
        } catch let err {
        }
        if err != nil {
            if let err = err {
                print("json解析失败：\(err)")
            }
            return nil
        }
        return dic
    }

    //  Converted to Swift 5.1 by Swiftify v5.1.33915 - https://objectivec2swift.com/
    class func null(toNil obj: Any?) -> Any? {
        if (obj is NSNull) {
            return nil
        }
        return obj
    }
    
    
    class func changeType(_ myObj: Any?) -> Any? {
        if (myObj is [AnyHashable : Any]) {
            return self.nullDic(myObj as? [AnyHashable : Any])
        } else if (myObj is [AnyHashable]) {
            return self.nullArr(myObj as? [AnyHashable])
        } else if (myObj is String) {
            return self.string(to: myObj as? String)
        } else if (myObj is NSNull) {
            return self.nullToString()
        } else {
            return myObj
        }
    }
//    ------------------------------//
    
    //  Converted to Swift 5.1 by Swiftify v5.1.33915 - https://objectivec2swift.com/
    
    //将NSDictionary中的Null类型的项目转化成@""
    class func nullDic(_ myDic: [AnyHashable : Any]?) -> [AnyHashable : Any]? {
        let keyArr = myDic?.keys
        var resDic: [AnyHashable : Any] = [:]
//        for i in 0..<(keyArr?.count ?? 0) {
//            var obj: Any? = nil
//            if let aKeyArr = keyArr?[i] {
//                obj = myDic?[aKeyArr]
//            }
//            obj = self.changeType(obj)
//            resDic[keyArr?[i]] = obj
//        }
        return resDic
    }

    //将NSArray中的Null类型的项目转化成@""
    class func nullArr(_ myArr: [AnyHashable]?) -> [AnyHashable]? {
        var resArr: [AnyHashable] = []
        for i in 0..<(myArr?.count ?? 0) {
            var obj = myArr?[i]
            obj = self.changeType(obj) as? AnyHashable
            if let obj = obj {
                resArr.append(obj)
            }
        }
        return resArr
    }

    //将NSString类型的原路返回
    class func string(to string: String?) -> String? {
        return string
    }

    //将Null类型的项目转化成@""
    class func nullToString() -> String? {
        //    return @"<NSNull>";
        return ""
    }


}


