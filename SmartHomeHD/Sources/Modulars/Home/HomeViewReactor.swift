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
        var setcions: [HomeViewSection]?
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
                
                    if let roomList = data.roomlist ,
                        let floorList = data.floorlist,
                        let devicelist = data.list {
                        return Observable.just(.setUserInfo(floorList, roomList, devicelist))
                    }
                    
                    return .empty()
                }).catchError({ (error) -> Observable<Mutaion> in
                    FHToaster.show(text: error.localizedDescription)
                    return .empty()
                })
        }
       
    }
    
    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutaion) -> HomeViewReactor.State {
        
        var newState = state
        
        switch mutation {
            
        case .setUserInfo(let floorModels, let roomModels, let models):
            
            ///1 遍历楼层列表
            let sections = floorModels.map { (floorModel) -> HomeViewSection in

                let reactor = FloorViewReactor.init(floors: roomModels, devicelist: models)
                
                return  HomeViewSection.init(items: [reactor])
            }
           
            newState.setcions = sections
            return newState
        }
    }
}



