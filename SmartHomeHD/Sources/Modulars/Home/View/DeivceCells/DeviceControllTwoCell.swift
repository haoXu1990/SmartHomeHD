//
//  DeviceControllTwoCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

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
        leftBtn.layer.cornerRadius = 25
        leftBtn.layer.masksToBounds = true
        leftBtn.backgroundColor = .black
        controllView.addSubview(leftBtn)
        
        middleBtn = UIButton.init()
        middleBtn.layer.cornerRadius = 25
        middleBtn.layer.masksToBounds = true
        middleBtn.backgroundColor = .black
        controllView.addSubview(leftBtn)
        
        rightBtn = UIButton.init()
        rightBtn.layer.cornerRadius = 25
        rightBtn.layer.masksToBounds = true
        rightBtn.backgroundColor = .black
        controllView.addSubview(leftBtn)
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
        
    
        
    
//        middleBtn.rx.tap.subscribe(onNext: { [unowned self](_) in
//            
//        }).disposed(by: rx.disposeBag)
//        
//        leftBtn.rx.tap.subscribe(onNext: { [unowned self](_) in
//            
//        }).disposed(by: rx.disposeBag)
//        
//        rightBtn.rx.tap.subscribe(onNext: { [unowned self](_) in
//            
//        }).disposed(by: rx.disposeBag)
    }
}
