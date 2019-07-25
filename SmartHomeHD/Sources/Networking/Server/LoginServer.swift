//
//  LoginServer.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/23.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Moya


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

protocol LoginServerType {
    
    /// 登录、获取用户信息
    func login(parames:[String:Any]) ->Single<Response>
}

final class LoginServer: LoginServerType {
    
    func login(parames: [String : Any]) -> Single<Response> {
        
        /// 加密
        let encrypt = ServerTool.handleReuqestParamesEncrypt(parames: parames)
        
        return SmartHomeHDAPIProvider.rx.request(.requestGet(parames: encrypt))
    }
    
}