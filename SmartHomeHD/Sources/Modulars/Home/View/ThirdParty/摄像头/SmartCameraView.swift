//
//  SmartCameraView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/29.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import EZOpenSDKFramework
import ReactorKit
import RxSwift
import NSObject_Rx

class SmartCameraView: UIView,ReactorKit.View {
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    @IBOutlet weak var title: UILabel!
    
   
    @IBOutlet weak var plaerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSDK() {
        
        EZOpenSDK.initLib(withAppKey: "4d64d27449d9480bb8da793e3aec6302")
        
        
    }
    
   
}

extension SmartCameraView {
    func bind(reactor: SmartCameraViewReactor) {
        
       Observable.just(Reactor.Action.fetchToken)
        .bind(to: reactor.action)
    }
}
