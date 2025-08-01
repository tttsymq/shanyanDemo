//
//  TestViewController.m
//  ShanYanSDK_Demo
//
//  Created by wanglijun on 2019/6/28.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#import "TestViewController.h"
#import "PhoneNumberCheckController.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "ShanYanUIConfigureMaker.h"
#import "ShanYanGetPhoneNumberDemoCode.h"
#import <CLConsole/CLConsole.h>
#import <NSObject+YYModel.h>
#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface TestNavViewController ()
@end
@implementation TestNavViewController

@end

@interface TestViewController ()
@end

@implementation TestViewController

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    
    UIImageView * shanYanLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_flash253"]];
    shanYanLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:shanYanLogo];
    [shanYanLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(self.view).multipliedBy(0.35);
        make.centerY.mas_equalTo(-self.view.bounds.size.height*0.25);
    }];
    
    UIButton * openAuthAPI_CustomVC = [[UIButton alloc]init];
    openAuthAPI_CustomVC.layer.cornerRadius = 22.5;
    openAuthAPI_CustomVC.layer.masksToBounds = YES;
    [openAuthAPI_CustomVC setBackgroundColor:[UIColor colorWithRed:38/255.0 green:94/255.0 blue:250/255.0 alpha:1]];
    [openAuthAPI_CustomVC setTitle:@"拉起授权界面" forState:(UIControlStateNormal)];
    [openAuthAPI_CustomVC addTarget:self action:@selector(openAuthAPIClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:openAuthAPI_CustomVC];
    
    UIButton * localPhoneNumberCheckBtn = [[UIButton alloc]init];
    localPhoneNumberCheckBtn.layer.cornerRadius = 22.5;
    localPhoneNumberCheckBtn.layer.masksToBounds = YES;
    [localPhoneNumberCheckBtn setBackgroundColor:[UIColor colorWithRed:38/255.0 green:94/255.0 blue:250/255.0 alpha:1]];
    [localPhoneNumberCheckBtn setTitle:@"闪验本机认证" forState:(UIControlStateNormal)];
    [localPhoneNumberCheckBtn addTarget:self action:@selector(localPhoneNumberCheckBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:localPhoneNumberCheckBtn];


    [openAuthAPI_CustomVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(45);
    }];
    [localPhoneNumberCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(openAuthAPI_CustomVC);
        make.top.equalTo(openAuthAPI_CustomVC.mas_bottom).offset(30);
    }];
}

/// 展示授权页
-(void)openAuthAPIClick:(UIButton *)sender{
    //建议做防止快速点击
    [sender setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setEnabled:YES];
    });
    [SVProgressHUD show];
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

    __weak typeof(self) weakSelf = self;
    
    //    CLUIConfigure * baseUIConfigure = [CLUIConfigure clDefaultUIConfigure];//fast test

//    CLUIConfigure * baseUIConfigure;
//    NSInteger type_random = arc4random()%3;
//    if (type_random == 0) {
//        baseUIConfigure = [ShanYanUIConfigureMaker shanYanUIConfigureMakerStyle0];
//    }else if (type_random == 1){
//        baseUIConfigure = [ShanYanUIConfigureMaker shanYanUIConfigureMakerStyle1];
//    }else{
//        baseUIConfigure = [ShanYanUIConfigureMaker shanYanUIConfigureMakerStyle2];
//    }
////    baseUIConfigure = [ShanYanUIConfigureMaker shanYanUIConfigureMakerStyle0];
//
//    baseUIConfigure.viewController = self;
    
    static  int a =0;
    
    int i = a%7;

    NSString *st = [@"configureMake" stringByAppendingFormat:@"%d",i];

    CLUIConfigure * baseUIConfigure = [self performSelector:NSSelectorFromString(st)];

    a++;
    
    [CLShanYanSDKManager setCLShanYanSDKManagerDelegate:ShanYanUIConfigureMaker.staticInstancetype];
    
    [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

        //建议做防止快速点击
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [sender setEnabled:YES];
        });
        
        if (completeResult.error) {
            CLConsoleLog(@"openLoginAuthListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);
        }else{
            CLConsoleLog(@"openLoginAuthListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);
        }

    } oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {
        
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

        __strong typeof(self) strongSelf = weakSelf;
 
        if (completeResult.error) {
            CLConsoleLog(@"oneKeyLoginListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);
            
            
            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
            if (completeResult.code == 1011){
                //用户取消登录（点返回）
                //处理建议：如无特殊需求可不做处理，仅作为交互状态回调，此时已经回到当前用户自己的页面
                //点击sdk自带的返回，无论是否设置手动销毁，授权页面都会强制关闭
            }  else{
                //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                //1003    一键登录获取token失败
                //其他     其他错误//
                
                //关闭授权页
//                    [CLShanYanSDKManager finishAuthControllerAnimated:YES Completion:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CLShanYanSDKManager hideLoading];
                });
            }
        }else{
            
            CLConsoleLog(@"oneKeyLoginListener:%@\ncost:%f",completeResult.yy_modelToJSONObject,end - start);

            //测试置换手机号
            [ShanYanGetPhoneNumberDemoCode getPhonenumber:completeResult.data completion:^(NSString * _Nonnull phoneNumber, id  _Nullable responseObject, NSError * _Nonnull error) {
               
                //关闭页面
                [CLShanYanSDKManager finishAuthControllerCompletion:^{
                }];
                
                if (phoneNumber) {
                    CLConsoleLog(@"免密登录成功,手机号：%@",phoneNumber);
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"免密登录成功,手机号：%@",phoneNumber]];
                    
                }else{
                    
                    if (responseObject) {
                        CLConsoleLog(@"免密登录解密失败:%@",responseObject);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"免密登录解密失败:%@",responseObject]];
                    }else{
                        CLConsoleLog(@"免密登录解密失败:%@",error.localizedDescription);
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"免密登录解密失败:%@",error.localizedDescription]];
                    }
                }

            }];
        }
    }];
}

//本机号认证
- (void)localPhoneNumberCheckBtnClicked {
    PhoneNumberCheckController * vc = [PhoneNumberCheckController new];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 样式案例


-(CLUIConfigure *)configureMake0{
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(NO);
    //导航栏设置
    configure.clNavigationBarHidden = @(NO);
    configure.clNavigationBottomLineHidden = @(YES);
    configure.clNavigationBackgroundClear = @(YES);
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    configure.clNavigationLeftControl = leftItem;
    //右侧按钮
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithTitle:@"密码登录" style:UIBarButtonItemStylePlain target:self action:nil];
    configure.clNavigationRightControl = rigtItem;
    //logo
    configure.clLogoImage = [UIImage imageNamed:@"shanyanLogo1"];
    //手机掩码配置
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:25 weight:0.8];
    configure.clPhoneNumberColor = [UIColor blackColor];
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    //运营商slog
    configure.clSloganTextFont = [UIFont systemFontOfSize:14];
    configure.clSlogaTextAlignment = @(NSTextAlignmentRight);
    configure.clSloganTextColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
    //一键登录按钮
    configure.clLoginBtnText = @"本机号码一键登录";
    configure.clLoginBtnBgColor = [UIColor systemBlueColor];
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:17];
    
    //协议
    configure.clCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.clCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.clCheckBoxValue = @(NO);

    configure.clAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.clAppPrivacyFirst = @[@"用户协议",[NSURL URLWithString:@"http://shanyan.253.com"]];
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.clAppPrivacyLineSpacing = @(3.0);
    
    UIColor *normalColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    UIColor *privacyColor = [UIColor systemBlueColor];
    configure.clAppPrivacyColor = @[normalColor,privacyColor];
    
    
    //布局
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //logo
    CLOrientationLayOut *layOut = [[CLOrientationLayOut alloc] init];
    layOut.clLayoutLogoCenterX = @(0);
    layOut.clLayoutLogoTop = @(top + 44 + 40*scale);
    layOut.clLayoutLogoWidth = @(90*scale);
    layOut.clLayoutLogoHeight = @(layOut.clLayoutLogoWidth.floatValue *59/144.0);//依据图片的宽高比例
    
    top += 44 + 40*scale + layOut.clLayoutLogoHeight.floatValue;
    
    //手机掩码
    layOut.clLayoutPhoneTop = @(top + 60*scale);
    layOut.clLayoutPhoneCenterX = @(0);
    layOut.clLayoutPhoneHeight = @(35);
    
    top += 60*scale + layOut.clLayoutPhoneHeight.floatValue;
    
    //slog
    layOut.clLayoutSloganTop = @(top +25*scale);
    layOut.clLayoutSloganHeight = @(25*scale);
    
    CGFloat slogTop = layOut.clLayoutSloganTop.floatValue;
    CGFloat slogHeigh = layOut.clLayoutSloganHeight.floatValue;
    
    top += 25*scale + layOut.clLayoutSloganHeight.floatValue;
    
    //loginbtn
    layOut.clLayoutLoginBtnTop =  @(top + 25*scale);
    layOut.clLayoutLoginBtnLeft = @(25*scale);
    layOut.clLayoutLoginBtnRight = @(-25*scale);
    layOut.clLayoutLoginBtnHeight = @(45*scale);
    configure.clLoginBtnCornerRadius = @(layOut.clLayoutLoginBtnHeight.floatValue/2.0);
    
    layOut.clLayoutSloganLeft = @(configure.clLoginBtnCornerRadius.floatValue + layOut.clLayoutLoginBtnLeft.floatValue);
    
    
    top += 25*scale + layOut.clLayoutLoginBtnHeight.floatValue;
    
    //协议
    layOut.clLayoutAppPrivacyTop  = @(top + 25*scale);
    layOut.clLayoutAppPrivacyLeft = @(25*scale + 25);
    layOut.clLayoutAppPrivacyRight = @(-25*scale);
    
    
    top += 25*scale + 50;
    
    //自定义控件
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        //使用其他手机号
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherPhoneButton setTitle:@"使用其他手机 >" forState:UIControlStateNormal];
        [otherPhoneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [otherPhoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [otherPhoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherPhoneButton];
        
        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(slogTop);
            make.right.mas_equalTo(-25*scale - 22.5*scale);
            make.height.mas_equalTo(slogHeigh);
        }];
        
        //其他方式登录
        UIView *contentView = [[UIView alloc] init];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:leftLineView];
        
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(contentView);
            make.width.mas_equalTo(0.1*width);
        }];
        
        UILabel *otherLabel = [[UILabel alloc] init];
        otherLabel.text = @"使用其他账号登录";
        otherLabel.font = [UIFont systemFontOfSize:14];
        otherLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:otherLabel];
        
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftLineView.mas_right).offset(10*scale);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(otherLabel.mas_right).offset(10*scale);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(0.1*width);
            make.right.equalTo(contentView.mas_right);
            make.centerY.equalTo(leftLineView);
        }];
        
        [customAreaView addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(top + 25*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
        //其他按钮视图
        __block UIView *weiXinView;
        __block UIView *qqView;
        __block UIView *weiBoView;
        
        NSArray *imageNames = @[@"weixin",@"qq",@"weibo"];
        NSArray *titiles = @[@"微信",@"QQ",@"微博"];
        
        [imageNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *buttonContentView = [[UIView alloc] init];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:idx];
            [button setBackgroundImage :[UIImage imageNamed:obj] forState:UIControlStateNormal];
            [buttonContentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(0.15*width);
                make.height.mas_equalTo(0.15*width);
                make.top.left.right.equalTo(buttonContentView).offset(5);
            }];
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = titiles[idx];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont systemFontOfSize:15];
            tipLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            [buttonContentView addSubview:tipLabel];
            
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(button.mas_bottom).offset(10);
                make.left.right.equalTo(buttonContentView);
                make.bottom.equalTo(buttonContentView).offset(-2);
                make.height.mas_equalTo(25);
            }];
            
            if (idx == 0) {
                
                weiXinView = buttonContentView;
            }else if (idx == 1){
                
                qqView = buttonContentView;
            }else{
                
                weiBoView = buttonContentView;
            }
            
        }];
        
        UIView *buttonContentView = [[UIView alloc] init];
        
        [buttonContentView addSubview:weiXinView];
        [weiXinView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(buttonContentView);
        }];
        
        
        [buttonContentView addSubview:qqView];
        [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(buttonContentView);
            make.left.equalTo(weiXinView.mas_right).offset(0.13*width);
        }];
        
        
        [buttonContentView addSubview:weiBoView];
        [weiBoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(buttonContentView);
            make.left.equalTo(qqView.mas_right).offset(0.13*width);
        }];
        
        [customAreaView addSubview:buttonContentView];
        
        [buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(contentView.mas_bottom).offset(15*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
    };
    
    
    configure.clOrientationLayOutPortrait = layOut;
    
    return configure;
    
}


-(CLUIConfigure *)configureMake1{
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(NO);
    configure.clNavigationBarHidden = @(YES);
    configure.clLogoHiden = @(YES);
    configure.clBackgroundImg = [UIImage imageNamed:@"bb886219260f91b2be4ad0a913616be2"];
    //手机掩码
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:18 weight:0.5];
    configure.clPhoneNumberColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //一件登录按钮
    configure.clLoginBtnText = @"一键登录";
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:16 weight:0.2];
    configure.clLoginBtnBgColor = [UIColor colorWithRed:225/255.0 green:0 blue:56/255.0 alpha:1.0];
    
    //运营商slog
    configure.clSlogaTextAlignment = @(NSTextAlignmentCenter);
    configure.clSloganTextFont = [UIFont systemFontOfSize:15];
    configure.clSloganTextColor = [UIColor lightGrayColor];
    
    //协议
    
    configure.clCheckBoxHidden = @(YES);
    configure.clAppPrivacyNormalDesTextFirst = @"同意";
    configure.clAppPrivacyNormalDesTextSecond = @"和";
    configure.clAppPrivacyFirst = @[@"《用户协议》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextThird = @"、";
    configure.clAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyPunctuationMarks = @(YES);
    configure.clAppPrivacyColor = @[[UIColor lightGrayColor],[UIColor lightGrayColor]];
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.clAppPrivacyLineSpacing = @(3.0);
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    
    //布局
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    

    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    CGFloat top = height - 255*scale;
    
    CGFloat currentY = top;
    
    CLOrientationLayOut *clOrientationLayOut = [[CLOrientationLayOut alloc] init];
    
    //手机掩码
    clOrientationLayOut.clLayoutPhoneTop = @(top);
    clOrientationLayOut.clLayoutPhoneLeft = @(40*scale);
    clOrientationLayOut.clLayoutPhoneRight = @(-40*scale);
    clOrientationLayOut.clLayoutPhoneHeight = @(25*scale);
    
    currentY = clOrientationLayOut.clLayoutPhoneTop.floatValue + clOrientationLayOut.clLayoutPhoneHeight.floatValue;
    
    //一件登录按钮
    clOrientationLayOut.clLayoutLoginBtnTop = @(currentY + 20*scale);
    clOrientationLayOut.clLayoutLoginBtnLeft = @(40*scale);
    clOrientationLayOut.clLayoutLoginBtnRight = @(-40*scale);
    clOrientationLayOut.clLayoutLoginBtnHeight = @(50*scale);
    
    configure.clLoginBtnCornerRadius = @(clOrientationLayOut.clLayoutLoginBtnHeight.floatValue/2.0);
    
    
    currentY =  clOrientationLayOut.clLayoutLoginBtnTop.floatValue + clOrientationLayOut.clLayoutLoginBtnHeight.floatValue;
    
    //slog
    clOrientationLayOut.clLayoutSloganTop = @(currentY + 20*scale);
    clOrientationLayOut.clLayoutSloganLeft = @(40*scale);
    clOrientationLayOut.clLayoutSloganRight = @(-40*scale);
    clOrientationLayOut.clLayoutSloganHeight = @(20*scale);
    
    currentY = clOrientationLayOut.clLayoutSloganTop.floatValue + clOrientationLayOut.clLayoutSloganHeight.floatValue;
    
    //协议
    clOrientationLayOut.clLayoutAppPrivacyTop = @(currentY +20*scale);
    clOrientationLayOut.clLayoutAppPrivacyLeft = @(40*scale);
    clOrientationLayOut.clLayoutAppPrivacyRight = @(-40*scale);
    clOrientationLayOut.clLayoutAppPrivacyHeight = @(50*scale);
    
    currentY  = clOrientationLayOut.clLayoutAppPrivacyTop.floatValue + clOrientationLayOut.clLayoutAppPrivacyHeight.floatValue;
    
    currentY += 20*scale;
    
    
    
    configure.clOrientationLayOutPortrait = clOrientationLayOut;
    
    
    __weak typeof(self) weakSelf = self;
    
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        UIView *cornerView = [[UIView alloc] init];
        cornerView.layer.masksToBounds = YES;
        cornerView.layer.cornerRadius  = 10.0;
        cornerView.backgroundColor = [UIColor whiteColor];
        [customAreaView addSubview:cornerView];
        
        [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(top - 30*scale);
            make.left.mas_equalTo(20*scale);
            make.right.mas_equalTo(-20*scale);
            make.height.mas_equalTo(currentY - top + 30*scale);
        }];
        
//        UIButton *cannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cannelButton setTitle:@"取消登录" forState:UIControlStateNormal];
//        [cannelButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
//        [cannelButton setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [cannelButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
//        [customAreaView addSubview:cannelButton];
//        [cannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.mas_offset(top);
//            make.left.equalTo(cornerView).offset(20*scale);
//            make.height.mas_equalTo(30*scale);
//
//        }];
        
        
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherButton setTitle:@"更换号码" forState:UIControlStateNormal];
        [otherButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [otherButton setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
        [otherButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherButton];
        [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(top);
            make.right.equalTo(cornerView).offset(-20*scale);
            make.height.mas_equalTo(25*scale);
            
        }];
        
        
    };
    
    return configure;
    
}


-(CLUIConfigure *)configureMake2{
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    //黑
    UIColor *color1 = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    //灰
    UIColor *color2 = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    //墨绿
    UIColor *color3 = [UIColor colorWithRed:54/255.0 green:134/255.0 blue:141/255.0 alpha:1.0];
    
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(NO);;
    //导航栏
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(dismis)];
    configure.clNavigationLeftControl = closeButtonItem;
    configure.clNavigationBackgroundClear = @(YES);
    configure.clNavigationBottomLineHidden = @(YES);
    
    //隐藏logo
    configure.clLogoHiden = @(YES);
    
    //掩码
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:22];
    configure.clPhoneNumberColor = color1;
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentLeft);
    
    //登录按钮
    configure.clLoginBtnText = @"立即登录";
    configure.clLoginBtnBgColor = color3;
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:16 weight:0.3];
    configure.clLoginBtnCornerRadius = @(5.0);
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    
    //slog
    configure.clSloganTextFont = [UIFont systemFontOfSize:14 weight:0.2];
    configure.clSloganTextColor = color2;
    
    
    //协议
    configure.clCheckBoxHidden = @(YES);
    configure.clAppPrivacyNormalDesTextFirst = @"注册/登录即代表您年满18岁，已认真阅读并同意接受闪验";
    configure.clAppPrivacyFirst = @[@"《服务条款》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextSecond = @"、";
    configure.clAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextThird= @",以及同意";
    configure.clAppPrivacyPunctuationMarks = @(YES);
    configure.clPrivacyShowUnderline = @(YES);
    configure.clOperatorPrivacyAtLast = @(YES);
    configure.clAppPrivacyLineSpacing = @(3.0);
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:16 weight:0.3];
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.clAppPrivacyColor = @[color2,color3];
    
    
    CLOrientationLayOut *layout = [[CLOrientationLayOut alloc] init];
    configure.clOrientationLayOutPortrait = layout;
    
    
    CGFloat top = 180*scale + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44;//顶部视图的高度以及间距只和
    
    //掩码
    layout.clLayoutPhoneTop = @(top) ;
    layout.clLayoutPhoneLeft = @(30*scale);
    layout.clLayoutLogoHeight = @(30*scale);
    
    
    top  = layout.clLayoutPhoneTop.floatValue + layout.clLayoutLogoHeight.floatValue;
    
    //登录按钮
    layout.clLayoutLoginBtnTop = @(top + 30*scale);
    layout.clLayoutLoginBtnLeft = @(30*scale);
    layout.clLayoutLoginBtnRight = @(-30*scale);
    layout.clLayoutLoginBtnHeight = @(50*scale);
    
    
    top = layout.clLayoutLoginBtnTop.floatValue + layout.clLayoutLoginBtnHeight.floatValue;
    
    //slog
    layout.clLayoutSloganTop = @(top + 10*scale);
    layout.clLayoutSloganLeft = @(30*scale);
    layout.clLayoutLogoHeight = @(25*scale);
        
    top  = layout.clLayoutSloganTop.floatValue + layout.clLayoutLogoHeight.floatValue;
    
    CGFloat slogBottom = top;
    
    
    top += 110*scale + 0.15*width;
    
    
    //协议
    layout.clLayoutAppPrivacyTop = @(top + 20*scale);
    layout.clLayoutAppPrivacyLeft = @(30*scale);
    layout.clLayoutAppPrivacyRight = @(-30*scale);
    
    __weak typeof(self) weakSelf = self;
    
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        customAreaView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *tipLabel1 = [[UILabel alloc] init];
        tipLabel1.text = @"本机号码快捷登录";
        tipLabel1.font = [UIFont systemFontOfSize:30 weight:1.0];
        tipLabel1.textColor = color1;
        [customAreaView addSubview:tipLabel1];
        
        [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(50*scale + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44);
            make.left.mas_equalTo(30*scale);
            make.height.mas_equalTo(40*scale);
        }];
        
        
        UILabel *tipLabel2 = [[UILabel alloc] init];
        tipLabel2.text = @"本机号码未注册将自动创建新账号";
        tipLabel2.font = [UIFont systemFontOfSize:16 weight:0.2];
        tipLabel2.textColor = color2;
        [customAreaView addSubview:tipLabel2];
        
        [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.equalTo(tipLabel1.mas_bottom).offset(5*scale);
            make.left.equalTo(tipLabel1);
            make.height.mas_equalTo(25*scale);
        }];
        
        UILabel *tipLabel3 = [[UILabel alloc] init];
        tipLabel3.text = @"本机号码";
        tipLabel3.font = [UIFont systemFontOfSize:16 weight:0.2];
        tipLabel3.textColor = color1;
        [customAreaView addSubview:tipLabel3];
        
        [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(tipLabel2);
            make.top.equalTo(tipLabel2.mas_bottom).offset(30*scale);
            make.height.mas_equalTo(25*scale);
        }];
        
        //其他手机号登录
        UIButton *otherPhone = [UIButton buttonWithType:UIButtonTypeSystem];
        [otherPhone setTitle:@"使用其他手机号" forState:UIControlStateNormal];
        [otherPhone.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.3]];
        [otherPhone setTitleColor:color3 forState:UIControlStateNormal];
        [otherPhone addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherPhone];
        
        [otherPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo( slogBottom + 20*scale);
            make.left.mas_equalTo(30*scale);
            make.height.mas_equalTo(25*scale);
        }];
        
        //或者使用微信登录
        UILabel *weixinLabel = [[UILabel alloc] init];
        weixinLabel.text = @"或使用微信登录";
        weixinLabel.textColor = color2;
        weixinLabel.font = [UIFont systemFontOfSize:16 weight:0.3];
        [customAreaView addSubview:weixinLabel];
        
        [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(otherPhone.mas_bottom).offset(20*scale);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(25*scale);
            
        }];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage :[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [customAreaView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0.15*width);
            make.height.mas_equalTo(0.15*width);
            make.top.equalTo(weixinLabel.mas_bottom).offset(20*scale);
            make.centerX.mas_equalTo(0);
            
        }];
    
    };
    
    
    return configure;
}


-(CLUIConfigure *)configureMake3{
    
    //黑
    UIColor *color1 = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    //灰
    UIColor *color2 = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    //天蓝
    UIColor *color3 = [UIColor colorWithRed:60/255.0 green:160/255.0 blue:247/255.0 alpha:1.0];
    
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(NO);;
    
    //导航设置
    configure.clNavigationBarHidden = @(YES);
    
    //logo
    configure.clLogoHiden = @(YES);
    
    //掩码
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:22];
    configure.clPhoneNumberColor = color1;
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //slog
    configure.clSloganTextFont = [UIFont systemFontOfSize:14];
    configure.clSloganTextColor = color2;
    configure.clSlogaTextAlignment = @(NSTextAlignmentCenter);
    
    //登录按钮
    configure.clLoginBtnText = @"本机号一键登录";
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:18 weight:0.2];
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    configure.clLoginBtnBgColor = color3;
    configure.clLoginBtnCornerRadius = @(5);
    
    //协议
    configure.clCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.clCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.clCheckBoxValue = @(NO);

    configure.clAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.clAppPrivacyFirst = @[@"《用户协议》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextSecond = @"、";
    configure.clAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextThird = @"和";
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.clAppPrivacyLineSpacing = @(3.0);
    configure.clOperatorPrivacyAtLast = @(YES);
    configure.clAppPrivacyPunctuationMarks = @(YES);
    configure.clAppPrivacyColor = @[color2,color3];
    configure.clAuthTypeUseWindow = @(YES);
    
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height  = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CLOrientationLayOut *cLOrientationLayOut = [[CLOrientationLayOut alloc] init];
    configure.clOrientationLayOutPortrait = cLOrientationLayOut;
        
    CGFloat top = height/2.0 - 340*scale/2.0;
    
    //手机掩码
    cLOrientationLayOut.clLayoutPhoneTop = @(top + 70*scale);
    cLOrientationLayOut.clLayoutPhoneLeft = @(50*scale);
    cLOrientationLayOut.clLayoutPhoneCenterX = @(0);
    cLOrientationLayOut.clLayoutPhoneHeight = @(30*scale);
    
    top = cLOrientationLayOut.clLayoutPhoneTop.floatValue + cLOrientationLayOut.clLayoutPhoneHeight.floatValue;
    
    //slog
    cLOrientationLayOut.clLayoutSloganTop = @(top + 20*scale);
    cLOrientationLayOut.clLayoutSloganLeft = @(50*scale);
    cLOrientationLayOut.clLayoutSloganCenterX = @(0);
    cLOrientationLayOut.clLayoutSloganHeight = @(25*scale);
    
    
    top = cLOrientationLayOut.clLayoutSloganTop.floatValue + cLOrientationLayOut.clLayoutSloganHeight.floatValue;
    
    //登录按钮
    cLOrientationLayOut.clLayoutLoginBtnTop = @(top + 25*scale);
    cLOrientationLayOut.clLayoutLoginBtnLeft = @(50*scale);
    cLOrientationLayOut.clLayoutLoginBtnRight = @(-50*scale);
    cLOrientationLayOut.clLayoutLoginBtnHeight = @(45*scale);
    
    top = cLOrientationLayOut.clLayoutLoginBtnTop.floatValue + cLOrientationLayOut.clLayoutLoginBtnHeight.floatValue;
    
    //协议
    cLOrientationLayOut.clLayoutAppPrivacyTop = @(top + 70*scale);
    cLOrientationLayOut.clLayoutAppPrivacyLeft = @(50*scale + 30);
    cLOrientationLayOut.clLayoutAppPrivacyRight = @(-50*scale);
    
    top  = cLOrientationLayOut.clLayoutAppPrivacyTop.floatValue + cLOrientationLayOut.clLayoutAppPrivacyHeight.floatValue;
    
    
    __weak typeof(self) weakSelf = self;
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        customAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UIView *conerView = [[UIView alloc] init];
        conerView.backgroundColor = [UIColor whiteColor];
        conerView.layer.cornerRadius = 10.0;
        [customAreaView addSubview:conerView];
        
        [conerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.mas_equalTo(cLOrientationLayOut.clLayoutPhoneTop.floatValue - 70*scale);
            make.left.mas_equalTo(30*scale);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(340*scale + 35*scale);
            
        }];
        
        //关闭按钮
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [close addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [conerView addSubview:close];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(10*scale);
            make.right.mas_offset(-10*scale);
            make.width.height.mas_equalTo(25*scale);
        }];
        
        
        UILabel *welcomLabel = [[UILabel alloc] init];
        welcomLabel.text = @"欢迎使用闪验";
        welcomLabel.font = [UIFont systemFontOfSize:15];
        welcomLabel.textColor = color1;
        welcomLabel.textAlignment = NSTextAlignmentCenter;
        [customAreaView addSubview:welcomLabel];
        
        [welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerY.mas_equalTo(conerView.mas_top).offset(40*scale);
            make.left.mas_equalTo(50*scale);
            make.centerX.mas_equalTo(0);
            make.height.mas_offset(25*scale);
             
        }];
        
        //其他方式登录
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
        [otherButton setTitleColor:color1 forState:UIControlStateNormal];
        [otherButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [otherButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherButton];
        
        [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(customAreaView.mas_top).offset(cLOrientationLayOut.clLayoutLoginBtnTop.floatValue + cLOrientationLayOut.clLayoutLoginBtnHeight.floatValue + 35*scale);

            
        }];
    };
    
    return configure;
    
}

-(CLUIConfigure *)configureMake4{
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(NO);
    //导航栏设置
    configure.clNavigationBarHidden = @(NO);
    configure.clNavigationBottomLineHidden = @(YES);
    configure.clNavigationBackgroundClear = @(YES);
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    configure.clNavigationLeftControl = leftItem;
    //logo
    configure.clLogoImage = [UIImage imageNamed:@"shanyanLogo1"];
    //手机掩码配置
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:25 weight:0.8];
    configure.clPhoneNumberColor = [UIColor blackColor];
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    //运营商slog
    configure.clSloganTextFont = [UIFont systemFontOfSize:14];
    configure.clSlogaTextAlignment = @(NSTextAlignmentCenter);
    configure.clSloganTextColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    
    //一键登录按钮
    configure.clLoginBtnText = @"本机号码一键登录";
    configure.clLoginBtnBgColor = [UIColor systemBlueColor];
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:17];
    
    //协议
    configure.clCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.clCheckBoxHidden = @(YES);
    configure.clAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.clAppPrivacyFirst = @[@"用户协议",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.clAppPrivacyLineSpacing = @(3.0);
    
    UIColor *normalColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    UIColor *privacyColor = [UIColor systemBlueColor];
    configure.clAppPrivacyColor = @[normalColor,privacyColor];
    
    
    //布局
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //logo
    CLOrientationLayOut *layOut = [[CLOrientationLayOut alloc] init];
    layOut.clLayoutLogoCenterX = @(0);
    layOut.clLayoutLogoTop = @(top + 44 + 40*scale);
    layOut.clLayoutLogoWidth = @(90*scale);
    layOut.clLayoutLogoHeight = @(layOut.clLayoutLogoWidth.floatValue *59/144.0);//依据图片的宽高比例
    
    top += 44 + 40*scale + layOut.clLayoutLogoHeight.floatValue;
    
    //手机掩码
    layOut.clLayoutPhoneTop = @(top + 60*scale);
    layOut.clLayoutPhoneCenterX = @(0);
    layOut.clLayoutPhoneHeight = @(35);
    
    top += 60*scale + layOut.clLayoutPhoneHeight.floatValue;
    
    //slog
    layOut.clLayoutSloganTop = @(top +25*scale);
    layOut.clLayoutSloganHeight = @(25*scale);
    layOut.clLayoutSloganLeft = @(25*scale);
    layOut.clLayoutSloganRight = @(-25*scale);
    
    top += 25*scale + layOut.clLayoutSloganHeight.floatValue;
    
    //loginbtn
    layOut.clLayoutLoginBtnTop =  @(top + 25*scale);
    layOut.clLayoutLoginBtnLeft = @(25*scale);
    layOut.clLayoutLoginBtnRight = @(-25*scale);
    layOut.clLayoutLoginBtnHeight = @(45*scale);
    configure.clLoginBtnCornerRadius = @(layOut.clLayoutLoginBtnHeight.floatValue/2.0);
    
    layOut.clLayoutSloganLeft = @(configure.clLoginBtnCornerRadius.floatValue + layOut.clLayoutLoginBtnLeft.floatValue);
    
    top += 25*scale + layOut.clLayoutLoginBtnHeight.floatValue;
    
    
    //协议
    layOut.clLayoutAppPrivacyLeft = @(25*scale);
    layOut.clLayoutAppPrivacyRight = @(-25*scale);
    layOut.clLayoutAppPrivacyBottom = @(-50*scale);
    
    //自定义控件
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        //使用其他手机号
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherPhoneButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
        [otherPhoneButton addTarget:self action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [otherPhoneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [otherPhoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [otherPhoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherPhoneButton];

        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(top + 40*scale);
            make.centerX.mas_equalTo(0);
        }];
        
        
    };
    
    
    configure.clOrientationLayOutPortrait = layOut;
    
    return configure;
}

-(CLUIConfigure *)configureMake5{
    
    //黑
    UIColor *color1 = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    //灰
    UIColor *color2 = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    //天蓝
    UIColor *color3 = [UIColor colorWithRed:60/255.0 green:160/255.0 blue:247/255.0 alpha:1.0];
    
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(YES);
    
    //导航设置
    configure.clNavigationBarHidden = @(YES);
    
    //logo
    configure.clLogoHiden = @(YES);
    
    //掩码
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:22];
    configure.clPhoneNumberColor = color1;
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    
    //slog
    configure.clSloganTextFont = [UIFont systemFontOfSize:14];
    configure.clSloganTextColor = color2;
    configure.clSlogaTextAlignment = @(NSTextAlignmentCenter);
    
    //登录按钮
    configure.clLoginBtnText = @"本机号一键登录";
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:18 weight:0.2];
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    configure.clLoginBtnBgColor = color3;
    configure.clLoginBtnCornerRadius = @(5);
    
    //协议
    configure.clCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.clCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.clCheckBoxValue = @(NO);

    configure.clAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.clAppPrivacyFirst = @[@"《用户协议》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextSecond = @"、";
    configure.clAppPrivacySecond = @[@"《隐私政策》",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyNormalDesTextThird = @"和";
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.clAppPrivacyLineSpacing = @(3.0);
    configure.clOperatorPrivacyAtLast = @(YES);
    configure.clAppPrivacyPunctuationMarks = @(YES);
    configure.clAppPrivacyColor = @[color2,color3];
    configure.clAuthTypeUseWindow = @(YES);
    
    
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height  = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准

    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    

    CLOrientationLayOut *cLOrientationLayOutPortrait = [[CLOrientationLayOut alloc] init];
    configure.clOrientationLayOutPortrait = cLOrientationLayOutPortrait;
        
    CGFloat top = height/2.0 - 340*scale/2.0;
    
    //手机掩码
    cLOrientationLayOutPortrait.clLayoutPhoneTop = @(top + 70*scale);
    cLOrientationLayOutPortrait.clLayoutPhoneLeft = @(50*scale);
    cLOrientationLayOutPortrait.clLayoutPhoneCenterX = @(0);
    cLOrientationLayOutPortrait.clLayoutPhoneHeight = @(30*scale);
    
    top = cLOrientationLayOutPortrait.clLayoutPhoneTop.floatValue + cLOrientationLayOutPortrait.clLayoutPhoneHeight.floatValue;
    
    //slog
    cLOrientationLayOutPortrait.clLayoutSloganTop = @(top + 20*scale);
    cLOrientationLayOutPortrait.clLayoutSloganLeft = @(50*scale);
    cLOrientationLayOutPortrait.clLayoutSloganCenterX = @(0);
    cLOrientationLayOutPortrait.clLayoutSloganHeight = @(25*scale);
    
    
    top = cLOrientationLayOutPortrait.clLayoutSloganTop.floatValue + cLOrientationLayOutPortrait.clLayoutSloganHeight.floatValue;
    
    //登录按钮
    cLOrientationLayOutPortrait.clLayoutLoginBtnTop = @(top + 25*scale);
    cLOrientationLayOutPortrait.clLayoutLoginBtnLeft = @(50*scale);
    cLOrientationLayOutPortrait.clLayoutLoginBtnRight = @(-50*scale);
    cLOrientationLayOutPortrait.clLayoutLoginBtnHeight = @(45*scale);
    
    top = cLOrientationLayOutPortrait.clLayoutLoginBtnTop.floatValue + cLOrientationLayOutPortrait.clLayoutLoginBtnHeight.floatValue;
    
    //协议
    cLOrientationLayOutPortrait.clLayoutAppPrivacyTop = @(top + 70*scale);
    cLOrientationLayOutPortrait.clLayoutAppPrivacyLeft = @(50*scale + 30);
    cLOrientationLayOutPortrait.clLayoutAppPrivacyRight = @(-50*scale);
    
    top  = cLOrientationLayOutPortrait.clLayoutAppPrivacyTop.floatValue + cLOrientationLayOutPortrait.clLayoutAppPrivacyHeight.floatValue;
    
    __weak typeof(self) weakSelf = self;
    
    
    //横屏
    CGFloat heightLandscape  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat widthLandscape  = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat topLandscape = heightLandscape/2.0 - 300*scale/2.0;
    
    CLOrientationLayOut *clOrientationLayOutLandscape = [[CLOrientationLayOut alloc] init];
    configure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;
    
    //手机掩码
    clOrientationLayOutLandscape.clLayoutPhoneTop = @(topLandscape + 60*scale);
    clOrientationLayOutLandscape.clLayoutPhoneCenterX = @(0);
    clOrientationLayOutLandscape.clLayoutPhoneWidth = @(heightLandscape - 100*scale);
    clOrientationLayOutLandscape.clLayoutPhoneHeight = @(30*scale);
    
    topLandscape = clOrientationLayOutLandscape.clLayoutPhoneTop.floatValue + clOrientationLayOutLandscape.clLayoutPhoneHeight.floatValue;
    
    //slog
    clOrientationLayOutLandscape.clLayoutSloganTop = @(topLandscape + 10*scale);
    clOrientationLayOutLandscape.clLayoutSloganWidth = @(heightLandscape - 100*scale);
    clOrientationLayOutLandscape.clLayoutSloganCenterX = @(0);
    clOrientationLayOutLandscape.clLayoutSloganHeight = @(20*scale);
    
    
    topLandscape = clOrientationLayOutLandscape.clLayoutSloganTop.floatValue + clOrientationLayOutLandscape.clLayoutSloganHeight.floatValue;
    
    //登录按钮
    clOrientationLayOutLandscape.clLayoutLoginBtnTop = @(topLandscape + 15*scale);
    clOrientationLayOutLandscape.clLayoutLoginBtnWidth = @(heightLandscape - 100*scale);
    clOrientationLayOutLandscape.clLayoutLoginBtnCenterX = @(0);
    clOrientationLayOutLandscape.clLayoutLoginBtnHeight = @(45*scale);
    
    topLandscape = clOrientationLayOutLandscape.clLayoutLoginBtnTop.floatValue + clOrientationLayOutLandscape.clLayoutLoginBtnHeight.floatValue;
    
    //协议
    clOrientationLayOutLandscape.clLayoutAppPrivacyTop = @(topLandscape + 60*scale);
    clOrientationLayOutLandscape.clLayoutAppPrivacyWidth = @(heightLandscape - 100*scale-30);
    clOrientationLayOutLandscape.clLayoutAppPrivacyCenterX = @(15);

    topLandscape  = clOrientationLayOutLandscape.clLayoutAppPrivacyTop.floatValue + clOrientationLayOutLandscape.clLayoutAppPrivacyHeight.floatValue;
    
    __block UIView *conerViewBlock;
    __block UIButton *closeBlock;
    __block UILabel *welcomLabelBlock;
    __block UIButton *otherButtonBlock;
    
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        
        customAreaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
       
        
        void (^ rientationPortraitBlcok) (UIInterfaceOrientation orientation) = ^(UIInterfaceOrientation orientation){
            
            
            UIView *conerView = [[UIView alloc] init];
            conerView.backgroundColor = [UIColor whiteColor];
            conerView.layer.cornerRadius = 10.0;
            [customAreaView addSubview:conerView];
            conerViewBlock = conerView;
            
            //关闭按钮
            UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
            [close setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [close addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
            [conerView addSubview:close];
            closeBlock = close;
            
            
            UILabel *welcomLabel = [[UILabel alloc] init];
            welcomLabel.text = @"欢迎使用闪验";
            welcomLabel.font = [UIFont systemFontOfSize:15];
            welcomLabel.textColor = color1;
            welcomLabel.textAlignment = NSTextAlignmentCenter;
            [customAreaView addSubview:welcomLabel];
            welcomLabelBlock = welcomLabel;
            
            
            UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherButton setTitle:@"其他方式登录" forState:UIControlStateNormal];
            [otherButton setTitleColor:color1 forState:UIControlStateNormal];
            [otherButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [otherButton addTarget:weakSelf action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
            [customAreaView addSubview:otherButton];
            otherButtonBlock = otherButton;
            
        
            //竖屏
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            
                [conerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_equalTo(cLOrientationLayOutPortrait.clLayoutPhoneTop.floatValue - 70*scale);
                    make.left.mas_equalTo(30*scale);
                    make.centerX.mas_equalTo(0);
                    make.height.mas_equalTo(340*scale + 35*scale);
                    
                }];
                
                [close mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_offset(10*scale);
                    make.right.mas_offset(-10*scale);
                    make.width.height.mas_equalTo(25*scale);
                }];
                
                [welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                    make.centerY.mas_equalTo(conerView.mas_top).offset(40*scale);
                    make.left.mas_equalTo(50*scale);
                    make.centerX.mas_equalTo(0);
                    make.height.mas_offset(25*scale);
                     
                }];
                
                //其他方式登录
                [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(0);
                    make.centerY.equalTo(customAreaView.mas_top).offset(cLOrientationLayOutPortrait.clLayoutLoginBtnTop.floatValue + cLOrientationLayOutPortrait.clLayoutLoginBtnHeight.floatValue + 35*scale);
                }];
                
            }else{
            //横屏
                
                [conerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    
                    make.top.mas_equalTo(clOrientationLayOutLandscape.clLayoutPhoneTop.floatValue - 60*scale);
                    make.width.mas_equalTo(heightLandscape - 60*scale);
                    make.centerX.mas_equalTo(0);
                   
                    make.bottom.mas_offset(-clOrientationLayOutLandscape.clLayoutPhoneTop.floatValue + 60*scale+10*scale);
                    
                }];
                
                [close mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_offset(10*scale);
                    make.right.mas_offset(-10*scale);
                    make.width.height.mas_equalTo(25*scale);
                }];
                
                [welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                    make.centerY.mas_equalTo(conerView.mas_top).offset(40*scale);
                    make.left.mas_equalTo(50*scale);
                    make.centerX.mas_equalTo(0);
                    make.height.mas_offset(25*scale);
                     
                }];
                
                //其他方式登录
                [otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(0);
                    make.centerY.equalTo(customAreaView.mas_top).offset(clOrientationLayOutLandscape.clLayoutLoginBtnTop.floatValue + clOrientationLayOutLandscape.clLayoutLoginBtnHeight.floatValue + 35*scale);
                }];
                
            }
            
        };
        
        
        rientationPortraitBlcok(orientation);
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            
            UIInterfaceOrientation orientationIn = [UIApplication sharedApplication].statusBarOrientation;
            
            //删除以前约束
            [conerViewBlock removeFromSuperview];
            [closeBlock  removeFromSuperview];
            [welcomLabelBlock removeFromSuperview];
            [otherButtonBlock removeFromSuperview];
            
            rientationPortraitBlcok(orientationIn);
        }];
    };
    
    return configure;
    
}

-(CLUIConfigure *)configureMake6{
    
    
    CLUIConfigure *configure = [[CLUIConfigure alloc] init];
    configure.viewController = self;
    configure.shouldAutorotate = @(NO);
    
    
    //导航栏设置
    configure.clNavigationBarHidden = @(NO);
    configure.clNavigationBottomLineHidden = @(YES);
    configure.clNavigationBackgroundClear = @(YES);
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    configure.clNavigationLeftControl = leftItem;
    //右侧按钮
    UIBarButtonItem *rigtItem = [[UIBarButtonItem alloc] initWithTitle:@"密码登录" style:UIBarButtonItemStylePlain target:self action:nil];
    configure.clNavigationRightControl = rigtItem;
    //logo
    configure.clLogoImage = [UIImage imageNamed:@"shanyanLogo1"];
    //手机掩码配置
    configure.clPhoneNumberFont = [UIFont systemFontOfSize:25 weight:0.8];
    configure.clPhoneNumberColor = [UIColor whiteColor];
    configure.clPhoneNumberTextAlignment = @(NSTextAlignmentCenter);
    //运营商slog
    configure.clSloganTextFont = [UIFont systemFontOfSize:14];
    configure.clSlogaTextAlignment = @(NSTextAlignmentRight);
    configure.clSloganTextColor = [UIColor whiteColor];
    
    //一键登录按钮
    configure.clLoginBtnText = @"本机号码一键登录";
    configure.clLoginBtnBgColor = [UIColor systemBlueColor];
    configure.clLoginBtnTextColor = [UIColor whiteColor];
    configure.clLoginBtnTextFont = [UIFont systemFontOfSize:17];
    
    //协议
    configure.clCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
    configure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
    configure.clCheckBoxSize = [NSValue valueWithCGSize:CGSizeMake(25, 25)];
    configure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
    configure.clCheckBoxValue = @(NO);

    configure.clAppPrivacyNormalDesTextFirst = @"我已阅读并同意";
    configure.clAppPrivacyFirst = @[@"用户协议",[NSURL URLWithString:@"https://shanyan253.com"]];
    configure.clAppPrivacyTextFont = [UIFont systemFontOfSize:14];
    configure.clAppPrivacyTextAlignment = @(NSTextAlignmentLeft);
    configure.clAppPrivacyLineSpacing = @(3.0);
    
    UIColor *normalColor = [UIColor whiteColor];
    UIColor *privacyColor = [UIColor systemBlueColor];
    configure.clAppPrivacyColor = @[normalColor,privacyColor];
    
    
    //布局
    CGFloat width  = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat scale = width/375.0;//以iphone6 屏幕为基准
    
    CGFloat top = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //logo
    CLOrientationLayOut *layOut = [[CLOrientationLayOut alloc] init];
    layOut.clLayoutLogoCenterX = @(0);
    layOut.clLayoutLogoTop = @(top + 44 + 40*scale);
    layOut.clLayoutLogoWidth = @(90*scale);
    layOut.clLayoutLogoHeight = @(layOut.clLayoutLogoWidth.floatValue *59/144.0);//依据图片的宽高比例
    
    top += 44 + 40*scale + layOut.clLayoutLogoHeight.floatValue;
    
    //手机掩码
    layOut.clLayoutPhoneTop = @(top + 60*scale);
    layOut.clLayoutPhoneCenterX = @(0);
    layOut.clLayoutPhoneHeight = @(35);
    
    top += 60*scale + layOut.clLayoutPhoneHeight.floatValue;
    
    //slog
    layOut.clLayoutSloganTop = @(top +25*scale);
    layOut.clLayoutSloganHeight = @(25*scale);
    
    CGFloat slogTop = layOut.clLayoutSloganTop.floatValue;
    CGFloat slogHeigh = layOut.clLayoutSloganHeight.floatValue;
    
    top += 25*scale + layOut.clLayoutSloganHeight.floatValue;
    
    //loginbtn
    layOut.clLayoutLoginBtnTop =  @(top + 25*scale);
    layOut.clLayoutLoginBtnLeft = @(25*scale);
    layOut.clLayoutLoginBtnRight = @(-25*scale);
    layOut.clLayoutLoginBtnHeight = @(45*scale);
    configure.clLoginBtnCornerRadius = @(layOut.clLayoutLoginBtnHeight.floatValue/2.0);
    
    layOut.clLayoutSloganLeft = @(configure.clLoginBtnCornerRadius.floatValue + layOut.clLayoutLoginBtnLeft.floatValue);
    
    
    top += 25*scale + layOut.clLayoutLoginBtnHeight.floatValue;
    
    //协议
    layOut.clLayoutAppPrivacyTop  = @(top + 25*scale);
    layOut.clLayoutAppPrivacyLeft = @(25*scale + 25);
    layOut.clLayoutAppPrivacyRight = @(-25*scale);
    
    
    top += 25*scale + 50;
    
    //自定义控件
    configure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        
        PlayerView *playerView = [[PlayerView alloc] init];
        [customAreaView addSubview:playerView];
        
        [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.top.left.bottom.right.equalTo(customAreaView);
        }];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"颜色遮罩_x264" ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem *playeItem = [[AVPlayerItem alloc] initWithURL:url];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playeItem];
        
    
        AVPlayerLayer *playerLayer = (AVPlayerLayer *)playerView.layer;
        playerLayer.player = player;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        
        [player play];
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            
            CMTime time  = CMTimeMake(0, 1);
            
            [player seekToTime:time];
            
            [player play];
            
        }];
        //使用其他手机号
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherPhoneButton setTitle:@"使用其他手机 >" forState:UIControlStateNormal];
        [otherPhoneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [otherPhoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [otherPhoneButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherPhoneButton];
        
        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(slogTop);
            make.right.mas_equalTo(-25*scale - 22.5*scale);
            make.height.mas_equalTo(slogHeigh);
        }];
        
        //其他方式登录
        UIView *contentView = [[UIView alloc] init];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:leftLineView];
        
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(contentView);
            make.width.mas_equalTo(0.1*width);
        }];
        
        UILabel *otherLabel = [[UILabel alloc] init];
        otherLabel.text = @"使用其他账号登录";
        otherLabel.font = [UIFont systemFontOfSize:14];
        otherLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:otherLabel];
        
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(leftLineView.mas_right).offset(10*scale);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [contentView addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(otherLabel.mas_right).offset(10*scale);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(0.1*width);
            make.right.equalTo(contentView.mas_right);
            make.centerY.equalTo(leftLineView);
        }];
        
        [customAreaView addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(top + 25*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
        //其他按钮视图
        __block UIView *weiXinView;
        __block UIView *qqView;
        __block UIView *weiBoView;
        
        NSArray *imageNames = @[@"weixin",@"qq",@"weibo"];
        NSArray *titiles = @[@"微信",@"QQ",@"微博"];
        
        [imageNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *buttonContentView = [[UIView alloc] init];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:idx];
            [button setBackgroundImage :[UIImage imageNamed:obj] forState:UIControlStateNormal];
            [buttonContentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(0.15*width);
                make.height.mas_equalTo(0.15*width);
                make.top.left.right.equalTo(buttonContentView).offset(5);
            }];
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = titiles[idx];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.font = [UIFont systemFontOfSize:15];
            tipLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            [buttonContentView addSubview:tipLabel];
            
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(button.mas_bottom).offset(10);
                make.left.right.equalTo(buttonContentView);
                make.bottom.equalTo(buttonContentView).offset(-2);
                make.height.mas_equalTo(25);
            }];
            
            if (idx == 0) {
                
                weiXinView = buttonContentView;
            }else if (idx == 1){
                
                qqView = buttonContentView;
            }else{
                
                weiBoView = buttonContentView;
            }
            
        }];
        
        UIView *buttonContentView = [[UIView alloc] init];
        
        [buttonContentView addSubview:weiXinView];
        [weiXinView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(buttonContentView);
        }];
        
        
        [buttonContentView addSubview:qqView];
        [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(buttonContentView);
            make.left.equalTo(weiXinView.mas_right).offset(0.13*width);
        }];
        
        
        [buttonContentView addSubview:weiBoView];
        [weiBoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(buttonContentView);
            make.left.equalTo(qqView.mas_right).offset(0.13*width);
        }];
        
        [customAreaView addSubview:buttonContentView];
        
        [buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(contentView.mas_bottom).offset(15*scale);
            make.centerX.equalTo(customAreaView);
        }];
        
    };
    
    
    configure.clOrientationLayOutPortrait = layOut;
    
    return configure;
    
}
- (void)dismis{
    
    [CLShanYanSDKManager finishAuthControllerCompletion:nil];
    
}

@end
