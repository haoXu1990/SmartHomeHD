//
//  ViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import swiftScan
import ObjectMapper
import RxSwift
import NSObject_Rx
import EFColorPicker

class ViewController: UIViewController {
  
    private let hsbColorView: EFColorWheelView = EFColorWheelView()
    
    var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        
//        hsbColorView.addTarget(
//            self, action: #selector(ef_colorDidChangeValue(sender:)), for: UIControl.Event.valueChanged
//        )
////        hsbColorView.addTarget(self, action: #selector(colorValueChange(sender:)), for: .valueChanged)
//        view.addSubview(hsbColorView)
//        hsbColorView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize.init(width: 200, height: 200))
//        }
        initUI()
        
        createQR()
        
        observerNotifation()
    }
    @objc func ef_colorDidChangeValue(sender: EFColorWheelView) {
        
//        self.view.backgroundColor = UIColor(
//            hue: sender.hue,
//            saturation: sender.saturation,
//            brightness: sender.brightness,
//            alpha: sender.alpha
//        )
    }
    func observerNotifation()  {
        
        /// 登录通知
        NotificationCenter.default.rx.notification(.pubLoginAuth)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (data) in
                
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: rx.disposeBag)
        
    }
    
    func initUI()  {
        
        view.backgroundColor = .white
        qrImageView = UIImageView.init()
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 200, height: 200))
        }
    }
    
    func createQR() {
    
        let param = ["DEVICEID": UIDevice.current.identifierForVendor!.uuidString, "NAME": "NAME", "TYPE": "HD", "VERSION": "0.9"]        
        
        let qrImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: param.toJSONString(), size: CGSize.init(width: 200, height: 200), qrColor: .black, bkColor: .white)
        
        qrImageView.image = qrImg
    }
    
    
    
    

}

