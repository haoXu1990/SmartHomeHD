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
import SwiftyUserDefaults

class HomeViewReactor: NSObject, Reactor {
   
    enum Action {
        case fetchUserInfo
    }
    
    enum Mutaion {
        
        case setUserInfo([FloorMoel], [RoomMoel], [DeviceModel], [SceneModeModel])
    }
    
    struct State {
        var setcions: [HomeViewSection]? = []
        
        var floors: [FloorMoel] = []
        
        var rooms: [RoomMoel] = []
        
        var devices: [DeviceModel] = []
        
        var showActivityView: Bool = true
    }
    
    let initialState: HomeViewReactor.State = State()
    let service: DeviceServerType
    
    init(service: DeviceServerType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        
        switch action {
        case .fetchUserInfo:
            
            guard let appid = Defaults[.appid],
                let houseid = Defaults[.houseid] else {
                    FHToaster.show(text: "用户数据无效,请重新登录")
                    return .empty()
            }
            /// 请求控制列表参数
            let param: [String: Any] = ["method": "controll.eqment.info", "appid": appid, "houseid": houseid, "istype": "1"]
            
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
            newState.floors = floorModels
            newState.rooms = roomModels
            newState.devices = models
            newState.showActivityView = false
            return newState
        }
    }
}



