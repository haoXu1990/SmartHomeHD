
//
//  HomeViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//  首页控制器, 管理  房间、楼层
//  新增门铃报警弹窗
import UIKit
import ReusableKit
import RxSwift
import ReactorKit
import RxViewController
import RxDataSources
import RxCocoa
import NVActivityIndicatorView
import LXFProtocolTool
import Then

class HomeViewController: UIViewController, ReactorKit.View, Refreshable {
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
    
    let titleLabel = UILabel.init().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 门铃报警
        NotificationCenter.default.rx.notification(.pubAlarmChange)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (data) in
                guard let _ = self, let result = data.object as? [String: Any] else { return }
                
                if let type = result["type"] as? Int,
                    let state = result["state"] as? String,
                    let bid = result["bid"] as? String,
                    let dbcode = result["dbcode"] as? Int {
                    
                    if type == 15 {
                        // 门铃呼叫
                        if state == "2" {
                            let title = result["text"] as? String
                            let view = SmartDoorbell.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
                            view.bid = bid
                            view.dbcode = String(dbcode)
                            view.show(title: title.or("门铃来电"))
                        }
                    }
                }
                
            }).disposed(by: rx.disposeBag)
        
        /// 刷新界面
        NotificationCenter.default.rx.notification(.pubRefresh)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self else { return }
                
                Observable.just(Reactor.Action.fetchUserInfo)
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.rx.disposeBag)
            }).disposed(by: rx.disposeBag)
        
        /// title
        NotificationCenter.default.rx.notification(.updateFlooerTitle)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (data) in
               guard let self = self, let result = data.object as? String else { return }
                
                self.titleLabel.text = result
            }).disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.pubStateChange)
        .takeUntil(self.rx.deallocated)
        .subscribe(onNext: { [weak self] (data) in
           guard let self = self, let result = data.object as? [String: Any] else { return }

            if let eqmsn = result["eqmsn"] as? String,
            let channel = result["channel"] as? Int,
                let state = result["state"] as? Int {
                Observable.just(Reactor.Action.modifyDeviceStatus(eqmsn, channel, state))
                .bind(to: self.reactor!.action)
                .disposed(by: self.rx.disposeBag)
            }
            
            
            
        }).disposed(by: rx.disposeBag)
    }

    init(reactor: HomeViewReactor, frame:CGRect) {
        
        defer { self.reactor = reactor }
        collectionViewFrame = CGRect.init(x: 0, y: 55, width: frame.width, height: frame.height - 55)
        
        super.init(nibName: nil, bundle: nil)
        initUI()
        initLayoutBtn()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func initUI()  {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: collectionViewFrame.width, height: collectionViewFrame.height)
        
        collectionView = UICollectionView.init(frame: collectionViewFrame,collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = false
        collectionView.register(Reusable.FloorViewCell)
        view.addSubview(collectionView)
        
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
        circleLayoutBtn.setImage(UIImage.init(named: "btn_home_roomlayout_3d"), for: .normal)
        view.addSubview(circleLayoutBtn)
        
        circleLayoutBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        
        flowLayoutBtn = UIButton.init()
        flowLayoutBtn.setImage(UIImage.init(named: "btn_home_roomlayout_flow"), for: .normal)
        view.addSubview(flowLayoutBtn)
        
        flowLayoutBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(flowLayoutBtn)
            make.left.equalToSuperview().offset(60)
        }
    }
}



extension HomeViewController {
    
    func bind(reactor: HomeViewReactor) {
       
        collectionView.dataSource = nil
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        circleLayoutBtn.rx.tap
            .map{_ in Reactor.Action.setLayout(true)}
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        flowLayoutBtn.rx.tap
            .map{_ in Reactor.Action.setLayout(false)}
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
    
        Observable.just(Reactor.Action.fetchUserInfo)
            .bind(to: reactor.action)
            .disposed(by: self.rx.disposeBag)
        
        reactor.state.map { $0.setcions }
            .filterNil()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        reactor.state.map{$0.showActivityView}
            .distinctUntilChanged()
            .bind(to: activityView.rx.animating)
            .disposed(by: rx.disposeBag)
        
//        self.rx.headerRefresh(reactor, collectionView, headerConfig: RefreshConfig.normalHeader)
//            .map{_ in Reactor.Action.fetchUserInfo }
//            .bind(to: reactor.action)
//            .disposed(by: rx.disposeBag)
        
    }
}

extension HomeViewController: UICollectionViewDelegate, UIScrollViewDelegate {

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let originPoint: CGPoint = self.view.convert(self.collectionView.center, to: collectionView)
        guard let path = collectionView.indexPathForItem(at: originPoint) else { return }
        if path.section < self.reactor?.currentState.setcions?.count ?? 0 {
            let section = self.reactor!.currentState.setcions![path.section]
            
            let item = section.items[0]
            let room = item.currentState.rooms![0]
            self.titleLabel.text = item.floorModel!.title! + "-" + room.title!
        }
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

private enum Reusable {
   
    static let FloorViewCell = ReusableCell<FloorViewCell>.init(identifier: "FloorViewCell", nib: nil)
}



