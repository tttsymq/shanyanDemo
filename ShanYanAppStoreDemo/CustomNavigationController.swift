//
//  CustomNavigationController.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/13.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override var shouldAutorotate: Bool{
        get{
            return topViewController?.shouldAutorotate ?? false
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return topViewController?.supportedInterfaceOrientations ?? .all
        }
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get{
            return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
