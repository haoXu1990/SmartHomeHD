//
//  UIView+Rx.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    
    var backgroundColor: Binder<UIColor> {
        return Binder.init(self.base, binding: { (view, color) in
            view.backgroundColor = color
        })
    }
    
}
