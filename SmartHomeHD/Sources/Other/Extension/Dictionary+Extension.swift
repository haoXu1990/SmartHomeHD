//
//  Diction.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/23.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

extension Dictionary {
    
    /// JSON 字典转 JSON 字符串
    func toJSONString() -> String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return strJson! as String
    }
    
//    func descriptionWithLoca() -> String {
//        
//        let allKeys = self.keys
//        var str = "{\t\n"
//       
//        for (key, value) in self.enumerated() {
//            
//            str.appendingFormat("\t \"%@\" = %@, \n", key, value as! CVarArg)
//        }
//        return str + "}"
//    }
}
