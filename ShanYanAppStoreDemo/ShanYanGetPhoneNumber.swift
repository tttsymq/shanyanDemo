//
//  ShanYanGetPhoneNumber.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/13.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoSwift
import CocoaSecurity

//一键登录置换手机号示例接口
let cl_SDK_URL_MobileQuery = "https://api.253.com/open/flashsdk/mobile-query"
//本机校验验证手机号示例接口
let cl_SDK_URL_MobileValidate = "https://api.253.com/open/flashsdk/mobile-validate"

public protocol ShanYanCallBack {
    func success(code: Int? , massage: String? , data:Dictionary<String, Any>? , phonenumber: String? ,telecom: String?)
    func failure( code: Int? , massage: String? , data:Dictionary<String, Any>? , error: Error?)
}

class ShanYanGetPhoneNumber: NSObject {
    
//
    class func getPhonenumber(token: Dictionary<String, Any>? , callBack: ShanYanCallBack?) {
        
        guard token?.isEmpty == false else {
            if let callBack = callBack {
                callBack.failure(code: -9999, massage: "token为空,请先拉起授权页并点击一键登录", data: nil, error: nil)
            }
            return
        }
        
        var paramr : Dictionary<String, Any> = Dictionary()
        paramr["appId"] = appID
        for (key,value) in token! {
            paramr[key] = value
        }

        let sortedKeys = paramr.keys.sorted { (obj1, obj2) -> Bool in
            return obj1.compare(obj2) == ComparisonResult.orderedAscending
        }
        var formDataString = String()
        for key in sortedKeys {
            formDataString.append(key)
            formDataString.append(paramr[key] as! String)
        }
                
//        paramr["sign"] = try! HMAC(key: appKey, variant: .sha256).authenticate(formDataString.bytes).toHexString();
        let hmacSha256Result = CocoaSecurity.hmacSha256(formDataString, hmacKey: appKey)
        paramr["sign"] = hmacSha256Result?.hex
        
        
        Alamofire.request(cl_SDK_URL_MobileQuery, method: .post, parameters: paramr, encoding: URLEncoding(), headers: nil).responseJSON { response in
            debugPrint(response)
            
            let json =  try? JSON(data: response.data!)
            let message = json?["message"].string
            let code = json?["code"].int
            let data = json?["data"].dictionaryObject
            
            if let mobileName = json?["data"]["mobileName"].string{
                let appKey_md5_result = CocoaSecurity.md5(appKey)
                let appKey_md5 = appKey_md5_result?.hexLower
                if (appKey_md5?.count == 32) {
                            
                    let key = appKey_md5?.prefix(16)
                    let iv = appKey_md5?.suffix(16)
                            
                    let decoder = CocoaSecurityDecoder()
                    
                    let aes256Decrypt = CocoaSecurity.aesDecrypt(with: decoder.hex(mobileName),key: key?.data(using:.utf8),iv: iv?.data(using:.utf8))
                
                    if let aes256Decrypt = aes256Decrypt {
                        if let callBack = callBack {
                            let mobileCode = aes256Decrypt.utf8String
                            callBack.success(code: code, massage: message, data: data, phonenumber: mobileCode,telecom: "")
                            return
                        }
                    }
                }
            }
            if let callBack = callBack {
                callBack.failure(code: code, massage: "置换手机号失败", data: data, error: nil)
            }
            
        }
    }
    
    
    class func checkPhonenumber(token: Dictionary<String, Any>? , callBack: ShanYanCallBack?){
        guard token?.isEmpty == false else {
            if let callBack = callBack {
                callBack.failure(code: -9999, massage: "token为空,请重新点击本机号码一键认证", data: nil, error: nil)
            }
            return
        }
        
        var paramr : Dictionary<String, Any> = Dictionary()
        paramr["appId"] = appID
        for (key,value) in token! {
            paramr[key] = value
        }

        let sortedKeys = paramr.keys.sorted { (obj1, obj2) -> Bool in
            return obj1.compare(obj2) == ComparisonResult.orderedAscending
        }
        var formDataString = String()
        for key in sortedKeys {
            formDataString.append(key)
            formDataString.append(paramr[key] as! String)
        }
                
    //        paramr["sign"] = try! HMAC(key: appKey, variant: .sha256).authenticate(formDataString.bytes).toHexString();
        let hmacSha256Result = CocoaSecurity.hmacSha256(formDataString, hmacKey: appKey)
        paramr["sign"] = hmacSha256Result?.hex
        
        Alamofire.request(cl_SDK_URL_MobileValidate, method: .post, parameters: paramr, encoding: URLEncoding(), headers: nil).responseJSON { response in
            debugPrint(response)
            
            let json =  try? JSON(data: response.data!)
            let message = json?["message"].string
            let code = json?["code"].int
            let data = json?["data"].dictionaryObject
            
            if let isVerify = json?["data"]["isVerify"].string{
                if isVerify == "1" {
                    if let callBack = callBack {
                        callBack.success(code: code, massage: message, data: data, phonenumber: nil,telecom: "")
                        return
                    }
                }else{
                    if let callBack = callBack {
                        callBack.failure(code: code, massage: "校验手机号失败,号码不一致", data: data, error: nil)
                        return
                    }
                }
            }
            if let callBack = callBack {
                callBack.failure(code: code, massage: "校验手机号失败", data: data, error: nil)
            }
        }
    }
}
