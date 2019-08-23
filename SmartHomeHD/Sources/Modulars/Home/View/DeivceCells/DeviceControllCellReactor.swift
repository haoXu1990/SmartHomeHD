//
//  DeviceControllCellReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/26.
//  Copyright © 2019 FH. All rights reserved.
//


import ReactorKit
import RxSwift
import SwiftyUserDefaults
import SwiftDate

class DeviceControllCellReactor: NSObject,Reactor {

    enum Action {
        /// Socket 控制自研设备 开(左) 、关(右)、 暂停 等命令
        case sendCommand(SmartDeviceSwitchState)
        
        case fetchYsAccessToken
    }
    
    enum Mutaion {
        
        case setStatus(SmartDeviceSwitchState)
    }
    
    struct State {
        var deviceModels:DeviceModel!
    }
    
    let initialState: DeviceControllCellReactor.State
    
    let service: CommonServerType = CommonServer.init()
    
    init(deviceModel: DeviceModel) {
        self.initialState = State.init(deviceModels: deviceModel)
    }
    
    
    func mutate(action: DeviceControllCellReactor.Action) -> Observable<Mutaion> {
        
        switch action {
        case .sendCommand(let type):
            
            let typeID = self.currentState.deviceModels.typeid!
            
            if Int(typeID) ==  SmartDeviceType.Windowopener.rawValue {
                
                if let ptype =  self.currentState.deviceModels.ptype {
                    if ptype == "WBH" || ptype == "WBV" {
                        send470Command(type: type)
                        return .just(Mutaion.setStatus(type))
                    }
                }
            }
            
            sendNormalCommand(type: type)
            return .just(Mutaion.setStatus(type))
        case .fetchYsAccessToken:
            
            
            let accessTime = Defaults[.ysAccessTime]
            let remo = Region.init(calendar: Calendars.chinese, zone: Zones.current, locale: Locale.current)
            
            if accessTime != nil && accessTime != 0 {
                ///本地有, 需要判断是否过期
                
                let currentTime = DateInRegion.init(Date.init(), region: remo)
                let expTime = DateInRegion.init(milliseconds: accessTime!, region: remo)
                
                if !currentTime.isAfterDate(expTime, orEqual: true, granularity: .hour) {
                    /// 过期, 需要重新请求
                    log.debug("获取萤石云 AccessToken 未过期, 过期时间:\(expTime.date.toFormat("yyyy-MM-dd hh:mm:ss"))")
                    return .empty()
                }
                else {
                    log.debug("萤石云 AccessToken 过期, 重新获取")
                }
            }
            
             /// 获取萤石云 AccessToken
            let dict = ["method": "manage.video.info",
                        "appid": "",
                        "houseid":""]
            service.requestGet(parames: dict).mapJSON().subscribe(onSuccess: { (resonse) in
                
                guard let json = resonse as? [String: Any] else { return }
                let code = json["errCode"] as? Int
                
                if code.or(-1) == 200 {
                    
                    if let result = json["result"] as? [String: Any] {
                        let token = result["token"] as! String
                        let temptime = result["temptime"] as! Int
                        log.debug("获取到萤石云 Token: \(token)")
                        Defaults[.ysAccessTime] = temptime
                        Defaults[.ysAccessToken] = token
                    }
                }
                
            }) { (error) in
                FHToaster.show(text: error.localizedDescription)
                log.error(error.localizedDescription)
            }.disposed(by: rx.disposeBag)
            return .empty()
        }
    }


    func reduce(state: DeviceControllCellReactor.State, mutation: DeviceControllCellReactor.Mutaion) -> DeviceControllCellReactor.State {
        
        var newState = state
       
        switch mutation {
        case .setStatus(let model):
            
            switch model {
            case .off:
                newState.deviceModels.status = SmartDeviceSwitchState.off.rawValue
                return newState
            case .on:
                newState.deviceModels.status = SmartDeviceSwitchState.on.rawValue
                return newState
            case .pause:
                newState.deviceModels.status = SmartDeviceSwitchState.pause.rawValue
                return newState
            }
        }
    }
    
}


extension DeviceControllCellReactor {
    
    
    func sendNormalCommand(type: SmartDeviceSwitchState) {
   
        let sn = self.currentState.deviceModels.boxsn
        let eqmId = self.currentState.deviceModels.orderby!
        let state = type.rawValue
        let channel = self.currentState.deviceModels.channel!
        let param = ["msgid": "1460088436",
                     "boxsn": sn,
                     "eqmId": eqmId,
                     "state": state,
                     "energy": "0",
                     "channel": channel]
        
        FHSoketManager.shear().sendMessage(event: "pubState", data: param as [String : Any])
    }
    
    func send470Command(type: SmartDeviceSwitchState) {
        
        /// typeid, cmdtype 先写死,目前只有 WIFI 开窗器一个设备用到本方法
//        let uid = Defaults[.appid]
//        let sn = self.currentState.deviceModels.boxsn
        let eqmsn = self.currentState.deviceModels.eqmsn!
        var resultType: WIFICurtaion
        switch type {
        case .on:
            resultType = .powerOn
        case .off:
            resultType = .powerOff
        case .pause:
            resultType = .powerStop
        }
        
        
        
        let cmdParam = intToHexString(number: resultType.rawValue, bitWith: 2)
        /// 设备ID + cmd + 控制参数
        let cmd = eqmsn + intToHexString(number: 0x66, bitWith: 2) + cmdParam
        let param = ["boxsn": eqmsn,
                     "typeid": "11",
                     "cmdtype": "4",
                     "cmd": cmd]
        
        FHSoketManager.shear().sendMessage(event: "TransLink", data: param as [String : Any])
        
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
