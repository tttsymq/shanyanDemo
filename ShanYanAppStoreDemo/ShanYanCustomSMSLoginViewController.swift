//
//  ShanYanCustomSMSLoginViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2020/1/8.
//  Copyright © 2020 wanglijun. All rights reserved.
//

import UIKit
import PKHUD

typealias  willDismissBlock = () -> Void

class ShanYanCustomSMSLoginViewController: UIViewController {

    var willDismiss : willDismissBlock?
    var didDismiss : willDismissBlock?

    var phoneTextField : UITextField!
    
    let mainColor = UIColor(red: 13/255.0, green: 79/255.0, blue: 254/255.0, alpha: 1)

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
//            self.customBackGroundView.isHidden = false
//        }, completion: nil)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)

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

        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_button_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popBackClick(sender:)))

//        let shanyanLogo = UIImageView(image: UIImage(named: "闪验logo2"))
//        self.view.addSubview(shanyanLogo)
//        shanyanLogo.snp.makeConstraints { (maker) in
//            maker.width.equalTo(120)
//            maker.height.equalTo(50)
//            maker.centerX.equalToSuperview()
//            maker.top.equalTo(UIScreen.main.bounds.height*0.2)
//        }
        phoneTextField = UITextField()
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        phoneTextField.leftViewMode = .always
        phoneTextField.borderStyle = .none
        phoneTextField.keyboardType = .phonePad
        phoneTextField.keyboardAppearance = .dark
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "请输入手机号码", attributes:[NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        phoneTextField.layer.cornerRadius = 22.5
        phoneTextField.layer.masksToBounds = true
        phoneTextField.layer.borderWidth = 0.5
        phoneTextField.layer.borderColor = mainColor.cgColor
        self.view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.7)
            maker.height.equalTo(45)
            maker.top.equalToSuperview().offset(UIScreen.main.bounds.height*0.2+150)
        }

        let startVerifyButton = UIButton()
        startVerifyButton.setTitle("登录/注册", for:.normal)
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
        tipLabel.text = "点击登录，即代表您已同意闪验用户协议"
        tipLabel.font = UIFont.systemFont(ofSize: 10)
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .center
        tipLabel.textColor = mainColor
        self.view.addSubview(tipLabel)
        (tipLabel).snp.makeConstraints { (maker) in
           maker.centerX.equalToSuperview()
           maker.left.right.equalTo(startVerifyButton)
           maker.top.equalTo(startVerifyButton.snp.bottom).offset(20)
           maker.height.greaterThanOrEqualTo(50)
        }
        // Do any additional setup after loading the view.
        
        phoneTextField.hero.id = "phoneLabel"
        startVerifyButton.hero.id = "loginButton"
//        tipLabel.hero.id = "otherloginBtn"
        tipLabel.hero.modifiers = [.translate(x: 0, y: 200, z: 0),.fade]

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
             HUD.flash(.label("开始登录/注册…"),onView: self.view)
         }
//         DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//             HUD.hide()
//         }
    }
    @objc func popBackClick(sender: UIButton) {
        if let willdismissBlock = self.willDismiss{
            willdismissBlock()
        }
        
        phoneTextField.resignFirstResponder()

        self.dismiss(animated: true) {
            if let diddismissBlock = self.didDismiss{
                diddismissBlock()
            }
        }
    }

}
