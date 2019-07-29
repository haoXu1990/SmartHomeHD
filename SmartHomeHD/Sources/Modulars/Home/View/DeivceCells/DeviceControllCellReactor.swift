//
//  DeviceControllCellReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/26.
//  Copyright © 2019 FH. All rights reserved.
//


import ReactorKit
import RxSwift

class DeviceControllCellReactor: Reactor {

    enum Action {
        /// 控制 开(左) 、关(右)、 暂停 等命令
        case sendCommand(SmartDeviceSwitchState)
    }
    
    enum Mutaion {
        
        case setStatus(SmartDeviceSwitchState)
    }
    
    struct State {
        var deviceModels:DeviceModel!
    }
    
    let initialState: DeviceControllCellReactor.State
    
    init(deviceModel: DeviceModel) {
        self.initialState = State.init(deviceModels: deviceModel)
    }
    
    
    func mutate(action: DeviceControllCellReactor.Action) -> Observable<Mutaion> {
        
        switch action {
        case .sendCommand(let type):
            let sn = self.currentState.deviceModels.boxsn
            let eqmId = self.currentState.deviceModels.orderby!
            let state = type.rawValue
            let channel = self.currentState.deviceModels.channel!
            let param = ["msgid": "1460088436",
                         "boxsn": sn,
                         "eqmId": eqmId,
                         "state": state,
                         "energy": "0",
                         "channel": channel]
            
            FHSoketManager.shear().sendMessage(event: "pubState", data: param as [String : Any])
            return .just(Mutaion.setStatus(type))
        }
    }


    func reduce(state: DeviceControllCellReactor.State, mutation: DeviceControllCellReactor.Mutaion) -> DeviceControllCellReactor.State {
        
        var newState = state
       
        switch mutation {
        case .setStatus(let model):
            
            switch model {
            case .off:
                newState.deviceModels.status = SmartDeviceSwitchState.off.rawValue
                return newState
            case .on:
                newState.deviceModels.status = SmartDeviceSwitchState.on.rawValue
                return newState
            case .pause:
                newState.deviceModels.status = SmartDeviceSwitchState.pause.rawValue
                return newState
            }
        }
    }
    
}
