//
//  PlayerView.m
//  ShanYanSDK_Demo
//
//  Created by 陈玉乐 on 2020/11/30.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVPlayerLayer.h>

@implementation PlayerView

+(Class)layerClass{

    return [AVPlayerLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
