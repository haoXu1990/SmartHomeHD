//
//  MessageViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/9.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import NSObject_Rx
import ReactorKit
import RxSwiftExt
import RxDataSources
import RxCocoa
import RxSwift
import SwiftyUserDefaults
import SwiftDate
import LXFProtocolTool
class MessageViewReactor: NSObject, Reactor, RefreshControllable {

    enum Action {
        case fetchAlarmList(Bool)
    }
    
    enum Mutaion {
        
        case setAlarmList([AlarmModel], Bool)
        case setRefreshStatus(RefreshStatus)
    }
    
    struct State {
        var alarmModels: [AlarmModel]?
    }
    
    let initialState = State()
    
    let serverType = CommonServer()
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .fetchAlarmList(let more):
            guard let appid = Defaults[.appid],
                let houseid = Defaults[.houseid] else {
                    FHToaster.show(text: "用户数据无效,请重新登录")
                    return .empty()
            }
            let date = Date.init()
            
            var minid = "0"
            
            if more, let lastModel =  self.currentState.alarmModels?.last {
                minid = lastModel.tmptimes.or("0")
            }
            
            let time = date.toFormat("yyyy-MM-dd",locale: Locale.current)
            /// 请求控制列表参数
            let param: [String: Any] = ["method": "eqment.alarm.list",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "time": time,
                                        "eqmsn":"0",
                                        "isalarm":"1",
                                        "minid":minid,
                                        "calendar":"1"]
            
            let request = serverType.requestGet(parames: param)
                .mapResponseToObjectArray(type: AlarmModel.self)
                .asObservable()
                .flatMap({ (data) -> Observable<Mutaion> in
                    return .just(Mutaion.setAlarmList(data, more))
                    
                }).catchError({ (error) -> Observable<Mutaion> in
                    FHToaster.show(text: error.localizedDescription)
                    return .empty()
                })
            
            let endRefresh:RefreshStatus = minid == "0" ? .endHeaderRefresh : .endFooterRefresh            
            
            return Observable.concat([Observable.just(Mutaion.setRefreshStatus(endRefresh)),
                                      request])
         
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var newState = state
        
        switch mutation {
        case .setAlarmList(let models, let more):
            if more {
                newState.alarmModels?.append(contentsOf: models)
            }
            else {
                newState.alarmModels = models
            }
        return newState
        case .setRefreshStatus(let value):
            lxf.refreshStatus.value = value
        }
        return newState
    }
}
