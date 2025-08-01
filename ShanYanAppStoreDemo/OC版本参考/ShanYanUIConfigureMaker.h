//
//  ShanYanUIConfigureMaker.h
//  ShanYanSDK_Demo
//
//  Created by wanglijun on 2020/7/30.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShanYanUIConfigureMaker : NSObject<CLShanYanSDKManagerDelegate>

+(instancetype)staticInstancetype;

//标准全屏样式
+(CLUIConfigure*)shanYanUIConfigureMakerStyle0;
//标准弹窗样式
+(CLUIConfigure*)shanYanUIConfigureMakerStyle1;

//弹窗+背景蒙版
//实现思路：以弹窗模式弹出，窗口大小设为全屏，将窗口背景设为蒙版色，再自定义一个授权页窗口背景view充当授权窗口，将控件放在窗口背景view中
+(CLUIConfigure*)shanYanUIConfigureMakerStyle2;
@end

NS_ASSUME_NONNULL_END
