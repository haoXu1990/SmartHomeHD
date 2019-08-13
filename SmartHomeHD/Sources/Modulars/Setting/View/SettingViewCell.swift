//
//  SettingViewCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/12.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import TYCyclePagerView
import ReactorKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SettingViewCell: UITableViewCell, View {
    var disposeBag: DisposeBag = DisposeBag.init()
    var backgroundImageView: UIImageView!
    
    var titleLable: UILabel!
    
    var lineImageView: UIImageView!
    
    var deleteBtn: UIButton!
    
    var cyclePagerView: TYCyclePagerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        
        initScenModeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingViewCell {
    
    func initUI() {
        self.backgroundColor = .clear
        backgroundImageView = UIImageView.init()
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.image = UIImage.init(named: "house_floor_bg")
        contentView.addSubview(backgroundImageView)
        
        titleLable = UILabel.init()
        titleLable.textColor = .black
        titleLable.textAlignment = .center
        backgroundImageView.addSubview(titleLable)
        
        lineImageView = UIImageView.init()
        lineImageView.image = UIImage.init(named: "house_room_line")
        backgroundImageView.addSubview(lineImageView)
        
        deleteBtn = UIButton.init()
        deleteBtn.setBackgroundImage(UIImage.init(named: "house_delete"), for: .normal)
        backgroundImageView.addSubview(deleteBtn)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview()
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        
        lineImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(101)
            make.width.equalTo(1)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-1)
        }
    }
    
    func initScenModeView() {
        cyclePagerView = TYCyclePagerView.init()
        cyclePagerView.backgroundColor = .clear
        cyclePagerView.isInfiniteLoop = false
        cyclePagerView.dataSource = self
        cyclePagerView.delegate = self

        cyclePagerView.register(RoomItemCell.self, forCellWithReuseIdentifier: "RoomItemCell")
        contentView.addSubview(cyclePagerView)
        cyclePagerView.snp.makeConstraints { (make) in
            make.left.equalTo(lineImageView.snp.right).offset(40)
            make.right.equalTo(deleteBtn.snp.left).offset(-40)
            make.top.equalTo(backgroundImageView)
            make.bottom.equalTo(backgroundImageView)
        }
    }
    
}

extension SettingViewCell {
    
    func bind(reactor: SettingViewCellReactor) {
        reactor.state.map{$0.rooms}
            .subscribe(onNext: { [weak self] (rooms) in
            guard let self = self else { return }
            self.cyclePagerView.reloadData()
        }).disposed(by: rx.disposeBag)
    }
}
extension SettingViewCell: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        
        let count = self.reactor?.currentState.rooms?.count ?? 0
        return count + 1
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "RoomItemCell", for: index) as! RoomItemCell
        
        if index >= (self.reactor?.currentState.rooms?.count ?? 0)  {
            cell.cellType = .add
        }
        else if let model = self.reactor?.currentState.rooms?[index] {
            cell.titleLabel.text = model.title
            cell.cellType = .normal
        }
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: 100, height: pageView.frame.height)
        layout.itemSpacing = 30
        layout.itemHorizontalCenter = false
        layout.layoutType = .normal
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        log.debug("点击事件")
    }
    func pagerViewWillBeginDragging(_ pageView: TYCyclePagerView) {
        
        log.verbose("滑动")
    }
    
}
