//
//  SettingViewCellReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/12.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import NSObject_Rx
import ReactorKit
import RxSwiftExt
import RxCocoa
import RxSwift

class SettingViewCellReactor: NSObject, Reactor  {
    
    typealias Action = NoAction
    
    struct State {
        var rooms: [RoomMoel]?
        
        var devices: [DeviceModel]?
    }
    
    var initialState: SettingViewCellReactor.State
    
    init(rooms: [RoomMoel], devices: [DeviceModel]) {
        
        self.initialState = State.init(rooms: rooms, devices: devices)
    }
    
}
