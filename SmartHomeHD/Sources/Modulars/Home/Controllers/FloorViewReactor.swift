//
//  FloorViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import ReactorKit

class FloorViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        
        var deviceList: [DeviceModel]?
        
        var setcions: [FloorViewSection] = []
    }
    
    let initialState: FloorViewReactor.State
    
    init(floors: [RoomMoel], devicelist: [DeviceModel]) {
        
        /// 这里临时添加几个
        
//        let resultSection = FloorViewSection.init(items: [floors[0], floors[0], floors[0], floors[0], floors[0], floors[0]], deviceListModel: devicelist)
        let resultSection = FloorViewSection.init(items: floors, deviceListModel: devicelist)
        
        self.initialState = State.init(deviceList: devicelist, setcions: [resultSection])
    
    }
}





