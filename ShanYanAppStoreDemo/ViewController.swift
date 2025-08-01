//
//  ViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/7.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit
import SnapKit
import CL_ShanYanSDK
import PKHUD
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController,ShanYanCallBack,CLShanYanSDKManagerDelegate,ShanYanConfigureMakerDelegate {
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        HUD.hide()
    }
    
    override var shouldAutorotate: Bool{
        get{
            return false
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return .portrait
        }
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get{
            return .portrait
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let vc = ShanYanNetstatusViewController()
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.present(vc, animated: false) {
                
            }
        }
        
        let preLoginStartTime = Date().timeIntervalSince1970
        CLShanYanSDKManager.preGetPhonenumber { (completeResult) in
            UserDefaults.standard.set(Date().timeIntervalSince1970 - preLoginStartTime, forKey: "preLoginCost")
            UserDefaults.standard.synchronize()
        }

        PKHUD.sharedHUD.dimsBackground = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Do any additional setup after loading the view.
        let logoImg = UIImageView.init(image: UIImage.init(named: "编组2"))
        self.view.addSubview(logoImg)
        
        let scale = UIScreen.main.bounds.size.width/375.0;

        logoImg.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                make.top.equalTo(topLayoutGuide.snp.top).offset(20)
            }
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        
        let 场景图 = UIImageView.init(image: UIImage.init(named: "场景图"))
        self.view.addSubview(场景图)
        
        场景图.snp.makeConstraints { (make) in
            make.top.equalTo(logoImg.snp.bottom).offset(0*scale)
            make.left.equalTo(40*(2-scale))
            make.right.equalTo(-40*(2-scale))
            make.height.equalTo(场景图.snp.width).multipliedBy(0.81)
        }
        
        let 背景底 = UIImageView.init(image: UIImage.init(named: "背景底"))
        self.view.addSubview(背景底)
        
        背景底.snp.makeConstraints { (make) in
            make.top.equalTo(10*scale)
            make.left.right.equalTo(0)
            make.height.equalTo(背景底.snp.width).multipliedBy(1.5)
        }
        
        let 编组6 = UIImageView.init(image: UIImage.init(named: "编组6"))
        self.view.addSubview(编组6)
        
        编组6.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(编组6.snp.width).multipliedBy(0.81)
        }

        let label = UILabel()
        label.text = "你的新一代\n身份验证解决方案"
        label.numberOfLines = 2
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 30*scale)
        label.textColor = UIColor(red: 73/255.0, green: 81/255.0, blue: 112/255.0, alpha: 1.0)
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(场景图.snp.bottom).offset(5*scale)
            make.left.equalTo(15)
            make.right.equalTo(-0)
            make.height.equalTo(85*scale)
        }
        
        let btnView = UIView()
        self.view.addSubview(btnView)
        btnView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(8*scale)
            make.left.right.equalTo(0)
//            make.height.equalTo(250)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-46*scale)
            } else {
                make.bottom.equalTo(-46*scale)
            }
        }
        
        let 全屏模式 = CustomButton()
        let 弹窗模式 = CustomButton()
        let 调试模式 = CustomButton()
        let 本机校验 = CustomButton()
        
        调试模式.addTarget(self, action: #selector(调试模式Click), for: .touchUpInside)
        全屏模式.addTarget(self, action: #selector(全屏模式Click), for: .touchUpInside)
        弹窗模式.addTarget(self, action: #selector(弹窗模式Click), for: .touchUpInside)
        本机校验.addTarget(self, action: #selector(本机校验Click), for: .touchUpInside)

        全屏模式.backgroundColor = UIColor.white
        弹窗模式.backgroundColor = UIColor.white
        调试模式.backgroundColor = UIColor.white
        本机校验.backgroundColor = UIColor.white

        全屏模式.layer.cornerRadius = 5;
        弹窗模式.layer.cornerRadius = 5;
        调试模式.layer.cornerRadius = 5;
        本机校验.layer.cornerRadius = 5;

        全屏模式.layer.shadowColor = UIColor.init(red: 233/255.0, green: 231/255.0, blue: 250/255.0, alpha: 1).cgColor
        弹窗模式.layer.shadowColor = UIColor.init(red: 233/255.0, green: 231/255.0, blue: 250/255.0, alpha: 1).cgColor
        调试模式.layer.shadowColor = UIColor.init(red: 233/255.0, green: 231/255.0, blue: 250/255.0, alpha: 1).cgColor
        本机校验.layer.shadowColor = UIColor.init(red: 233/255.0, green: 231/255.0, blue: 250/255.0, alpha: 1).cgColor
        
        全屏模式.layer.shadowOpacity = 0.8;
        弹窗模式.layer.shadowOpacity = 0.8;
        调试模式.layer.shadowOpacity = 0.8;
        本机校验.layer.shadowOpacity = 0.8;

        本机校验.layer.shadowOffset = CGSize.init(width: 2, height: -2)
        弹窗模式.layer.shadowOffset = CGSize.init(width: 2, height: -2)
        调试模式.layer.shadowOffset = CGSize.init(width: 2, height: -2)
        本机校验.layer.shadowOffset = CGSize.init(width: 2, height: -2)

        全屏模式.layer.shadowRadius = 10
        弹窗模式.layer.shadowRadius = 10
        调试模式.layer.shadowRadius = 10
        本机校验.layer.shadowRadius = 10

        btnView.addSubview(全屏模式)
        btnView.addSubview(弹窗模式)
        btnView.addSubview(调试模式)
        btnView.addSubview(本机校验)
        
        全屏模式.snp.makeConstraints { (make) in
            make.top.equalTo(10*scale)
            make.left.equalTo(15*scale)
        }
        弹窗模式.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(全屏模式)
            make.right.equalTo(-15*scale)
            make.left.equalTo(全屏模式.snp.right).offset(15)
        }
        调试模式.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(全屏模式)
            make.bottom.equalTo(-15*scale)
            make.top.equalTo(全屏模式.snp.bottom).offset(15)
        }
        本机校验.snp.makeConstraints { (make) in
            make.width.height.equalTo(全屏模式)
            make.centerX.equalTo(弹窗模式)
            make.centerY.equalTo(调试模式)
        }
        
        本机校验.titleLabel.textColor = UIColor.black
        本机校验.titleLabel.font = UIFont.systemFont(ofSize: 12.5*scale)
        本机校验.titleLabel.text = "本机校验"
        本机校验.imageView.image = UIImage.init(named: "本机校验")
        
        本机校验.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(本机校验.imageView.snp.bottom).offset(5*scale)
        }
        本机校验.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(本机校验)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(本机校验).offset(-15*scale)
        }

        全屏模式.titleLabel.textColor = UIColor.black
        全屏模式.titleLabel.font = UIFont.systemFont(ofSize: 12.5*scale)
        全屏模式.titleLabel.text = "全屏模式"
        全屏模式.imageView.image = UIImage.init(named: "全屏模式")
        
        全屏模式.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(全屏模式.imageView.snp.bottom).offset(5*scale)
        }
        全屏模式.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(全屏模式)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(全屏模式).offset(-15*scale)
        }
        
        弹窗模式.titleLabel.textColor = UIColor.black
        弹窗模式.titleLabel.font = UIFont.systemFont(ofSize: 12.5*scale)
        弹窗模式.titleLabel.text = "弹窗模式"
        弹窗模式.imageView.image = UIImage.init(named: "弹窗模式")
        
        弹窗模式.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(弹窗模式.imageView.snp.bottom).offset(5*scale)
        }
        弹窗模式.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(弹窗模式)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(弹窗模式).offset(-15*scale)
        }
        
        调试模式.titleLabel.textColor = UIColor.black
        调试模式.titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12.5*scale)
        调试模式.titleLabel.text = "调试模式"
        调试模式.imageView.image = UIImage.init(named: "调试模式")
        
        调试模式.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(调试模式.imageView.snp.bottom).offset(5*scale)
        }
        调试模式.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(调试模式)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(调试模式).offset(-15*scale)
        }
        
        
        let borderColor = UIColor(red: 0.87, green: 0.9, blue: 0.93, alpha: 1)
        let textColor = UIColor(red: 0.67, green: 0.72, blue: 0.79, alpha: 1)
        let netStatusHeight = 36*scale
        let netStatusWidth = 140*scale
        
        let netStatusBtn = UIButton()
        view.addSubview(netStatusBtn)
        
        netStatusBtn.titleLabel?.font = UIFont(name: "PingFangSC", size: 14.0*scale)
        netStatusBtn.setTitle("查看当前网络", for: UIControl.State.normal)
        netStatusBtn.setTitleColor(textColor, for: UIControl.State.normal)
        netStatusBtn.layer.cornerRadius = 0.5*netStatusHeight
        netStatusBtn.layer.borderWidth = 1
        netStatusBtn.layer.borderColor = borderColor.cgColor
        
        netStatusBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(btnView)
            make.width.equalTo(netStatusWidth)
            make.height.equalTo(netStatusHeight)
            make.top.equalTo(调试模式.snp.bottom).offset(10*scale)
        }
        
        netStatusBtn.addTarget(self, action: #selector(netStatusBtnClicked), for: UIControl.Event.touchUpInside)
 
    }
    
    @objc func netStatusBtnClicked() {
        let vc = ShanYanNetstatusViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false) {}
    }
    
    @objc func 本机校验Click(sender : CustomButton) {
        let mobiileCheckVC = ShanYanCustomMobileCheckViewController()
        self.navigationController?.pushViewController(mobiileCheckVC, animated: true)
    }
    @objc func 全屏模式Click(sender : CustomButton) {
        
        DispatchQueue.main.async {
//            HUD.show(.labeledRotatingImage(image: UIImage(named: "shanyan_demo_loading_bg"), title: "拉起授权页…", subtitle: nil), onView: self.view)
            HUD.show(.label("拉起授权页…"),onView: self.view)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }
        
        let shanYanCustomLoginViewController = ShanYanCustomLoginViewController()
        self.navigationController?.pushViewController(shanYanCustomLoginViewController, animated: true)
    }
    
    @objc func 弹窗模式Click(sender : CustomButton) {
        DispatchQueue.main.async {
            HUD.show(.label("拉起授权页…"),onView: self.view)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }
        let uiConfigure = ShanYanConfigureMaker(delegate: self).configureStyle3(configureInstance: CLUIConfigure())
        uiConfigure.viewController = self
        uiConfigure.clAppPrivacyCustomWeb = NSNumber(booleanLiteral: false)
 
        uiConfigure.clAppMorePrivacyArray = [ ["decollator":"、",
            "privacyName":"《自定义隐私协议》",
            "privacyURL": "https://www.baidu.com"]] as Array
        
        CLShanYanSDKManager.setCLShanYanSDKManagerDelegate(self)
        
        CLShanYanSDKManager.quickAuthLogin(with: uiConfigure, openLoginAuthListener: openLoginAuthListener(complete:),oneKeyLoginListener:oneKeyLoginListener(complete:))
    }
    
    @objc func 调试模式Click(sender : CustomButton) {
        self.navigationController?.pushViewController(DebugViewController(), animated: true)
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
            
            DispatchQueue.main.async {
                let previewSuccessVC = PreviewSuccessViewController()
                previewSuccessVC.error = error
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
            
            if complete.code == 1011 {
                
            }else{
                
                CLShanYanSDKManager.finishAuthControllerCompletion {}
                DispatchQueue.main.async {
                    let previewSuccessVC = PreviewSuccessViewController()
                    previewSuccessVC.error = error
                    self.navigationController?.pushViewController(previewSuccessVC, animated: true)
                }
                
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
    
    func success(code: Int?, massage: String?, data: Dictionary<String, Any>?, phonenumber: String?, telecom: String?) {
        
        CLShanYanSDKManager.finishAuthController(animated: false, completion: {})
        DispatchQueue.main.async {
            let previewSuccessVC = PreviewSuccessViewController()
            previewSuccessVC.telecom = telecom
            previewSuccessVC.phoneNumber = phonenumber
            self.navigationController?.pushViewController(previewSuccessVC, animated: true)
        }
        
    }
    func failure(code: Int?, massage: String?, data: Dictionary<String, Any>?, error: Error?) {
        
        CLShanYanSDKManager.finishAuthControllerCompletion {}
        
        DispatchQueue.main.async {
            let error = NSError(domain: massage ?? "", code: code ?? -999, userInfo: data)
            
            let previewSuccessVC = PreviewSuccessViewController()
            previewSuccessVC.error = error
            self.navigationController?.pushViewController(previewSuccessVC, animated: true)
        }
        
    }
    
    
    //MARK: - CLShanYanSDKManagerDelegate
    func clShanYanSDKManagerAuthPage(afterViewDidLoad authPageView: UIView, currentTelecom telecom: String?) {
    }
    func clShanYanSDKManagerWebPrivacyClicked(_ privacyName: String, privacyIndex index: Int, currentTelecom telecom: String?) {
    }

    func shanYanConfigureOtherWayClick(sender: UIButton) {
        CLShanYanSDKManager.finishAuthControllerCompletion {}
        DispatchQueue.main.async {
            HUD.flash(.label("其他方式登录"), delay: 1.5)
        }
    }
    
    func customNavLeftItemClick(sender: UIButton) {
    }
    
    
    //uiConfigure.clAppPrivacyCustomWeb = NSNumber(booleanLiteral: true) 属性为true时，会有回调结果
    func clShanYanPrivacyListener(_ privacyName: String, privacyURL URLString: String, authPage authPageVC: UIViewController) {
        print(privacyName + URLString)
    }
}

