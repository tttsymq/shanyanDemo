//
//  ShanYanCustomMobileCheckViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2020/1/7.
//  Copyright © 2020 wanglijun. All rights reserved.
//

import UIKit
import Kingfisher
import CL_ShanYanSDK
import PKHUD
import SwiftyJSON

enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
 
    case URL(_: String)
    case IP(_: String)
 
 
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
 
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}

class ShanYanCustomMobileCheckViewController: UIViewController,ShanYanCallBack {

    var phoneTextField : UITextField!
    
    let mainColor = UIColor(red: 13/255.0, green: 79/255.0, blue: 254/255.0, alpha: 1)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
//            self.customBackGroundView.isHidden = false
//        }, completion: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.barStyle = .default

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneTextField.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        phoneTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "title_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popBackClick(sender:)))
        
        let shanyanLogo = UIImageView(image: UIImage(named: "闪验logo2"))
        self.view.addSubview(shanyanLogo)
        shanyanLogo.snp.makeConstraints { (maker) in
            maker.width.equalTo(120)
            maker.height.equalTo(50)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(UIScreen.main.bounds.height*0.2)
        }

        phoneTextField = UITextField()
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        phoneTextField.leftViewMode = .always
        phoneTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        phoneTextField.rightViewMode = .always
        phoneTextField.borderStyle = .none
        phoneTextField.keyboardType = .phonePad
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "请输入本机号码", attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        phoneTextField.layer.cornerRadius = 22.5
        phoneTextField.layer.masksToBounds = true
        phoneTextField.layer.borderWidth = 0.5
        phoneTextField.layer.borderColor = mainColor.cgColor
        self.view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.7)
            maker.height.equalTo(45)
            maker.top.equalTo(shanyanLogo.snp.bottom).offset(60)
        }

        let startVerifyButton = UIButton()
        startVerifyButton.setTitle("本机号码一键认证", for:.normal)
        startVerifyButton.setTitleColor(UIColor.white, for: .normal)
        startVerifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startVerifyButton.backgroundColor = mainColor
        startVerifyButton.layer.cornerRadius = 22.5
        startVerifyButton.addTarget(self, action: #selector(startVerifyButtonClick(sender:)), for: .touchUpInside)
        
        self.view.addSubview(startVerifyButton)
        startVerifyButton.snp.makeConstraints { (maker) in
            maker.centerX.width.height.equalTo(phoneTextField)
            maker.top.equalTo(phoneTextField.snp.bottom).offset(20)
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "点击本机号码一键认证，即代表您已同意并授权闪验通过国内三大运营商为您校验手机号码验证"
        tipLabel.font = UIFont.systemFont(ofSize: 10)
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.gray
        self.view.addSubview(tipLabel)
        (tipLabel).snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.left.right.equalTo(startVerifyButton)
            maker.top.equalTo(startVerifyButton.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(50)
        }
    }
    
    @objc func startVerifyButtonClick(sender: UIButton) {
        
        guard self.phoneTextField.text != nil else {
            DispatchQueue.main.async {
                HUD.flash(.label("请输入手机号"),onView: self.view,delay: 2)
            }
            return
        }
        guard self.phoneTextField.text?.count == 11 else {
            DispatchQueue.main.async {
                HUD.flash(.label("请检查手机号"),onView: self.view,delay: 2)
            }
            return
        }
        
        DispatchQueue.main.async {
            HUD.show(.label("开始校验…"),onView: self.view)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            HUD.hide()
        }

        CLShanYanSDKManager.mobileCheck { (complete) in
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
                
                DispatchQueue.main.async {
                    HUD.show(.label("\(msg)\n\(message)\n\(errorString)"),onView: self.view)
                }
                return
            }
            print(#function,#line,complete.code,complete.message ?? "")
            
            //添加手机号
            var token = complete.data as? Dictionary<String, Any>
            token?.updateValue(self.phoneTextField.text!, forKey: "mobile")

            ShanYanGetPhoneNumber.checkPhonenumber(token: token, callBack: self)
                    
        }
        
    }
    
    func success(code: Int?, massage: String?, data: Dictionary<String, Any>?, phonenumber: String?, telecom: String?) {
        let previewSuccessVC = PreviewSuccessViewController()
        previewSuccessVC.telecom = telecom
        previewSuccessVC.phoneNumber = self.phoneTextField.text
        self.navigationController?.pushViewController(previewSuccessVC, animated: true)
    }
    func failure(code: Int?, massage: String?, data: Dictionary<String, Any>?, error: Error?) {
        
        let error = NSError(domain: massage ?? "", code: code ?? -999, userInfo: data)
        
        let previewSuccessVC = PreviewSuccessViewController()
        previewSuccessVC.error = error
        self.navigationController?.pushViewController(previewSuccessVC, animated: true)
        
//        DispatchQueue.main.async {
//            HUD.flash(.label(String(format: "%d %@",code!,massage!,JSON(data).dictionaryObject ?? "")), delay: 2.5)
//        }
    }

    
    @objc func popBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
