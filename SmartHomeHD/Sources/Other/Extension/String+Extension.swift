//
//  String+Extension.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/21.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

extension String {
    func toHex() -> Int64 {
        return Int64.init(self, radix: 16)!
    }
}
extension String {
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toFloat() -> Float? {
        return Float(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    //MARK:- 去除字符串两端的空白字符
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func subString(to: Int) -> String {
        var to = to
        if to > self.count {
            to = self.count
        }
        return String(self.prefix(to))
    }
    
    func subString(from: Int) -> String {
        if from >= self.count {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.endIndex
        return String(self[startIndex..<endIndex])
    }
    
    func subString(start: Int, end: Int) -> String {
        if start < end {
            let startIndex = self.index(self.startIndex, offsetBy: start)
            let endIndex = self.index(self.startIndex, offsetBy: end)
            
            return String(self[startIndex..<endIndex])
        }
        return ""
    }
    
}

//不包含后几个字符串的方法
extension String {
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
}
