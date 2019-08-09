
//
//  HomeViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//  首页控制器, 管理  房间、楼层

import UIKit
import ReusableKit
import RxSwift
import ReactorKit
import RxViewController
import RxDataSources
import RxCocoa
import NVActivityIndicatorView


class HomeViewController: UIViewController, ReactorKit.View {
    var disposeBag: DisposeBag = DisposeBag.init()
    
    /// 3D 布局
    var circleLayoutBtn:UIButton!
    /// 流式布局
    var flowLayoutBtn:UIButton!
    
    var collectionView: UICollectionView!
    
    fileprivate var flowStyle: RoomControllViewLayoutStyle = .cirle3D
    
    fileprivate var collectionViewFrame:CGRect!
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSection>!
    
    var activityView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    init(reactor: HomeViewReactor, frame:CGRect) {
        
        defer { self.reactor = reactor }
        collectionViewFrame = CGRect.init(x: 0, y: 55, width: frame.width, height: frame.height - 55)
        super.init(nibName: nil, bundle: nil)
        
        initLayoutBtn()
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func initUI()  {
        
        view.clipsToBounds = false
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: collectionViewFrame.width, height: collectionViewFrame.height)
        
        collectionView = UICollectionView.init(frame: collectionViewFrame,collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = false
        collectionView.register(Reusable.FloorViewCell)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.backgroundColor = .black       
    
        activityView = NVActivityIndicatorView.init(frame: CGRect.init(x: collectionViewFrame.width * 0.5 - 25, y: collectionViewFrame.height * 0.5 - 25, width: 50, height: 50))
        activityView.type = .lineScalePulseOut
        view.addSubview(activityView)
        
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewSection>.init(configureCell: { (ds, cv, ip, item) in
            /// 固定只有一个 Cell
            
            let cell = cv.dequeue(Reusable.FloorViewCell, for: ip)
            
            if cell.reactor !== item {
                cell.reactor = item
            }
            
            return cell
        })
    }

    func initLayoutBtn() {
        circleLayoutBtn = UIButton.init()
        circleLayoutBtn.addTarget(self, action: #selector(HomeViewController.circleLayoutBtnAction), for: .touchUpInside)
        
        circleLayoutBtn.setImage(UIImage.init(named: "btn_home_roomlayout_3d"), for: .normal)
        view.addSubview(circleLayoutBtn)
        
        circleLayoutBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        
        flowLayoutBtn = UIButton.init()
        flowLayoutBtn.addTarget(self, action: #selector(HomeViewController.flowLayoutBtnAction), for: .touchUpInside)
        flowLayoutBtn.setImage(UIImage.init(named: "btn_home_roomlayout_flow"), for: .normal)
        view.addSubview(flowLayoutBtn)
        flowLayoutBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
    }
}

///MARK - Action
extension HomeViewController {
    
    @objc func circleLayoutBtnAction()  {
//        homeVC.reloadCollectionData(flowStyle: .cirle3D)
    }
    
    @objc func flowLayoutBtnAction()  {
//        homeVC.reloadCollectionData(flowStyle: .flow)
    }
}

extension HomeViewController {
    
    func bind(reactor: HomeViewReactor) {
       
        collectionView.dataSource = nil
    
        Observable.just(Reactor.Action.fetchUserInfo)
            .bind(to: reactor.action)
            .disposed(by: self.rx.disposeBag)
        
        reactor.state.map { $0.setcions }.filterNil()
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)
        
        reactor.state.map{$0.showActivityView}
            .distinctUntilChanged()
            .bind(to: activityView.rx.animating)
            .disposed(by: rx.disposeBag)
    }
}

extension Reactive where Base: NVActivityIndicatorView {
    var animating: Binder<Bool> {
        return Binder<Bool>.init(self.base) { (view, show) in
            if show {
                view.startAnimating()
            }
            else {
                view.stopAnimating()
            }
        }
    }
}

///MARK - open method
extension HomeViewController {
    
    open func reloadCollectionData(flowStyle: RoomControllViewLayoutStyle) {
        
        if flowStyle == self.flowStyle { return }
        self.flowStyle = flowStyle
        
        collectionView.reloadData()
        // 这里需要重新加载数据, 有点问题
    }
}


private enum Reusable {
   
    static let FloorViewCell = ReusableCell<FloorViewCell>.init(identifier: "FloorViewCell", nib: nil)
}

