//
//  ShanYanConfigureMaker.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/13.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit
import CL_ShanYanSDK
import PKHUD
import Kingfisher
import Hero

@objc protocol ShanYanConfigureMakerDelegate: NSObjectProtocol {
    func shanYanConfigureOtherWayClick(sender: UIButton)
    func customNavLeftItemClick(sender: UIButton)
}

class ShanYanConfigureMaker: NSObject {

    var notifObserver : NSObject?
    weak var shanYanConfigureMakerDelegate :ShanYanConfigureMakerDelegate?
    
    deinit {
        if let notifObserver = self.notifObserver {
            NotificationCenter.default.removeObserver(notifObserver)
        }
    }

    override init() {
        
    }
    init(delegate: ShanYanConfigureMakerDelegate?) {
        shanYanConfigureMakerDelegate = delegate
    }
    
    // MARK: - 竖屏模式
    func configureStyle0(configureInstance: CLUIConfigure) -> CLUIConfigure {
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat

        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        let style2Color = UIColor.init(red: 33/255.0, green: 113/255.0, blue: 242/255.0, alpha: 1)
        
        let baseUIConfigure = configureInstance;
        baseUIConfigure.manualDismiss = NSNumber(booleanLiteral: true)

        //横竖屏设置
        baseUIConfigure.shouldAutorotate = NSNumber(booleanLiteral: true)
        
        baseUIConfigure.supportedInterfaceOrientations = NSNumber(integerLiteral: Int(UIInterfaceOrientationMask.all.rawValue))
//        baseUIConfigure.preferredInterfaceOrientationForPresentation = NSNumber(integerLiteral: Int(UIInterfaceOrientation.landscapeLeft.rawValue))
//        baseUIConfigure.clAuthWindowModalTransitionStyle = NSNumber(integerLiteral: Int(UIModalTransitionStyle.crossDissolve.rawValue))

        baseUIConfigure.clNavigationBackgroundClear = NSNumber(booleanLiteral: true)
        baseUIConfigure.clNavigationBottomLineHidden = NSNumber(booleanLiteral: true)
        //    baseUIConfigure.clNavigationBackBtnImage = [UIImage imageNamed:@"矩形 124 拷贝"];
        
        //LOGO
        baseUIConfigure.clLogoImage = UIImage(named: "闪验logo2")!
            
        //PhoneNumber
        baseUIConfigure.clPhoneNumberColor = style2Color;
        baseUIConfigure.clPhoneNumberFont = UIFont(name: "PingFang-SC-Medium", size: 18.0*screenScale)!
        
        //LoginBtn
        baseUIConfigure.clLoginBtnText = "一键登录"
        baseUIConfigure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 15*screenScale)
        baseUIConfigure.clLoginBtnBgColor = style2Color;
        baseUIConfigure.clLoginBtnCornerRadius = NSNumber(floatLiteral: Double(5*screenScale))
        baseUIConfigure.clLoginBtnTextColor = UIColor.white
//        baseUIConfigure.clLoginBtnShadowColor = UIColor(red: 180/255.0, green: 190/255.0, blue: 254/255.0, alpha: 1)
//        baseUIConfigure.clLoginBtnshadowOpacity = NSNumber(floatLiteral: 0.8)
//        baseUIConfigure.clLoginBtnshadowOffset = NSValue(cgSize: CGSize(width: 5, height: 5))
//        baseUIConfigure.clLoginBtnMasksToBounds = NSNumber(booleanLiteral: false)
        
        //Privacy
        baseUIConfigure.clAppPrivacyFirst = ["闪验用户协议","https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html"]
        baseUIConfigure.clAppPrivacySecond = ["闪验隐私政策","https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html?from=singlemessage&isappinstalled=0"]
        
        baseUIConfigure.clAppPrivacyColor = [UIColor.lightGray,style2Color]
        baseUIConfigure.clAppPrivacyTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        baseUIConfigure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 11)
        baseUIConfigure.clAppPrivacyLineSpacing = NSNumber(value: 2);
        //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);
        
        //CheckBox
        //CheckBox
        baseUIConfigure.clCheckBoxHidden = NSNumber(booleanLiteral: false)
        baseUIConfigure.clCheckBoxValue = NSNumber(booleanLiteral: true)
        baseUIConfigure.clCheckBoxCheckedImage = UIImage(named: "checkboxround1")!
        baseUIConfigure.clCheckBoxUncheckedImage = UIImage(named: "checkboxround0-2")!
        baseUIConfigure.clCheckBoxImageEdgeInsets = NSValue(uiEdgeInsets: UIEdgeInsets(top: 4, left: 14, bottom: 10, right: 0))
        
        /**UITextView.textContainerInset 文字与TextView控件内边距 UIEdgeInset  eg.*/
//        baseUIConfigure.clAppPrivacyTextContainerInset = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 50)];
        baseUIConfigure.clAppPrivacyTextContainerInset = NSValue(uiEdgeInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right:50))

        
        //Slogan
        baseUIConfigure.clSloganTextColor = UIColor.lightGray
        baseUIConfigure.clSloganTextFont = UIFont.systemFont(ofSize: 11)
        baseUIConfigure.clSlogaTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
                
        //Loading-
        baseUIConfigure.clLoadingSize = NSValue(cgSize: CGSize(width: 60*screenScale, height: 60*screenScale))
        baseUIConfigure.clLoadingIndicatorStyle = NSNumber(integerLiteral: Int(UIActivityIndicatorView.Style.white.rawValue))
        baseUIConfigure.clLoadingTintColor = style2Color
        baseUIConfigure.clLoadingBackgroundColor = UIColor.white
        baseUIConfigure.clLoadingCornerRadius = NSNumber(floatLiteral: 5)
        
        
        baseUIConfigure.loadingView = { customAreaView in
            DispatchQueue.main.async {
                if let gifpath = Bundle.main.path(forResource:"loading", ofType:"gif"){
                    DispatchQueue.main.async {
                        let loadingView = AnimatedImageView()
                        customAreaView.addSubview(loadingView)
                        let url = URL(fileURLWithPath: gifpath)
//                        let provider = LocalFileImageDataProvider(fileURL: url)
                        loadingView.kf.setImage(with: KF.ImageResource(downloadURL: url))
                        
                        loadingView.snp.makeConstraints({ (make) in
                            make.center.equalTo(customAreaView)
                            make.width.height.equalTo(45*screenScale)
                        })
                    }
                }
            }
        }
        
        baseUIConfigure.customAreaView =  { customAreaView in
            let bg0 = UIImageView()
            let bg = UIImageView()
            customAreaView.addSubview(bg0)
            customAreaView.addSubview(bg)

            let otherLinkBtn = UIButton()
            otherLinkBtn.setTitle("其他方式登录", for: .normal)
            otherLinkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            otherLinkBtn.setTitleColor(UIColor.darkGray, for: .normal)
            customAreaView.addSubview(otherLinkBtn)
            
            otherLinkBtn.addTarget(self, action: #selector(self.otherWayLoginbtnClick(sender:)), for: .touchUpInside)
        
            //布局
            self.setSeylt0ContrainsOther(bg0: bg0, bg: bg, otherWay: otherLinkBtn, customView: customAreaView)
        }

        //layout 布局
        //布局-竖屏
        let clOrientationLayOutPortrait  = CLOrientationLayOut()
        
        clOrientationLayOutPortrait.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120*screenScale))
        clOrientationLayOutPortrait.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50*screenScale))
        clOrientationLayOutPortrait.clLayoutLogoCenterX = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutLogoTop = NSNumber(floatLiteral: Double(screenHeight_Portrait*0.2))
        
        clOrientationLayOutPortrait.clLayoutPhoneTop = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutLogoTop.floatValue + clOrientationLayOutPortrait.clLayoutLogoHeight.floatValue))
        clOrientationLayOutPortrait.clLayoutPhoneCenterX = (0)
        clOrientationLayOutPortrait.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(25*screenScale))
        clOrientationLayOutPortrait.clLayoutPhoneWidth = clOrientationLayOutPortrait.clLayoutLogoWidth
//        clOrientationLayOutPortrait.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape*0.5))
        
        clOrientationLayOutPortrait.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutPortrait.clLayoutSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutPortrait.clLayoutSloganTop =  NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutPhoneTop.floatValue +  clOrientationLayOutPortrait.clLayoutPhoneHeight.floatValue))
        
        
        clOrientationLayOutPortrait.clLayoutLoginBtnTop = NSNumber(floatLiteral: Double(screenHeight_Portrait*0.4 + 15*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(45*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnLeft = NSNumber(floatLiteral: Double(20*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnRight = NSNumber(floatLiteral: Double(-20*screenScale))
        
        clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyRight = NSNumber(floatLiteral: Double(-40*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = NSNumber(floatLiteral: Double(-160*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(40*screenScale))
        

        
        //布局-横屏
        let clOrientationLayOutLandscape = CLOrientationLayOut()
        
        clOrientationLayOutLandscape.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120*screenScale))
        clOrientationLayOutLandscape.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50*screenScale))
        clOrientationLayOutLandscape.clLayoutLogoCenterX = NSNumber(floatLiteral: -40)
        clOrientationLayOutLandscape.clLayoutLogoTop = NSNumber(floatLiteral: Double(40))
        
        clOrientationLayOutLandscape.clLayoutPhoneTop = NSNumber(floatLiteral: Double(clOrientationLayOutLandscape.clLayoutLogoTop.floatValue + clOrientationLayOutLandscape.clLayoutLogoHeight.floatValue))
        clOrientationLayOutLandscape.clLayoutPhoneCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(25*screenScale))
        clOrientationLayOutLandscape.clLayoutPhoneWidth = clOrientationLayOutLandscape.clLayoutLogoWidth
//        clOrientationLayOutLandscape.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape*0.5))

        
        clOrientationLayOutLandscape.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutLandscape.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutLandscape.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutLandscape.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutLandscape.clLayoutSloganCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutLandscape.clLayoutSloganTop =  NSNumber(floatLiteral: Double(clOrientationLayOutLandscape.clLayoutPhoneTop.floatValue +  clOrientationLayOutLandscape.clLayoutPhoneHeight.floatValue))
        
        clOrientationLayOutLandscape.clLayoutLoginBtnTop = NSNumber(floatLiteral: Double(screenHeight_Landscape*0.4 + 15*screenScale))
        clOrientationLayOutLandscape.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutLandscape.clLayoutLoginBtnCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutLoginBtnWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape * 0.5))

        clOrientationLayOutLandscape.clLayoutAppPrivacyCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutAppPrivacyBottom = (0)
        clOrientationLayOutLandscape.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutLandscape.clLayoutAppPrivacyWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape * 0.5))
        
        baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;
        baseUIConfigure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;
        
        return baseUIConfigure;
    }
    func setSeylt0ContrainsOther(bg0 :UIImageView, bg :UIImageView, otherWay: UIButton, customView :UIView){
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.width
            screenHeight_Landscape = UIScreen.main.bounds.height
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        bg0.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        if orientation == .portrait || orientation == .portraitUpsideDown{
            //竖屏
            bg0.image = UIImage(named: "720*1280竖屏背景")
            bg.image = UIImage(named: "竖屏上滑弹窗2")
            
            bg.snp.remakeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.bottom.equalTo(-40)
            })
            otherWay.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView)
                make.bottom.equalTo(-160*screenScale - 45*screenScale - 15 - 30*screenScale)
                make.width.equalTo(100)
                make.height.equalTo(45)
            })
        }else{
            bg0.image = UIImage(named: "720横屏背景")
            bg.image = UIImage(named: "闪电弹窗横屏侧滑")
            bg.snp.remakeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(-40)
            })
            otherWay.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView).offset(-40)
                make.bottom.equalTo(-45*screenScale - 15 - 30*screenScale)
                make.width.equalTo(100)
                make.height.equalTo(45)
            })
        }
    }
    func setSeylt0Contrains(bg0 :UIImageView, bg :UIImageView, wx :UIView, qq :UIView , wb :UIView, customView :UIView){
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.width
            screenHeight_Landscape = UIScreen.main.bounds.height
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        bg0.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        if orientation == .portrait || orientation == .portraitUpsideDown{
            //竖屏
            bg0.image = UIImage(named: "720*1280竖屏背景")
            bg.image = UIImage(named: "竖屏上滑弹窗2")
            
            bg.snp.remakeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.bottom.equalTo(-40)
            })
            qq.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView)
                make.bottom.equalTo(-160*screenScale - 45*screenScale - 15 - 30*screenScale)
                make.width.height.equalTo(35)
            })
            wx.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.right.equalTo(qq.snp.left).offset(-40)
            })
            wb.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.left.equalTo(qq.snp.right).offset(40)
            })
        }else{
            bg0.image = UIImage(named: "720横屏背景")
            bg.image = UIImage(named: "闪电弹窗横屏侧滑")
            bg.snp.remakeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(-40)
            })
            qq.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView).offset(-40)
                make.bottom.equalTo(-45*screenScale - 15 - 30*screenScale)
                make.width.height.equalTo(35)
            })
            wx.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.right.equalTo(qq.snp.left).offset(-40)
            })
            wb.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.left.equalTo(qq.snp.right).offset(40)
            })
        }
        
    }

    // MARK: - 横屏模式
    func configureStyle1(configureInstance: CLUIConfigure) -> CLUIConfigure {
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        let style2Color = UIColor.init(red: 33/255.0, green: 113/255.0, blue: 242/255.0, alpha: 1)
        
        let baseUIConfigure = configureInstance;
        
        baseUIConfigure.manualDismiss = NSNumber(booleanLiteral: true)

        baseUIConfigure.clAuthWindowModalPresentationStyle = NSNumber(integerLiteral: Int(UIModalPresentationStyle.fullScreen.rawValue))

        //横竖屏设置
        baseUIConfigure.shouldAutorotate = NSNumber(booleanLiteral: false)
        
        baseUIConfigure.supportedInterfaceOrientations = NSNumber(integerLiteral: Int(UIInterfaceOrientationMask.landscape.rawValue))
        baseUIConfigure.preferredInterfaceOrientationForPresentation = NSNumber(integerLiteral: Int(UIInterfaceOrientation.landscapeLeft.rawValue))
        
        baseUIConfigure.clNavigationBackgroundClear = NSNumber(booleanLiteral: true)
        baseUIConfigure.clNavigationBottomLineHidden = NSNumber(booleanLiteral: true)
        //    baseUIConfigure.clNavigationBackBtnImage = [UIImage imageNamed:@"矩形 124 拷贝"];
        
        //LOGO
        baseUIConfigure.clLogoImage = UIImage(named: "闪验logo2")!
        
        //PhoneNumber
        baseUIConfigure.clPhoneNumberColor = style2Color;
        baseUIConfigure.clPhoneNumberFont = UIFont(name: "PingFang-SC-Medium", size: 18.0*screenScale)!
        
        //LoginBtn
        baseUIConfigure.clLoginBtnText = "一键登录"
        baseUIConfigure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 15*screenScale)
        baseUIConfigure.clLoginBtnBgColor = style2Color;
        baseUIConfigure.clLoginBtnCornerRadius = NSNumber(floatLiteral: Double(5*screenScale))
        baseUIConfigure.clLoginBtnTextColor = UIColor.white
//        baseUIConfigure.clLoginBtnShadowColor = UIColor(red: 180/255.0, green: 190/255.0, blue: 254/255.0, alpha: 1)
//        baseUIConfigure.clLoginBtnshadowOpacity = NSNumber(floatLiteral: 0.8)
//        baseUIConfigure.clLoginBtnshadowOffset = NSValue(cgSize: CGSize(width: 5, height: 5))
//        baseUIConfigure.clLoginBtnMasksToBounds = NSNumber(booleanLiteral: false)
        
        //Privacy
        baseUIConfigure.clAppPrivacyFirst = ["闪验用户协议","https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html"]
        baseUIConfigure.clAppPrivacySecond = ["闪验隐私政策","https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html?from=singlemessage&isappinstalled=0"]
        
        baseUIConfigure.clAppPrivacyColor = [UIColor.lightGray,style2Color]
        baseUIConfigure.clAppPrivacyTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        baseUIConfigure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 11)
        //        baseUIConfigure.clAppPrivacyLineSpacing = @(2);
        //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);
        
        //CheckBox
        baseUIConfigure.clCheckBoxHidden = NSNumber(booleanLiteral: false)
        baseUIConfigure.clCheckBoxValue = NSNumber(booleanLiteral: true)
        baseUIConfigure.clCheckBoxCheckedImage = UIImage(named: "checkboxround1")!
        baseUIConfigure.clCheckBoxUncheckedImage = UIImage(named: "checkboxround0-2")!
        baseUIConfigure.clCheckBoxImageEdgeInsets = NSValue(uiEdgeInsets: UIEdgeInsets(top: 8, left: 14, bottom: 6, right: 0))
        
        //Slogan
        baseUIConfigure.clSloganTextColor = UIColor.lightGray
        baseUIConfigure.clSloganTextFont = UIFont.systemFont(ofSize: 11)
        baseUIConfigure.clSlogaTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        
        //Loading-
        baseUIConfigure.clLoadingSize = NSValue(cgSize: CGSize(width: 60*screenScale, height: 60*screenScale))
        baseUIConfigure.clLoadingIndicatorStyle = NSNumber(integerLiteral: Int(UIActivityIndicatorView.Style.white.rawValue))
        baseUIConfigure.clLoadingTintColor = style2Color
        baseUIConfigure.clLoadingBackgroundColor = UIColor.white
        baseUIConfigure.clLoadingCornerRadius = NSNumber(floatLiteral: 5)
        
        baseUIConfigure.loadingView = { customAreaView in
            DispatchQueue.main.async {
                let hud = PKHUD.init()
                hud.dimsBackground  = false
                hud.contentView = PKHUDSystemActivityIndicatorView()
                hud.show(onView: customAreaView)
            }
        }
        
        baseUIConfigure.customAreaView =  {customAreaView in
            let bg0 = UIImageView()
            let bg = UIImageView()
            customAreaView.addSubview(bg0)
            customAreaView.addSubview(bg)
            
            let otherLinkBtn = UIButton()
            otherLinkBtn.setTitle("其他方式登录", for: .normal)
            otherLinkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            otherLinkBtn.setTitleColor(UIColor.darkGray, for: .normal)
            customAreaView.addSubview(otherLinkBtn)
            otherLinkBtn.addTarget(self, action: #selector(self.otherWayLoginbtnClick(sender:)), for: .touchUpInside)

            //布局
            self.setSeylt1ContrainsOther(bg0: bg0, bg: bg, otherWay: otherLinkBtn, customView: customAreaView)
            
        }
        
        //layout 布局
        //布局-竖屏
        let clOrientationLayOutPortrait  = CLOrientationLayOut()
        
        clOrientationLayOutPortrait.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120*screenScale))
        clOrientationLayOutPortrait.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50*screenScale))
        clOrientationLayOutPortrait.clLayoutLogoCenterX = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutLogoTop = NSNumber(floatLiteral: Double(screenHeight_Portrait*0.2))
        
        clOrientationLayOutPortrait.clLayoutPhoneTop = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutLogoTop.floatValue + clOrientationLayOutPortrait.clLayoutLogoHeight.floatValue))
        clOrientationLayOutPortrait.clLayoutPhoneCenterX = (0)
        clOrientationLayOutPortrait.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(25*screenScale))
        clOrientationLayOutPortrait.clLayoutPhoneWidth = clOrientationLayOutPortrait.clLayoutLogoWidth
        //        clOrientationLayOutPortrait.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape*0.5))
        
        clOrientationLayOutPortrait.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutPortrait.clLayoutSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutPortrait.clLayoutSloganTop =  NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutPhoneTop.floatValue +  clOrientationLayOutPortrait.clLayoutPhoneHeight.floatValue))
        
        
        clOrientationLayOutPortrait.clLayoutLoginBtnTop = NSNumber(floatLiteral: Double(screenHeight_Portrait*0.4 + 15*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(45*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnLeft = NSNumber(floatLiteral: Double(20*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnRight = NSNumber(floatLiteral: Double(-20*screenScale))
        
        clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyRight = NSNumber(floatLiteral: Double(-40*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = NSNumber(floatLiteral: Double(-160*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(60*screenScale))
        
        
        
        //布局-横屏
        let clOrientationLayOutLandscape = CLOrientationLayOut()
        
        clOrientationLayOutLandscape.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120*screenScale))
        clOrientationLayOutLandscape.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50*screenScale))
        clOrientationLayOutLandscape.clLayoutLogoCenterX = NSNumber(floatLiteral: -40)
        clOrientationLayOutLandscape.clLayoutLogoTop = NSNumber(floatLiteral: Double(40))
        
        clOrientationLayOutLandscape.clLayoutPhoneTop = NSNumber(floatLiteral: Double(clOrientationLayOutLandscape.clLayoutLogoTop.floatValue + clOrientationLayOutLandscape.clLayoutLogoHeight.floatValue))
        clOrientationLayOutLandscape.clLayoutPhoneCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(25*screenScale))
        clOrientationLayOutLandscape.clLayoutPhoneWidth = clOrientationLayOutLandscape.clLayoutLogoWidth
        //        clOrientationLayOutLandscape.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape*0.5))
        
        clOrientationLayOutLandscape.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutLandscape.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutLandscape.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutLandscape.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutLandscape.clLayoutSloganCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutLandscape.clLayoutSloganTop =  NSNumber(floatLiteral: Double(clOrientationLayOutLandscape.clLayoutPhoneTop.floatValue +  clOrientationLayOutLandscape.clLayoutPhoneHeight.floatValue))
        
        clOrientationLayOutLandscape.clLayoutLoginBtnTop = NSNumber(floatLiteral: Double(screenHeight_Landscape*0.4 + 15*screenScale))
        clOrientationLayOutLandscape.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutLandscape.clLayoutLoginBtnCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutLoginBtnWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape * 0.5))
        
        clOrientationLayOutLandscape.clLayoutAppPrivacyCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutAppPrivacyBottom = (0)
        clOrientationLayOutLandscape.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(60*screenScale))
        clOrientationLayOutLandscape.clLayoutAppPrivacyWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape * 0.5))
        
        baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutLandscape;
        baseUIConfigure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;
        
        return baseUIConfigure;
    }
    func setSeylt1ContrainsOther(bg0 :UIImageView, bg :UIImageView, otherWay: UIButton, customView :UIView){
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.width
            screenHeight_Landscape = UIScreen.main.bounds.height
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        bg0.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        if orientation == .portrait || orientation == .portraitUpsideDown{
            //竖屏
            bg0.image = UIImage(named: "720*1280竖屏背景")
            bg.image = UIImage(named: "竖屏上滑弹窗2")
            
            bg.snp.remakeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.bottom.equalTo(-40)
            })
            otherWay.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView)
                make.bottom.equalTo(-160*screenScale - 45*screenScale - 15 - 30*screenScale)
                make.width.equalTo(100)
                make.height.equalTo(45)
            })
        }else{
            bg0.image = UIImage(named: "720横屏背景")
            bg.image = UIImage(named: "闪电弹窗横屏侧滑")
            bg.snp.remakeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(-40)
            })
            otherWay.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView).offset(-40)
                make.bottom.equalTo(-45*screenScale - 15 - 30*screenScale)
                make.width.equalTo(100)
                make.height.equalTo(45)
            })
        }
    }
    func setSeylt1Contrains(bg0 :UIImageView, bg :UIImageView, wx :UIView, qq :UIView , wb :UIView, customView :UIView){
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.width
            screenHeight_Landscape = UIScreen.main.bounds.height
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        bg0.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        if orientation == .portrait || orientation == .portraitUpsideDown{
            //竖屏
            bg0.image = UIImage(named: "720*1280竖屏背景")
            bg.image = UIImage(named: "竖屏上滑弹窗2")
            
            bg.snp.remakeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.bottom.equalTo(-40)
            })
            qq.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView)
                make.bottom.equalTo(-160*screenScale - 45*screenScale - 15 - 30*screenScale)
                make.width.height.equalTo(35)
            })
            wx.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.right.equalTo(qq.snp.left).offset(-40)
            })
            wb.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.left.equalTo(qq.snp.right).offset(40)
            })
        }else{
            bg0.image = UIImage(named: "720横屏背景")
            bg.image = UIImage(named: "闪电弹窗横屏侧滑")
            bg.snp.remakeConstraints({ (make) in
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(-40)
            })
            qq.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView).offset(-40)
                make.bottom.equalTo(-45*screenScale - 15 - 30*screenScale)
                make.width.height.equalTo(35)
            })
            wx.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.right.equalTo(qq.snp.left).offset(-40)
            })
            wb.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.left.equalTo(qq.snp.right).offset(40)
            })
        }
    }
    
    // MARK: - 弹窗模式
    func configureStyle3(configureInstance: CLUIConfigure) -> CLUIConfigure {
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        let style2Color = UIColor.init(red: 33/255.0, green: 113/255.0, blue: 242/255.0, alpha: 1)
        
        let baseUIConfigure = configureInstance;
        
        baseUIConfigure.manualDismiss = NSNumber(booleanLiteral: true)

        //横竖屏设置
        baseUIConfigure.shouldAutorotate = NSNumber(booleanLiteral: false)
        
        baseUIConfigure.supportedInterfaceOrientations = NSNumber(integerLiteral: Int(UIInterfaceOrientationMask.all.rawValue))
        //        baseUIConfigure.preferredInterfaceOrientationForPresentation = NSNumber(integerLiteral: Int(UIInterfaceOrientation.landscapeLeft.rawValue))
        
        baseUIConfigure.clAuthTypeUseWindow = NSNumber(booleanLiteral: true)
        baseUIConfigure.clAuthWindowCornerRadius = NSNumber(integerLiteral: 10)
        //    baseUIConfigure.clAuthWindowModalTransitionStyle = @(UIModalTransitionStyleCoverVertical);
        
        baseUIConfigure.clNavigationBackgroundClear = NSNumber(booleanLiteral: true)
        baseUIConfigure.clNavigationBottomLineHidden = NSNumber(booleanLiteral: true)
        //    baseUIConfigure.clNavigationBackBtnImage = [UIImage imageNamed:@"矩形 124 拷贝"];
        baseUIConfigure.clNavBackBtnAlimentRight = NSNumber(booleanLiteral: true)
        
        //LOGO
        baseUIConfigure.clLogoImage = UIImage(named: "闪验logo2")!
        
        //PhoneNumber
        baseUIConfigure.clPhoneNumberColor = style2Color;
        baseUIConfigure.clPhoneNumberFont = UIFont(name: "PingFang-SC-Medium", size: 18.0*screenScale)!
        
        //LoginBtn
        baseUIConfigure.clLoginBtnText = "一键登录"
        baseUIConfigure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 15*screenScale)
        baseUIConfigure.clLoginBtnBgColor = style2Color;
        baseUIConfigure.clLoginBtnCornerRadius = NSNumber(floatLiteral: Double(5*screenScale))
        baseUIConfigure.clLoginBtnTextColor = UIColor.white
//        baseUIConfigure.clLoginBtnShadowColor = UIColor(red: 180/255.0, green: 190/255.0, blue: 254/255.0, alpha: 1)
//        baseUIConfigure.clLoginBtnshadowOpacity = NSNumber(floatLiteral: 0.8)
//        baseUIConfigure.clLoginBtnshadowOffset = NSValue(cgSize: CGSize(width: 5, height: 5))
//        baseUIConfigure.clLoginBtnMasksToBounds = NSNumber(booleanLiteral: true)
        
        //Privacy
        baseUIConfigure.clAppPrivacyFirst = ["闪验用户协议","https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html"]
        baseUIConfigure.clAppPrivacySecond = ["闪验隐私政策","https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html?from=singlemessage&isappinstalled=0"]
        
        baseUIConfigure.clAppPrivacyColor = [UIColor.lightGray,style2Color]
        baseUIConfigure.clAppPrivacyTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        baseUIConfigure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 10)
        baseUIConfigure.clAppPrivacyLineSpacing = NSNumber(value: 2.0);
        //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);
        
        //CheckBox
        baseUIConfigure.clCheckBoxHidden = NSNumber(booleanLiteral: false)
        baseUIConfigure.clCheckBoxValue = NSNumber(booleanLiteral: true)
        baseUIConfigure.clCheckBoxCheckedImage = UIImage(named: "checkboxround1")!
        baseUIConfigure.clCheckBoxUncheckedImage = UIImage(named: "checkboxround0")!
        baseUIConfigure.clCheckBoxImageEdgeInsets = NSValue(uiEdgeInsets: UIEdgeInsets(top: 8, left: 14, bottom: 6, right: 0))
        
        /**⚠️⚠️⚠️协议勾选框 设置CheckBox对齐后的偏移量,相对于对齐后的中心距离在当前垂直方向上的偏移*/
        baseUIConfigure.clCheckBoxVerticalAlignmentOffset = NSNumber(value: -0.7)
        
        //Slogan
        baseUIConfigure.clSloganTextColor = UIColor.lightGray
        baseUIConfigure.clSloganTextFont = UIFont.systemFont(ofSize: 11)
        baseUIConfigure.clSlogaTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        
        //Loading-
        baseUIConfigure.clLoadingSize = NSValue(cgSize: CGSize(width: 60*screenScale, height: 60*screenScale))
        baseUIConfigure.clLoadingIndicatorStyle = NSNumber(integerLiteral: Int(UIActivityIndicatorView.Style.white.rawValue))
        baseUIConfigure.clLoadingTintColor = style2Color
        baseUIConfigure.clLoadingBackgroundColor = UIColor.white
        baseUIConfigure.clLoadingCornerRadius = NSNumber(floatLiteral: 5)
        
        baseUIConfigure.clAuthWindowPresentingAnimate = NSNumber(booleanLiteral: false)
        
        baseUIConfigure.loadingView = { customAreaView in
            DispatchQueue.main.async {
                if let gifpath = Bundle.main.path(forResource:"loading", ofType:"gif"){
                    DispatchQueue.main.async {
                        let loadingView = AnimatedImageView()
//                        loadingView.layer.cornerRadius = 30
//                        loadingView.layer.masksToBounds = true
//                        loadingView.backgroundColor = UIColor.white
                        customAreaView.addSubview(loadingView)
                        loadingView.snp.makeConstraints({ (make) in
                            make.center.equalTo(customAreaView)
                            make.width.height.equalTo(45)
                        })
                        let url = URL(fileURLWithPath: gifpath)
//                        let provider = LocalFileImageDataProvider(fileURL: url)
                        loadingView.kf.setImage(with: KF.ImageResource(downloadURL: url))
                    }
                }
            }
        }
        
        baseUIConfigure.customAreaView =  { customAreaView in
            
            customAreaView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
            
            let bg0 = UIImageView()
            let bg = UIImageView()
//            customAreaView.addSubview(bg0)
//            customAreaView.addSubview(bg)
            
            let otherLinkBtn = UIButton()
            otherLinkBtn.setTitle("其他方式登录", for: .normal)
            otherLinkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            otherLinkBtn.setTitleColor(UIColor.darkGray, for: .normal)
            customAreaView.addSubview(otherLinkBtn)
            otherLinkBtn.addTarget(self, action: #selector(self.otherWayLoginbtnClick(sender:)), for: .touchUpInside)

            //布局
            self.setSeylt3ContrainsOther(bg0: bg0, bg: bg, otherWay: otherLinkBtn, customView: customAreaView)

        }
        
        //layout 布局
        //布局-竖屏
        let clOrientationLayOutPortrait  = CLOrientationLayOut()
        
        //窗口
        clOrientationLayOutPortrait.clAuthWindowOrientationWidth = NSNumber(floatLiteral: Double(screenWidth_Portrait * 0.8))
        clOrientationLayOutPortrait.clAuthWindowOrientationHeight = NSNumber(floatLiteral: Double(screenHeight_Portrait * 0.5))
        clOrientationLayOutPortrait.clAuthWindowOrientationCenter = NSValue(cgPoint: CGPoint(x: screenWidth_Portrait*0.5, y: screenHeight_Portrait*0.5))
        
        clOrientationLayOutPortrait.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120*screenScale))
        clOrientationLayOutPortrait.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50*screenScale))
        clOrientationLayOutPortrait.clLayoutLogoCenterX = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutLogoTop = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clAuthWindowOrientationHeight.floatValue*0.15))
        
        clOrientationLayOutPortrait.clLayoutPhoneTop = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutLogoTop.floatValue + clOrientationLayOutPortrait.clLayoutLogoHeight.floatValue))
        clOrientationLayOutPortrait.clLayoutPhoneCenterX = (0)
        clOrientationLayOutPortrait.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(25*screenScale))
        clOrientationLayOutPortrait.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Portrait*0.8))
        
        clOrientationLayOutPortrait.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutPortrait.clLayoutSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutPortrait.clLayoutSloganTop =  NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutPhoneTop.floatValue +  clOrientationLayOutPortrait.clLayoutPhoneHeight.floatValue))
        
        
        clOrientationLayOutPortrait.clLayoutLoginBtnTop = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clAuthWindowOrientationHeight.floatValue*0.4 + Float(15*screenScale)))
        clOrientationLayOutPortrait.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(45*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnLeft = NSNumber(floatLiteral: Double(20*screenScale))
        clOrientationLayOutPortrait.clLayoutLoginBtnRight = NSNumber(floatLiteral: Double(-20*screenScale))
        
        clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyRight = NSNumber(floatLiteral: Double(-40*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = NSNumber(floatLiteral: Double(0*screenScale))
        clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(40*screenScale))
        
        
        
        //布局-横屏
        let clOrientationLayOutLandscape = CLOrientationLayOut()
        
        clOrientationLayOutLandscape.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120*screenScale))
        clOrientationLayOutLandscape.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50*screenScale))
        clOrientationLayOutLandscape.clLayoutLogoCenterX = NSNumber(floatLiteral: -40)
        clOrientationLayOutLandscape.clLayoutLogoTop = NSNumber(floatLiteral: Double(40))
        
        clOrientationLayOutLandscape.clLayoutPhoneTop = NSNumber(floatLiteral: Double(clOrientationLayOutLandscape.clLayoutLogoTop.floatValue + clOrientationLayOutLandscape.clLayoutLogoHeight.floatValue))
        clOrientationLayOutLandscape.clLayoutPhoneCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(25*screenScale))
        clOrientationLayOutLandscape.clLayoutPhoneWidth = clOrientationLayOutLandscape.clLayoutLogoWidth
        //        clOrientationLayOutLandscape.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape*0.5))
        
        clOrientationLayOutLandscape.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutLandscape.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutLandscape.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutLandscape.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutLandscape.clLayoutSloganCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutLandscape.clLayoutSloganTop =  NSNumber(floatLiteral: Double(clOrientationLayOutLandscape.clLayoutPhoneTop.floatValue +  clOrientationLayOutLandscape.clLayoutPhoneHeight.floatValue))
        
        clOrientationLayOutLandscape.clLayoutLoginBtnTop = NSNumber(floatLiteral: Double(screenHeight_Landscape*0.4 + 15*screenScale))
        clOrientationLayOutLandscape.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutLandscape.clLayoutLoginBtnCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutLoginBtnWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape * 0.5))
        
        clOrientationLayOutLandscape.clLayoutAppPrivacyCenterX = clOrientationLayOutLandscape.clLayoutLogoCenterX
        clOrientationLayOutLandscape.clLayoutAppPrivacyBottom = (0)
        clOrientationLayOutLandscape.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(40*screenScale))
        clOrientationLayOutLandscape.clLayoutAppPrivacyWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape * 0.5))
        
        baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;
        baseUIConfigure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;
        
        return baseUIConfigure;
    }
    func setSeylt3ContrainsOther(bg0 :UIImageView, bg :UIImageView, otherWay: UIButton, customView :UIView){
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.width
            screenHeight_Landscape = UIScreen.main.bounds.height
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        if orientation == .portrait || orientation == .portraitUpsideDown{
            //竖屏
            otherWay.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView)
                make.bottom.equalTo(-45*screenScale - 15 - 30*screenScale)
                make.width.equalTo(100)
                make.height.equalTo(45)
            })
        }else{
            otherWay.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView).offset(-40)
                make.bottom.equalTo(-45*screenScale - 15 - 10*screenScale)
                make.width.equalTo(100)
                make.height.equalTo(45)
            })
        }
    }
    func setSeylt3Contrains(bg0 :UIImageView, bg :UIImageView, wx :UIView, qq :UIView , wb :UIView, customView :UIView){
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.width
            screenHeight_Landscape = UIScreen.main.bounds.height
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
//        bg0.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets.zero)
//        }
        if orientation == .portrait || orientation == .portraitUpsideDown{
            //竖屏
//            bg0.image = UIImage(named: "720*1280竖屏背景")
//            bg.image = UIImage(named: "竖屏上滑弹窗2")
            
//            bg.snp.remakeConstraints({ (make) in
//                make.left.top.right.equalTo(0)
//                make.bottom.equalTo(-40)
//            })
            qq.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView)
                make.bottom.equalTo(-45*screenScale - 15 - 30*screenScale)
                make.width.height.equalTo(35)
            })
            wx.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.right.equalTo(qq.snp.left).offset(-40)
            })
            wb.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.left.equalTo(qq.snp.right).offset(40)
            })
        }else{
//            bg0.image = UIImage(named: "720横屏背景")
//            bg.image = UIImage(named: "闪电弹窗横屏侧滑")
//            bg.snp.remakeConstraints({ (make) in
//                make.left.top.bottom.equalTo(0)
//                make.right.equalTo(-40)
//            })
            qq.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(customView).offset(-40)
                make.bottom.equalTo(-45*screenScale - 15 - 10*screenScale)
                make.width.height.equalTo(35)
            })
            wx.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.right.equalTo(qq.snp.left).offset(-40)
            })
            wb.snp.remakeConstraints({ (make) in
                make.centerY.width.height.equalTo(qq)
                make.left.equalTo(qq.snp.right).offset(40)
            })
        }
        
    }

// MARK: - 视频背景沉浸模式
    func configureStyleYinKe(configureInstance: CLUIConfigure) -> CLUIConfigure {
        let screenWidth_Portrait : CGFloat
        let screenHeight_Portrait : CGFloat
        let screenWidth_Landscape : CGFloat
        let screenHeight_Landscape : CGFloat

        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown{
            screenWidth_Portrait = UIScreen.main.bounds.width
            screenHeight_Portrait = UIScreen.main.bounds.height
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }else{
            screenWidth_Portrait = UIScreen.main.bounds.height
            screenHeight_Portrait = UIScreen.main.bounds.width
            screenWidth_Landscape = UIScreen.main.bounds.height
            screenHeight_Landscape = UIScreen.main.bounds.width
        }
        
        var screenScale = (UIScreen.main.bounds.width/375.0)
        if (screenScale > 1) {
            screenScale = 1
        }
        
        let style2Color = UIColor(red: 13/255.0, green: 79/255.0, blue: 254/255.0, alpha: 1)
        
        let baseUIConfigure = configureInstance;
        baseUIConfigure.manualDismiss = NSNumber(booleanLiteral: true)

        //横竖屏设置
        baseUIConfigure.shouldAutorotate = NSNumber(booleanLiteral: true)
        
        baseUIConfigure.supportedInterfaceOrientations = NSNumber(integerLiteral: Int(UIInterfaceOrientationMask.portrait.rawValue))
//        baseUIConfigure.preferredInterfaceOrientationForPresentation = NSNumber(integerLiteral: Int(UIInterfaceOrientation.landscapeLeft.rawValue))
//        baseUIConfigure.clAuthWindowModalTransitionStyle = NSNumber(integerLiteral: Int(UIModalTransitionStyle.crossDissolve.rawValue))
        
        baseUIConfigure.clPreferredStatusBarStyle = NSNumber(integerLiteral: Int(UIStatusBarStyle.lightContent.rawValue))
        baseUIConfigure.clNavigationBarStyle = NSNumber(integerLiteral: Int(UIBarStyle.black.rawValue))
        baseUIConfigure.clNavigationBackgroundClear = NSNumber(booleanLiteral: true)
        baseUIConfigure.clNavigationBottomLineHidden = NSNumber(booleanLiteral: true)
        baseUIConfigure.clNavigationBackBtnImage = UIImage(named: "nav_button_white")!
        
        baseUIConfigure.clNavigationLeftControl = UIBarButtonItem(image: UIImage(named: "nav_button_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(customNavLeftItemClick(sender:)))
        
        //LOGO
//        baseUIConfigure.clLogoImage = UIImage(named: "闪验logo2")!
        baseUIConfigure.clLogoHiden = NSNumber(booleanLiteral: true)
        
        //PhoneNumber
        baseUIConfigure.clPhoneNumberColor = UIColor.white
        baseUIConfigure.clPhoneNumberFont = UIFont.systemFont(ofSize: 20)
        
        
        //LoginBtn
        baseUIConfigure.clLoginBtnText = "一键登录"
        baseUIConfigure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 13)
        baseUIConfigure.clLoginBtnBgColor = style2Color
        baseUIConfigure.clLoginBtnCornerRadius = NSNumber(floatLiteral: Double(20))
        baseUIConfigure.clLoginBtnTextColor = UIColor.white
//        baseUIConfigure.clLoginBtnShadowColor = UIColor(red: 180/255.0, green: 190/255.0, blue: 254/255.0, alpha: 1)
//        baseUIConfigure.clLoginBtnshadowOpacity = NSNumber(floatLiteral: 0.8)
//        baseUIConfigure.clLoginBtnshadowOffset = NSValue(cgSize: CGSize(width: 5, height: 5))
//        baseUIConfigure.clLoginBtnMasksToBounds = NSNumber(booleanLiteral: false)
        
        //Privacy
        baseUIConfigure.clAppPrivacyFirst = ["闪验用户协议","https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html"]
        baseUIConfigure.clAppPrivacySecond = ["闪验隐私政策","https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html?from=singlemessage&isappinstalled=0"]
        
        baseUIConfigure.clAppPrivacyColor = [UIColor.darkGray,UIColor.lightGray]
        baseUIConfigure.clAppPrivacyTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        baseUIConfigure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 10)
        //        baseUIConfigure.clAppPrivacyLineSpacing = @(2);
        //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);
        
        //CheckBox
        //CheckBox
        baseUIConfigure.clCheckBoxHidden = NSNumber(booleanLiteral: true)
        baseUIConfigure.clCheckBoxValue = NSNumber(booleanLiteral: true)
        baseUIConfigure.clCheckBoxCheckedImage = UIImage(named: "checkboxround1")!
        baseUIConfigure.clCheckBoxUncheckedImage = UIImage(named: "checkboxround0-2")!
        baseUIConfigure.clCheckBoxSize = NSValue.init(cgSize: CGSize(width: 40, height: 40))
        baseUIConfigure.clCheckBoxImageEdgeInsets = NSValue(uiEdgeInsets: UIEdgeInsets(top: 8, left: 14, bottom: 6, right: 0))
      
        //Slogan
        baseUIConfigure.clSloganTextColor = UIColor.darkGray
        baseUIConfigure.clSloganTextFont = UIFont.systemFont(ofSize: 10)
        baseUIConfigure.clSlogaTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))
        
//        //shanyanSlogan
//        baseUIConfigure.clShanYanSloganTextColor = style2Color
//        baseUIConfigure.clShanYanSloganTextFont = UIFont.systemFont(ofSize: 10)
//        baseUIConfigure.clShanYanSloganTextAlignment = NSNumber(integerLiteral: Int(NSTextAlignment.center.rawValue))

        //Loading-
        baseUIConfigure.clLoadingSize = NSValue(cgSize: CGSize(width: 60*screenScale, height: 60*screenScale))
        baseUIConfigure.clLoadingIndicatorStyle = NSNumber(integerLiteral: Int(UIActivityIndicatorView.Style.white.rawValue))
        baseUIConfigure.clLoadingTintColor = style2Color
        baseUIConfigure.clLoadingBackgroundColor = UIColor.white
        baseUIConfigure.clLoadingCornerRadius = NSNumber(floatLiteral: 5)
        
        baseUIConfigure.clAuthTypeUseWindow = NSNumber(booleanLiteral: true)
//        baseUIConfigure.clAuthWindowModalTransitionStyle = NSNumber(integerLiteral: UIModalTransitionStyle.crossDissolve.rawValue)
        
        baseUIConfigure.loadingView = { customAreaView in
            DispatchQueue.main.async {
                if let gifpath = Bundle.main.path(forResource:"loading", ofType:"gif"){
                    let loadingView = AnimatedImageView()
                    customAreaView.addSubview(loadingView)
                    let url = URL(fileURLWithPath: gifpath)
//                        let provider = LocalFileImageDataProvider(fileURL: url)
                    loadingView.kf.setImage(with: KF.ImageResource(downloadURL: url))
                    
                    loadingView.snp.makeConstraints({ (make) in
                        make.center.equalTo(customAreaView)
                        make.width.height.equalTo(45*screenScale)
                    })
                }
            }
        }
        
   

        //layout 布局
        //布局-竖屏
        let clOrientationLayOutPortrait  = CLOrientationLayOut()
        
        clOrientationLayOutPortrait.clAuthWindowOrientationOrigin = NSValue(cgPoint: CGPoint.zero)
        clOrientationLayOutPortrait.clAuthWindowOrientationWidth = NSNumber(floatLiteral: Double(screenWidth_Portrait))
        clOrientationLayOutPortrait.clAuthWindowOrientationHeight = NSNumber(floatLiteral: Double(screenHeight_Portrait))
        
//        clOrientationLayOutPortrait.clLayoutLogoWidth = NSNumber(floatLiteral: Double(120))
//        clOrientationLayOutPortrait.clLayoutLogoHeight = NSNumber(floatLiteral: Double(50))
//        clOrientationLayOutPortrait.clLayoutLogoCenterX = NSNumber(floatLiteral: 0)
//        clOrientationLayOutPortrait.clLayoutLogoTop = NSNumber(floatLiteral: Double(screenHeight_Portrait*0.2))

        
        clOrientationLayOutPortrait.clLayoutShanYanSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutShanYanSloganHeight = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutShanYanSloganWidth = NSNumber(floatLiteral: 0)

        clOrientationLayOutPortrait.clLayoutSloganLeft = (0);
        clOrientationLayOutPortrait.clLayoutSloganRight = (0);
        clOrientationLayOutPortrait.clLayoutSloganHeight = NSNumber(floatLiteral: 15)
        clOrientationLayOutPortrait.clLayoutSloganBottom =  NSNumber(floatLiteral: -15)
        
        clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = NSNumber(floatLiteral: Double(40))
        clOrientationLayOutPortrait.clLayoutAppPrivacyRight = NSNumber(floatLiteral: Double(-40))
        clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = NSNumber(floatLiteral: clOrientationLayOutPortrait.clLayoutSloganBottom.doubleValue - clOrientationLayOutPortrait.clLayoutSloganHeight.doubleValue)
        clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = NSNumber(floatLiteral: Double(40))

        clOrientationLayOutPortrait.clLayoutLoginBtnCenterX = NSNumber(floatLiteral: 0)
        clOrientationLayOutPortrait.clLayoutLoginBtnBottom = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutAppPrivacyBottom.floatValue - clOrientationLayOutPortrait.clLayoutAppPrivacyHeight.floatValue - Float(110 * screenScale)))
        clOrientationLayOutPortrait.clLayoutLoginBtnHeight = NSNumber(floatLiteral: Double(40))
        clOrientationLayOutPortrait.clLayoutLoginBtnWidth = NSNumber(floatLiteral: Double(screenWidth_Portrait*0.7))
        
        clOrientationLayOutPortrait.clLayoutPhoneBottom = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutLoginBtnBottom.floatValue - clOrientationLayOutPortrait.clLayoutLoginBtnHeight.floatValue - 15))
        clOrientationLayOutPortrait.clLayoutPhoneCenterX = (0)
        clOrientationLayOutPortrait.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(40))
        clOrientationLayOutPortrait.clLayoutPhoneRight = NSNumber(floatLiteral: Double(-screenWidth_Portrait*0.15))
        clOrientationLayOutPortrait.clLayoutPhoneLeft = NSNumber(floatLiteral: Double(screenWidth_Portrait*0.15 + 70))

//        clOrientationLayOutPortrait.clLayoutPhoneBottom = NSNumber(floatLiteral: Double(clOrientationLayOutPortrait.clLayoutLoginBtnBottom.floatValue - clOrientationLayOutPortrait.clLayoutLoginBtnHeight.floatValue - 15))
//        clOrientationLayOutPortrait.clLayoutPhoneCenterX = (0)
//        clOrientationLayOutPortrait.clLayoutPhoneHeight = NSNumber(floatLiteral: Double(40))
//        clOrientationLayOutPortrait.clLayoutPhoneWidth = clOrientationLayOutPortrait.clLayoutLoginBtnWidth
        
//        clOrientationLayOutPortrait.clLayoutPhoneWidth = NSNumber(floatLiteral: Double(screenWidth_Landscape*0.5))
        
        
        baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;
        
        
        let clLayoutLoginBtnBottom = clOrientationLayOutPortrait.clLayoutLoginBtnBottom.floatValue
        baseUIConfigure.customAreaView =  { customAreaView in
            
            customAreaView.backgroundColor = UIColor.clear
            
            let otherLinkBtn = UIButton()
            otherLinkBtn.semanticContentAttribute = .forceRightToLeft//iOS9 available
            otherLinkBtn.setTitle("其他手机号登录 ", for: .normal)
            otherLinkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            otherLinkBtn.setTitleColor(UIColor.white, for: .normal)
            customAreaView.addSubview(otherLinkBtn)
            otherLinkBtn.setImage(UIImage(named: "goto"), for: .normal)
            otherLinkBtn.addTarget(self, action: #selector(self.otherWayLoginbtnClick(sender:)), for: .touchUpInside)

            //相对一键登录按钮布局
            otherLinkBtn.snp.makeConstraints { (maker) in
                maker.width.equalTo(screenWidth_Portrait*0.7)
                maker.centerX.equalToSuperview()
                maker.height.equalTo(30)
                maker.bottom.equalTo(clLayoutLoginBtnBottom + 40)
            }

            otherLinkBtn.hero.modifiers = [.translate(x: 0, y: 20, z: 0),.fade]

        }
        
        return baseUIConfigure;
    }

    
    // MARK: - otherWayLoginbtnClick
    @objc func otherWayLoginbtnClick(sender: UIButton){
        if let delegate = self.shanYanConfigureMakerDelegate {
            delegate.shanYanConfigureOtherWayClick(sender: sender)
        }
    }
    @objc func customNavLeftItemClick(sender: UIButton){
        if let delegate = self.shanYanConfigureMakerDelegate {
            delegate.customNavLeftItemClick(sender: sender)
        }
    }
}
