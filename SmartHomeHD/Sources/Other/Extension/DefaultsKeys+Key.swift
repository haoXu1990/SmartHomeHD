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
    static let ysAccessTime = DefaultsKey<Int?>.init("ysAccessTime")   
    static let ysVerifyCode = DefaultsKey<String?>.init("ysverifyCode")
    
    
    
    /// 用户数据
    static let appid = DefaultsKey<String?>.init("appid")
    static let houseCreatedId = DefaultsKey<String?>.init("houseCreatedId")
    static let houseid = DefaultsKey<String?>.init("houseid")
    static let secret = DefaultsKey<String?>.init("secret")
    static let surl = DefaultsKey<String?>.init("surl")
    static let token = DefaultsKey<String?>.init("token")
    static let defaultEvnWithBox = DefaultsKey<String?>.init("defaultEvnWithBox")
    
//    appid = Rd88h;
//    defaultEvnWithBox = 5CCF7F1B3199;
//    houseCreatedId = 518;
//    houseid = 637;
//    msgid = 12;
//    secret = "D=Cew36Gl";
//    surl = "sz.wisdudu.com";
//    token = "A58AD0F3-057B-4930-8C54-623B73BB86DD";
}
