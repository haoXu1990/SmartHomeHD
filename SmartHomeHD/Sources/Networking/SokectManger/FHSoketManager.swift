//
//  SoketManager.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults


private var share: FHSoketManager?

class FHSoketManager: NSObject {
    
    var socketIO: SocketIO!
    
    override init() {
        super.init()
        
        socketIO = SocketIO.init(delegate: self)
    }
    
    class func shear() -> FHSoketManager {
        
        if share == nil {
            share = FHSoketManager.init()
        }
        return share!
    }
    
    func connectSocket() {
        
        /**
         
         appid = "=jTsnmGU0";
         defaultEvnWithBox = A020A60E215A;
         houseCreatedId = 2529;
         houseid = 2430;
         msgid = 12;
         secret = 6C9WgrMDZABYP;
         surl = "sz.wisdudu.com";
         token = "A58AD0F3-057B-4930-8C54-623B73BB86DD";
         */
        
        /**
         样板间
         appid = Rd88h;
         defaultEvnWithBox = 5CCF7F1B3199;
         houseCreatedId = 518;
         houseid = 637;
         msgid = 12;
         secret = "D=Cew36Gl";
         surl = "sz.wisdudu.com";
         token = "A58AD0F3-057B-4930-8C54-623B73BB86DD";
         */
        
        
        
        if let uid = Defaults[.appid],
            let secret = Defaults[.secret],
            let host = Defaults[.surl] {
            /// 用户已登录
            log.debug("用户已登录")
            let port: Int = 1018
            let params: [String: Any] = ["type": "HD",
                                         "uid": uid,
                                         "token": UIDevice.current.identifierForVendor!.uuidString,
                                         "secret":secret]
            
            if socketIO.isConnected { return }
            
            socketIO.connect(toHost: host, onPort: port, withParams: params)
        }
        else {
            /// 用户未登录
            log.debug("用户未登录")
            let host = "sz.wisdudu.com"
            let port: Int = 1018
            let params: [String: Any] = ["type": "HD",
                                         "uid": "",
                                         "token": UIDevice.current.identifierForVendor!.uuidString,
                                         "secret":""]
            
            if socketIO.isConnected { return }
            
            socketIO.connect(toHost: host, onPort: port, withParams: params)
        }
        
    }
    
    func sendMessage(event:String, data: [String: Any])  {
        log.debug("socke send: \(data)")
        socketIO.sendEvent(event, withData: data)
    }
    
}
extension FHSoketManager: SocketIODelegate {
   
    
    
    func socketIODidConnect(_ socket: SocketIO!) {
        
        DLog("socket.io connect success")
      
    }
    
    func socketIODidDisconnect(_ socket: SocketIO!, disconnectedWithError error: Error!) {
        // 重连
        connectSocket()
    }
    
 
    func socketIO(_ socket: SocketIO!, didReceiveEvent packet: SocketIOPacket!) {
        
        let resutlJson = packet.dataAsJSON() as! [String : Any]
        
     
        let name:String = resutlJson["name"] as! String
        
        let args:Array = resutlJson["args"] as! Array<Any>
        
        log.debug(resutlJson)
        
        NotificationCenter.default.post(name: NSNotification.Name.init(name), object: args[0])
       
    }
    
    func socketIO(_ socket: SocketIO!, onError error: Error!) {
        
        log.error("socket.io connect field \(error.localizedDescription)")     
    }
 
}
