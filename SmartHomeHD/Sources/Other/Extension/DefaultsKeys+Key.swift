//
//  DefaultsKeys+Key.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/30.
//  Copyright © 2019 FH. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    
    /// 荧石云摄像头 token
    static let ysAccessToken = DefaultsKey<String?>.init("ysAccessToken")

    static let ysVerifyCode = DefaultsKey<String?>.init("ysverifyCode")
}
