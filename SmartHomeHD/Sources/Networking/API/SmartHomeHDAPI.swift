//
//  LoginAPI.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/23.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Moya

let APIROOTURL = "http://sz.wisdudu.com"

let SmartHomeHDAPIProvider = MoyaProvider<SmartHomeHDAPI>.init(plugins: [DebugPlugin()])

public enum SmartHomeHDAPI {
    case login(parames:[String: Any], requestMethod: Moya.Method)
    
    case requestGet(parames:[String: Any])
    
    case requestPost(parames:[String: Any])
    
    case requestPut(parames:[String: Any])
    
    case requestDeleted(parames:[String: Any])
}

extension SmartHomeHDAPI: TargetType {
    public var baseURL: URL {
        return URL.init(string: APIROOTURL)!
    }
    
    public var path: String {
        return "/inter/index.php"
    }
    
    public var method: Moya.Method {
        switch self {
        case .login(_, let requestMethod):
            return requestMethod
        case .requestGet(_):
            return .get
        case .requestPost(_):
            return .post
        case .requestPut(_):
            return .put
        case .requestDeleted(_):
            return .delete
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case let .login(parames, _):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)
        case let .requestPost(parames):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)
        case let .requestGet(parames):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)
        case .requestPut(let parames):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)
        case .requestDeleted(let parames):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}


