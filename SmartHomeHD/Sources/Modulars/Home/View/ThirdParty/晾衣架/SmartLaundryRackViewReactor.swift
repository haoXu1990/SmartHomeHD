//
//  SmartLaundryRackViewReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/11/15.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import Moya
import CoreFoundation
import Foundation
import SwiftyUserDefaults
import ReactorKit

enum SmartLaundryRackKey: Int {
    /// 电源
    case power = 0x01
    /// 升降
    case riseAndFall = 0x02
    /// 照明
    case light = 0x03
    /// 消毒
    case antivirus = 0x04
    /// 烘干
    case dring = 0x05
    /// 风干
    case wind = 0x06
}

enum SmartLaundryRackKeyParam: Int {
    /// 关 or 向上
    case off = 0x00
    /// 开 or 暂停
    case on = 0x01
    /// 反转 or 向下
    case overturn = 0x02
}


class SmartLaundryRackViewReactor: NSObject, Reactor {
    
    enum Action {
        case sendCommand(key:SmartLaundryRackKey,
            param:SmartLaundryRackKeyParam,
            time:Int,
            cmdType: String)
    }
    
    enum Mutaion {
        
    }
    
    struct State {
        var deviceModel:DeviceModel!
        
    }
    
    var initialState: SmartLaundryRackViewReactor.State
    let service: CommonServerType = CommonServer.init()
    
    init(deviceModel: DeviceModel) {
        self.initialState = State.init(deviceModel: deviceModel)
    }
    
    func mutate(action: SmartLaundryRackViewReactor.Action) -> Observable<SmartCameraViewReactor.Mutaion> {
        
        switch action {
        case .sendCommand(let key, let param, let time, let cmdType):
            sendCommand(key: key, param: param, time: time, cmdType: cmdType)
            break
        }
        
        return .empty()
    }
    
//    func reduce(state: SmartCameraViewReactor.State, mutation: SmartCameraViewReactor.Mutaion) -> SmartCameraViewReactor.State {
//
//        var newState = state
//
//    }
}

extension SmartLaundryRackViewReactor {
    
    func sendCommand(key:SmartLaundryRackKey,
                     param:SmartLaundryRackKeyParam,
                     time:Int,
                     cmdType: String) {
        
        guard let deviceModel = self.currentState.deviceModel else { return }
        
        let cmd = fetchCmd(deviceID: deviceModel.eqmsn, key: key, param: param, time: time)
        let appid = Defaults[.appid]
        let param = ["msgid": "1460088436",
                     "uid": appid,
                     "boxsn": deviceModel.boxsn,
                     "typeid": deviceModel.typeid,
                     "cmdtype": cmdType,
                     "cmd": cmd]
        
        FHSoketManager.shear().sendMessage(event: "TransLink", data: param as [String : Any])
    }
    
    
    func fetchCmd(deviceID:String,
                  key:SmartLaundryRackKey,
                  param: SmartLaundryRackKeyParam,
                  time:Int) -> String {
        
        return String.init(format: "%@%@%@%@", deviceID,intToHexString(number: Int64(key.rawValue), bitWith: 2), intToHexString(number: Int64(param.rawValue), bitWith: 2), intToHexString(number: Int64(time), bitWith: 4))
        
    }
    
    /// Int convert hexString
    ///
    /// - Parameters:
    ///   - number: need convert number
    ///   - bitWith: bitWithd
    /// - Returns: hexString
    func intToHexString(number:Int64, bitWith: Int) -> String {
        
        var tmpid = number
        
        var ttmping: Int64 = 0
        
        var nLetterValue: String = ""
        var str: String = ""
        for _ in 0..<19 {
            ttmping = tmpid % 16
            tmpid = tmpid / 16
            
            switch ttmping {
            case 10:
                nLetterValue = "a"
                break
            case 11:
                nLetterValue = "b"
                break
            case 12:
                nLetterValue = "c"
                break
            case 13:
                nLetterValue = "d"
                break
            case 14:
                nLetterValue = "e"
                break
            case 15:
                nLetterValue = "f"
                break
            default:
                nLetterValue = String.init(format: "%lld", ttmping)
            }
            
            str = nLetterValue.appending(str)
            
            if tmpid == 0 { break }
        }
        
        /// 根据位宽设置添0
        let zero = bitWith - str.count
        var result: String = ""
        for _ in 0..<zero {
            result.append("0")
        }
        
        return result.appending(str)
    }
}
