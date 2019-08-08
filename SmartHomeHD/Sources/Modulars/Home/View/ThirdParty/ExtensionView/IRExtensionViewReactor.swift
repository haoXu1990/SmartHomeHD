//
//  IRExtensionViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/7.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import NSObject_Rx
import Moya
import CoreFoundation
import Foundation


class IRExtensionViewReactor: NSObject, Reactor {
   
    enum Action {
        
        /// 获取遥控板
//        case fetchRemote
        
        /// 发送红外命令(空调除外)
        case sendCommond(IRKeyType)
        
        /// 发送空调红外命令
        case sendAirCommand(TJIrKey, Int)
        
    }
    
    enum Mutaion {
        
        /// 设置空调状态
        case setAirStatus(TJAirRemoteState?)
    }
    
    struct State {
        var extensionKeys: [TJIrKey]
        
//        var airStatus:TJAirRemoteState?
    }
    
    let initialState: IRExtensionViewReactor.State
    
    var remoteModel: TJRemote
    var deviceModel: DeviceModel
    
    init(remote: TJRemote, keys: [TJIrKey], deviceModel: DeviceModel) {
        self.deviceModel = deviceModel
        self.remoteModel = remote   
        self.initialState = State.init(extensionKeys: keys)
    }
    
    
    func mutate(action: Action) -> Observable<Mutaion> {
        
        switch action {
        case .sendCommond(let keyType):
            let irList = fetchIRKey(keyType: keyType)
            if irList.count == 0 { FHToaster.show(text: "按键获取失败") }
            sendIRSoket(irList: irList)
            
            break
        case .sendAirCommand(let key, let temper):
            log.debug("keyType: \(key.type.rawValue)")
            let irList = fetchAirIRKey(key: key, tmper: temper)
            if irList.count == 0 { FHToaster.show(text: "按键获取失败") }
            sendIRSoket(irList: irList, type: 1)

            break
        }
        
        return .empty()
    }
    
//    func reduce(state: State, mutation: Mutaion) -> State {
//        var newState = state
//        switch mutation {
//        case .setAirStatus(let status):
//
//            return newState
//        }
//
//    }
    
}

extension IRExtensionViewReactor {
    
    func sendIRSoket(irList: [TJInfrared], type: Int = 0) {
        for ir in irList {
            
            guard let irData = ir.data , let data = TJRemoteHelper.getIrCode(ir.freq, data: irData) else {
                FHToaster.show(text: "按键解析失败")
                return
            }
            
            let sn = self.deviceModel.boxsn
            
            let param:[String : Any] = ["vender": "2",
                                        "boxsn": sn!,
                                        "data": Tool.dataToHexString(with: data),
                                        "type": type]
            
            FHSoketManager.shear().sendMessage(event: "pubIrMatchTjia", data: param )
        }
    }
}


extension IRExtensionViewReactor {
    
    /// 根据 按键类型获取空调按键列表
    ///
    /// - Parameter keyType: 按键类型
    /// - Parameter tmper:  定时设置 (只在温度设置时需要)
    /// - Returns: [TJInfrared]
    func fetchAirIRKey(key: TJIrKey, tmper: Int) -> [TJInfrared] {
        
        
        if let remoteState = TJAirRemoteStateManager.shared()?.getAirRemoteState(remoteModel._id) {
            if remoteState.power == .off {
                
                return []
            }
            if key.type == .airTimer {
                /// 空调定时按键
                log.info("处理空调定时按键")
                guard let irList = TJRemoteHelper.sharedInstance().fetchAirTimerInfrared(key, state: remoteState, time: 10) else {
                    return []
                }
                return irList
            }
            else {
                log.info("处理空调普通按键")
                /// 空调普通按键
                guard let irList = TJRemoteHelper.sharedInstance().fetchAirRemoteInfrared(remoteModel, key: key, state: remoteState) else {
                    return []
                }
                return irList
            }
        }
        
        return []
    }
    
    /// 根据 按键类型获取按键列表 (空调除外)
    ///
    /// - Parameter keyType: 按键类型
    /// - Returns: [TJInfrared]
    func fetchIRKey(keyType: IRKeyType) -> [TJInfrared] {
        
        if let keys:[TJIrKey] = remoteModel.keys as? [TJIrKey] {
            
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
