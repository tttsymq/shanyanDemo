//
//  ShanYanGetPhoneNumberDemoCode.h
//  ShanYanSDK_Demo
//
//  Created by wanglijun on 2020/5/27.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShanYanGetPhoneNumberDemoCode : NSObject
//一键登录token置换手机号示例
//此处模拟客户服务端调用闪验服务端，依照闪验服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)getPhonenumber:(NSDictionary *)completeResultData completion:(nullable void (^)(NSString *phoneNumber, id  _Nullable responseObject, NSError * _Nonnull error))completion;

//本机校验token验证手机号示例
//此处模拟客户服务端调用闪验服务端，依照闪验服务端文档，实际情景下，app需要调用自己的服务端接口，将整个token传给服务端，整个token的验证在客户服务端进行，客户服务端将结果返回给app
+ (void)validatePhonenumber:(NSString*)phoneNumberToCheck completeResultData:(NSDictionary *)completeResultData completion:(nullable void (^)(NSNumber * isValidated, id  _Nullable responseObject, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
