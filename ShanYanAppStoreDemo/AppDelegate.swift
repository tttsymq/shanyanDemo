//
//  AppDelegate.swift
//  ShanYanAppStoreDemo
//
//  Created by wanglijun on 2019/8/7.
//  Copyright © 2019 wanglijun. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CL_ShanYanSDK

let appID = "<#appId#>"//需和BundleID对应
let appKey = "<#appKey#>"//测试流程用，实际使用中appKey应在后端保存

//♻️ 如需体验OC示例，请在 ShanYanGetPhoneNumberDemoCode.m 中设置appID、appKey

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        let blyConfig = BuglyConfig()
        blyConfig.channel = "AppStore"
        blyConfig.version = "2.3.6.9"
        Bugly.start(withAppId: "b4aef0f8b1",config: blyConfig)
        
        if let shanyanLogo1 =  UIImage(named: "shanyanLogo1"){
            SVProgressHUD.setInfoImage(shanyanLogo1)
            SVProgressHUD.setSuccessImage(shanyanLogo1)
            SVProgressHUD.setErrorImage(shanyanLogo1)
        }
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setImageViewSize(CGSize(width: 72, height: 29))
        SVProgressHUD.setDefaultMaskType(.none)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "SVProgressHUDDidReceiveTouchEventNotification"), object: nil, queue: OperationQueue.main) { (notif) in
            SVProgressHUD.dismiss()
        }
        
        
        print(CLShanYanSDKManager.clShanYanSDKVersion())
        
        //输出日志
        //        CLShanYanSDKManager.printConsoleEnable(true)
        let initStartTime: TimeInterval = Date().timeIntervalSince1970
        CLShanYanSDKManager.initWithAppId(appID) { (complete) in
            let error = complete.error as NSError?
            UserDefaults.standard.set(Date().timeIntervalSince1970 - initStartTime, forKey: "sdkInitCost")
            UserDefaults.standard.synchronize()
            
            guard error == nil else{
                print(complete.code,complete.message ?? "",complete.error ?? "")
                return
            }
            CLShanYanSDKManager.preGetPhonenumber { (complete) in
                let error = complete.error as NSError?
                guard error == nil else{
                    print(complete.code,complete.message!,complete.error ??  "")
                    print("预取号失败")
                    return
                }
            }
            print(#function,#line,complete.code,complete.message ?? "")
        }
        
#warning("OC版本调试界面(默认使用swift版本界面)")
        /*
         window = UIWindow(frame: UIScreen.main.bounds)
         window?.backgroundColor = UIColor.white
         window?.rootViewController = UINavigationController(rootViewController: TestViewController())
         window?.makeKeyAndVisible()
         */
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

