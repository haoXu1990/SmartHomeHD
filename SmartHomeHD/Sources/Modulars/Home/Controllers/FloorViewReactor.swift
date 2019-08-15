//
//  FloorViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import ReactorKit
import NSObject_Rx
import RxSwiftExt
import RxCocoa
import RxSwift

class FloorViewReactor: NSObject, Reactor {
    
    enum Action {
        case sendScenModeCommand(SceneModeModel)
        
        case setLayout(Bool)
    }
    
    struct State {
        
        var deviceList: [DeviceModel]?
        
        var rooms: [RoomMoel]?
        
        var setcions: [FloorViewSection]?
        
        var scenModes: [SceneModeModel]?
        
        var fllowLayout: Bool = false
    }
    
    enum Mutaion {
        case setLayout(Bool)
    }
    
    let initialState: FloorViewReactor.State

    init(roomModels: [RoomMoel], devicelist: [DeviceModel], secnModes: [SceneModeModel], layout: Bool) {
        
        let reactors = roomModels.map { (roomModel) -> RoomViewReactor in
            
            let devices = devicelist.filter({ (model) -> Bool in
                let typeID = Int(model.typeid!)!
                let cellType = RoomViewCell.cellFactory(typeID: typeID)
                
                return (roomModel.roomid == model.roomid) && (cellType != .zero)
            })
            return RoomViewReactor.init(devicelist: devices, roomModel: roomModel)
        }
        let section = FloorViewSection.init(items: reactors)
        
        self.initialState = State.init(deviceList: devicelist, rooms: roomModels,setcions: [section], scenModes: secnModes, fllowLayout: layout)
    
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .sendScenModeCommand(let mode):
            sendSoket(model: mode)
            FHToaster.show(text: "已执行\(mode.title ?? "")")
            return .empty()
        case .setLayout(let layout):
            return .just(Mutaion.setLayout(layout))
        }
    }
    func reduce(state: State, mutation: Mutaion) -> State {
        
        var newState = state
        
        switch mutation {
        case .setLayout(let layout):
            newState.fllowLayout = layout
            return newState
        }
        
        
    }
    
}

extension FloorViewReactor {
    
    func sendSoket(model: SceneModeModel) {
       
            let param:[String : Any] = ["uid": model.userid.or(""),
                                        "modId": model.modeid.or(""),
                                        "Ind": model.orderby.or(""),
                                        "status": model.status.or("")]
            FHSoketManager.shear().sendMessage(event: "pubMode", data: param )
      
    }
}





