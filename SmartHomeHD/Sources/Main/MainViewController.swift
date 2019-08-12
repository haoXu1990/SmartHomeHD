//
//  MainViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//  主控制器, 管理 首页 , 消息, 设置 

import UIKit
import SnapKit
import ReusableKit
import RxSwift
import ReactorKit
import RxCocoa
import NSObject_Rx
import RxSwiftExt


import HMSegmentedControl

enum RoomControllViewLayoutStyle:NSInteger {
    case cirle3D // 3D
    case flow /// 流式布局
}

class MainViewController: UIViewController {

    var scrollView: UIScrollView!
    var segmentVC: HMSegmentedControl!
    
    var homeVC: HomeViewController!
    
    var messageVC: UIViewController!
    
    var settingVC: UIViewController!
    
    var headerView: UIView!
    
    var service: DeviceServerType = DeviceServer.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        
        FHSoketManager.shear().connectSocket()
//        let vc = ViewController.init()
//        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.alpha = 1;
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        /// 隐藏状态栏
        return true
    }
    
    func initUI()  {
        
        view.backgroundColor = .black
        view.clipsToBounds = false
        
        // 0. 创建顶部导航       
        headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 55))
        headerView.backgroundColor = .hexColor(0x151515)
        view.addSubview(headerView)
        
        let logImage = UIImageView.init(image: UIImage.init(named: "image_log_style1"))
        headerView.addSubview(logImage)
        logImage.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-55)
        }
        
        // 1. 初始化 segment
        
        let images:[UIImage] = [UIImage.init(named: "btn_home_segment_home")!,
                                UIImage.init(named: "btn_home_segment_home")!,
                                UIImage.init(named: "btn_home_segment_home")!]
        segmentVC = HMSegmentedControl.init(sectionImages: images, sectionSelectedImages: images, titlesForSections: ["", "", ""])
        segmentVC.frame = CGRect.init(x: 55, y: 0, width: 500, height: 55)
        segmentVC.imagePosition = .leftOfText
        segmentVC.backgroundColor = .clear
        segmentVC.selectionIndicatorColor = .clear
        segmentVC.selectionIndicatorHeight = 0.01
        segmentVC.selectionStyle = .textWidthStripe
        segmentVC.segmentWidthStyle = .dynamic
        segmentVC.indexChangeBlock = { [weak self]  (index:NSInteger) in
            guard let self = self else { return }
            self.scrollView.scrollRectToVisible(CGRect.init(x: kScreenW * CGFloat(index), y: 0, width: kScreenW, height: 500), animated: true)
        }
        
        headerView.addSubview(segmentVC)
        
        // 2. 初始化 ScrollView
        let scrollViewY = segmentVC.frame.height
        let scrollViewH = kScreenH - scrollViewY
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: scrollViewY, width: kScreenW, height: scrollViewH))
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize.init(width: kScreenW * 3, height: 300)
        scrollView.delegate = self
        scrollView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: kScreenH, height: scrollViewH), animated: false)
        view.addSubview(scrollView)
        
        // 3. 把控制器添加到 ScrollView
        /// 这里一定得强引用
        let reactor = HomeViewReactor.init(service: self.service)
        let rect = CGRect.init(x: 0, y: 0, width: kScreenW, height: scrollViewH)
        homeVC = HomeViewController.init(reactor: reactor, frame: rect)      
        scrollView.addSubview(homeVC.view)
        
        messageVC = MessageViewController.init(reactor: MessageViewReactor())
        messageVC.view.frame = CGRect.init(x: kScreenW, y: 0, width: kScreenW, height: scrollViewH)
        messageVC.view.backgroundColor = .black
        scrollView.addSubview(messageVC.view)
        
        settingVC = SettingViewController.init(reactor: reactor)
        settingVC.view.frame = CGRect.init(x: kScreenW * 2, y: 0, width: kScreenW, height: scrollViewH)        
        scrollView.addSubview(settingVC.view)
        
    }
    
    
    

}




extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.size.width
//        let page = scrollView.contentOffset.x / pageWidth
//
//        segmentVC.setSelectedSegmentIndex(UInt(page), animated: true)
    }
}
