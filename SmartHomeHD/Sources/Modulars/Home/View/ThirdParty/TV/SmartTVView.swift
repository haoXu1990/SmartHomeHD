//
//  SmartTVView.swift
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

class SmartTVView: SmartControllBaseView, View {

    var disposeBag: DisposeBag = DisposeBag.init()
    
    /// 电源开关
    var powerBtn: UIButton!
    /// 收藏
    var favoriteBtn: UIButton!
    /// 信源
    var singalBtn: UIButton!
    
    
    ///缩放
    var zoomBtn: ZAShapeButton!
    /// 方向
    var directionBtn: ZAShapeButton!
    /// 声音
    var volumeBtn: ZAShapeButton!
    
    
    /// 返回
    var backupBtn: UIButton!
    /// 信息
    var infoBtn: UIButton!
    ///  静音
    var muteBtn: UIButton!
    
    
    /// 数字按钮
    var numberBtn: UIButton!
    /// 菜单按钮
    var menuBtn: UIButton!
    /// 退出
    var exitBtn: UIButton!
    /// 更多按钮
    var moreBtn: UIButton!
    
    
    override func initUI() {
        
        powerBtn = UIButton.init()
        powerBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_power"), for: .normal)
        contentView.addSubview(powerBtn)
        favoriteBtn = UIButton.init()
        favoriteBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_collect"), for: .normal)
        contentView.addSubview(favoriteBtn)
        singalBtn = UIButton.init()
        singalBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_av"), for: .normal)
        contentView.addSubview(singalBtn)
        
        
        directionBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_Round)
        directionBtn.image = UIImage.init(named: "image_virtual_control_round")
        directionBtn.buttonType =  ButtonType_Round
        directionBtn.setTitle("OK")
        directionBtn.addTarget(self, action: #selector(SmartTVView.directionAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        contentView.addSubview(directionBtn)
        zoomBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_V_PlusAndMin)
        zoomBtn.image = UIImage.init(named: "image_virtual_control_v")
        zoomBtn.setTitle("频道")
        zoomBtn.addTarget(self, action: #selector(SmartTVView.zoomAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        contentView.addSubview(zoomBtn)
        volumeBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_V_PlusAndMin)
        volumeBtn.image = UIImage.init(named: "image_virtual_control_v_+")
        volumeBtn.setTitle("声音")
        volumeBtn.addTarget(self, action: #selector(SmartTVView.volumeAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        contentView.addSubview(volumeBtn)
        
        
        
        
        backupBtn = UIButton.init()
        backupBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_return"), for: .normal)
        contentView.addSubview(backupBtn)
        infoBtn = UIButton.init()
        infoBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_tips"), for: .normal)
        contentView.addSubview(infoBtn)
        muteBtn = UIButton.init()
        muteBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_silence"), for: .normal)
        contentView.addSubview(muteBtn)
        
        
        
        numberBtn = UIButton.init()
        numberBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_123"), for: .normal)
        contentView.addSubview(numberBtn)
        menuBtn = UIButton.init()
        menuBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_menu"), for: .normal)
        contentView.addSubview(menuBtn)
        exitBtn = UIButton.init()
        exitBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_out"), for: .normal)
        contentView.addSubview(exitBtn)
        moreBtn = UIButton.init()
        moreBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_more"), for: .normal)
        contentView.addSubview(moreBtn)
    }
    
    override func layoutSubview() {
        
        powerBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        favoriteBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(powerBtn)
            make.centerX.equalToSuperview()
        }
        
        singalBtn.snp.makeConstraints { (make) in
            make.top.equalTo(powerBtn)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        directionBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        zoomBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(directionBtn)
            make.left.equalTo(powerBtn.snp.left)
        }
        volumeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(directionBtn)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        
        backupBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(zoomBtn)
            make.top.equalTo(zoomBtn.snp.bottom).offset(30)
        }
        infoBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backupBtn)
        }
        muteBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(volumeBtn)
            make.centerY.equalTo(backupBtn)
        }
        
        
        
        
        numberBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backupBtn)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        menuBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberBtn)
            make.right.equalTo(infoBtn.snp.left).offset(10)
        }
        exitBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberBtn)
            make.left.equalTo(infoBtn.snp.right).offset(-10)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberBtn)
            make.centerX.equalTo(volumeBtn)
        }
        
        
        
        
    }
    

}


extension SmartTVView {
    
    func bind(reactor: InfraredControlReactor) {
       
        reactor.state.map{$0.deviceModels}
            .filterNil()
            .flatMap { (model) -> Observable<Reactor.Action> in
                return Observable.just(Reactor.Action.fetchRemote)
            }
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        reactor.state.map{ $0.deviceModels.title}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        powerBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .power)
        }).disposed(by: rx.disposeBag)
        
        favoriteBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .favorite)
        }).disposed(by: rx.disposeBag)
        
        singalBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .signal)
        }).disposed(by: rx.disposeBag)
        
        backupBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .back)
        }).disposed(by: rx.disposeBag)
        
        infoBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .information)
        }).disposed(by: rx.disposeBag)
        
        muteBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .mute)
        }).disposed(by: rx.disposeBag)
        
        
        numberBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let _ = self else {return }
            
        }).disposed(by: rx.disposeBag)
        
        menuBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .menu)
        }).disposed(by: rx.disposeBag)
        
        exitBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .menuExit)
        }).disposed(by: rx.disposeBag)
    }
}


// MARK: - Action
extension SmartTVView {
    
    func sendObsver(keType: IRKeyType) {
        
        Observable.just(Reactor.Action.sendCommond(keType))
            .bind(to: self.reactor!.action)
            .disposed(by: rx.disposeBag)
    }
    
    @objc func directionAction(sender: ZAShapeButton) {
        
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            sendObsver(keType: .menuUp)
            break;
        case SelectButtonPosition_Buttom:
            sendObsver(keType: .menuDown)
            break;
        case SelectButtonPosition_Center:
            sendObsver(keType: .menuOk)
            break;
        case SelectButtonPosition_Left:
            sendObsver(keType: .menuLeft)
            break;
        case SelectButtonPosition_Right:
            sendObsver(keType: .menuRight)
            break;
        default:
            break;
        }
        
        
    }
    
    @objc func zoomAction(sender: ZAShapeButton) {
        
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            sendObsver(keType: .channelUp)
            break;
        case SelectButtonPosition_Buttom:
            sendObsver(keType: .channelDown)
            break;
        default:
            break;
        }
    }
    
    @objc func volumeAction(sender: ZAShapeButton) {
        
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            sendObsver(keType: .volUp)
            break;
        case SelectButtonPosition_Buttom:
            sendObsver(keType: .volDown)
            break;
        default:
            break;
        }
    }
    
}
