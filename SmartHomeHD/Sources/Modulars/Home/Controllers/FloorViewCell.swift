//
//  CubeViewCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//  楼层, 管理一层房屋中所有的房间视图


import UIKit
import ReusableKit
import ReactorKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import RxOptional
import TYCyclePagerView
import Kingfisher

class FloorViewCell: UICollectionViewCell,ReactorKit.View {
   
    var disposeBag: DisposeBag = DisposeBag.init()
   
    var collectionView: UICollectionView!
    
    /// 普通流式布局
    var flowLayout: UICollectionViewFlowLayout!
  
    var layoutStyel:RoomControllViewLayoutStyle = .cirle3D
    
    var carouselView: iCarousel!
    
    var scenModeView: TYCyclePagerView!
    var dataSource: RxCollectionViewSectionedReloadDataSource<FloorViewSection>!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
        initCarouseView()
        
        initScenModeView()
        
        DLog("initUI")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUI() {

        dataSource = RxCollectionViewSectionedReloadDataSource<FloorViewSection>.init(configureCell: { (ds, cv, ip, item) in
            let cell = cv.dequeue(Reusable.RoomViewCell, for: ip)
            cell.roomBackgroundImageView.image = UIImage.init(named: "image_home_room_bg_1")
            return cell
        })
        
        /// 流布局
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: self.contentView.frame.width / 4, height: 100)

        collectionView = UICollectionView.init(frame: self.contentView.frame, collectionViewLayout: flowLayout)
        collectionView.isHidden = true
        collectionView.register(Reusable.RoomViewCell)
        contentView.addSubview(collectionView)
    }
    
    func initScenModeView() {
        scenModeView = TYCyclePagerView.init()
        scenModeView.backgroundColor = .clear
        scenModeView.isInfiniteLoop = true
        scenModeView.dataSource = self
        scenModeView.delegate = self
        
        scenModeView.register(ScenViewCell.self, forCellWithReuseIdentifier: "ScenViewCell")
        contentView.addSubview(scenModeView)
        scenModeView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(carouselView.snp.bottom).offset(20)
            make.left.equalTo(carouselView.snp.left).offset(200)
            make.right.equalTo(carouselView.snp.right).offset(-200)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    

    open func reloadData(flowStyle: RoomControllViewLayoutStyle) {
        
    }
    
}

extension FloorViewCell {
    
    func initCarouseView() {
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        carouselView = iCarousel.init(frame: CGRect.init(x: 55, y: 0, width: self.contentView.frame.width - 110, height: self.contentView.frame.height - 100))
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.bounces = false
        carouselView.isPagingEnabled = true
        carouselView.type = .cylinder
        carouselView.isHidden = true
        carouselView.backgroundColor = .clear
        contentView.addSubview(carouselView)
    }
    
    func showLayout(layout: Bool, index: Int = -1) {
        
        if layout {
            /// 3D
            /// 1. 隐藏 CollectionView
            collectionView.isHidden = true
            /// 2. 显示 iCarouselView
            carouselView.isHidden = false
            
            if index >= 0 {
                carouselView.scrollToItem(at: index, animated: true)
            }
            
        }
        else {
            /// 流布局
            /// 1. 显示 CollectionView
            collectionView.isHidden = false
            /// 2. 隐藏 iCarouselView
            carouselView.isHidden = true
        }
    }
}

extension FloorViewCell {
    
    func bind(reactor: FloorViewReactor) {
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        reactor.state.map{$0.fllowLayout}
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self](layout) in
                guard let self = self else { return }                
                self.showLayout(layout: layout)
        }).disposed(by: rx.disposeBag)
        
        reactor.state.map { $0.setcions }
            .filterNil()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        reactor.state
            .map{ $0.rooms }
            .filterNil()
            .subscribe(onNext: { [weak self] (rooms) in
                guard let self = self else { return }
                self.carouselView.reloadData()
            }).disposed(by: rx.disposeBag)
        
        reactor.state
            .map{ $0.scenModes }
            .filterNil()
            .subscribe(onNext: { [weak self] (rooms) in
                guard let self = self else { return }
                self.scenModeView.reloadData()
            }).disposed(by: rx.disposeBag)
    }
    
    
    func sendObsver(model: SceneModeModel) {
        
        Observable.just(Reactor.Action.sendScenModeCommand(model))
            .bind(to: self.reactor!.action)
            .disposed(by: rx.disposeBag)
    }
    
}

extension FloorViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showLayout(layout: true, index: indexPath.row)
    }
}

extension FloorViewCell: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return self.reactor?.currentState.scenModes?.count ?? 0
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ScenViewCell", for: index) as! ScenViewCell
        if let model = self.reactor?.currentState.scenModes?[index] {
            let url = URL.init(string: model.imgs.or(""))
            cell.imageView.kf.setImage(with: url)
            cell.titleLabel.text = model.title
        }
        
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: 180, height: pageView.frame.height)
        layout.itemSpacing = 15
        layout.itemHorizontalCenter = false
        layout.layoutType = .linear
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        
        if let model = self.reactor?.currentState.scenModes?[index] {
            sendObsver(model: model)
        }
        else {
            log.error("情景模式执行失败")
            FHToaster.show(text: "情景模式执行失败")
        }
    }
}

extension FloorViewCell: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.reactor?.currentState.rooms?.count ?? 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let cellView = view
        /// 返回 roomView
        if cellView == nil {
            let cellFrame = CGRect.init(x: 55, y: 0, width: self.contentView.frame.width - 110, height: self.contentView.frame.height - 100)
            let cell = RoomViewCell.init(frame: cellFrame)
            if let sections = self.reactor?.currentState.setcions?.first {
                let reactor = sections.items[index]
                cell.reactor = reactor
                return cell
            }
        }
        else {
            let cell = cellView as! RoomViewCell
            if let sections = self.reactor?.currentState.setcions?.first {
                let reactor = sections.items[index]
//                cell.roomBackgroundImageView.image = UIImage.init(named: "image_home_room_bg_1")
                cell.reactor = reactor
                return cell
            }
        }
        
        return view!
    }
}

private enum Reusable {
    
    static let RoomViewCell = ReusableCell<RoomViewCell>.init(identifier: "RoomViewCell", nib: nil)
}

