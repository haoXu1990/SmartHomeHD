//
//  SmartHDNoticationConst.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/23.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    
    /// 登录通知
    static let pubLoginAuth = NSNotification.Name.init("pubLoginAuth")
    
    /// 修改设备状态
    static let pubState = NSNotification.Name.init("pubState")
    
    /// 设备状态改变
    static let pubStateChange = NSNotification.Name.init("pubStateChange")
    
}
