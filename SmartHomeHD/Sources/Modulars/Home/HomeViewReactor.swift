//
//  HomeViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import RxSwift
import NSObject_Rx
import ReactorKit
import RxSwiftExt
import RxDataSources
import RxCocoa


class HomeViewReactor: NSObject, Reactor {
   
    enum Action {
        case fetchUserInfo
    }
    
    enum Mutaion {
        
        case setUserInfo([FloorMoel], [RoomMoel], [DeviceModel], [SceneModeModel])
    }
    
    struct State {
        var setcions: [HomeViewSection]?
        
        var showActivityView: Bool = true
    }
    
    let initialState: HomeViewReactor.State
    let service: DeviceServerType
    
    init(service: DeviceServerType) {
      
        self.initialState = State.init()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        
        switch action {
        case .fetchUserInfo:
            
            /// 请求控制列表参数
            let param: [String: Any] = ["method": "controll.eqment.info", "appid": "Rd88h", "houseid": "637", "istype": "1"]
            
            return service.fetchDeviceList(parames: param)
                .mapResponseToObject(type: HomeDeviceModel.self)
                .asObservable()
                .flatMap({ (data) -> Observable<Mutaion> in
                
                    let roomList = data.roomlist.or([])
                    let floorList = data.floorlist.or([])
                    let devicelist = data.list.or([])
                    let scenModel = data.modelist.or([])
                    return Observable.just(.setUserInfo(floorList, roomList, devicelist, scenModel))
                    
                }).catchError({ (error) -> Observable<Mutaion> in
                    FHToaster.show(text: error.localizedDescription)
                    return .empty()
                })
        }
       
    }
    
    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutaion) -> HomeViewReactor.State {
        
        var newState = state
        
        switch mutation {
            
        case .setUserInfo(let floorModels, let roomModels, let models, let scenModes):
            
            ///1 遍历楼层列表
            let sections = floorModels.map { (floorModel) -> HomeViewSection in

                let reactor = FloorViewReactor.init(floors: roomModels, devicelist: models, secnModes: scenModes)
                
                return  HomeViewSection.init(items: [reactor])
            }
           
            newState.setcions =  sections
            newState.showActivityView = false
            return newState
        }
    }
}



