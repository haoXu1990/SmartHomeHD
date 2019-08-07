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
   
    typealias Action = NoAction
    
    struct State {
        var extensionKeys: [TJIrKey]
    }
    
    let initialState: IRExtensionViewReactor.State
    
    var remoteModel: TJRemote
    
    init(remote: TJRemote, keys: [TJIrKey]) {
        
        self.remoteModel = remote   
        self.initialState = State.init(extensionKeys: keys)
    }
    
}
