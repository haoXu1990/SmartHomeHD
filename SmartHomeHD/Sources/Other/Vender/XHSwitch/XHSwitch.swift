//
//  XHSwitch.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/29.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit



class XHSwitch: UIView {
    
    /// 按钮状态
    open var on: Bool = false
    
    var backgroundImage: UIImageView?
    
    /// 滑块右边
    var sliderRightImage: UIImageView?
    
    var sliderLeftImage: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
