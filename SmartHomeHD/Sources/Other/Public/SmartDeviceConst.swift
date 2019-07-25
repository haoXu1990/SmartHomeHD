//
//  SmartDeviceConst.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit


enum SmartDeviceSwitchState: NSInteger {
    /// 开
    case off = 88
    /// 关
    case on = 89
}

enum SmartDeviceType: NSInteger {
    /// 开关
    case Switch = 1
    /// 插座
    case Socket = 2
    /// 窗帘
    case Curtain = 3
    /// 门磁
    case DoorMagnetic = 4
    /// 盒子
    case Box = 5
    /// 电视
    case Tv = 6
    /// 空调
    case Airconditioner = 7
    /// 机顶盒
    case STB = 8
    /// 投影幕布
    case TranslucentScreen = 9
    /// 投影仪
    case Projector = 10
    /// 开窗器
    case Windowopener = 11
    /// 语音机器人
    case VoiceRobot = 12
    /// 投食器
    case Feed = 13
    /// 投影仪升降机
    case Projectormachine = 14
    /// 智能水阀
    case WaterValve = 15
    /// 电风扇
    case Fan = 20
    /// 智能红外遥控(蘑菇 IR)
    case IR = 22
    
    
}





class SmartDeviceConst: NSObject {

}
