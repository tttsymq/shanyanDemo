//
//  PreviewSuccessViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/9.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit
import SwiftyJSON

class PreviewSuccessViewController: UIViewController {

    var labelCustom0_ : UILabel?
    var customModuleShow = false
    
    lazy var mainScroView :UIScrollView = {
        let mainScroView_ = UIScrollView()
        return mainScroView_
    }()
    lazy var webView :WKWebView = {
        let webView_ = WKWebView()
        return webView_
    }()
    
    var error :NSError?
    
    var phoneNumber :String?
    var telecom :String?
    var screenWidth = min(UIScreen.main.bounds.size.width,UIScreen.main.bounds.size.height)

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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.leftBarButtonItem = nil
        
        let scale = screenWidth/375.0

        mainScroView.frame = self.view.bounds
        mainScroView.bounces = false
        mainScroView.alwaysBounceVertical = false
        mainScroView.backgroundColor = UIColor.white
        self.view.addSubview(mainScroView)
        mainScroView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(self.view)
        }
        
        
        let tryAgainButton = UIButton()
        tryAgainButton.setTitle("再次体验", for: .normal)
        tryAgainButton.setTitleColor(UIColor.white, for: .normal)
        tryAgainButton.backgroundColor = UIColor.init(red: 59/255.0, green: 101/255.0, blue: 253/255.0, alpha: 1)
        tryAgainButton.layer.shadowColor = UIColor.init(red: 192/255.0, green: 209/255.0, blue: 254/255.0, alpha: 1).cgColor
        tryAgainButton.layer.shadowOpacity = 0.6
        tryAgainButton.layer.shadowOffset = CGSize.init(width: 5, height: 10)
        tryAgainButton.layer.cornerRadius = 5
        tryAgainButton.setImage(UIImage.init(named: "刷新"), for: .normal)
        tryAgainButton.addTarget(self, action: #selector(tryAgainClick(sender:)), for: .touchUpInside)
        mainScroView.addSubview(tryAgainButton)

        if error != nil {
            let faurileLogin = UIImageView(image: UIImage(named: "失败"))
            
            let faurileLabel = UILabel()
            faurileLabel.text = "登录失败"
            faurileLabel.font = UIFont.init(name: "PingFangSC-Medium", size: 21*scale)
            faurileLabel.textAlignment = .center
            faurileLabel.textColor = UIColor.init(red: 73/255.0, green: 81/255.0, blue: 112/255.0, alpha: 1)
            
            let messageTextView = UITextView()
            messageTextView.layer.cornerRadius = 8;
            messageTextView.backgroundColor = UIColor(red: 240/255.0, green:245/255.0, blue:255/255.0, alpha: 1)
            messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            messageTextView.textColor = UIColor(red: 73/255.0, green:81/255.0, blue:112/255.0, alpha:1.0)
            messageTextView.isScrollEnabled = false
            
            var userInfoString = ""
            if error!.userInfo.count > 0 {
                userInfoString = String(format: "%@", JSON(error!.userInfo).dictionaryObject ?? "")
            }
            userInfoString = userInfoString.unicodeStr
            messageTextView.text = String(format: "请按以下指引排除原因：\ncode:%d\nmessage:%@\ndescription:%@", error!.code, error!.domain, userInfoString )
            
            mainScroView.addSubview(faurileLogin)
            mainScroView.addSubview(messageTextView)
            mainScroView.addSubview(faurileLabel)

            faurileLogin.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainScroView)
                make.width.equalTo(150*scale)
                make.height.equalTo(faurileLogin.snp.width).multipliedBy(0.75)
                if #available(iOS 11.0, *) {
                    make.top.equalTo(self.view.safeAreaInsets.top + 44)
                } else {
                    make.top.equalTo(44)
                }
            }
        
            faurileLabel.snp.makeConstraints { (make) in
                make.top.equalTo(faurileLogin.snp.bottom).offset(20)
                make.left.right.equalTo(mainScroView)
                make.height.equalTo(25)
            }
            messageTextView.snp.makeConstraints { (make) in
                make.top.equalTo(faurileLabel.snp.bottom).offset(20)
                make.left.equalTo(mainScroView).offset(28)
                make.right.equalTo(mainScroView).offset(-28)
                make.height.greaterThanOrEqualTo(80)
            }
            tryAgainButton.snp.makeConstraints { (make) in
                make.top.equalTo(messageTextView.snp.bottom).offset(40)
                make.centerX.equalTo(mainScroView)
                make.height.equalTo(40*scale)
                make.width.equalTo(0.8*screenWidth)
            }
        }else{
            let successLogin = AnimatedImageView()
            
            let phoneNumLabel = UILabel()
            phoneNumLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 18*scale)
            phoneNumLabel.textAlignment = .center
            phoneNumLabel.textColor = UIColor.init(red: 79/255.0, green: 122/255.0, blue: 253/255.0, alpha: 1)
            if let phoneNumber = phoneNumber {
                phoneNumLabel.text = phoneNumber
            }
            
            let slogoLabel = UILabel()
            slogoLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 11*scale)
            slogoLabel.textAlignment = .center
            slogoLabel.textColor = UIColor.init(red: 135/255.0, green: 142/255.0, blue: 164/255.0, alpha: 1)
            if let telecom = telecom {
                switch telecom{
                case "CMCC":
                    slogoLabel.text = "该能力由中国移动提供"
                    break;
                case "CUCC":
                    slogoLabel.text = "该能力由中国联通提供"
                    break;
                case "CTCC":
                    slogoLabel.text = "该能力由中国电信提供"
                    break;
                default:
                    break
                }
            }
            
            let successLabel = UILabel()
            successLabel.text = "登录成功"
            successLabel.font = UIFont.init(name: "PingFangSC-Medium", size: 21*scale)
            successLabel.textAlignment = .center
            successLabel.textColor = UIColor.init(red: 73/255.0, green: 81/255.0, blue: 112/255.0, alpha: 1)
            
            
            mainScroView.addSubview(successLogin)
            mainScroView.addSubview(phoneNumLabel)
            mainScroView.addSubview(slogoLabel)
            mainScroView.addSubview(successLabel)
            
            successLogin.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainScroView)
                make.width.equalTo(150*scale)
                make.height.equalTo(successLogin.snp.width).multipliedBy(0.9)
                if #available(iOS 11.0, *) {
                    make.top.equalTo(self.view.safeAreaInsets.top + 44 + 20)
                } else {
                    make.top.equalTo(44 + 20)
                }
            }
            
            if let gifpath = Bundle.main.path(forResource:"success", ofType:"gif"){
                DispatchQueue.main.async {
                    let url = URL(fileURLWithPath: gifpath)
                    
//                    let provider = LocalFileImageDataProvider(fileURL: url)
                    successLogin.kf.setImage(with: KF.ImageResource(downloadURL: url))
                    
                }
            }
            
            phoneNumLabel.snp.makeConstraints { (make) in
                make.top.equalTo(successLogin.snp.bottom).offset(0)
                make.left.right.equalTo(mainScroView)
                make.height.equalTo(25)
            }
            slogoLabel.snp.makeConstraints { (make) in
                make.top.equalTo(phoneNumLabel.snp.bottom).offset(0)
                make.left.right.equalTo(mainScroView)
                make.height.equalTo(15)
            }
            successLabel.snp.makeConstraints { (make) in
                make.top.equalTo(slogoLabel.snp.bottom).offset(20)
                make.left.right.equalTo(mainScroView)
                make.height.equalTo(25)
            }
            tryAgainButton.snp.makeConstraints { (make) in
                make.top.equalTo(successLabel.snp.bottom).offset(40)
                make.centerX.equalTo(mainScroView)
                make.height.equalTo(40*scale)
                make.width.equalTo(0.8*screenWidth)
            }
        }
        
        let lineView = UIView()
        mainScroView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(tryAgainButton.snp.bottom).offset(60)
            make.left.right.equalTo(0)
            make.height.equalTo(4)
        }
        
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = lineView.bounds
        
        shapeLayer.position = CGPoint(x: 0, y: 2)
        
        shapeLayer.fillColor = UIColor.gray.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 1.5), NSNumber(value: 5)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x:0, y: 2))
        path.addLine(to: CGPoint(x: self.view.bounds.width, y: 2))
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)

        let detailLabel = UILabel()
        detailLabel.text = "上滑了解商品详情"
        detailLabel.textColor = UIColor.gray
        detailLabel.backgroundColor = UIColor.white
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12*scale)
        mainScroView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.center.equalTo(lineView)
            make.width.equalTo(120)
            make.height.equalTo(15)
        }
        
        let detailImageView = UIImageView()
        detailImageView.image = UIImage.init(named: "detail")

        mainScroView.addSubview(detailImageView)
        
        detailImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(detailLabel.snp.bottom).offset(30)
            make.height.equalTo(detailImageView.snp.width).multipliedBy(2814/1080.0)
        }
        
        let labelCustom0 = UILabel()
        labelCustom0_ = labelCustom0
        
        let labelCustom1 = UILabel()

        labelCustom0.text = "24小时客服：400-9669-253"
        labelCustom0.font = UIFont(name: "PingFangSC-Regular", size: 14)
        labelCustom0.textAlignment = .center
        labelCustom0.textColor = UIColor(red: 73/255.0, green: 81/255.0, blue: 112/255.0, alpha: 1)
        
        labelCustom1.text = "欢迎咨询了解产品或对闪验产品提出反馈意见"
        labelCustom1.numberOfLines = 0
        labelCustom1.font = UIFont(name: "PingFangSC-Regular", size: 12)
        labelCustom1.textAlignment = .center
        labelCustom1.textColor = UIColor(red: 152/255.0, green: 161/255.0, blue: 195/255.0, alpha: 1)
        
        mainScroView.addSubview(labelCustom0)
        mainScroView.addSubview(labelCustom1)

        labelCustom0.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(detailImageView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }
        labelCustom1.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(labelCustom0.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        webView.load(URLRequest(url: URL(string: "http://kefu253.udesk.cn/im_client?web_plugin_id=48056")!))
        webView.backgroundColor = UIColor.red
        mainScroView.addSubview(webView)
        webView.snp.remakeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(mainScroView).offset(-20)
            make.top.equalTo(labelCustom0_?.snp.bottom ?? 0).offset(30)
            if customModuleShow == false{
                make.height.equalTo(0)
            }else{
                if #available(iOS 11.0, *) {
                    make.height.equalTo(self.view.safeAreaLayoutGuide).offset(-55)
                } else {
                    make.height.equalTo(UIScreen.main.bounds.height).offset(-55)
                }
            }
        }
        webView.backgroundColor = UIColor.white
        webView.layer.shadowColor = UIColor.lightGray.cgColor
        webView.layer.shadowOpacity = 0.2
        webView.layer.shadowOffset = CGSize(width: 3, height: 2)
        webView.layer.cornerRadius = 5
        
        webView.scrollView.layer.cornerRadius = 5
        
        let buttonCustom0 = UIButton()
        let buttonCustom1 = UIButton()
        buttonCustom0.addTarget(self, action: #selector(custonOnline(sender:)), for: .touchUpInside)
        buttonCustom1.addTarget(self, action: #selector(custonPhoneCall(sender:)), for: .touchUpInside)

        buttonCustom0.setImage(UIImage(named: "客服"), for: .normal)
        buttonCustom1.setImage(UIImage(named: "电话"), for: .normal)

        buttonCustom0.setTitle("在线客服", for: .normal)
        buttonCustom1.setTitle("电话客服", for: .normal)
        
        buttonCustom0.setTitleColor(UIColor(red: 97/255.0, green: 139/255.0, blue: 254/255.0, alpha: 1), for: .normal)
        buttonCustom1.setTitleColor(UIColor(red: 97/255.0, green: 139/255.0, blue: 254/255.0, alpha: 1), for: .normal)
        
        buttonCustom0.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        buttonCustom1.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        
        mainScroView.addSubview(buttonCustom0)
        mainScroView.addSubview(buttonCustom1)
        
        buttonCustom0.layer.borderColor = UIColor.lightGray.cgColor
        buttonCustom0.layer.borderWidth = (2.0 / UIScreen.main.scale) / 2
        buttonCustom1.layer.borderColor = UIColor.lightGray.cgColor
        buttonCustom1.layer.borderWidth = (2.0 / UIScreen.main.scale) / 2
        
        buttonCustom0.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(webView.snp.bottom).offset(10)
            make.height.equalTo(45)
            make.bottom.equalTo(0)
        }
        buttonCustom1.snp.makeConstraints { (make) in
            make.left.equalTo(buttonCustom0.snp.right)
            make.right.equalTo(0)
            make.top.height.width.bottom.equalTo(buttonCustom0)
        }
    }
    
    @objc func tryAgainClick(sender: UIButton){
        if self.navigationController?.isKind(of:CustomNavigationController.self) ?? false {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func custonOnline(sender: UIButton){
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.isEnabled = true
        }
        customModuleShow = !customModuleShow
        webView.snp.remakeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(mainScroView).offset(-20)
            make.top.equalTo(labelCustom0_?.snp.bottom ?? 0).offset(30)
            if customModuleShow == false{
                make.height.equalTo(0)
            }else{
                if #available(iOS 11.0, *) {
                    make.height.equalTo(self.view.safeAreaLayoutGuide).offset(-55)
                } else {
                    make.height.equalTo(UIScreen.main.bounds.height).offset(-55)
                }
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.mainScroView.layoutIfNeeded()
            if self.customModuleShow == true{
                self.mainScroView.scrollRectToVisible(CGRect(x: 0, y: self.mainScroView.contentSize.height - UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: false)
            }
        }
    }
    @objc func custonPhoneCall(sender: UIButton){
        let phoneNumber = "400-9669-253"
        if #available(iOS 10.0, *){
            UIApplication.shared.open(URL(string: String(format:"telprompt://%@",phoneNumber))!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(URL(string: String(format:"telprompt://%@",phoneNumber))!)
        }
    }
}
