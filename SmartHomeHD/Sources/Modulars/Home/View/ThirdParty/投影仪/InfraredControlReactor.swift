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

class InfraredControlReactor: NSObject, Reactor {

    enum Action {
        
        /// 获取遥控板
        case fetchRemote
        
        case sendCommond(IRKeyType)
    }
    
    enum Mutaion {
    }
    
    struct State {
        var deviceModels:DeviceModel!
    }
    
    var initialState: InfraredControlReactor.State
    let service: CommonServerType = CommonServer.init()
    var remoteModel: TJRemote?
    init(deviceModel: DeviceModel) {
        self.initialState = State.init(deviceModels: deviceModel)
    }
    
    func mutate(action: InfraredControlReactor.Action) -> Observable<InfraredControlReactor.Mutaion> {
        
        switch action {
        case . fetchRemote:
            let remoteID = self.currentState.deviceModels.rowcount!
           
        
            TJRemoteClient.shared().downloadRemote(remoteID) { [weak self](error, remoteModel) in
                guard let self = self else {return}
                
                if error == .success || error == .localDataUpdateToDate {
                    log.info("下载遥控器成功")
                    FHToaster.show(text: "下载遥控器成功")
                    self.remoteModel = remoteModel
                }
                else {
                    log.error("下载遥控器失败: \(error.rawValue)")
                    FHToaster.show(text: "下载遥控器失败")
                }
            }
        case .sendCommond(let keyType):
            let irList = fetchIRKey(keyType: keyType)
            if irList.count == 0 { FHToaster.show(text: "遥控器不可用") }
            for ir in irList {
                
                guard let irData = ir.data , let data = TJRemoteHelper.getIrCode(ir.freq, data: irData) else {
                   FHToaster.show(text: "按键解析失败")
                    return .empty()
                }
                
                let sn = self.currentState.deviceModels.boxsn
                
                let param:[String : Any] = ["vender": "2",
                             "boxsn": sn!,
                             "data": Tool.dataToHexString(with: data),
                             "type": 0]
                
                FHSoketManager.shear().sendMessage(event: "pubIrMatchTjia", data: param )
            }
            
            break
            
        }
        
        return .empty()
    }

}

extension NSData {
    
    func toHexString () -> String {
        let len = self.length        
        var hexString = ""
       return ""
    }
}

extension InfraredControlReactor {
    
    /// 根据 按键类型获取按键列表
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
