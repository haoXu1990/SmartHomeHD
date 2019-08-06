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
import FilesProvider
import NVActivityIndicatorView
import SwiftDate

/// 沙河路径
let DZM_READ_DOCUMENT_DIRECTORY_PATH:String = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String)

/// 录像文件夹路径

let kRECORDINGPATH = DZM_READ_DOCUMENT_DIRECTORY_PATH + "/OpenSDK/EzvizLocalRecord/"

class SmartCameraView: UIView,ReactorKit.View, NibLoadable {
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    @IBOutlet weak var title: UILabel!
   
    @IBOutlet weak var plaerView: UIView!
    
    var player: EZPlayer!
    var recordingStatus = false
    /// 截图
    @IBOutlet weak var scrennshotsBtn: UIButton!
    /// 录像
    @IBOutlet weak var recordingBtn: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    /// 对讲
    @IBOutlet weak var intercomBtn: UIButton!
    @IBOutlet weak var intercomLabel: UILabel!
    
    /// 云台
    @IBOutlet weak var cloudView: UIView!
    
    /// 方向
    var directionBtn: ZAShapeButton!
    
    /// 录像存储路径
    var filePath:String = ""
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
        
        initSDK()
        
    }

    func initUI() {
        
        directionBtn = ZAShapeButton.init(frame: CGRect.zero, buttonType: ButtonType_Round)
        directionBtn.image = UIImage.init(named: "image_virtual_control_round_100px")
        directionBtn.buttonType =  ButtonType_Round
        directionBtn.setTitle("云台")
        directionBtn.addTarget(self, action: #selector(SmartCameraView.directionAction(sender:)), forResponseState: ButtonClickType_TouchUpInside)
        cloudView.addSubview(directionBtn)
        directionBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func initSDK() {
        
        EZOpenSDK.initLib(withAppKey: "4d64d27449d9480bb8da793e3aec6302")
        guard let token = Defaults[.ysAccessToken] else { return}
        EZOpenSDK.setAccessToken(token)
    }
    
    func initPlayer(model: SmartCameraYSModel, verifyCode: String?) {

        title.text = model.deviceName
        
        /// 创建播放器
        player = EZOpenSDK.createPlayer(withDeviceSerial: model.deviceSerial, cameraNo: model.channelNo!)
        
        /// 可选，设备开启了视频/图片加密功能后需设置，可根据EZDeviceInfo的isEncrypt属性判断
        if verifyCode != nil {
            player.setPlayVerifyCode(verifyCode)
        }
        
        player.delegate = self
        player.setPlayerView(plaerView)
        activityView.startAnimating()
        player.startRealPlay()
    }
    
    deinit {
        player.destoryPlayer()
    }
    
    open func stopPlayer() {
        player.destoryPlayer()
    }
}

// MARK: - Action
extension SmartCameraView {
    
    @objc func directionAction(sender: ZAShapeButton) {
        
        guard let cameraModel = self.reactor?.currentState.cameraModel else {
            return
        }
        switch (sender.selectButtonPosition) {
        case SelectButtonPosition_Top:
            log.info("点击了上")
            playerPTZControll(cameraModel: cameraModel, command: .up)
            break;
        case SelectButtonPosition_Buttom:
            log.info("点击了下")
           playerPTZControll(cameraModel: cameraModel, command: .down)
            break;
        case SelectButtonPosition_Center:
            log.info("点击了 ok")
            
            break;
        case SelectButtonPosition_Left:
            log.info("点击了左")
            playerPTZControll(cameraModel: cameraModel, command: .left)
            break;
        case SelectButtonPosition_Right:
            log.info("点击了右")
            playerPTZControll(cameraModel: cameraModel, command: .right)
            break;
        default:
            break;
        }
        
        
    }
    
    func playerPTZControll(cameraModel: SmartCameraYSModel, command: EZPTZCommand)  {
        
        EZOpenSDK.controlPTZ(cameraModel.deviceSerial, cameraNo: cameraModel.channelNo!, command: command, action: .start, speed: 2) { (error) in
            FHToaster.show(text: error!.localizedDescription)
        }
        
        EZOpenSDK.controlPTZ(cameraModel.deviceSerial, cameraNo: cameraModel.channelNo!, command: command, action: .stop, speed: 2) { (error) in
            FHToaster.show(text: error!.localizedDescription)
        }
        
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
        activityView.stopAnimating()
    }
    
    func player(_ player: EZPlayer!, didReceivedMessage messageCode: Int) {
        log.debug("didReceivedMessage: \(messageCode)")
        
// 可以不停止这个动画，让他一直转
//        if activityView.isAnimating {
//            activityView.stopAnimating()
//        }
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
                
                self.initPlayer(model: model, verifyCode: verifyCode)
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
            .flatMap({ [weak self](_) -> Observable<String> in
                guard let self = self else { return .just("挂断") }
                log.info("开始对讲")
                FHToaster.show(text: "开始对讲")
                self.player.startVoiceTalk()
                return Observable.just("挂断")
            })
            .bind(to: intercomLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        /// 结束对讲
        intercomBtn.rx
            .longPressGesture()
            .when(.ended)
            .flatMap({ [weak self](_) -> Observable<String> in
                guard let self = self else { return .just("对讲") }
                log.info("停止对讲")
                FHToaster.show(text: "停止对讲")
                self.player.stopVoiceTalk()
                return Observable.just("对讲")
            })
            .bind(to: intercomLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        recordingBtn.rx
            .tap
            .flatMap { [weak self] (_) -> Observable<String> in
            
                guard let self = self else { return .just("录像")}
                if self.recordingStatus == false {
                    self.recordingStatus = true
                    
                    if FileUtils.createFolder(basePath: .documents, folderName: "/OpenSDK/EzvizLocalRecord") {
                        log.error("文件创建成功")
                        
                        let fileName = Date.init().toFormat("yyyy-MM-dd HH:mm:ss", locale: Locales.init(rawValue: "current"))
                        self.filePath =  kRECORDINGPATH + fileName + ".mov"
                        self.player.startLocalRecord(withPath: self.filePath)
                    }
                    else {
                        log.error("文件创建失败")
                    }
                    
                    return .just("停止录像")
                }
                else {
                    self.recordingStatus = false
                    self.player.stopLocalRecord()
                    
                    let url = URL.init(fileURLWithPath: self.filePath)
                    log.info(url)
                    
                    /// 录像转移到相册
                    MMPhotoUtil.saveVideo(url, completion: { (success) in
                        
                        if success {
                            FHToaster.show(text: "录像保存成功")
                        }
                        else {
                            FHToaster.show(text: "录像保存失败")
                        }
                    })
                    return .just("录像")
                }
            }
            .bind(to: recordingLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        plaerView.rx.tapGesture().subscribe(onNext: { [weak self](_) in
            guard let self = self else { return }
            
            if self.plaerView.frame == UIScreen.main.bounds {
                
                
            }
            else {
                
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.plaerView.frame = UIScreen.main.bounds
//                })
            }
            
            
        }).disposed(by: rx.disposeBag)
    
            
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


extension SmartCameraView {
    
    /// 创建文件夹,如果存在则不创建
     func creat_file(path:String) ->Bool {
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) { return true }
        
        do{
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            
            return true
            
        }catch{ }
        
        return false
    }
    
}
