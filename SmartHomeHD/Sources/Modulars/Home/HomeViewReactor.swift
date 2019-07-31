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
        
        case setUserInfo([FloorMoel], [RoomMoel], [DeviceModel])
    }
    
    struct State {
        var setcions: [HomeViewSection] = []
    }
    
    let initialState: HomeViewReactor.State
    let service: DeviceServerType
    
    init(service: DeviceServerType) {
      
        self.initialState = State.init()
        self.service = service
    }
    
    func mutate(action: HomeViewReactor.Action) -> Observable<HomeViewReactor.Mutaion> {
        
        switch action {
        case .fetchUserInfo:
            
            /// 请求控制列表参数
            let param: [String: Any] = ["method": "controll.eqment.info", "appid": "Rd88h", "houseid": "637", "istype": "1"]
            
            return service.fetchDeviceList(parames: param)
                .mapResponseToObject(type: HomeDeviceModel.self)
                .asObservable()
                .flatMap({ (data) -> Observable<HomeViewReactor.Mutaion> in
                
                    if let roomList = data.roomlist ,
                        let floorList = data.floorlist,
                        let devicelist = data.list {
                        return Observable.just(Mutaion.setUserInfo(floorList, roomList, devicelist))
                    }
                    
                    return .empty()
                })
        }
       
    }
    
    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutaion) -> HomeViewReactor.State {
        
        var newState = state
        
        switch mutation {
            
        case .setUserInfo(let floorModels, let roomModels, let models):
            /// 在这里创建 Section 用于显示几个楼层
            
            
            /// 这里应该根据 楼层模型创建 section
            let sections = floorModels.compactMap { (floorModel) -> HomeViewSection in
                // 查找出当前楼层下得所有房间
                let roomModels = roomModels.filter({ (roomModel) -> Bool in
                    return roomModel.floor_id == floorModel.floor_id
                })
                
                /// 每个 Section 固定只有一个 Cell(items.count = 1)
//                return HomeViewSection.ini
             
                return HomeViewSection.init(items: [floorModel], roomModels: roomModels, deviceListModel: models)
            }
            newState.setcions = sections
            return newState
        }
    }
}



