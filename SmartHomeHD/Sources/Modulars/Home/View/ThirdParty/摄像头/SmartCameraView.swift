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

class SmartCameraView: UIView,ReactorKit.View {
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    @IBOutlet weak var title: UILabel!
   
    @IBOutlet weak var plaerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSDK()
        
        initUI()
    }

    func initSDK() {
        
        EZOpenSDK.initLib(withAppKey: "4d64d27449d9480bb8da793e3aec6302")
        
        guard let token = Defaults[.ysAccessToken] else { return}
        
        EZOpenSDK.setAccessToken(token)
    }
    
    func initUI() {
        
        /// 创建播放器
        let player: EZPlayer = EZOpenSDK.createPlayer(withDeviceSerial: "", cameraNo: 0)
        
        /// 可选，设备开启了视频/图片加密功能后需设置，可根据EZDeviceInfo的isEncrypt属性判断
        player.setPlayVerifyCode("")
        
        player.setPlayerView(plaerView)
        
        player.startRealPlay()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

extension SmartCameraView {
    func bind(reactor: SmartCameraViewReactor) {
        
       Observable.just(Reactor.Action.fetchCameraInfo)
        .bind(to: reactor.action)
        .disposed(by: rx.disposeBag)
        
        
        
    }
}
