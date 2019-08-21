//
//  MoyaPlugin.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/25.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Moya
import Result

final class DebugPlugin: PluginType {
    
    
//    private let view: UIView
//    
//    init(view: UIView) {
//        self.view = view
//    }
    
    func willSend(_ request: RequestType, target: TargetType) {
    
//        log.debug(target.task)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
       
//        if case Result.success(let response) = result {
//
//            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
//                return
//            }
//            log.debug(json)
//        }
//        else {
//
//        }
    }
}
