//
//  ShanYanNetstatusViewController.swift
//  ShanYanAppStoreDemo
//
//  Created by KevinChien on 2020/4/8.
//  Copyright © 2020 wanglijun. All rights reserved.
//

import UIKit

class ShanYanNetstatusViewController: UIViewController {
    var sdkInitCost: TimeInterval = -1
    var preLoginCost: TimeInterval = -1
    
    let scale = Float(UIScreen.main.bounds.width/375.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        createContentView()
    }
}

extension ShanYanNetstatusViewController{
    
    private func createContentView() {
        let contentBgView = UIView()
        
        contentBgView.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 1, alpha: 1)
        contentBgView.layer.cornerRadius = CGFloat(6.0*scale)
        view.addSubview(contentBgView)
        
        contentBgView.snp.makeConstraints { (make) in
//            make.top.equalTo(view).offset(122*scale)
//            make.left.equalTo(view).offset(22.5*scale)
//            make.right.equalTo(view).offset(-22.5*scale)
//            make.bottom.equalTo(view).offset(-174*scale)
            
            make.centerY.equalTo(view.snp_centerY)
            make.left.equalTo(view).offset(22.5*scale)
            make.right.equalTo(view).offset(-22.5*scale)
            make.height.equalTo(380*scale)
        }
        
        // 内容展示View
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = CGFloat(6.0*scale)
        contentBgView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(contentBgView).offset(14*scale)
            make.left.equalTo(contentBgView).offset(11*scale)
            make.right.equalTo(contentBgView).offset(-11*scale)
            make.bottom.equalTo(contentBgView).offset(-66*scale)
        }
        
        // 取消蒙版按钮
        let cancelBtn = UIButton()
        cancelBtn.setTitle("知道了", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        cancelBtn.backgroundColor = UIColor(red: 0.29, green: 0.49, blue: 1, alpha: 1)
        cancelBtn.layer.cornerRadius = CGFloat(38*0.5*scale)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: UIControl.Event.touchUpInside)
        contentBgView.addSubview(cancelBtn)

        cancelBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.width.equalTo(140*scale)
            make.height.equalTo(38*scale)
            make.bottom.equalTo(contentBgView).offset(-15*scale)
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "友情提示"
        tipLabel.numberOfLines = 0
        tipLabel.font = UIFont.boldSystemFont(ofSize: 21)
        tipLabel.textColor = UIColor(red: 0.29, green: 0.49, blue: 1, alpha: 1)
        contentView.addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.width.greaterThanOrEqualTo(84*scale)
            make.height.equalTo(30*scale)
            make.top.equalTo(contentView).offset(18*scale)
        }

        let leftTipImg = UIImageView(image: UIImage(named: "left_tip_img"))
        contentView.addSubview(leftTipImg)
        
        let rightTipImg = UIImageView(image: UIImage(named: "right_tip_img"))
        contentView.addSubview(rightTipImg)
        
        leftTipImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(tipLabel)
            make.height.equalTo(11*scale)
            make.width.equalTo(83*scale)
            make.right.equalTo(tipLabel.snp_left).offset(-10*scale)
        }
        
        rightTipImg.snp.makeConstraints { (make) in
            make.height.equalTo(leftTipImg)
            make.width.equalTo(leftTipImg)
            make.left.equalTo(tipLabel.snp_right).offset(10*scale)
            make.centerY.equalTo(tipLabel)
        }
        
        // WiFi状态
        let wifiKeyWords = ShanYanNetworkStatusTool.wifiStatus() ? "是 " : "否 "
        let wifiContent = "是否开启了wifi：\(wifiKeyWords)（个别oppo及vivo机型首次无法在wifi开启下调用闪验）"
        let wifiV = createListCell(contentView, index: "1", content: wifiContent, keyWords: wifiKeyWords)
        wifiV.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp_bottom).offset(20*scale)
            make.left.equalTo(contentView.snp_left).offset(15*scale)
            make.right.equalTo(contentView.snp_right).offset(-15*scale)
            make.height.equalTo(42*scale)
        }
        
        // 蜂窝移动网络 类型
        var cellularKeyWords = "无蜂窝网络"
        if ShanYanNetworkStatusTool.cellularMobileNetworkStatus() {
            cellularKeyWords = ShanYanNetworkStatusTool.currentCellularMobileNetworkName()
        }
        
        let cellularContent = "当前流量网络类型：\(cellularKeyWords)（请确定当前流量网络类型为4G或5G网络）"
        let cellularV = createListCell(contentView, index: "2", content: cellularContent, keyWords: cellularKeyWords)
        
        cellularV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(wifiV)
            make.top.equalTo(wifiV.snp_bottom).offset(10*scale)
        }
        
        // 初始化速率
        let sdkInitTemp = UserDefaults.standard.object(forKey: "sdkInitCost")
        
        if sdkInitTemp == nil {
            sdkInitCost = 0
        } else {
            sdkInitCost = sdkInitTemp as! TimeInterval
        }
        
        let sdkInitKeyWords = "\(String(format: "%.0f", sdkInitCost*1000))ms"
        let sdkInitContent = "当前链接闪验服务器速率（初始化）:\(sdkInitKeyWords)（4000MS以上可能超时）"
        let sdkInitV = createListCell(contentView, index: "3", content: sdkInitContent, keyWords: sdkInitKeyWords)
        sdkInitV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(wifiV)
            make.top.equalTo(cellularV.snp_bottom).offset(10*scale)
        }
        
        // 预取号速率
        let preLoginTemp = UserDefaults.standard.object(forKey: "preLoginCost")
        
        if preLoginTemp == nil {
            preLoginCost = 0
        } else {
            preLoginCost = preLoginTemp as! TimeInterval
        }

        let preLoginKeyWords = "\(String(format: "%.0f", preLoginCost*1000))ms"
        let preLoginContent = "当前链接运营商基站速率（预取号）：\(preLoginKeyWords)（4000MS以上可能超时）"
        let preLoginV = createListCell(contentView, index: "4", content: preLoginContent, keyWords: preLoginKeyWords)
        preLoginV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(wifiV)
            make.top.equalTo(sdkInitV.snp_bottom).offset(10*scale)
        }
    }
    
    func createListCell(_ spView: UIView, index: String, content: String, keyWords: String) -> UIView {
        
        let blueThemeColor = UIColor(red: 73/255.0, green: 125/255.0, blue: 1, alpha: 1.0)
        let themeFont = UIFont(name: "PingFangSC-Regular", size: CGFloat(14*scale))!
        let defaultThemeColor = UIColor(red: 0.38, green: 0.4, blue: 0.49,alpha:1)
        
        let cell = UIView()
        spView.addSubview(cell)
        
        let indexWH = 17.5*scale
        
        let indexLabel = UILabel()
        indexLabel.text = index
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor.white
        indexLabel.backgroundColor = blueThemeColor
        indexLabel.layer.cornerRadius = CGFloat(0.5*indexWH)
        indexLabel.layer.masksToBounds = true
        indexLabel.font = themeFont
        cell.addSubview(indexLabel)

        let contentLabel = UILabel()
        cell.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        contentLabel.font = themeFont
        contentLabel.textColor = defaultThemeColor
        
        //富文本设置
        let attributeString = NSMutableAttributedString(string:content)
        
        let range = (content as NSString).range(of: keyWords)
        
        attributeString.addAttribute(NSAttributedString.Key.font, value: themeFont,
            range: range)
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: blueThemeColor,
            range: range)

        contentLabel.attributedText = attributeString

        indexLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(indexWH)
            make.left.equalTo(cell)
            make.top.equalTo(cell).offset(7*scale)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(indexLabel.snp_right).offset(6*scale)
            make.right.top.bottom.equalTo(cell)
        }

        return cell
    }
    
    @objc func cancelBtnClicked() {
        self.dismiss(animated: false) {
            
        }
    }
}
