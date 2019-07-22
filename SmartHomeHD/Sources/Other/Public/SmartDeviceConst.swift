//
//  SmartDeviceConst.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit


enum SmartDeviceSwitchState: NSInteger {
    case off = 88  // 开
    case on = 89 // 关
}

enum SmartDeviceType: NSInteger {
    case Switch = 1 // 开关
    case Socket = 2 // 插座
    case Curtain = 3 // 窗帘
    case DoorMagnetic = 4 // 门磁
    case Box = 5 // 盒子
    case Tv = 6 // 电视
    case Airconditioner = 7 // 空调
    case STB = 8 // 机顶盒
    case TranslucentScreen = 9  // 投影幕布
    case Projector = 10 // 投影仪
    case Windowopener = 11 // 开窗器
    case VoiceRobot = 12 // 语音机器人
    case Feed = 13 // 投食器
    case Projectormachine = 14 //投影仪升降机
    case WaterValve = 15 // 智能水阀
    case Fan = 20 // 电风扇
    case IR = 22  // 智能红外遥控(蘑菇 IR)
    
}





class SmartDeviceConst: NSObject {

}
