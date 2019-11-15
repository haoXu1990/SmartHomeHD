//
//  SmartLaundryRackView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/11/15.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import NSObject_Rx
import RxCocoa
import SCLAlertView

class RackTitleView: UIView {
    
    var titleLabel: UILabel!
    
    var titleImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI () {
        titleImage = UIImageView.init()
        titleImage.image = UIImage.init(named: "image_device_cell_titlebg")
        self.addSubview(titleImage)
        
        titleLabel = UILabel.init()
        titleLabel.font = SMART_HOME_TITLE_FONT
        titleLabel.textColor = SMART_HOME_TITLE_COLOR
        titleLabel.textAlignment = .left
        self.addSubview(titleLabel)
      
        
        titleImage.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleImage)
            make.left.equalTo(titleImage).offset(10)
        }
    }
    
}


class SmartLaundryRackView: SmartControllBaseView, View, NibLoadable {
   
    var disposeBag: DisposeBag = DisposeBag.init()
     
    var leftBtn: UIButton!
    var middleBtn: UIButton!
    var rightBtn: UIButton!
    
    /// 照明
    var lgithTitle: RackTitleView!
    var lgithBtn: UIButton!
    
    /// 杀毒
    var antivirusTitle: RackTitleView!
    var antivirusBtn: UIButton!
    /// 烘干
    var dringTitle: RackTitleView!
    var dringBtn: UIButton!
    /// 风干
    var windTitle: RackTitleView!
    var windBtn: UIButton!
    
    override func initUI() {
    
       leftBtn = UIButton.init()
       leftBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_last_normal"), for: .normal)
       leftBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_last_selection"), for: .highlighted)
       contentView.addSubview(leftBtn)
       
       middleBtn = UIButton.init()
       middleBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_puse_normal"), for: .normal)
       middleBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_puse_selection"), for: .highlighted)
       contentView.addSubview(middleBtn)
       
       rightBtn = UIButton.init()
       rightBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_next_normal"), for: .normal)
       rightBtn.setBackgroundImage(UIImage.init(named: "image_device_contorl_next_selection"), for: .highlighted)
       contentView.addSubview(rightBtn)
        
        lgithBtn = UIButton.init()
        lgithBtn.setBackgroundImage(UIImage.init(named: "image_device_control_close"), for: .normal)
        lgithBtn.setBackgroundImage(UIImage.init(named: "image_device_control_open"), for: .selected)
        contentView.addSubview(lgithBtn)
        
        antivirusBtn = UIButton.init()
        antivirusBtn.setBackgroundImage(UIImage.init(named: "image_device_control_close"), for: .normal)
        antivirusBtn.setBackgroundImage(UIImage.init(named: "image_device_control_open"), for: .selected)
        contentView.addSubview(antivirusBtn)
        
        dringBtn = UIButton.init()
        dringBtn.setBackgroundImage(UIImage.init(named: "image_device_control_close"), for: .normal)
        dringBtn.setBackgroundImage(UIImage.init(named: "image_device_control_open"), for: .selected)
        contentView.addSubview(dringBtn)
        
        windBtn = UIButton.init()
        windBtn.setBackgroundImage(UIImage.init(named: "image_device_control_close"), for: .normal)
        windBtn.setBackgroundImage(UIImage.init(named: "image_device_control_open"), for: .selected)
        contentView.addSubview(windBtn)
        
        lgithTitle = RackTitleView.init()
        lgithTitle.titleLabel.text = "● 照明"
        contentView.addSubview(lgithTitle)
        
        antivirusTitle = RackTitleView.init()
        antivirusTitle.titleLabel.text = "● 杀毒"
        contentView.addSubview(antivirusTitle)
        
        
        dringTitle = RackTitleView.init()
        dringTitle.titleLabel.text = "● 烘干"
        contentView.addSubview(dringTitle)
        
        windTitle = RackTitleView.init()
        windTitle.titleLabel.text = "● 风干"
        contentView.addSubview(windTitle)
    }
    
    override func layoutSubview() {
        middleBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
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
        
        
        lgithTitle.snp.makeConstraints { (make) in
            make.top.equalTo(middleBtn.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        lgithBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lgithTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        
        antivirusTitle.snp.makeConstraints { (make) in
            make.top.equalTo(lgithBtn.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        antivirusBtn.snp.makeConstraints { (make) in
            make.top.equalTo(antivirusTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        
        dringTitle.snp.makeConstraints { (make) in
            make.top.equalTo(antivirusBtn.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        dringBtn.snp.makeConstraints { (make) in
            make.top.equalTo(dringTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        windTitle.snp.makeConstraints { (make) in
           make.top.equalTo(dringBtn.snp.bottom).offset(10)
           make.left.equalToSuperview()
           make.right.equalToSuperview()
           make.height.equalTo(30)
        }
        windBtn.snp.makeConstraints { (make) in
            make.top.equalTo(windTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
    }
}

extension SmartLaundryRackView {
    
    func bind(reactor: SmartLaundryRackViewReactor) {
        
        reactor.state.map{ $0.deviceModel.title}
        .filterNil()
        .distinctUntilChanged()
        .bind(to: titleLabel.rx.text)
        .disposed(by: rx.disposeBag)
        
        
        leftBtn.rx.tap
            .map{Reactor.Action.sendCommand(key: .riseAndFall, param: .off, time: 1, cmdType: "4")}
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        middleBtn.rx.tap
            .map{Reactor.Action.sendCommand(key: .riseAndFall, param: .on, time: 1, cmdType: "4")}
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        rightBtn.rx.tap
            .map{Reactor.Action.sendCommand(key: .riseAndFall, param: .overturn, time: 1, cmdType: "4")}
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        
        lgithBtn.rx.tap
            .map{ (_) -> Reactor.Action in
                self.lgithBtn.isSelected =  !self.lgithBtn.isSelected
                return  Reactor.Action.sendCommand(key: .light, param:  self.lgithBtn.isSelected ? .on : .off, time: 1, cmdType: "4")
            }
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        antivirusBtn.rx.tap
        .map{ (_) -> Reactor.Action in
            self.antivirusBtn.isSelected =  !self.antivirusBtn.isSelected
            
            return  Reactor.Action.sendCommand(key: .antivirus, param:  self.antivirusBtn.isSelected ? .on : .off, time: 1, cmdType: "4")
        }
        .bind(to: reactor.action)
        .disposed(by: rx.disposeBag)
        
        dringBtn.rx.tap
        .map{ (_) -> Reactor.Action in
            self.dringBtn.isSelected =  !self.dringBtn.isSelected
            return  Reactor.Action.sendCommand(key: .dring, param:  self.dringBtn.isSelected ? .on : .off, time: 1, cmdType: "4")
        }
        .bind(to: reactor.action)
        .disposed(by: rx.disposeBag)
        
        
        windBtn.rx.tap
        .map{ (_) -> Reactor.Action in
            self.windBtn.isSelected =  !self.windBtn.isSelected
            return  Reactor.Action.sendCommand(key: .wind, param:  self.windBtn.isSelected ? .on : .off, time: 1, cmdType: "4")
        }
        .bind(to: reactor.action)
        .disposed(by: rx.disposeBag)
        
    }
}

extension SmartLaundryRackView {
    
}
