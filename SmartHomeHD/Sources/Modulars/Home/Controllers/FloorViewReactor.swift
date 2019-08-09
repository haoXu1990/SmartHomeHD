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
    }
    
    struct State {
        
        var deviceList: [DeviceModel]?
        
        var rooms: [RoomMoel]?
        
        var setcions: [FloorViewSection]?
        
        var scenModes: [SceneModeModel]?
    }
    
    enum Mutaion {
        
    }
    
    let initialState: FloorViewReactor.State
    
    init(floors: [RoomMoel], devicelist: [DeviceModel], secnModes: [SceneModeModel]) {
        
        let reactors = floors.map { (roomModel) -> RoomViewReactor in
            
            let devices = devicelist.filter({ (model) -> Bool in
                let typeID = Int(model.typeid!)!
                let cellType = RoomViewCell.cellFactory(typeID: typeID)
                
                return (roomModel.roomid == model.roomid) && (cellType != .zero)
            })
            return RoomViewReactor.init(devicelist: devices)
        }
        let section = FloorViewSection.init(items: reactors)
        
        self.initialState = State.init(deviceList: devicelist, rooms: floors,setcions: [section], scenModes: secnModes)
    
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .sendScenModeCommand(let mode):
            sendSoket(model: mode)
            FHToaster.show(text: "已执行\(mode.title ?? "")")
            return .empty()
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





