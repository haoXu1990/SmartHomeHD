//
//  SoketManager.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import SocketIO



class FHSoketManager: NSObject {

    let share = FHSoketManager.init()
    
    var manager: SocketManager!
    
    override init() {
        super.init()
        
        let config:[String: Any] = [:]
        
        let url = URL.init(string: "sz.wisdudu.com")
        
        manager = SocketManager.init(socketURL: url!, config: config)
        
    }
    
  
    func connect()  {
        
        manager.connect()
    }
    
    
}
