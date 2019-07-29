//
//  SmartCameraViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/29.
//  Copyright © 2019 FH. All rights reserved.
//

import ReactorKit
import RxSwift
import NSObject_Rx
import Moya
import CoreFoundation
import Foundation

class SmartCameraViewReactor: NSObject, Reactor {
    
    enum Action {
        case fetchToken
    }
    
    enum Mutaion {
        
        case setToken(String)
    }
    
    struct State {
       var deviceModels:DeviceModel!
    }
    
    var initialState: SmartCameraViewReactor.State
    let service: CommonServerType = CommonServer.init()
    
    init(deviceModel: DeviceModel) {
        self.initialState = State.init(deviceModels: deviceModel)
    }
    
    func mutate(action: SmartCameraViewReactor.Action) -> Observable<SmartCameraViewReactor.Mutaion> {
        
        switch action {
        case .fetchToken:
            let dict = ["method": "manage.video.info",
                        "appid": "",
                        "houseid":""]
            
            service.requestGet(parames: dict).subscribe(onSuccess: { (response) in
                
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                    return
                }
                
                log.debug(json)
            }) { (error) in
                log.debug("error")
            }.disposed(by: rx.disposeBag)
            
            return service.requestGet(parames: dict).mapJSON().asObservable().flatMap { (json) -> Observable<Mutaion> in
                
                guard let json = json as? [String: Any] else { return .empty() }
                
                if let code = json["errCode"] as? Int {
                    
                    if let result = json["result"] as? [String: Any] {
                        let token = result["token"] as! String
                        let deviceSerial = self.currentState.deviceModels.eqmsn
                        let dict = ["method": "manage.video.info",
                                    "appid": "Rd88h",
                                    "houseid":"637",
                                    "accessToken": token,
                                    "deviceSerial": deviceSerial]
                        
                        self.service.requestGet(parames: dict).mapJSON().subscribe(onSuccess: { (json) in
                            
                            log.debug(json)
                        }, onError: { (error) in
                            
                    
                        }).disposed(by: self.rx.disposeBag)
                    }
                }
                
                /// 请求失败
                return .empty()
            }
            
            return .empty()
        }
        
    }
    
    func reduce(state: SmartCameraViewReactor.State, mutation: SmartCameraViewReactor.Mutaion) -> SmartCameraViewReactor.State {

        return state
    }
    
    
}
