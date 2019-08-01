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
        
        var setcions: [FloorViewSection]?
    }
    
    let initialState: FloorViewReactor.State
    
    init(floors: [RoomMoel], devicelist: [DeviceModel]) {
        
        /// 这里临时添加几个
        
//        let resultSection = FloorViewSection.init(items: [floors[0], floors[0], floors[0], floors[0], floors[0], floors[0]], deviceListModel: devicelist)
        
        let reactors = floors.map { (roomModel) -> RoomViewReactor in
            
            let devices = devicelist.filter({ (model) -> Bool in
                return roomModel.roomid == model.roomid
            })
            return RoomViewReactor.init(devicelist: devices)
        }
        let section = FloorViewSection.init(items: reactors)
        
        self.initialState = State.init(deviceList: devicelist, setcions: [section])
    
    }
}

extension FloorViewReactor {
//
//    func fetchDevice(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}




