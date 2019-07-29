//
//  DeviceControllTwoCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//  设备控制卡片， 适用于3个按钮控制设备: 窗帘、升降机、开窗器 等等

import UIKit
import RxSwift
import ReactorKit
import NSObject_Rx

class DeviceControllTwoCell: BaseTableViewCell, View {
    var disposeBag: DisposeBag = DisposeBag.init()
    
    var leftBtn: UIButton!
    
    var middleBtn: UIButton!
    
    var rightBtn: UIButton!
    
    
    override func initialize() {
        
        leftBtn = UIButton.init()
        leftBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_last_normal"), for: .normal)
        leftBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_last_selection"), for: .highlighted)
        controllView.addSubview(leftBtn)
        
        middleBtn = UIButton.init()
        middleBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_puse_normal"), for: .normal)
        middleBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_puse_selection"), for: .highlighted)
        controllView.addSubview(middleBtn)
        
        rightBtn = UIButton.init()
        rightBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_next_normal"), for: .normal)
        rightBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_next_selection"), for: .highlighted)
        controllView.addSubview(rightBtn)
    }
    
    
    override func layoutSubView() {
        
        middleBtn.snp.makeConstraints { (make) in            
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(middleBtn.snp.centerY)
            make.right.equalTo(middleBtn.snp.left).offset(-20)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(middleBtn.snp.centerY)
            make.left.equalTo(middleBtn.snp.right).offset(20)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
    }

}

extension DeviceControllTwoCell {
    
    func bind(reactor: DeviceControllCellReactor) {
        
        reactor.state
            .fetchCellTitle()
            .bind(to: titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        middleBtn.rx.tap.subscribe(onNext: {
            Observable.just(Reactor.Action.sendCommand(.pause))
                .bind(to: reactor.action)
                .disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        leftBtn.rx.tap.subscribe(onNext: {
            Observable.just(Reactor.Action.sendCommand(.off))
                .bind(to: reactor.action)
                .disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        rightBtn.rx.tap.subscribe(onNext: {
            Observable.just(Reactor.Action.sendCommand(.on))
                .bind(to: reactor.action)
                .disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
    }
}
