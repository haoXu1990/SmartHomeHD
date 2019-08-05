//
//  SmartAirView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/5.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import NSObject_Rx
import RxCocoa

class SmartAirView: SmartControllBaseView, View {
    var disposeBag: DisposeBag = DisposeBag.init()
  

//    /// 电源按钮
//    var powerBtn: UIButton!
//    
//    /// 模式按钮
//    var  modelBtn: UIButton!
    
    var circleAnimationView: CircleAnimationBottomView!
    
    override func initUI() {
    
        let circleX = 270 * 0.5 - 187 * 0.5
        let circleY = 450 * 0.5 - 187 * 0.5
        
        circleAnimationView = CircleAnimationBottomView.init(frame: CGRect.init(x: circleX, y: circleY, width: 187, height: 187))
        contentView.addSubview(circleAnimationView)
//        circleAnimationView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize.init(width: 375, height: 375))
//        }
    }
    
    override func layoutSubview() {
        
    }
}

extension SmartAirView {
    func bind(reactor: InfraredControlReactor) {
        
    }
}
