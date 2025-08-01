//
//  ShanYanCustomLoginViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2020/1/6.
//  Copyright © 2020 wanglijun. All rights reserved.
//

import UIKit
import AVFoundation
import CL_ShanYanSDK
import PKHUD
import SwiftyJSON
import Hero

class ShanYanCustomLoginViewController: UIViewController,ShanYanCallBack,ShanYanConfigureMakerDelegate,CLShanYanSDKManagerDelegate {
    
    var player : AVPlayer?
    
    var weixinLogin : UIButton!
    var shanYanLogin : UIButton!
    var label : UILabel!
    
    
    var authPageTopViewController: UIViewController?

    var phoneLabel : UILabel?
    var loginButton : UIButton?
    var appPrivicy : UILabel?
    var slogon : UILabel?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
//            self.customBackGroundView.isHidden = false
//        }, completion: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
            
        self.hero.isEnabled = true

        let preLoginStartTime = Date().timeIntervalSince1970
        CLShanYanSDKManager.preGetPhonenumber { (completeResult) in
            UserDefaults.standard.set(Date().timeIntervalSince1970 - preLoginStartTime, forKey: "preLoginCost")
            UserDefaults.standard.synchronize()
        }
        
        if let path = Bundle.main.path(forResource: "颜色遮罩_x264", ofType: "mp4"){
            let item = AVPlayerItem(url: URL(fileURLWithPath: path))
            player = AVPlayer(playerItem: item)
            player?.volume = 0
            let layerView = ShanYanVideoPlayerView(frame: UIScreen.main.bounds)
            layerView.backgroundColor = UIColor.white
            self.view.addSubview(layerView)
            layerView.snp.makeConstraints { (maker) in
                maker.left.top.bottom.right.equalTo(0)
            }
            if let playerLayer = layerView.layer as? AVPlayerLayer{
                playerLayer.videoGravity = .resize
                playerLayer.player = player
                player?.play()
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { (notif) in
                    let dragedCMTime = CMTimeMake(value: 0, timescale: 1)
                    self.player?.seek(to: dragedCMTime)
                    self.player?.play()
                }
                NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notif) in
                    self.player?.play()
                }
            }
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_button_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popBackClick(sender:)))
//        self.view.addSubview(backButton)
//        backButton.snp.makeConstraints { (maker) in
//            maker.left.equalTo(25)
//            maker.top.equalTo(topLayoutGuide.snp.bottom)
//            maker.width.height.equalTo(44)
//        }
        
        let screenScale = (UIScreen.main.bounds.width/375.0)
        
        let shanyanLogo = UIImageView(image: UIImage(named: "shanyanlogo"))
        self.view.addSubview(shanyanLogo)
        shanyanLogo.snp.makeConstraints { (maker) in
            maker.width.equalTo(110 * screenScale)
            maker.height.equalTo(110 * screenScale)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(UIScreen.main.bounds.height*0.2)
        }
        let tipImage = UIImageView(image: UIImage(named: "您的新一代验证解决方案"))
        tipImage.contentMode = .scaleAspectFit
        self.view.addSubview(tipImage)
        tipImage.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.height.equalTo(20)
//            maker.centerX.equalToSuperview()
            maker.top.equalTo(shanyanLogo.snp.bottom).offset(5)
        }
                
        weixinLogin = UIButton()
        weixinLogin.setImage(UIImage(named: "ik_login_weixin_"), for: .normal)
        weixinLogin.setTitle(" 微信登录", for: .normal)
        weixinLogin.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        weixinLogin.layer.cornerRadius = 20
        weixinLogin.backgroundColor = UIColor(red: 73/255.0, green: 74/255.0, blue: 106/255.0, alpha: 1)
        weixinLogin.addTarget(self, action: #selector(weixinLoginButtonClick(button:)), for: .touchUpInside)
        shanYanLogin = UIButton()
        shanYanLogin.setImage(UIImage(named: "login_phone_white_"), for: .normal)
        shanYanLogin.setTitle(" 手机登录", for: .normal)
        shanYanLogin.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        shanYanLogin.layer.cornerRadius = 20
        shanYanLogin.backgroundColor = UIColor(red: 13/255.0, green: 79/255.0, blue: 254/255.0, alpha: 1)
        shanYanLogin.addTarget(self, action: #selector(shanYanLoginButtonClick(button:)), for: .touchUpInside)
        
        
        self.view.addSubview(shanYanLogin)
        self.view.addSubview(weixinLogin)
                
        label = UILabel()
        label.text = "登录及同意闪验DEMO用户协议"
        label.textAlignment = .center
        label.textColor = UIColor(red: 73/255.0, green: 74/255.0, blue: 106/255.0, alpha: 0.9)
        label.font = UIFont.systemFont(ofSize: 9)
        self.view.addSubview(label)
        
        shanYanLogin.hero.id = "loginButton"
        weixinLogin.hero.id = "phoneLabel"
        label.hero.id = "appPricy"

        
        label.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.left.right.equalTo(0)
            maker.bottom.equalTo(bottomLayoutGuide.snp.bottom).offset(-15)
        }
        

        shanYanLogin.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(label.snp.top).offset(-UIScreen.main.bounds.height*0.15)
            maker.width.equalToSuperview().multipliedBy(0.7)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
        }
        weixinLogin.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(shanYanLogin.snp.top).offset(-15)
            maker.width.height.centerX.equalTo(shanYanLogin)
        }
    }
    
    //OC
    @objc func weixinLoginButtonClick(button:UIButton) -> Void {
        let oc_demo_vc = TestViewController()
        self.navigationController?.pushViewController(oc_demo_vc, animated: true)
    }
    
    @objc func shanYanLoginButtonClick(button:UIButton) -> Void {
//        DispatchQueue.main.async {
//            HUD.show(.label("拉起授权页…"),onView: self.view)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
//            HUD.hide()
//        }
        
        let uiConfigure = ShanYanConfigureMaker(delegate: self).configureStyleYinKe(configureInstance: CLUIConfigure())
        uiConfigure.viewController = self
        CLShanYanSDKManager.setCLShanYanSDKManagerDelegate(self)
        CLShanYanSDKManager.quickAuthLogin(with: uiConfigure, openLoginAuthListener: self.openLoginAuthListener(complete:),oneKeyLoginListener:self.oneKeyLoginListener(complete:))
    }
    
    func openLoginAuthListener(complete: CLCompleteResult){
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        let error = complete.error as NSError?
        guard error == nil else{
            let msg = String(complete.code)
            let message = complete.message ?? ""
            var errorString = ""
            if error!.userInfo.count > 0 {
               errorString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
            }
            
            print(#function,#line,msg,message,errorString)
            
//            DispatchQueue.main.async {
//                HUD.flash(.label("\(msg)\(message)\n\(errorString)"), delay: 2.5)
//            }
            
            let previewSuccessVC = PreviewSuccessViewController()
            previewSuccessVC.error = error
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(previewSuccessVC, animated: true)
            }
            
            return
        }
    
        print(#function,#line,complete.code,complete.message ?? "")
    }
    func oneKeyLoginListener(complete: CLCompleteResult){
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        let error = complete.error as NSError?
        guard error == nil else{
            let msg = String(complete.code)
            let message = complete.message ?? ""
            var errorString = ""
            if error!.userInfo.count > 0 {
                errorString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
            }
            print(#function,#line,msg,message,errorString)
            
//            hideShanYanAuthPageMaskViewWhenUseWindow()
            
            if complete.code == 1011 {
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.customBackGroundView.isHidden = false
//                }, completion: nil)
//                UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
//                    self.customBackGroundView.isHidden = false
//                }, completion: nil)
            }else{
                CLShanYanSDKManager.finishAuthControllerCompletion {
                    
                    let previewSuccessVC = PreviewSuccessViewController()
                    previewSuccessVC.error = error
                    self.navigationController?.pushViewController(previewSuccessVC, animated: true)
                }
                
//                DispatchQueue.main.async {
//                    HUD.flash(.label("\(msg)\(message)\n\(errorString)"), delay: 2.5)
//                }
            }
            return
        }
        print(#function,#line,complete.code,complete.message ?? "")
        
        ShanYanGetPhoneNumber.getPhonenumber(token: complete.data as? Dictionary<String, Any>, callBack: self)
        
        DispatchQueue.global().async {
            let preLoginStartTime = Date().timeIntervalSince1970
            CLShanYanSDKManager.preGetPhonenumber { (completeResult) in
                UserDefaults.standard.set(Date().timeIntervalSince1970 - preLoginStartTime, forKey: "preLoginCost")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    //MARK: - CLShanYanSDKManagerDelegate
    func clShanYanSDKManagerAuthPageCompleteInit(_ authPageVC: UIViewController, currentTelecom telecom: String?, object: NSObject?, userInfo: [AnyHashable : Any]? = nil) {
    }
    func clShanYanSDKManagerAuthPageWillPresent(_ authPageVC: UIViewController, currentTelecom telecom: String?, object: NSObject?, userInfo: [AnyHashable : Any]? = nil) {
                
        let phoneInfo = object
        let shanYanAuthPageVC = authPageVC
        let shanYanAuthPageNav = authPageVC.navigationController
                
        shanYanAuthPageVC.isHeroEnabled  = true
        shanYanAuthPageNav?.isHeroEnabled = true
        
        authPageTopViewController = authPageVC;
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.label.isHidden = true
        }) { (complete) in
        }
    }
    func clShanYanSDKManagerAuthPageCompleteViewDidLoad(_ authPageVC: UIViewController, currentTelecom telecom: String?, object: NSObject?, userInfo: [AnyHashable : Any]? = nil) {
        
        let phoneInfo = object
        let shanYanAuthPageVC = authPageVC
        let shanYanAuthPageNav = authPageVC.navigationController
        
        let shanYanAuthPageView = authPageVC.view

        let screenWidth_Portrait = UIScreen.main.bounds.width
        let screenHeight_Portrait = UIScreen.main.bounds.height

        if let sloganLabel = userInfo?["sloganLabel"] as? UILabel {
            sloganLabel.hero.modifiers = [.translate(x: 0, y: 20, z: 0),.fade]
        }
        
        if let phoneLB = userInfo?["phoneLB"] as? UILabel, let loginBtn = userInfo?["loginBtn"] as? UIButton , let privacyLabel = userInfo?["privacyLabel"] as? UILabel {
            
            loginBtn.hero.id = "loginButton"
            privacyLabel.hero.id = "appPricy"

            let phoneLabelBackground = UILabel()
            phoneLabelBackground.hero.id = "phoneLabel"

            phoneLabelBackground.layer.cornerRadius = 20
            phoneLabelBackground.layer.masksToBounds = true
            
            phoneLabelBackground.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
            shanYanAuthPageView?.addSubview(phoneLabelBackground)
            phoneLabelBackground.snp.makeConstraints { (maker) in
                maker.height.equalTo(40)
                maker.width.equalTo(screenWidth_Portrait*0.7)
                maker.centerX.equalToSuperview()
                maker.bottom.equalTo(loginBtn.snp.top).offset(-15)
            }
            
            let phoneTip = UILabel()
            phoneTip.text = "本机号码"
            phoneTip.textAlignment = .right
            phoneTip.textColor = UIColor.white
            phoneTip.font = UIFont.systemFont(ofSize: 14)
            phoneLabelBackground.addSubview(phoneTip)
            phoneTip.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.width.equalTo(80)
                maker.left.equalToSuperview()
                maker.height.equalToSuperview()
            }
            let line = UIView()
            line.backgroundColor = UIColor.white
            phoneLabelBackground.addSubview(line)
            line.snp.makeConstraints { (maker) in
                maker.left.equalTo(phoneTip.snp.right).offset(10)
                maker.height.equalTo(15)
                maker.width.equalTo(2)
                maker.centerY.equalToSuperview()
            }
            
            //将号码控件移到号码控件背景控件上
            phoneLB.removeFromSuperview()
            phoneLabelBackground.addSubview(phoneLB)
            phoneLB.snp.remakeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.right.equalToSuperview()
                maker.left.equalTo(line.snp.right)
                maker.height.equalTo(40)
            }
        }
        
        if let backgroundImageView = userInfo?["backgroundImageView"] as? UIImageView{
            
        }
        if let shanYanSloganLabel = userInfo?["shanYanSloganLabel"] as? UILabel {
            
        }
        if let checkBox = userInfo?["checkBox"] as? UIButton {
            
        }
    }
    
    func clShanYanSDKManagerAuthPageCompleteViewWillAppear(_ authPageVC: UIViewController, currentTelecom telecom: String?, object: NSObject?, userInfo: [AnyHashable : Any]? = nil) {
    }
    func clShanYanSDKManagerAuthPage(afterViewDidLoad authPageView: UIView, currentTelecom telecom: String?) {
    }
    
    func success(code: Int?, massage: String?, data: Dictionary<String, Any>?, phonenumber: String?, telecom: String?) {
        
        CLShanYanSDKManager.finishAuthController(animated: true, completion: {
            let previewSuccessVC = PreviewSuccessViewController()
            previewSuccessVC.telecom = telecom
            previewSuccessVC.phoneNumber = phonenumber
            self.navigationController?.pushViewController(previewSuccessVC, animated: true)
        })
    }
    func failure(code: Int?, massage: String?, data: Dictionary<String, Any>?, error: Error?) {
        
        CLShanYanSDKManager.finishAuthControllerCompletion {
            let error = NSError(domain: massage ?? "", code: code ?? -999, userInfo: data)
            
            let previewSuccessVC = PreviewSuccessViewController()
            previewSuccessVC.error = error
            self.navigationController?.pushViewController(previewSuccessVC, animated: true)
        }
        
//        DispatchQueue.main.async {
//            HUD.flash(.label(String(format: "%d %@",code!,massage!,JSON(data).dictionaryObject ?? "")), delay: 2.5)
//        }
    }
    
    func shanYanConfigureOtherWayClick(sender: UIButton) {
        
        //修改：向上动画
        sender.hero.modifiers = [.translate(x: 0, y: -200, z: 0),.fade]
        slogon?.hero.modifiers = [.translate(x: 0, y: -180, z: 0),.fade]
        appPrivicy?.hero.modifiers = [.translate(x: 0, y: -180, z: 0),.fade]
        
        let smsLoginVC = ShanYanCustomSMSLoginViewController()
        let smsNav = UINavigationController(rootViewController: smsLoginVC)
        smsNav.hero.isEnabled = true
        smsNav.modalPresentationStyle = .overFullScreen
        smsNav.modalTransitionStyle = .crossDissolve
        
        
        smsLoginVC.willDismiss = {  [weak self]  in
//            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
//                self?.phoneLabel?.isHidden = false
//                self?.loginButton?.isHidden = false
//                self?.slogon?.isHidden = false
//            }) { (complete) in
//            }
        }
        smsLoginVC.didDismiss = {  [weak self]  in
            //还原，向下动画
            sender.hero.modifiers = [.translate(x: 0, y: 20, z: 0),.fade]
            self?.slogon?.hero.modifiers = [.translate(x: 0, y: 20, z: 0),.fade]
            self?.appPrivicy?.hero.modifiers = nil
        }

        authPageTopViewController?.present(smsNav, animated: true, completion: nil)
    }
    func customNavLeftItemClick(sender: UIButton){

        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCrossDissolve, animations: {
            self.label.isHidden = false
        }) { (complete) in
        }
        
        CLShanYanSDKManager.finishAuthController(animated: true) {
        }
    }

    @objc func popBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
