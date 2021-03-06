//
//  RxMoyaMapper.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import CoreFoundation

enum DCUError : Swift.Error {
    // 解析失败
    case ParseJSONError
    // 网络请求发生错误
    case RequestFailed
    // 接收到的返回没有data
    case NoResponse
    //服务器返回了一个错误代码
    case UnexpectedResult(resultCode: Int?, resultMsg: String?)
}

enum RequestStatus: Int {
    case requestSuccess = 200
    case requestError
}

fileprivate let RESULT_CODE = "errCode"
fileprivate let RESULT_MSG = "message"
fileprivate let RESULT_DATA = "result"
//public extension Observable
public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func mapResponseToObject<T: BaseMappable>(type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            
            // 得到response
            //            guard let response = response as? Moya.Response else {
            //                throw DCUError.NoResponse
            //            }
            DLog("\(RESULT_DATA) \(RESULT_MSG) \(RESULT_CODE)")
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw DCUError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw DCUError.NoResponse
            }
            
            // 服务器返回code
            if let code = json[RESULT_CODE] as? Int {
                if code == RequestStatus.requestSuccess.rawValue {
                    // get data
                    let data =  json[RESULT_DATA]
                    if let data = data as? [String: Any] {
                        
                        if data.count == 1 {
                            
                            let list = data["list"]
                            if let list = list as? [String: Any] {
                                //服务器返回信息有点特别 result -> list
                                let object = Mapper<T>().map(JSON: list)!
                                
                                return Single.just(object)
                            }
                        }
                        
                        let object = Mapper<T>().map(JSON: data)!
                        return Single.just(object)
                        
                    }else {
                        return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: "请求失败"))
                    }
                } else {
                    return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String))
                    
                }
            } else {
                return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: "请求失败"))
                //                throw DCUError.ParseJSONError
            }
            
        }
    }
    
    func mapResponseToObjectArray<T: BaseMappable>(type: T.Type, context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response  -> Single<[T]> in
            
            // 得到response
            //            guard let response = response as? Moya.Response else {
            //                throw DCUError.NoResponse
            //            }
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw DCUError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw DCUError.NoResponse
            }
            
            // 服务器返回code
            if let code = json[RESULT_CODE] as? Int {
                if code == RequestStatus.requestSuccess.rawValue {
                    // 对象数组
                    var objects = [T]()
                    
                    
                    
                    guard let list =  json[RESULT_DATA] as? [String: Any] else {
                        
                        return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: "请求失败"))
                    }
                    
                    guard let objectsArrays = list["list"] as? [Any] else {
                        return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: "请求失败"))
                    }
                    
                    for object in objectsArrays {
                        if let data = object as? [String: Any] {
                            // 使用 ObjectMapper 解析成对象
                            let object = Mapper<T>().map(JSON: data)!
                            // 将对象添加到数组
                            objects.append(object)
                        }
                    }
                    
                    return  Single.just(objects)//objects
                    
                } else {
                    return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String))
                    
                }
            } else {
                return Single.error(DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: "请求失败"))
            }
        }
    }
}
