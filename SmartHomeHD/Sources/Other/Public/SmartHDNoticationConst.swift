//
//  SmartHDNoticationConst.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/23.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

/// app 自定义
extension NSNotification.Name {
    /// 退出登录
    static let pubExitAPP = NSNotification.Name.init("pubExitAPP")
    
    
    /// 更新
    static let pubRefresh = NSNotification.Name.init("pubRefresh")
}

/// 设备相关
extension NSNotification.Name {
    
    /// 登录通知
    static let pubLoginAuth = NSNotification.Name.init("pubLoginAuth")
    
    /// 修改设备状态
    static let pubState = NSNotification.Name.init("pubState")
    
    /// 设备状态改变
    static let pubStateChange = NSNotification.Name.init("pubStateChange")
    
    /// 报警
    static let pubAlarmChange = NSNotification.Name.init("pubAlarmChange")
    
    /// 470设备控制状态返回
    static let pubTransLinkChange = NSNotification.Name.init("TransLinkChange")    
    
}

/// 怡康门铃
extension NSNotification.Name {
    /// 怡康门铃所有与服务器交互反馈的数据都通过监听这个通知获得
    static let onMessageResultNotification = NSNotification.Name.init(equesOnMessageResultNotification)
    
    static let onMessageVideoplayingNotification = NSNotification.Name.init(equesOnMessageVideoplayingNotification)
}
