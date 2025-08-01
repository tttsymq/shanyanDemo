//
//  DebugViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/8.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit
import CL_ShanYanSDK
import Alamofire
import SwiftyJSON
import PKHUD

extension String {
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

class DebugViewController: UIViewController,ShanYanCallBack,CLShanYanSDKManagerDelegate,ShanYanConfigureMakerDelegate {

    var initStartTime: TimeInterval = 0
    var preLoginStartTime: TimeInterval = 0
    var authPageShowStartTime: TimeInterval = 0
    var loginStartTime: TimeInterval = 0
    var exchangeNumberStartTime: TimeInterval = 0
    
    var sdkInitCost: TimeInterval = 0
    var preLoginCost: TimeInterval = 0
    
    
    
    lazy var dataFormatter : DateFormatter = {
        let dataFormatter = DateFormatter.init()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dataFormatter
    }()
    
    
    var token :Dictionary<String, Any>?
    
    let consoleTextView = UITextView()
    
    @objc func popBack(sender : UIButton)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.dimsBackground = false
        
        self.view.backgroundColor = UIColor.white
        
        let scale = UIScreen.main.bounds.size.width/375.0;
        
        let back = UIButton()
        back.setImage(UIImage.init(named: "title_back"), for: .normal)
        back.addTarget(self, action: #selector(popBack(sender:)), for: .touchUpInside)
        self.view.addSubview(back)
        back.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                make.top.equalTo(topLayoutGuide.snp.top).offset(20)
            }
            make.left.equalTo(15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)
        label.text = "闪验SDKv" + CLShanYanSDKManager.clShanYanSDKVersion()
        label.textColor = UIColor.init(red: 86/255.0, green: 93/255.0, blue: 123/255.0, alpha: 1)
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(back)
            make.left.equalTo(back.snp.right).offset(10)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        
        let 背景底 = UIImageView.init(image: UIImage.init(named: "背景底"))
        self.view.addSubview(背景底)
        
        背景底.snp.makeConstraints { (make) in
            make.top.equalTo(10*scale)
            make.left.right.equalTo(0)
            make.height.equalTo(背景底.snp.width).multipliedBy(1.5)
        }
        
        let clounImage = UIImageView.init(image: UIImage.init(named: "编组 5"))
        self.view.addSubview(clounImage)
        clounImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.top.equalTo(label.snp.bottom).offset(25)
        }
        
        consoleTextView.backgroundColor = UIColor(red: 44/255.0, green: 47/255.0, blue: 66/255.0, alpha: 0.9)
        consoleTextView.font = UIFont.systemFont(ofSize: 12)
        consoleTextView.layer.cornerRadius = 3
        consoleTextView.layoutManager.allowsNonContiguousLayout = false
        consoleTextView.isEditable = false
        consoleTextView.textColor = UIColor.green
        consoleTextView.text = "通过优化验证流程,帮助企业从根源上有效防止用户流失,提升用户体验,让用户享受到瞬间完成验证的体验。\n\n"
        self.view.addSubview(consoleTextView)
        consoleTextView.snp.makeConstraints { (make) in
            make.left.equalTo(clounImage).offset(8)
            make.right.equalTo(clounImage).offset(-8)
            make.top.equalTo(clounImage).offset(12)
            make.height.equalTo(consoleTextView.snp.width)
        }

        let btnView = UIView()
        self.view.addSubview(btnView)
        btnView.snp.makeConstraints { (make) in
            make.top.equalTo(consoleTextView.snp.bottom).offset(20)
            make.left.right.equalTo(0)
            make.height.equalTo(250)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            } else {
                make.bottom.equalTo(-50)
            }
        }
        
        let borderColor = UIColor(red: 0.26, green: 0.49, blue: 1, alpha: 1)
        let netStatusHeight = 36*scale
        let netStatusWidth = 140*scale
        
        let netStatusBtn = UIButton()
        view.addSubview(netStatusBtn)
        
        netStatusBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14.0*scale)
        netStatusBtn.setTitle("查看当前网络", for: UIControl.State.normal)
        netStatusBtn.setTitleColor(borderColor, for: UIControl.State.normal)
        netStatusBtn.layer.cornerRadius = 0.5*netStatusHeight
        netStatusBtn.layer.borderWidth = 1
        netStatusBtn.layer.borderColor = borderColor.cgColor
        
        netStatusBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(netStatusWidth)
            make.height.equalTo(netStatusHeight)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(-15)
            }
        }
        
        netStatusBtn.addTarget(self, action: #selector(netStatusBtnClicked), for: UIControl.Event.touchUpInside)
        
        
        
        let 初始化 = CustomButton()
        let 预取号 = CustomButton()
        let 置换手机号 = CustomButton()
        let 拉起授权页 = CustomButton()
        
        初始化.addTarget(self, action: #selector(initSDK(sender:)), for: .touchUpInside)
        预取号.addTarget(self, action: #selector(preGetPhonenumberSDK(sender:)), for: .touchUpInside)
        置换手机号.addTarget(self, action: #selector(getPhonenumber(sender:)), for: .touchUpInside)
        拉起授权页.addTarget(self, action: #selector(qulickloginSDK(sender:)), for: .touchUpInside)

        初始化.backgroundColor = UIColor(red: 238/255.0, green: 243/255.0, blue: 255/255.0, alpha: 1)
        预取号.backgroundColor = UIColor(red: 238/255.0, green: 243/255.0, blue: 255/255.0, alpha: 1)
        置换手机号.backgroundColor = UIColor(red: 238/255.0, green: 243/255.0, blue: 255/255.0, alpha: 1)
        拉起授权页.backgroundColor = UIColor(red: 238/255.0, green: 243/255.0, blue: 255/255.0, alpha: 1)
        
        
        btnView.addSubview(初始化)
        btnView.addSubview(预取号)
        btnView.addSubview(置换手机号)
        btnView.addSubview(拉起授权页)
        
        初始化.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        预取号.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(初始化)
            make.right.equalTo(0)
            make.left.equalTo(初始化.snp.right).offset(4)
        }
        置换手机号.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(初始化)
            make.bottom.equalTo(-15*scale)
            make.top.equalTo(初始化.snp.bottom).offset(4)
        }
        拉起授权页.snp.makeConstraints { (make) in
            make.width.height.equalTo(初始化)
            make.centerX.equalTo(预取号)
            make.centerY.equalTo(置换手机号)
        }
        
        初始化.titleLabel.textColor = UIColor.black
        初始化.titleLabel.font = UIFont.systemFont(ofSize: 12.5*scale)
        初始化.titleLabel.text = "初始化"
        初始化.imageView.image = UIImage.init(named: "初始化")
        
        初始化.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(初始化.imageView.snp.bottom).offset(5*scale)
        }
        初始化.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(初始化)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(初始化).offset(-15*scale)
        }
        
        预取号.titleLabel.textColor = UIColor.black
        预取号.titleLabel.font = UIFont.systemFont(ofSize: 12.5*scale)
        预取号.titleLabel.text = "预取号"
        预取号.imageView.image = UIImage.init(named: "预取号")
        
        预取号.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(预取号.imageView.snp.bottom).offset(5*scale)
        }
        预取号.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(预取号)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(预取号).offset(-15*scale)
        }
        
        置换手机号.titleLabel.textColor = UIColor.black
        置换手机号.titleLabel.font = UIFont.systemFont(ofSize: 12.5*scale)
        置换手机号.titleLabel.text = "置换手机号"
        置换手机号.imageView.image = UIImage.init(named: "置换手机号")
        
        置换手机号.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(置换手机号.imageView.snp.bottom).offset(5*scale)
        }
        置换手机号.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(置换手机号)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(置换手机号).offset(-15*scale)
        }
        
        拉起授权页.titleLabel.textColor = UIColor.black
        拉起授权页.titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12.5*scale)
        拉起授权页.titleLabel.text = "拉起授权页"
        拉起授权页.imageView.image = UIImage.init(named: "拉起授权页")
        
        拉起授权页.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(18*scale)
            make.top.equalTo(拉起授权页.imageView.snp.bottom).offset(5*scale)
        }
        拉起授权页.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(拉起授权页)
            make.height.width.equalTo(45*scale)
            make.centerY.equalTo(拉起授权页).offset(-15*scale)
        }
        
        let arrow0 = UIImageView.init(image: UIImage.init(named: "直线2"))
        let arrow1 = UIImageView.init(image: UIImage.init(named: "直线3"))
        let arrow2 = UIImageView.init(image: UIImage.init(named: "直线4"))
        
        arrow0.contentMode = .right
        arrow1.contentMode = .bottom
        arrow2.contentMode = .left

        arrow0.clipsToBounds = true
        arrow1.clipsToBounds = true
        arrow2.clipsToBounds = true

        btnView.addSubview(arrow0)
        btnView.addSubview(arrow1)
        btnView.addSubview(arrow2)
        
        arrow0.snp.makeConstraints { (make) in
            make.centerY.equalTo(初始化)
            make.left.equalTo(初始化.snp.right).offset(-30)
            make.right.equalTo(预取号.snp.left).offset(30)
            make.height.equalTo(8)
        }
        arrow1.snp.makeConstraints { (make) in
            make.centerX.equalTo(预取号)
            make.top.equalTo(预取号.snp.bottom).offset(-15)
            make.bottom.equalTo(拉起授权页.snp.top).offset(15)
            make.width.equalTo(8)
        }
        arrow2.snp.makeConstraints { (make) in
            make.centerY.equalTo(拉起授权页)
            make.left.equalTo(置换手机号.snp.right).offset(-30)
            make.right.equalTo(拉起授权页.snp.left).offset(30)
            make.height.equalTo(8)
        }
    }
    func printLoading() {
        let msg = self.consoleTextView.text
    }
    func printLog(msg : String , function : String ,line : Int, startTime : TimeInterval) {
        
        let now = Date()
        let timeInterval = (now.timeIntervalSince1970 - startTime)
        
        //let msg = String.init(format:"%@\ncostTime:%.3f\nline:%d\nfunc:%@\nmsg:%@\n\n",dataFormatter.string(from: now),timeInterval,line,function,msg).unicodeStr
        
        let msg = String.init(format:"%@\ncostTime:%.3fs\nmsg:%@\n\n",dataFormatter.string(from: now),timeInterval,msg).unicodeStr
        
        DispatchQueue.main.async {
            self.consoleTextView.text = self.consoleTextView.text.appending(msg)
            self.consoleTextView.scrollRangeToVisible(NSRange(location: self.consoleTextView.text.count, length: 1))
        }
    }

    
    @objc func initSDK(sender : UIButton) {
        
        DispatchQueue.main.async {
            HUD.show(.label("初始化…"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }

        initStartTime = Date().timeIntervalSince1970
        
        CLShanYanSDKManager.initWithAppId(appID) { (complete) in
            
            DispatchQueue.main.async {
                HUD.hide()
            }
            
            let msg = String(complete.code)
            let message = complete.message ?? ""
            let error = complete.error as NSError?
            guard error == nil else{
                
                var errorString = ""
                if error!.userInfo.count > 0 {
                    errorString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
                }
                
                self.printLog(msg: msg + message + errorString , function: #function, line: #line, startTime : self.initStartTime)
                return
            }
            self.printLog(msg:String(format: "%d %@",complete.code,complete.message ?? ""), function: #function, line: #line, startTime : self.initStartTime)

            UserDefaults.standard.set(Date().timeIntervalSince1970 - self.initStartTime, forKey: "sdkInitCost")
            UserDefaults.standard.synchronize()
        }
    }
    @objc func preGetPhonenumberSDK(sender : UIButton) {

        DispatchQueue.main.async {
            HUD.show(.label("预取号…"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }
        preLoginStartTime = Date().timeIntervalSince1970
        CLShanYanSDKManager.preGetPhonenumber { (complete) in
            
            DispatchQueue.main.async {
                HUD.hide()
            }

            let msg = String(complete.code)
            let message = complete.message ?? ""
            let error = complete.error as NSError?
            guard error == nil else{

                var errorString = ""
                if error!.userInfo.count > 0 {
                    errorString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
                }
                
                self.printLog(msg: msg + message + errorString , function: #function, line: #line , startTime: self.preLoginStartTime)
                return
            }
            
            self.printLog(msg:String(format: "%@ %@",msg,message), function: #function, line: #line , startTime: self.preLoginStartTime)
            
            UserDefaults.standard.set(Date().timeIntervalSince1970 - self.preLoginStartTime, forKey: "preLoginCost")
            UserDefaults.standard.synchronize()
        }
    }
    @objc func qulickloginSDK(sender : UIButton) {
        
        DispatchQueue.main.async {
            HUD.show(.label("拉起授权页…"),onView: self.view)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }
        let uiConfigure = ShanYanConfigureMaker(delegate: self).configureStyle0(configureInstance: CLUIConfigure())
        uiConfigure.viewController = self
        CLShanYanSDKManager.setCLShanYanSDKManagerDelegate(self)
        uiConfigure.clCheckBoxValue = NSNumber(value: true)
        authPageShowStartTime = Date().timeIntervalSince1970
        CLShanYanSDKManager.quickAuthLogin(with: uiConfigure, openLoginAuthListener: openLoginAuthListener(complete:),oneKeyLoginListener:oneKeyLoginListener(complete:))
    }
    
    @objc func getPhonenumber(sender : UIButton) {
        
//        if self.token==nil {
//            self.printLog(msg: "" , function: #function, line: #line,startTime: Date().timeIntervalSince1970)
//        }

        DispatchQueue.main.async {
            HUD.show(.label("获取手机号…"))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }
        
        exchangeNumberStartTime = Date().timeIntervalSince1970
        
        ShanYanGetPhoneNumber.getPhonenumber(token: self.token, callBack: self)
        
    }
    
    //MARK: - qulickloginSDKCallBack
    func openLoginAuthListener(complete: CLCompleteResult){
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        let msg = String(complete.code)
        let message = complete.message ?? ""
        
        let error = complete.error as NSError?
        guard error == nil else{
            
            var errorString = ""
            if error!.userInfo.count > 0 {
                errorString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
            }
            
            self.printLog(msg: msg + message + errorString , function: #function, line: #line,startTime: self.authPageShowStartTime)
            return
        }
        self.printLog(msg:String(format: "%@ %@",msg,message), function: #function, line: #line, startTime: self.authPageShowStartTime)
        loginStartTime = Date().timeIntervalSince1970
    }
    
    func oneKeyLoginListener(complete: CLCompleteResult){
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        CLShanYanSDKManager.finishAuthControllerCompletion()
        
        let msg = String(complete.code)
        let message = complete.message ?? ""
        
        let error = complete.error as NSError?
        guard error == nil else{
            var errorString = ""
            if error!.userInfo.count > 0 {
                errorString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
            }
            let startTime = complete.code == 1011 ? Date().timeIntervalSince1970:self.loginStartTime
            
            self.printLog(msg: msg + message + errorString , function: #function, line: #line, startTime: startTime)
            return
        }
        
        self.token = complete.data as? Dictionary<String, Any>
        
        self.printLog(msg:String(format: "%@\n%@\n%@",msg,message,JSON(self.token).dictionaryObject ?? ""), function: #function, line: #line, startTime: self.loginStartTime)
        
//        DispatchQueue.global().async {
//            let preLoginStartTime = Date().timeIntervalSince1970
//            CLShanYanSDKManager.preGetPhonenumber { (completeResult) in
//                UserDefaults.standard.set(Date().timeIntervalSince1970 - preLoginStartTime, forKey: "preLoginCost")
//                UserDefaults.standard.synchronize()
//            }
//        }
    }
    
    
    //MARK: - CLShanYanSDKManagerDelegate
    func clShanYanSDKManagerAuthPage(afterViewDidLoad authPageView: UIView, currentTelecom telecom: String?) {

    }
    func clShanYanSDKManagerWebPrivacyClicked(_ privacyName: String, privacyIndex index: Int, currentTelecom telecom: String?) {
        
    }
    
    //MARK: - getPhonenumberCallBack
    func success(code: Int?, massage: String?, data: Dictionary<String, Any>?, phonenumber: String?, telecom: String?) {
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        var resultCode = code
        if resultCode == nil {
            resultCode = 999
        }

        self.printLog(msg:String(format: "%d \n手机号：%@\n %@ %@",resultCode ?? 0,phonenumber ?? "",massage!,JSON(data ?? [:]).dictionaryObject ?? ""), function: #function, line: #line, startTime: self.exchangeNumberStartTime)


//        let previewSuccessVC = PreviewSuccessViewController()
//        previewSuccessVC.telecom = telecom
//        previewSuccessVC.phoneNumber = phonenumber
//        self.navigationController?.pushViewController(previewSuccessVC, animated: true)
        
        self.token = nil
    }
    
    func failure(code: Int?, massage: String?, data: Dictionary<String, Any>?, error: Error?) {
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
        CLShanYanSDKManager.finishAuthControllerCompletion()
        
        self.printLog(msg:String(format: "%d %@",code ?? 0,massage!,JSON(data ?? [:]).dictionaryObject ?? ""), function: #function, line: #line, startTime: self.exchangeNumberStartTime)
    }
    
    func shanYanConfigureOtherWayClick(sender: UIButton) {
        CLShanYanSDKManager.finishAuthControllerCompletion {
            DispatchQueue.main.async {
                HUD.flash(.label("其他方式登录"), delay: 1.5)
            }
        }
    }
    func customNavLeftItemClick(sender: UIButton) {
        
    }
    
    @objc func netStatusBtnClicked() {
        
        let vc = ShanYanNetstatusViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false) {
            
        }
    }
}
