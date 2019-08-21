//
//  SmartDoorbell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/16.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import UIButton_SSEdgeInsets
import HJViewStyle
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import Kingfisher

let kBellUrl = "thirdparty.ecamzone.cc:8443"
let kBellKey = "yYkrmTPcAJyFdnPR26NbNmzSJ3bWFjFN"
let kBellKeyId = "9643cda77d1d1c54"


class SmartDoorbell: UIView {

    var activitiView: NVActivityIndicatorView!
    var contentView: UIView!
    var titleLabel: UILabel!
    
    var playerView: UIView!
    var callImageView: UIImageView!
    
    var answerBtn: UIButton!
    var voiceBtn: UIButton!
    var videoBtn: UIButton!
    var closeBtn: UIButton!
    
    var bid: String?
    var dbcode: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        bindAction()
        registerNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        contentView = UIView.init()
        contentView.cornerRadius = 5
        contentView.shadowColor = .black
        contentView.backgroundColor = .black
        self.addSubview(contentView)
        
        titleLabel = UILabel.init()
        titleLabel.textColor = .white
        titleLabel.text = "门铃来电"
        titleLabel.cornerRadius = 5
        titleLabel.backgroundColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)
        
        playerView = UIView.init()
        playerView.backgroundColor = .clear
        contentView.addSubview(playerView)
        
        activitiView = NVActivityIndicatorView.init(frame: CGRect.zero)
        playerView.addSubview(activitiView)
        
        callImageView = UIImageView.init()
        contentView.addSubview(callImageView)
        
        answerBtn = UIButton.init()
        answerBtn.titleLabel?.font = .systemFont(ofSize: 14)
        answerBtn.titleLabel?.textAlignment = .center
        answerBtn.setTitleColor(.white, for: .normal)
        answerBtn.setTitle("挂断", for: .normal)
        answerBtn.setImage(UIImage.init(named: "device_camara_duijiang"), for: .normal)
        answerBtn.setImagePositionWith(.top, spacing: 5.0)
        contentView.addSubview(answerBtn)
        
        voiceBtn = UIButton.init()
        voiceBtn.titleLabel?.font = .systemFont(ofSize: 14)
        voiceBtn.titleLabel?.textAlignment = .center
        voiceBtn.setTitleColor(.white, for: .normal)
        voiceBtn.setTitle("语音通话", for: .normal)
        voiceBtn.setImage(UIImage.init(named: "device_camara_duijiang"), for: .normal)
        voiceBtn.setImagePositionWith(.top, spacing: 5.0)
        contentView.addSubview(voiceBtn)
        
        videoBtn = UIButton.init()
        videoBtn.titleLabel?.font = .systemFont(ofSize: 14)
        videoBtn.titleLabel?.textAlignment = .center
        videoBtn.setTitleColor(.white, for: .normal)
        videoBtn.setTitle("视频通话", for: .normal)
        videoBtn.setImage(UIImage.init(named: "device_camara_duijiang"), for: .normal)
        videoBtn.setImagePositionWith(.top, spacing: 5.0)
        contentView.addSubview(videoBtn)
        
        closeBtn = UIButton.init()
        closeBtn.setBackgroundImage(UIImage.init(named: "house_close"), for: .normal)
        contentView.addSubview(closeBtn)
    }
    
    override func layoutSubviews() {
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 400, height: 410))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        playerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.height.equalTo(200)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
        }
        
        callImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(playerView)
        }
        
        activitiView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        voiceBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(playerView.snp.bottom).offset(40)
        }
        
        answerBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(voiceBtn)
            make.right.equalTo(voiceBtn.snp.left).offset(-20)
        }
        
        videoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(voiceBtn)
            make.left.equalTo(voiceBtn.snp.right).offset(10)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
}

extension SmartDoorbell {
    
    func login() {
        
        guard let dbcode = self.dbcode else { return }
        
        /// 登录请求
        YKBusinessFramework.equesSdkLogin(withUrl: kBellUrl, username: dbcode, appKey: kBellKey)
    }
}

extension SmartDoorbell {
    
    func registerNotification() {
        
        /// 门铃的所有操作结果都是通知返回
        NotificationCenter.default
            .rx.notification(.onMessageResultNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self, let result = data.object as? [String: Any] else { return }
                
                if let method = result["method"] as? String {
                    
                    if method == "login" {
                        if let code = result["code"] as? Int {
                            /// 登录成功
                            if code == 4000 {
                                /// 请求列表, 试试
                                YKBusinessFramework.equesGetDeviceList()
                            }
                        }
                    }
                    /// 门铃来电图片
                    else if method == "filetrans" {
                        
                        if let fid = result["fid"] as? String {
                            let url = YKBusinessFramework.equesGetRingPictureUrl(self.bid, fid: fid)
                            self.callImageView.kf.setImage(with: url)
                        }
                    }
                    /// 门铃挂断
                    else if method == "punch" {
                        
                        if let state = result["state"] as? String {
                            if state == "close" {
                                self.dismiss()
                            }
                        }
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default
            .rx.notification(.onMessageVideoplayingNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self, let _ = data.object as? [String: Any] else { return }
                self.activitiView.stopAnimating()
                
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SmartDoorbell {
    func bindAction() {
        /// 关闭
        closeBtn.rx
            .tap
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.dismiss()
        }).disposed(by: rx.disposeBag)
        
        /// 视频
        videoBtn.rx
            .tap
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                
                if YKBusinessFramework.equesIsLogin() {
                    DispatchQueue.main.async {
                        self.activitiView.startAnimating()
                        self.callImageView.isHidden = true
                        // 必须在主线程播放, 这个第三方好像有问题
                        YKBusinessFramework.equesOpenCall(self.bid!, show: self.playerView, enableVideo: true)
                    }
                }
                else {
                    
                }
            }).disposed(by: rx.disposeBag)
        
        /// 语音
        voiceBtn.rx
            .tap
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                
                if YKBusinessFramework.equesIsLogin() {
                    DispatchQueue.main.async {
                        YKBusinessFramework.equesOpenCall(self.bid!, show: self.callImageView, enableVideo: false)
                    }
                }
            }).disposed(by: rx.disposeBag)
        
        /// 挂断
        answerBtn.rx
            .tap
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.dismiss()
            }).disposed(by: rx.disposeBag)
        
    }
}
extension SmartDoorbell {
    
    func show(title: String) {
        let rv = UIApplication.shared.keyWindow! as UIWindow
        titleLabel.text = title
        rv.addSubview(self)
        
        login()
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            YKBusinessFramework.equesCloseCall(self.bid!)
        }        
        self.removeFromSuperview()
    }
}
