//
//  ModelType.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift

protocol ModelType: Mappable {
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    
    associatedtype Event
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        
        if #available(iOS 10.0, *) {
            return .iso8601
        }
        
        return .secondsSince1970
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder.init()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}

private var streams: [String: Any] = [:]
extension ModelType {
    
    static var event: PublishSubject<Event> {
        let key = String.init(describing: self)
        
        if let stream = streams[key] as? PublishSubject<Event> { return stream}
        let stream = PublishSubject<Event>.init()
        streams[key] = stream
        
        return stream
    }
}
