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
import SwiftyUserDefaults
import RxCocoa
import RxGesture
import MMPhotoPicker


class SmartCameraView: UIView,ReactorKit.View, NibLoadable {
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    @IBOutlet weak var title: UILabel!
   
    @IBOutlet weak var plaerView: UIView!
    
    var player: EZPlayer!
    
    /// 截图
    @IBOutlet weak var scrennshotsBtn: UIButton!
    /// 录像
    @IBOutlet weak var recordingBtn: UIButton!
    /// 对讲
    @IBOutlet weak var intercomBtn: UIButton!
    /// 云台
    @IBOutlet weak var cloudBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSDK()
        
    }

    func initSDK() {
        
        EZOpenSDK.initLib(withAppKey: "4d64d27449d9480bb8da793e3aec6302")
        
        guard let token = Defaults[.ysAccessToken] else { return}
        
        EZOpenSDK.setAccessToken(token)
    }
    
    func initUI(model: SmartCameraYSModel, verifyCode: String?) {

        title.text = model.deviceName
        
        /// 创建播放器
        player = EZOpenSDK.createPlayer(withDeviceSerial: model.deviceSerial, cameraNo: model.channelNo!)
        
        /// 可选，设备开启了视频/图片加密功能后需设置，可根据EZDeviceInfo的isEncrypt属性判断
        if verifyCode != nil {
            player.setPlayVerifyCode(verifyCode)
        }
        
        player.delegate = self
        
        player.setPlayerView(plaerView)
        
        player.startRealPlay()
        
    }
    
    func replayer(model: SmartCameraYSModel, verifyCode: String?) {
    
    }

    deinit {
        player.destoryPlayer()
    }
}

extension Reactive where Base: EZPlayer {
//    var createPlayer11: Binder<SmartCameraYSModel?> {
//        return Binder(self.base) { player, model in
//            player.setPlayVerifyCode(model?.isEncrypt!)
//            player.startRealPlay()
//        }
//    }
}

///Mark - 播放器代理
extension SmartCameraView: EZPlayerDelegate {
    func player(_ player: EZPlayer!, didPlayFailed error: Error!) {
        
        FHToaster.show(text: error.localizedDescription)
        log.error("出错啦:" + error.localizedDescription)
    }
    
    func player(_ player: EZPlayer!, didReceivedMessage messageCode: Int) {
        log.debug("didReceivedMessage: \(messageCode)")
    }
    
    func player(_ player: EZPlayer!, didReceivedDataLength dataLength: Int) {
        log.debug("didReceivedDataLength: \(dataLength)")
    }
    
    func player(_ player: EZPlayer!, didReceivedDisplayHeight height: Int, displayWidth width: Int) {
        log.debug("didReceivedDisplayHeight: \(height), width:\(width)")
    }
}



extension SmartCameraView {
    
    func bind(reactor: SmartCameraViewReactor) {
        
       Observable.just(Reactor.Action.fetchCameraInfo)
        .bind(to: reactor.action)
        .disposed(by: rx.disposeBag)
        
        /// 获取设备信息, 成功后创建播放器
        reactor.state.map {$0.cameraModel }
            .filterNil()
            .subscribe(onNext: { [weak self] (model) in
                guard let self = self else { return }
                log.info("创建播放器")
                
                let verifyCode = self.reactor?.currentState.deviceModels.remark
                
                self.initUI(model: model, verifyCode: verifyCode)
            })
            .disposed(by: rx.disposeBag)
        
        /// 截图
        scrennshotsBtn.rx
            .tap
            .subscribe(onNext: { [weak self]  in
            /// 截图
            guard let self = self else { return }
            
            let image = self.player.capturePicture(100)
            MMPhotoUtil.save(image, completion: { (sucess) in
                
                if sucess {
                    FHToaster.show(text: "照片保存成功")
                }
                else {
                    FHToaster.show(text: "照片保存失败")
                }
            })
        })
            .disposed(by: rx.disposeBag)
        
        /// 开始对讲
        intercomBtn.rx
            .longPressGesture()
            .when(.began)
            .subscribe(onNext: { [weak self](longPress) in
                guard let self = self else { return }
                log.info("开始对讲")
                FHToaster.show(text: "开始对讲")
                self.player.startVoiceTalk()
            
        })
            .disposed(by: rx.disposeBag)
        
        /// 结束对讲
        intercomBtn.rx
            .longPressGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self](longPress) in
                guard let self = self else { return }
                log.info("停止对讲")
                FHToaster.show(text: "停止对讲")
                self.player.stopVoiceTalk()
        })
            .disposed(by: rx.disposeBag)
        
       
        /// 进入前台开始播放
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.player.startRealPlay()
            })
            .disposed(by: rx.disposeBag)
        
        /// 进入后台停止播放
        NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.player.stopRealPlay()
            })
            .disposed(by: rx.disposeBag)
        
    }
}
