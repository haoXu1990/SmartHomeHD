//
//  SmartDeviceConst.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

/// WIFI 开窗器
enum WIFICurtaion: Int64 {
    case powerOn = 0x00
    case powerStop = 0x02
    case powerOff = 0x01
}

enum SmartDeviceSwitchState: String {
   
    /// 关 (左), 89
    case off = "89"
    
    /// 开 (右), 88
    case on = "88"
    
    /// 暂停, 96
    case pause = "96"
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
    case YSCamera = 33
    /// 双模开关
    case SwitchDOUBLE = 63
    /// 触摸开关
    case SwitchTouch = 65
    
    /// 晾衣架
    case LaundryRack = 57
}





class SmartDeviceConst: NSObject {

}
