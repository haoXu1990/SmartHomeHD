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
        
        case addfloor(String)
        
        case deletedfloor(String)
        
        case setLayout(Bool)
    }
    
    enum Mutaion {
        
        case setUserInfo([FloorMoel], [RoomMoel], [DeviceModel], [SceneModeModel])
        
        case addfloor(FloorMoel)
        
        case deletedFloor(String)
        
        case setLayout(Bool)
    }
    
    struct State {
        var setcions: [HomeViewSection]? = []
        
        var floors: [FloorMoel] = []
        
        var rooms: [RoomMoel] = []
        
        var devices: [DeviceModel] = []
        
        var secenModels: [SceneModeModel] = []
        
        var showActivityView: Bool = true
    }
    
    let initialState: HomeViewReactor.State = State()
    let service: DeviceServerType
    
    init(service: DeviceServerType) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        guard let appid = Defaults[.appid],
            let houseid = Defaults[.houseid] else {
                FHToaster.show(text: "用户数据无效,请重新登录")
                return .empty()
        }
        
        switch action {
        case .fetchUserInfo:
            
            let param: [String: Any] = ["method": "controll.eqment.info",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "istype": "1"]
            
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
        case .addfloor(let floorName):
            let param: [String: Any] = ["method": "manage.house.room",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "istype": "2",
                                        "title":floorName]
            return commonService.requestPost(parames: param).mapResponseToObject(type: FloorMoel.self).asObservable().flatMap { (model) -> Observable<Mutaion> in
                    return .just(Mutaion.addfloor(model))
            }
            
        case .deletedfloor(let floorID):
            let param: [String: Any] = ["method": "manage.house.room",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "istype": "2",
                                        "id":floorID]
            
            return commonService.requestDeleted(parames: param).mapJSON().asObservable().flatMap({ (json) -> Observable<Mutaion> in
                
                guard let result = json as? [String: Any] else {return .empty()}
                
                if let errorCode = result["errCode"] as? Int {
                    if errorCode == 200 {
                        return .just(Mutaion.deletedFloor(floorID))
                    }
                    else {
                        let mesg = result["message"] as? String
                        FHToaster.show(text: mesg.or("删除失败"))
                        return .empty()
                    }
                }
                return .empty()
            })
            
        case .setLayout(let layout):
            return .just(Mutaion.setLayout(layout))
        }
       
    }
    
    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutaion) -> HomeViewReactor.State {
        
        var newState = state
        
        switch mutation {
            
        case .setUserInfo(let floorModels, let roomModels, let models, let scenModes):
            
            ///1 遍历楼层列表
            let sections = floorModels.map { (floorModel) -> HomeViewSection in

                let tmpRooms = roomModels.filter({ (tmpModel) -> Bool in
                    return (floorModel.floor_id == tmpModel.floor_id) && (tmpModel.floor_id != "0")
                })
                
                let reactor = FloorViewReactor.init(roomModels: tmpRooms, devicelist: models, secnModes: scenModes, layout: true)
                
                return  HomeViewSection.init(items: [reactor])
            }
           
            newState.setcions =  sections
            newState.floors = floorModels
            newState.rooms = roomModels
            newState.devices = models
            newState.secenModels = scenModes
            newState.showActivityView = false
            return newState
        case .addfloor(let model):
            newState.floors.append(model)
            let floorModels = newState.floors
            let roomModels = newState.rooms
            let models = newState.devices
            let scenModes = newState.secenModels
            ///1 遍历楼层列表
            let sections = floorModels.map { (floorModel) -> HomeViewSection in
                
                let tmpRooms = roomModels.filter({ (tmpModel) -> Bool in
                    return (floorModel.floor_id == tmpModel.floor_id) && (tmpModel.floor_id != "0")
                })
             
                let reactor = FloorViewReactor.init(roomModels: tmpRooms, devicelist: models, secnModes: scenModes, layout: true)
                
                return  HomeViewSection.init(items: [reactor])
            }
            newState.setcions = sections
            return newState
        case .deletedFloor(let floolrID):
            
            newState.floors = newState.floors.filter({ (model) -> Bool in
                return model.floor_id != floolrID
            })
            
            let floorModels = newState.floors
            let roomModels = newState.rooms
            let models = newState.devices
            let scenModes = newState.secenModels
            ///1 遍历楼层列表
            let sections = floorModels.map { (floorModel) -> HomeViewSection in
                
                let tmpRooms = roomModels.filter({ (tmpModel) -> Bool in
                    return (floorModel.floor_id == tmpModel.floor_id) && (tmpModel.floor_id != "0")
                })
                
                let reactor = FloorViewReactor.init(roomModels: tmpRooms, devicelist: models, secnModes: scenModes, layout: true)
                
                return  HomeViewSection.init(items: [reactor])
            }
            newState.setcions = sections
            
            
            return newState
        case .setLayout(let layout):
            
            let floorModels = newState.floors
            let roomModels = newState.rooms
            let scenModes = newState.secenModels
            let models = newState.devices
            
            ///1 遍历楼层列表
            let sections = floorModels.map { (floorModel) -> HomeViewSection in
                
                let tmpRooms = roomModels.filter({ (tmpModel) -> Bool in
                    return (floorModel.floor_id == tmpModel.floor_id) && (tmpModel.floor_id != "0")
                })
                
                let reactor = FloorViewReactor.init(roomModels: tmpRooms, devicelist: models, secnModes: scenModes, layout: layout)
                
                return  HomeViewSection.init(items: [reactor])
            }
            newState.setcions = sections
            
            return newState
        }
    }
}



