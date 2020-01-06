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
import LXFProtocolTool
class HomeViewReactor: NSObject, Reactor, RefreshControllable {
   
    enum Action {
        
        case fetchUserInfo
        
        case addfloor(String)
        
        case deletedfloor(String)
        
        case setLayout(Bool)
        
        case modifyDeviceStatus(String ,Int, Int)
    }
    
    enum Mutaion {
        
        case setUserInfo([FloorMoel], [RoomMoel], [DeviceModel], [SceneModeModel])
        
        case addfloor(FloorMoel)
        
        case deletedFloor(String)
        
        case setLayout(Bool)
        
        case setDeviceStatus(String, Int, Int)
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
                    self.lxf.refreshStatus.value = .endHeaderRefresh
                    let roomList = data.roomlist.or([])
                    let floorList = data.floorlist.or([])
                    let devicelist = data.list.or([])
                    let scenModel = data.modelist.or([])
                    FHToaster.show(text: "更新界面成功")
                    return Observable.just(.setUserInfo(floorList, roomList, devicelist, scenModel))
                    
                }).catchError({ (error) -> Observable<Mutaion> in
                    self.lxf.refreshStatus.value = .endHeaderRefresh
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
        case .modifyDeviceStatus(let eqmsn, let channel, let state):
            return .just(Mutaion.setDeviceStatus(eqmsn, channel, state))
        }
       
    }
    
    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutaion) -> HomeViewReactor.State {
        
        var newState = state
        
        switch mutation {
            
        case .setUserInfo(let floorModels, let roomModels, let models, let scenModes):            

            newState.setcions = sectionFactory(floorModels: floorModels, roomModels: roomModels, models: models, scenModes: scenModes, layout: true)// sections
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
            newState.setcions = sectionFactory(floorModels: floorModels, roomModels: roomModels, models: models, scenModes: scenModes, layout: true)
            return newState
        case .deletedFloor(let floolrID):
            
            newState.floors = newState.floors.filter({ (model) -> Bool in
                return model.floor_id != floolrID
            })
            
            let floorModels = newState.floors
            let roomModels = newState.rooms
            let models = newState.devices
            let scenModes = newState.secenModels
            newState.setcions = sectionFactory(floorModels: floorModels, roomModels: roomModels, models: models, scenModes: scenModes, layout: true)
            
            
            return newState
        case .setLayout(let layout):
            
            let floorModels = newState.floors
            let roomModels = newState.rooms
            let scenModes = newState.secenModels
            let models = newState.devices
            newState.setcions = sectionFactory(floorModels: floorModels, roomModels: roomModels, models: models, scenModes: scenModes, layout: layout)
            
            return newState
        case .setDeviceStatus(let eqmsn, let channel, let state):
            
            let floorModels = newState.floors
            let roomModels = newState.rooms
            let scenModes = newState.secenModels
            /// 找到设备列表中的设备，
            newState.devices = newState.devices.map { (deviceModel) -> DeviceModel in
                var tmpModel = deviceModel
                if  deviceModel.eqmsn == eqmsn
                && deviceModel.channel?.toInt() == channel {
                    /// 修改状态
                    tmpModel.status = String(state)
                    return tmpModel
                }
                return deviceModel
            }
            
            
            newState.setcions = sectionFactory(floorModels: floorModels, roomModels: roomModels, models: newState.devices, scenModes: scenModes, layout: true)
            
            
            return newState
        }
    }
}



extension HomeViewReactor {
    
    func sectionFactory(floorModels:[FloorMoel],
                        roomModels:[RoomMoel],
                        models:[DeviceModel],
                        scenModes:[SceneModeModel],
                        layout: Bool) -> [HomeViewSection] {
        ///1 遍历楼层列表
        let sections = floorModels.map { (floorModel) -> HomeViewSection in
            
            let tmpRooms = roomModels.filter({ (tmpModel) -> Bool in
                return (floorModel.floor_id == tmpModel.floor_id) && (tmpModel.floor_id != "0")
            })
            
            let reactor = FloorViewReactor.init(roomModels: tmpRooms, devicelist: models, secnModes: scenModes, layout: layout, floorModel: floorModel)
            
            return  HomeViewSection.init(items: [reactor])
        }
        
        return sections
    }
}

