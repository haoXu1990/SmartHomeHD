//
//  AppDelegate.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /// 初始化恬家 SDK
        Tool.initTQSDK()
        //
        let rootVC = MainViewController()
//        let rootVC = HomeViewController.init(frame: CGRect.init(x: 0, y: 50, width: kScreenW, height: 550))
        let rootNav = UINavigationController.init(rootViewController: rootVC)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNav
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return UIApplication.shared.lxf.currentVcOrientationMask
    }
    
    


}

