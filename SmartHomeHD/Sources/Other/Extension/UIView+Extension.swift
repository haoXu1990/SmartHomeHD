//
//  UIView+Extension.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/9.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit



extension UIView {
    
    /// 圆角
    func circular(radius: CGFloat = 10.0) {
        self.layer.cornerRadius =  radius
        self.layer.masksToBounds = true
    }
}

