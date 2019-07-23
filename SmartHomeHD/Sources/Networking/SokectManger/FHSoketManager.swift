//
//  SoketManager.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit



let sockeURL = URL.init(string: "http://sz.wisdudu.com:1018")

private var share: FHSoketManager?

class FHSoketManager: NSObject {
    
    var socketIO: SocketIO!
    
    var socketParams:[String: Any] = ["type": "HD",
                                "uid":"",
                                "token": UUID.init().uuidString,
                                "secret":""]
    
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
        
        let host: String = "sz.wisdudu.com"
        let port: Int = 1018
        let params: [String: Any] = ["type": "HD",
        "uid":"",
        "token": UIDevice.current.identifierForVendor!.uuidString,
        "secret":""]
        
        if socketIO.isConnected { return }
        
        socketIO.connect(toHost: host, onPort: port, withParams: params)
        
    }
    
    
}
extension FHSoketManager: SocketIODelegate {
   
    
    
    func socketIODidConnect(_ socket: SocketIO!) {
        
        DLog("socket.io connect success")
        // 重连
        connectSocket()
    }
    
    func socketIODidDisconnect(_ socket: SocketIO!, disconnectedWithError error: Error!) {
        
    }
    
 
    func socketIO(_ socket: SocketIO!, didReceiveEvent packet: SocketIOPacket!) {
        
        let resutlJson = packet.dataAsJSON() as! [String : Any]
        DLog("didReceiveEvent: \(resutlJson)")
        
        let name:String = resutlJson["name"] as! String
        
        let args:Array = resutlJson["args"] as! Array<Any>
        
        NotificationCenter.default.post(name: NSNotification.Name.init(name), object: args[0])
       
    }
    
    func socketIO(_ socket: SocketIO!, onError error: Error!) {
        
    }
 
    
//    func socketIO(_ socket: SocketIO!, didSendMessage packet: SocketIOPacket!) {
//        DLog("didSendMessage: \(String(describing: packet.ack))")
//
//    }
//
//    func socketIO(_ socket: SocketIO!, didReceiveMessage packet: SocketIOPacket!) {
//        DLog("didReceiveMessage: \(packet)")
//    }
//
//    func socketIO(_ socket: SocketIO!, didReceiveJSON packet: SocketIOPacket!) {
//        DLog("didReceiveJSON: \(packet)")
//    }
}
