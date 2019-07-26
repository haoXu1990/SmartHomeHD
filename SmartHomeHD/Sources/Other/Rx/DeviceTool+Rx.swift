//
//  DeviceTool+Rx.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/26.
//  Copyright © 2019 FH. All rights reserved.
//


import ReactorKit
import RxSwift


extension ObservableType where Self.E == DeviceControllCellReactor.State {
    
    /// 返回 显示title
    /// DeviceControllCellReactor.State.deviceModels -> "●  设备名称"
    /// - Returns: Observable<String>
    internal func fetchCellTitle() -> Observable<String> {
        
        return self.flatMap({ (element) -> Observable<String> in
            let title = String.init(format: "● %@", element.deviceModels.title.or(""))
            return Observable.just(title)
        })
    }
    
    
    
    /// 返回某些设备 icon 
    ///
    /// - Returns: Observable<UIImage?>
    internal func fetchCellDeviceIcon() -> Observable<UIImage?> {
        
        return self.flatMap { (element) -> Observable<UIImage?> in
            
            let image = SmartDeviceTool.fetchCellDeviceIcon(ptye: element.deviceModels.ptype!,
                                                            typeid: Int(element.deviceModels.typeid!)!,
                                                            channel: Int(element.deviceModels.channel!)!)
            
            return Observable.just(image)
        }        
    }
    
    /// 返回DeviceCellOne MoreIcon
    ///
    /// - Returns: Observable<UIImage?>
    internal func fetchCellDeviceMoreIcon() -> Observable<UIImage?> {
        
        return self.flatMap { (element) -> Observable<UIImage?> in
            
            let image = SmartDeviceTool.fetchCellDeviceMoreIcon(ptye: element.deviceModels.ptype!,
                                                            typeid: Int(element.deviceModels.typeid!)!,
                                                            channel: Int(element.deviceModels.channel!)!)
            
            return Observable.just(image)
        }
    }
}

