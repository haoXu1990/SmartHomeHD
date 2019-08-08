//
//  SmartProjectorView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/31.
//  Copyright © 2019 FH. All rights reserved.
//
/**
 红外设备控制流程:
    1. 根据遥控板 ID 下载遥控板
    2. 根据按键 ID 找到按键列表(一个按键命令可能有很多个)遍历列表发送出去

 投影仪各个按键 ID:
    1. 电源: 800
    2. 缩放+: 813
    3. 缩放-: 814
    4. 方向上: 818
    5. 方向下: 819
    6. 方向左: 820
    7. 方向右: 821
    8. 方向OK: 817
    9. 菜单: 822
    10.更多: 55
 
 */






import UIKit
import ReactorKit
import RxSwift
import NSObject_Rx
import RxCocoa

class SmartProjectorView: SmartControllBaseView, View {

    var disposeBag: DisposeBag = DisposeBag.init()
    
    /// 菜单按钮
    var menuBtn: UIButton!
    
    /// 更多按钮
    var moreBtn: UIButton!
    
    ///缩放
    var zoomBtn: ZAShapeButton!
    
    /// 方向
    var directionBtn: ZAShapeButton!
    
    /// 声音
    var volumeBtn: ZAShapeButton!
    
    /// 电源开关
    var powerBtn: UIButton!
    
    override func initUI() {
        
        menuBtn = UIButton.init()
        menuBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_menu"), for: .normal)
        contentView.addSubview(menuBtn)
        
        moreBtn = UIButton.init()
        moreBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_more"), for: .normal)
        contentView.addSubview(moreBtn)
        
        
        directionBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_Round)
        directionBtn.image = UIImage.init(named: "image_virtual_control_round")
        directionBtn.buttonType =  ButtonType_Round
        directionBtn.setTitle("OK")
        directionBtn.addTarget(self, action: #selector(SmartProjectorView.directionAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        contentView.addSubview(directionBtn)
        
        zoomBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_V_PlusAndMin)
        zoomBtn.image = UIImage.init(named: "image_virtual_control_v")
       
        zoomBtn.setTitle("缩放")
        zoomBtn.addTarget(self, action: #selector(SmartProjectorView.zoomAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        contentView.addSubview(zoomBtn)
        
        
        volumeBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_V_PlusAndMin)
        volumeBtn.image = UIImage.init(named: "image_virtual_control_v_+")
        volumeBtn.setTitle("声音")
        volumeBtn.addTarget(self, action: #selector(SmartProjectorView.volumeAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        contentView.addSubview(volumeBtn)
        
        powerBtn = UIButton.init()
        powerBtn.setBackgroundImage(UIImage.init(named: "image_device_control_open"), for: .normal)
        contentView.addSubview(powerBtn)
    }
    
    override func layoutSubview() {
        
        menuBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(menuBtn)
            make.right.equalToSuperview().offset(-20)
        }
        
        directionBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()            
            make.centerY.equalToSuperview().offset(-50)
        }
        
        zoomBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(directionBtn)
            make.left.equalToSuperview().offset(20)
        }
        
        volumeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(directionBtn)
            make.right.equalToSuperview().offset(-20)
        }
        
        powerBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(directionBtn)
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    func showExtensionView() {
        
        if let model = self.reactor?.remoteModel, let keys = self.reactor?.extensionKeys,
            let deviceModel = self.reactor?.currentState.deviceModels {
            let extensionView = IRExtensionView.init()
            extensionView.reactor = IRExtensionViewReactor.init(remote: model, keys: keys, deviceModel: deviceModel)
            self.extensionView.addSubview(extensionView)
            extensionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func disMissExtensionView() {
        
        for view in extensionView.subviews {
            view.removeFromSuperview()
        }
    }
}

// MARK: - Reactor
extension SmartProjectorView {
    
    func bind(reactor: InfraredControlReactor) {
        
        /// 下载遥控器按键
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
        
        menuBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .menu)
        }).disposed(by: rx.disposeBag)
        
        powerBtn.rx.tap.subscribe(onNext: { [weak self](_) in
            guard let self = self else {return }
            self.sendObsver(keType: .power)
        }).disposed(by: rx.disposeBag)
        
        moreBtn.rx.tap.subscribe(onNext: { [weak self](_) in
            guard let self = self else {return }
            if self.extensionView.subviews.count > 0 {
                self.disMissExtensionView()
            }
            else {
                self.showExtensionView()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    func sendObsver(keType: IRKeyType) {
        
        Observable.just(Reactor.Action.sendCommond(keType))
            .bind(to: self.reactor!.action)
            .disposed(by: rx.disposeBag)
    }
}
extension SmartProjectorView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        disMissExtensionView()
    }
}

// MARK: - Action
extension SmartProjectorView {
    
    @objc func directionAction(sender: ZAShapeButton) {
        
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            log.info("点击了上")
            sendObsver(keType: .menuUp)
            break;
        case SelectButtonPosition_Buttom:
            log.info("点击了下")
            sendObsver(keType: .menuDown)
            break;
        case SelectButtonPosition_Center:
            log.info("点击了 ok")
            sendObsver(keType: .menuOk)
            break;
        case SelectButtonPosition_Left:
            log.info("点击了左")
            sendObsver(keType: .menuLeft)
            break;
        case SelectButtonPosition_Right:
            log.info("点击了右")
            sendObsver(keType: .menuRight)
            break;
        default:
            break;
        }
        
        
    }
    
    @objc func zoomAction(sender: ZAShapeButton) {
        
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            log.info("点击了缩放+")
            sendObsver(keType: .dZoomUp)
            break;
        case SelectButtonPosition_Buttom:
            log.info("点击了缩放-")
            sendObsver(keType: .dZoomDown)
            break;
        default:
            break;
        }
    }
    
    @objc func volumeAction(sender: ZAShapeButton) {
        
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            log.info("点击了声音+")
            sendObsver(keType: .volUp)
            break;
        case SelectButtonPosition_Buttom:
            log.info("点击了声音-")
            sendObsver(keType: .volDown)
            break;
        default:
            break;
        }
    }
    
}
extension SmartProjectorView {
    
    func allKeyType() -> [IRKeyType] {
        
        return [.menu, .power, .menuUp,
                .menuOk, .menuDown, .menuLeft,
                .menuRight, .dZoomUp, .dZoomDown,
                .volUp, .volDown]
    }
}
