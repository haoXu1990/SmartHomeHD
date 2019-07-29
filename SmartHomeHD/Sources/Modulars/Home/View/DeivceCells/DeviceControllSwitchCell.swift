//
//  DeviceControllSwitchCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/29.
//  Copyright © 2019 FH. All rights reserved.
//  设备控制卡片， 适用于单个按钮控制设备: 开关、投食器、等等

import UIKit
import RxSwift
import ReactorKit
import NSObject_Rx

class DeviceControllSwitchCell: BaseTableViewCell, View{
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    var controllBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func initialize() {
        controllBtn = UIButton.init()      
        controllView.addSubview(controllBtn)
    }
    
    override func layoutSubviews() {
        
        controllBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}

extension DeviceControllSwitchCell {
    
    func bind(reactor: DeviceControllCellReactor) {
        
        reactor.state
            .fetchCellTitle()
            .bind(to: titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        reactor.state.flatMap { (state) -> Observable<UIImage> in
             let status = state.deviceModels.status.or("88")
            if status == SmartDeviceSwitchState.on.rawValue {
                return Observable.just(UIImage.init(named: "image_device_control_open")!)
            }
            return Observable.just(UIImage.init(named: "image_device_control_close")!)
        }.distinctUntilChanged().bind(to: controllBtn.rx.backgroundImage()).disposed(by: rx.disposeBag)
    
        
       
        controllBtn.rx.tap.subscribe(onNext: {
        
            var status: SmartDeviceSwitchState = .on
            
            if reactor.currentState.deviceModels.status == "88" {
                status = .off
            }
            Observable.just(Reactor.Action.sendCommand(status))
                .bind(to: reactor.action)
                .disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
    }
}
