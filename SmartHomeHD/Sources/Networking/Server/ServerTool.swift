//
//  ServerTool.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/23.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import SwiftDate

class ServerTool: NSObject {
    
    class func handleReuqestParamesEncrypt(parames:[String: Any]) -> [String: Any] {
        
        if parames.count == 0 { return [:] }
        
        var resultDict: [String: Any] = parames
        
        /// 添加小区 ID
        resultDict["villageid"] = NSNumber.init(value: 3)
        
        /// 添加请求时间
        resultDict["temptime"] = Date.init().toFormat("yyyy-MM-dd HH:mm", locale: Locale.current)
        
        /// 加密字段, 暂时忽略
        resultDict["sign"] = "111"
        
        return resultDict
    }
}



