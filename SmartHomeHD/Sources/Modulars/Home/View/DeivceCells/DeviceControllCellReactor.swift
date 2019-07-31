//
//  DeviceControllCellReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/26.
//  Copyright © 2019 FH. All rights reserved.
//


import ReactorKit
import RxSwift
import SwiftyUserDefaults

class DeviceControllCellReactor: NSObject,Reactor {

    enum Action {
        /// Socket 控制自研设备 开(左) 、关(右)、 暂停 等命令
        case sendCommand(SmartDeviceSwitchState)
        
        case fetchYsAccessToken
    }
    
    enum Mutaion {
        
        case setStatus(SmartDeviceSwitchState)
    }
    
    struct State {
        var deviceModels:DeviceModel!
    }
    
    let initialState: DeviceControllCellReactor.State
    
    let service: CommonServerType = CommonServer.init()
    
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
        case .fetchYsAccessToken:
             /// 获取萤石云 AccessToken
            let dict = ["method": "manage.video.info",
                        "appid": "",
                        "houseid":""]
            service.requestGet(parames: dict).mapJSON().subscribe(onSuccess: { (resonse) in
                
                guard let json = resonse as? [String: Any] else { return }
                let code = json["errCode"] as? Int
                
                if code.or(-1) == 200 {
                    
                    if let result = json["result"] as? [String: Any] {
                        let token = result["token"] as! String
//                        let reamark = result["token"] as! String
                        log.debug("获取到萤石云 Token: \(token)")
                        Defaults[.ysAccessToken] = token                        
                    }
                }
                
            }) { (error) in
                
            }.disposed(by: rx.disposeBag)
            return .empty()
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
