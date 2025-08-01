//
//  ShanYanNetworkStatusTool.h
//  ShanYanAppStoreDemo
//
//  Created by KevinChien on 2020/4/8.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface ShanYanNetworkStatusTool : NSObject
/// 是否存在蜂窝网络检测
+ (BOOL)cellularMobileNetworkStatus;

/// 是否存在WLAN
+ (BOOL)wifiStatus;

/// 当前蜂窝网络 名称
+ (NSString*)currentCellularMobileNetworkName;

@end

NS_ASSUME_NONNULL_END
