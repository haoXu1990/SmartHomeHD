//
//  SmartDeviceTool.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/26.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit




class SmartDeviceTool: NSObject {

    
    /// 获取设备控制列表 Cell 某些设备 icon
    ///
    /// - Parameters:
    ///   - ptye: ptype
    ///   - typeid: typeID
    ///   - channel: channel
    /// - Returns: UIImage?
    class func fetchCellDeviceIcon(ptye: String, typeid: Int, channel: Int) -> UIImage? {
    
        guard let smartType = SmartDeviceType.init(rawValue: typeid) else { return nil }
        
        
        switch smartType {
        case .Feed:
            return UIImage.init(named: "icon_cell_feed")
        case .Airconditioner:
            return UIImage.init(named: "icon_cell_kongdiao")
        case .Tv:
            return UIImage.init(named: "icon_cell_tv")
        case .IR:
            return UIImage.init(named: "icon__cell_ir")
        default:
            return nil
        }        
    }
    
    
    /// 获取设备控制列表 Cell 某些设备显示更多 icon
    ///
    /// - Parameters:
    ///   - ptye: ptype
    ///   - typeid: typeID
    ///   - channel: channel
    /// - Returns: UIImage?
    class func fetchCellDeviceMoreIcon(ptye: String, typeid: Int, channel: Int) -> UIImage? {
        
        guard let smartType = SmartDeviceType.init(rawValue: typeid) else { return nil }
        
        
        switch smartType {
        case .Airconditioner:
            return UIImage.init(named: "icon_more")
        case .Tv:
            return UIImage.init(named: "icon_more")
        case .IR:
            return UIImage.init(named: "icon_more")
        default:
            return nil
        }
    }
    
    
    /// 获取设备控制列表 Cell 某些设备显示更多 icon
    ///
    /// - Parameters:
    ///   - ptye: ptype
    ///   - typeid: typeID
    ///   - channel: channel
    /// - Returns: UIImage?
    class func fetchCellDeviceFirstBtnImage(ptye: String, typeid: Int, channel: Int) -> UIImage? {
        
        guard let smartType = SmartDeviceType.init(rawValue: typeid) else { return nil }
        
        
        switch smartType {
        case .Windowopener:
            return UIImage.init(named: "icon_more")
        case .Tv:
            return UIImage.init(named: "icon_more")
        case .IR:
            return UIImage.init(named: "icon_more")
        default:
            return nil
        }
    }
    
    
}
