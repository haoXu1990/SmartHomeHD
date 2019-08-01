//
//  RoomViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import ReactorKit

class RoomViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var deviceModels:[DeviceModel]!
        
        var setcions: [DeviceControllSection]?
    }
    
    let initialState: RoomViewReactor.State
    
    init(devicelist: [DeviceModel]) {
        
        let reactors =  devicelist.map { (model) -> DeviceControllCellReactor in
           return DeviceControllCellReactor.init(deviceModel: model)
        }
        
       
       
        self.initialState = State.init(deviceModels: devicelist, setcions:  [DeviceControllSection.init(items: reactors)])
        
    }
}
