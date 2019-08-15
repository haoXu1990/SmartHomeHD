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
        
        var roomImageUrlStr: String?
    }
    
    let initialState: RoomViewReactor.State
    var roomModel: RoomMoel
    init(devicelist: [DeviceModel], roomModel: RoomMoel) {
        
        let reactors =  devicelist.map { (model) -> DeviceControllCellReactor in
           return DeviceControllCellReactor.init(deviceModel: model)
        }
        
       
        self.roomModel = roomModel
        self.initialState = State.init(deviceModels: devicelist, setcions:  [DeviceControllSection.init(items: reactors)], roomImageUrlStr: roomModel.imageurl)
        
    }
}
