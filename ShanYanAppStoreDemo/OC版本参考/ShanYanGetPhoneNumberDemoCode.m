//
//  ShanYanGetPhoneNumberDemoCode.m
//  ShanYanSDK_Demo
//
//  Created by wanglijun on 2020/5/27.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import "ShanYanGetPhoneNumberDemoCode.h"
#import <CocoaSecurity.h>
#import <AFNetworking.h>
#import <NSObject+YYModel.h>
@implementation ShanYanGetPhoneNumberDemoCode

#define cl_SDK_APPID  @"<#appid#>" //2.3.0开始，前端不需要appKey
#define cl_SDK_APPKEY @"<#appKey#>"//实际情景下appKey保存在客户服务端。由于Demo在获取token成功后，模拟客户服务端调用置换手机号，因此需要此appKey
#define cl_SDK_URL_MobileQuery   @"https://api.253.com/open/flashsdk/mobile-query"//Demo测试置换手机号接口
#define cl_SDK_URL_MobileValidate   @"https://api.253.com/open/flashsdk/mobile-validate"//Demo测试本机号校验接口


//一键登录token置换手机号示例
//此处模拟客户服务端调用闪验服务端，依照闪验服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)getPhonenumber:(NSDictionary *)completeResultData completion:(nullable void (^)(NSString *phoneNumber, id  _Nullable responseObject, NSError * _Nullable error))completion{

//    NSLog(@"tokenParamr:%@",completeResultData);
    
//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary * paramr = [NSMutableDictionary dictionaryWithDictionary:completeResultData];
    paramr[@"appId"] = cl_SDK_APPID;


    NSMutableString *formDataString = [NSMutableString new];
    NSArray * keys = [paramr.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * objString1 = [NSString stringWithFormat:@"%@",obj1];
        NSString * objString2 = [NSString stringWithFormat:@"%@",obj2];
        return [objString1 compare:objString2];
    }];
    for (NSString * key in keys) {
        [formDataString appendString:key];
        [formDataString appendString:paramr[key]];
    }

    CocoaSecurityResult * hmacSha256Result = [CocoaSecurity hmacSha256:formDataString hmacKey:cl_SDK_APPKEY];
    paramr[@"sign"] = hmacSha256Result.hex;

    NSLog(@"%@",paramr);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    [manager POST:cl_SDK_URL_MobileQuery parameters:paramr headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        if (code == 200000) {
            NSString * mobileName = responseObject[@"data"][@"mobileName"];
            CocoaSecurityResult * appKey_md5_result = [CocoaSecurity md5:cl_SDK_APPKEY];
            NSString * appKey_md5 = appKey_md5_result.hexLower;
            if (appKey_md5.length == 32) {

                NSString * key = [appKey_md5 substringToIndex:16];
                NSString * iv = [appKey_md5 substringFromIndex:16];

                CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
                CocoaSecurityResult *aes256Decrypt = [CocoaSecurity aesDecryptWithData:[decoder hex:mobileName] key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:[iv dataUsingEncoding:NSUTF8StringEncoding]];

                NSString * mobileCode = aes256Decrypt.utf8String;

                if (completion) {
                    completion(mobileCode,responseObject,nil);
                }
            }else {
                if (completion) {
                    completion(nil,responseObject,nil);
                }
            }
        } else {
            if (completion) {
                completion(nil,responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil,nil,error);
        }
    }];

}

//本机校验token验证手机号示例
//此处模拟客户服务端调用闪验服务端，依照闪验服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)validatePhonenumber:(NSString*)phoneNumberToCheck completeResultData:(NSDictionary *)completeResultData completion:(nullable void (^)(NSNumber * isValidated, id  _Nullable responseObject, NSError * _Nullable error))completion{

//    NSLog(@"tokenParamr:%@",completeResultData);
    
//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary * paramr = [NSMutableDictionary dictionaryWithDictionary:completeResultData];
    paramr[@"appId"] = cl_SDK_APPID;
    paramr[@"mobile"] = phoneNumberToCheck;


    NSMutableString *formDataString = [NSMutableString new];
    NSArray * keys = [paramr.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * objString1 = [NSString stringWithFormat:@"%@",obj1];
        NSString * objString2 = [NSString stringWithFormat:@"%@",obj2];
        return [objString1 compare:objString2];
    }];
    for (NSString * key in keys) {
        [formDataString appendString:key];
        [formDataString appendString:paramr[key]];
    }

    CocoaSecurityResult * hmacSha256Result = [CocoaSecurity hmacSha256:formDataString hmacKey:cl_SDK_APPKEY];
    paramr[@"sign"] = hmacSha256Result.hex;

    NSLog(@"%@",paramr);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:cl_SDK_URL_MobileValidate parameters:paramr headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        if (code == 200000) {
            if ([responseObject[@"data"][@"isVerify"] integerValue] == 1) {
                //本机校验成功，号码一致
                if (completion) {
                    completion(@(YES),responseObject,nil);
                }
            }else{
                //本机校验失败，号码不一致
                if (completion) {
                    completion(@(NO),responseObject,nil);
                }
            }
        }else{
            //本机校验失败
            if (completion) {
                completion(nil,responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil,nil,error);
        }
    }];

}
@end
