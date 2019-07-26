//
//  DeviceControllCellReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/26.
//  Copyright © 2019 FH. All rights reserved.
//


import ReactorKit

class DeviceControllCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var deviceModels:DeviceModel!
    }
    
    let initialState: DeviceControllCellReactor.State
    
    init(deviceModel: DeviceModel) {
        
        
        self.initialState = State.init(deviceModels: deviceModel)
        
    }
}
