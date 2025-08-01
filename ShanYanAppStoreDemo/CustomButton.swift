//
//  CustomButton.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/8.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit

class CustomButton: UIControl {
    public
    let titleLabel : UILabel
    let imageView : UIImageView

    init() {
        self.titleLabel  = UILabel()
        self.titleLabel.textAlignment = .center
        
        self.imageView = UIImageView()
        super.init(frame: CGRect.zero)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
