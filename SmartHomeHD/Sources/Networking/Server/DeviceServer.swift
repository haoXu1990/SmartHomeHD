//
//  DeviceServer.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Moya

protocol DeviceServerType {
    
    
    /// 获取控制设备列表
    ///
    /// - Parameter parames: 请求参数
    /// - Returns: Single<Response>
    func fetchDeviceList(parames:[String:Any]) ->Single<Response>
}


final class DeviceServer: DeviceServerType {

    func fetchDeviceList(parames: [String : Any]) -> Single<Response> {
        
        /// 加密
        let encrypt = ServerTool.handleReuqestParamesEncrypt(parames: parames)
        
        return SmartHomeHDAPIProvider.rx.request(.requestGet(parames: encrypt))
    }
}
