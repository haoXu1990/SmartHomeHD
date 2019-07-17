//
//  NibLoadable.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibNmae :String? = nil) -> Self {
        
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}
