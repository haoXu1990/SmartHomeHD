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

    /// 电源按钮
    var powerBtn: UIButton!
    /// 模式按钮
    var modelBtn: UIButton!
    
    /// 温度控制
    var circleAnimationView: CircleAnimationBottomView!
    
    /// 风挡
    var windlevelBtn: UIButton!
    /// 左右风
    var leftWindBtn: UIButton!
    /// 上下风
    var updownWindBtn: UIButton!
    
    /// 定时
    var timeBtn: UIButton!
    /// 更多
    var moreBtn: UIButton!
    
    override func initUI() {
    
        let circleX = 270 * 0.5 - 187 * 0.5
        let circleY = 450 * 0.5 - 187 * 0.5 - 30
        circleAnimationView = CircleAnimationBottomView.init(frame: CGRect.init(x: circleX, y: circleY, width: 187, height: 187))
        circleAnimationView.didTouchBlock = { [weak self] result in
            guard let self = self else {return }
            
            Observable.just(Reactor.Action.sendAirCommand(.tempSet, result))
                .bind(to: self.reactor!.action)
                .disposed(by: self.rx.disposeBag)
            log.debug("选择的温度: \(result)")
        }
        circleAnimationView.bgImage = UIImage.init(named: "device_control_air_circle_bg") 
        contentView.addSubview(circleAnimationView)
        
        
        powerBtn = UIButton.init()
        powerBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_power"), for: .normal)
        contentView.addSubview(powerBtn)
        modelBtn = UIButton.init()
        modelBtn.setBackgroundImage(UIImage.init(named: "device_control_air_pattern"), for: .normal)
        contentView.addSubview(modelBtn)
        
        windlevelBtn = UIButton.init()
        windlevelBtn.setBackgroundImage(UIImage.init(named: "device_control_air_wind"), for: .normal)
        contentView.addSubview(windlevelBtn)
        leftWindBtn = UIButton.init()
        leftWindBtn.setBackgroundImage(UIImage.init(named: "device_control_air_wind_lr"), for: .normal)
        contentView.addSubview(leftWindBtn)
        updownWindBtn = UIButton.init()
        updownWindBtn.setBackgroundImage(UIImage.init(named: "device_control_air_wind_ud"), for: .normal)
        contentView.addSubview(updownWindBtn)
        
        timeBtn = UIButton.init()
        timeBtn.isHidden = true
        timeBtn.setBackgroundImage(UIImage.init(named: "device_control_air_time"), for: .normal)
        contentView.addSubview(timeBtn)
        moreBtn = UIButton.init()
        moreBtn.setBackgroundImage(UIImage.init(named: "device_control_tv_more"), for: .normal)
        contentView.addSubview(moreBtn)
    }
    
    override func layoutSubview() {
        
        powerBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        modelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(powerBtn)
            make.right.equalToSuperview().offset(-20)
        }
        
        windlevelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(powerBtn)
            make.top.equalTo(circleAnimationView.snp.bottom).offset(30)
        }
        leftWindBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(circleAnimationView)
            make.centerY.equalTo(windlevelBtn)
        }
        updownWindBtn.snp.makeConstraints { (make) in
            make.right.equalTo(modelBtn)
            make.centerY.equalTo(windlevelBtn)
        }
        
        timeBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(windlevelBtn)
            make.bottom.equalToSuperview().offset(-10)
        }
        moreBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(leftWindBtn)
            make.bottom.equalToSuperview().offset(-10)
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

extension SmartAirView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        disMissExtensionView()
    }
}

extension SmartAirView {
    
    func bind(reactor: InfraredControlReactor) {
       
        reactor.state.map{$0.deviceModels}
            .filterNil()
            .distinctUntilChanged()
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
        
        reactor.state.map{$0.airStatus}
            .filterNil()
            .bind(to: circleAnimationView.rx.refreshStataus)
            .disposed(by: rx.disposeBag)
        
        
        powerBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .power)
        }).disposed(by: rx.disposeBag)
        
        modelBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .mode)
        }).disposed(by: rx.disposeBag)
        
        windlevelBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .windAmount)
        }).disposed(by: rx.disposeBag)
        
        leftWindBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .windHorizontal)
        }).disposed(by: rx.disposeBag)
        updownWindBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return }
            self.sendObsver(keType: .windVertical)
        }).disposed(by: rx.disposeBag)
        
        moreBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return}
            
            if self.extensionView.subviews.count > 0 {
                self.disMissExtensionView()
            }
            else {
                self.showExtensionView()
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
}

extension SmartAirView {
    func sendObsver(keType: IRKeyType) {        
        Observable.just(Reactor.Action.sendAirCommand(keType, 0))
            .bind(to: self.reactor!.action)
            .disposed(by: rx.disposeBag)
    }
    
    class func fetchAIRModel(mode: AirMode) -> String {
        var tmpSt = ""
        switch mode {
        case .auto:
            tmpSt = "AUTO"
        case .wind:
            tmpSt = "送风"
        case .dry:
            tmpSt = "抽湿"
        case .hot:
            tmpSt = "制热"
        case .cool:
            tmpSt = "制冷"
        }
        return tmpSt
    }
}

extension Reactive where Base: CircleAnimationBottomView {
    var refreshStataus: Binder<TJAirRemoteState> {
        return Binder<TJAirRemoteState>.init(self.base) { (circleView, remoteState) in
            
            if remoteState.power == .on {                
                circleView.temperInter = CGFloat(remoteState.temp)
                circleView.temperLabel.text = String.init(format: "%dC", Int(remoteState.temp))
                circleView.modelTypeLabel.text = SmartAirView.fetchAIRModel(mode: remoteState.mode)
                circleView.bgImage = UIImage.init(named: "device_control_air_circle_bg_on")
            }
            else {
                circleView.temperInter = 0
                circleView.temperLabel.text = ""
                circleView.modelTypeLabel.text = ""
                circleView.bgImage = UIImage.init(named: "device_control_air_circle_bg")
            }
        }
    }
}



extension SmartAirView {
    
    func allKeyType() -> [IRKeyType] {
        
        return [.power, .mode, .windAmount, .windHorizontal, .windVertical, .airTimer]
    }
    
}
