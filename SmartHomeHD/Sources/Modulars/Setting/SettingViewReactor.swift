//
//  SettingViewReactor.swift
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
import SwiftyUserDefaults

class SettingViewReactor: NSObject {
    enum Action {
        
        case fetchFloorList
    }
    
    enum Mutaion {
        
    }
    
    struct State {
        
    }
    
    let initialState = State()
    
    let serverType = CommonServer()
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .fetchFloorList:
            guard let appid = Defaults[.appid],
                let houseid = Defaults[.houseid] else {
                    FHToaster.show(text: "用户数据无效,请重新登录")
                    return .empty()
            }
            
            /// 请求控制列表参数
            let param: [String: Any] = ["method": "eqment.alarm.list",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "time": "2019-08-08",
                                        "eqmsn":"0",
                                        "isalarm":"1",
                                        "minid":"0",
                                        "calendar":"1"]
            

            return .empty()
//            return serverType.requestGet(parames: param)
//                .mapResponseToObjectArray(type: AlarmModel.self)
//                .asObservable()
//                .flatMap({ (data) -> Observable<Mutaion> in
//                    return .just(Mutaion.setAlarmList(data))
//
//                }).catchError({ (error) -> Observable<Mutaion> in
//                    FHToaster.show(text: error.localizedDescription)
//                    return .empty()
//                })
            
        }
    }
    
//    func reduce(state: State, mutation: Mutaion) -> State {
//        var newState = state
//
//
//    }
}
