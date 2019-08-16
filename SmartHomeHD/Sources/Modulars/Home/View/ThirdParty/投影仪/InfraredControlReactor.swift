//
//  InfraredControlReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/31.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import NSObject_Rx
import Moya
import CoreFoundation
import Foundation
import SwiftyUserDefaults
import Dollar

class InfraredControlReactor: NSObject, Reactor {

    enum Action {
        
        /// 获取遥控板
        case fetchRemote
        
        /// 发送红外命令(空调除外)
        case sendCommond(IRKeyType)
        
        /// 发送空调红外命令
        case sendAirCommand(IRKeyType, Int)
      
    }
    
    enum Mutaion {
        
        /// 设置空调状态
        case setAirStatus(TJAirRemoteState?)
    }
    
    struct State {
        
        var deviceModels:DeviceModel!
        
        var airStatus:TJAirRemoteState?
    }
    
    var initialState: State
    let service: CommonServerType = CommonServer.init()
    var remoteModel: TJRemote?
    var allKeyType: [IRKeyType]
    var extensionKeys: [TJIrKey]?
    
    init(deviceModel: DeviceModel, allKeyType: [IRKeyType] = [.power]) {
        
        self.allKeyType = allKeyType
        self.initialState = State.init(deviceModels: deviceModel, airStatus: nil)
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        
        switch action {
        case .fetchRemote:
            let remoteID = self.currentState.deviceModels.rowcount!
            
            if let remoteModel = TJDataManager.shared().getRemoteById(remoteID) {
                FHToaster.show(text: "加载本地遥控器成功")
                self.remoteModel = remoteModel
                self.extensionKeys = self.fetchExtensionKeys(remote: remoteModel)
            }
            else {
                TJRemoteClient.shared().downloadRemote(remoteID) { [weak self](error, remoteModel) in
                    guard let self = self else {return}
                    
                    if error == .success || error == .localDataUpdateToDate {
                        log.info("下载遥控器成功")
                        FHToaster.show(text: "下载遥控器成功")
                        self.remoteModel = remoteModel
                        self.extensionKeys = self.fetchExtensionKeys(remote: remoteModel)
                    }
                    else {
                        log.error("下载遥控器失败: \(error.rawValue)")
                        FHToaster.show(text: "下载遥控器失败")
                    }
                }
            }
            
        case .sendCommond(let keyType):
            let irList = fetchIRKey(keyType: keyType)
            if irList.count == 0 { FHToaster.show(text: "按键获取失败") }
            sendIRSoket(irList: irList)
            
            break
        case .sendAirCommand(let keyType, let temper):
            log.debug("keyType: \(keyType.rawValue)")
            let irList = fetchAirIRKey(keyType: keyType, tmper: temper)
            if irList.count == 0 { FHToaster.show(text: "按键获取失败") }
            sendIRSoket(irList: irList, type: 1)
            
            if let remoteModel = self.remoteModel {
                let remoteState = TJAirRemoteStateManager.shared()?.getAirRemoteState(remoteModel._id)
                return Observable.just(Mutaion.setAirStatus(remoteState))
            }
             break
        }
       
        return .empty()
    }

    func reduce(state: State, mutation: Mutaion) -> State {
        var newState = state
        switch mutation {
        case .setAirStatus(let status):
            newState.airStatus = status
        return newState
        }
        
    }
}

extension InfraredControlReactor {
    
    func sendIRSoket(irList: [TJInfrared], type: Int = 0) {
        for ir in irList {
            
            guard let irData = ir.data , let data = TJRemoteHelper.getIrCode(ir.freq, data: irData) else {
                FHToaster.show(text: "按键解析失败")
                return
            }
            
            let sn = self.currentState.deviceModels.boxsn
            
            let param:[String : Any] = ["vender": "2",
                                        "boxsn": sn!,
                                        "data": Tool.dataToHexString(with: data),
                                        "type": type]
            
            FHSoketManager.shear().sendMessage(event: "pubIrMatchTjia", data: param )
        }
    }
}

extension InfraredControlReactor {
    
    
    /// 获取遥控板得所有扩展按键
    ///
    /// - Parameter remote: 遥控板
    /// - Returns: [TJIrKey]
    func fetchExtensionKeys(remote: TJRemote) -> [TJIrKey] {
        
        var extensionKeys: [TJIrKey] = []
        
        if let keys = remote.keys as? [TJIrKey] {
            for key in keys {
                if allKeyType.contains(key.type) == false {
                    extensionKeys.append(key)
                }
            }
        }
        
        return extensionKeys
    }

}
extension InfraredControlReactor {
    
    /// 根据 按键类型获取空调按键列表
    ///
    /// - Parameter keyType: 按键类型
    /// - Parameter tmper: 温度 (只在温度设置时需要)
    /// - Returns: [TJInfrared]
    func fetchAirIRKey(keyType: IRKeyType, tmper: Int) -> [TJInfrared] {
        
        if let remoteModel = self.remoteModel, let keys:[TJIrKey] = remoteModel.keys as? [TJIrKey] {
            
            let remoteState = TJAirRemoteStateManager.shared()?.getAirRemoteState(remoteModel._id)
            /// 温度设置, 这个Type 是自定义的
            if keyType == .tempSet {
                
                log.info("处理空调温度设置按键")
                let param = TJAdvancedAirRemoteParam.init(airRemoteState: remoteState!)
                param.temp = Int32(tmper)
                guard let irList = TJRemoteHelper.sharedInstance().fetchAirRemoteInfrared(remoteModel, state: remoteState!, param: param) else {
                    return []
                }
                return irList
            }
            else {
                
                for key in  keys {
                    if key.type == keyType {
                        
                        if key.type == .airTimer {
                            /// 空调定时按键
                            log.info("处理空调定时按键")
                            guard let irList = TJRemoteHelper.sharedInstance().fetchAirTimerInfrared(key, state: remoteState!, time: 10) else {
                                return []
                            }
                            return irList
                        }
                        else {
                            log.info("处理空调普通按键")
                            /// 空调普通按键
                            guard let irList = TJRemoteHelper.sharedInstance().fetchAirRemoteInfrared(remoteModel, key: key, state: remoteState!) else {
                                return []
                            }
                            return irList
                        }
                    }
                }
            }
            
        }
        
        return []
    }
    
    /// 根据 按键类型获取按键列表 (空调除外)
    ///
    /// - Parameter keyType: 按键类型
    /// - Returns: [TJInfrared]
    func fetchIRKey(keyType: IRKeyType) -> [TJInfrared] {
        
        if let remoteModel = self.remoteModel, let keys:[TJIrKey] = remoteModel.keys as? [TJIrKey] {
            
            for key in  keys {
                /// 找到对应得按键列表
                if key.type == keyType {
                    
                    guard let irList = TJRemoteHelper.sharedInstance().fetchRemoteInfrared(remoteModel, key: key) else {
                        return []
                    }
                    return irList
                }
            }
        }
        
        return []
    }
}
