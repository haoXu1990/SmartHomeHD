
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
        collectionViewFrame = frame
        super.init(nibName: nil, bundle: nil)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func initUI()  {
        
        view.frame = collectionViewFrame
        view.clipsToBounds = false
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: collectionViewFrame.width, height: collectionViewFrame.height)
        
        collectionView = UICollectionView.init(frame:CGRect.init(x: 0, y: 0, width: collectionViewFrame.width, height: collectionViewFrame.height),collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = false
        collectionView.register(Reusable.FloorViewCell)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.backgroundColor = .black       
    
        activityView = NVActivityIndicatorView.init(frame: CGRect.init(x: collectionViewFrame.width * 0.5 - 25, y: collectionViewFrame.height * 0.5 - 25, width: 50, height: 50))
        activityView.type = .lineScalePulseOut
        view.addSubview(activityView)
//        activityView.startAnimating()
        
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewSection>.init(configureCell: { (ds, cv, ip, item) in
            /// 固定只有一个 Cell
            
            let cell = cv.dequeue(Reusable.FloorViewCell, for: ip)
            
            if cell.reactor !== item {
                cell.reactor = item
            }
            
            return cell
        })
    }

    
}

extension HomeViewController {
    
    func bind(reactor: HomeViewReactor) {
       
        collectionView.dataSource = nil
        
        reactor.state.map { $0.setcions }.filterNil()
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)
    
        
        Observable.just(Reactor.Action.fetchUserInfo)
            .bind(to: reactor.action)
            .disposed(by: self.rx.disposeBag)
        
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

