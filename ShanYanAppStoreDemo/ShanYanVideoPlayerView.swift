//
//  ShanYanVideoPlayerView.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2020/1/6.
//  Copyright © 2020 wanglijun. All rights reserved.
//

import UIKit
import AVFoundation

class ShanYanVideoPlayerView: UIView {

    override class var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
