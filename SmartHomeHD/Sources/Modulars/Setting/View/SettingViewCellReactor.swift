//
//  SettingViewCellReactor.swift
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

class SettingViewCellReactor: NSObject, Reactor  {
    
    enum Action {
        
        case addRoom(String, String)
        
        case deletedRoom(String)
        
        case roomAddDevice([DeviceModel], String)
    }
    
    enum Mutaion {
        
        case addRoom(RoomMoel)
        
        case deletedRoom(String)
        
        case setdevices(String)
    }
    
    struct State {
        var rooms: [RoomMoel] = []
        
        var devices: [DeviceModel] = []
        
        /// 无具体作用只是为了方便外界刷新数据
        var eqmids: String?
    }
    
    var initialState: SettingViewCellReactor.State
    var floorID: String
    init(rooms: [RoomMoel], devices: [DeviceModel], floorID: String) {
        self.floorID = floorID
        self.initialState = State.init(rooms: rooms, devices: devices, eqmids: nil)
    }
    
    
    func mutate(action: Action) -> Observable<Mutaion> {
        guard let appid = Defaults[.appid],
            let houseid = Defaults[.houseid] else {
                FHToaster.show(text: "用户数据无效,请重新登录")
                return .empty()
        }
        
        switch action {
        case .addRoom(let roomName, let floorID):
            let param: [String: Any] = ["method": "manage.house.room",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "istype": "1",
                                        "title": roomName,
                                        "floor_id": floorID]
            
            return commonService.requestPost(parames: param).mapResponseToObject(type: RoomMoel.self).asObservable().flatMap { (model) -> Observable<Mutaion> in
                return .just(Mutaion.addRoom(model))
                }.catchError({ (error) -> Observable<SettingViewCellReactor.Mutaion> in
                    log.error(error.localizedDescription)
                    FHToaster.show(text: error.localizedDescription)
                    return .empty()
                })
        
        case .deletedRoom(let roomID):
            let param: [String: Any] = ["method": "manage.house.room",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "istype": "1",
                                        "id":roomID]
            
            return commonService.requestDeleted(parames: param)
                    .mapJSON()
                    .asObservable()
                    .flatMap({ (json) -> Observable<Mutaion> in
                    
                    guard let result = json as? [String: Any] else {return .empty()}
                    
                    if let errorCode = result["errCode"] as? Int {
                        if errorCode == 200 {
                            return .just(Mutaion.deletedRoom(roomID))
                        }
                        else {
                            let mesg = result["message"] as? String
                            FHToaster.show(text: mesg.or("删除失败"))
                            return .empty()
                        }
                    }
                    return .empty()
                })
        case .roomAddDevice(let devices, let roomID):
            
            let eqmids = devices.map { (model) -> String in
                return model.eqmid
            }
            
            let str: String = eqmids.joined(separator: ",")            
            
            let param: [String: Any] = ["method": "manage.eqment.key",
                                        "appid": appid,
                                        "houseid": houseid,
                                        "roomid": roomID,
                                        "eqmid":str]
            return commonService
                .requestPut(parames: param)
                .mapJSON()
                .asObservable()
                .flatMap({ (json) -> Observable<Mutaion> in
                
                guard let result = json as? [String: Any] else {return .empty()}
                
                if let errorCode = result["errCode"] as? Int {
                    if errorCode == 200 {
                        FHToaster.show(text: "修改成功")
                        return .just(Mutaion.setdevices(str))
                    }
                    else {
                        let mesg = result["message"] as? String
                        FHToaster.show(text: mesg.or("删除失败"))
                        return .empty()
                    }
                }
                return .empty()
            })
        }
        
    }


    
    func reduce(state: State, mutation: Mutaion) -> State {
        
        var newState = state
        
        switch mutation {
        case .addRoom(let model):
            newState.rooms.append(model)
            newState.eqmids = model.roomid
            return newState
        case .deletedRoom(let roomID):
            newState.rooms = newState.rooms.filter({ (model) -> Bool in
                return model.roomid != roomID
            })
            newState.eqmids = roomID
            return newState
        case .setdevices(let str):
            newState.eqmids = str
            return newState
        }
    
    
    }

}
