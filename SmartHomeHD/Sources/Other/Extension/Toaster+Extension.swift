//
//  Toaster+Extension.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/30.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Toaster

final class FHToaster {
    
    static func show(text: String,
                     delay: TimeInterval = 0,
                     duration: TimeInterval = 2) {
        if ToastCenter.default.currentToast == nil {
            
            Toast.init(text: text, delay: delay, duration: duration).show()
        }
    }
    
}
