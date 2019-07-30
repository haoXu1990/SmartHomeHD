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
import SwiftyUserDefaults

class SmartCameraViewReactor: NSObject, Reactor {
    
    enum Action {
        case fetchCameraInfo
    }
    
    enum Mutaion {
        
        case setToken(String)
        
        case setCameraModel(SmartCameraYSModel)
    }
    
    struct State {
        var deviceModels:DeviceModel!
        var cameraModel:SmartCameraYSModel?
    }
    
    var initialState: SmartCameraViewReactor.State
    let service: CommonServerType = CommonServer.init()
    
    init(deviceModel: DeviceModel) {
        self.initialState = State.init(deviceModels: deviceModel, cameraModel: nil)
    }
    
    func mutate(action: SmartCameraViewReactor.Action) -> Observable<SmartCameraViewReactor.Mutaion> {
        
        switch action {
        case .fetchCameraInfo:
            let deviceSerial = self.currentState.deviceModels.eqmsn!
            guard let token = Defaults[.ysAccessToken] else { return .empty()}
            
            let dict: [String: Any] = ["method": "manage.video.info",
                        "appid": "Rd88h",
                        "houseid":"637",
                        "accessToken": token,
                        "deviceSerial": deviceSerial]
            
            return service.requestGet(parames: dict)
                .mapResponseToObject(type: SmartCameraYSModel.self)
                .asObservable()
                .flatMap({ (model) -> Observable<SmartCameraViewReactor.Mutaion> in
                    return Observable.just(Mutaion.setCameraModel(model))
                })
                .catchError({ (error) -> Observable<SmartCameraViewReactor.Mutaion> in
                    
                    FHToaster.show(text: error.localizedDescription)
                    return .empty()
                })
          
            
        }
        
    }
    
    func reduce(state: SmartCameraViewReactor.State, mutation: SmartCameraViewReactor.Mutaion) -> SmartCameraViewReactor.State {
        
        var newState = state
        switch mutation {
        case .setCameraModel(let cameraModel):
            newState.cameraModel = cameraModel
            return newState
        default:
            return state
        }
    }
    
}
