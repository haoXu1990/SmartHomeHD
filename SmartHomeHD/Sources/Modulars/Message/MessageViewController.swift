//
//  MessageViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import ReusableKit
import RxSwift
import ReactorKit
import RxViewController
import RxDataSources
import RxCocoa
import NVActivityIndicatorView
import Kingfisher
import LXFProtocolTool


class MessageViewController: UIViewController, ReactorKit.View, Refreshable {
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    var titleLabel: UILabel!
    
    var lineImageView: UIImageView!
    
    var collectionView: UICollectionView!
    
    init(reactor: MessageViewReactor) {        
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        initUI ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
    func initUI () {
        titleLabel = UILabel.init()
        titleLabel.text = "报警记录"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        lineImageView = UIImageView.init()
        lineImageView.image = UIImage.init(named: "device_alarm_line")
        view.addSubview(lineImageView)
        lineImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        
        let itemW = (kScreenW - 110) * 0.5 - 50
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: itemW, height: 50)
        
        collectionView = UICollectionView.init(frame: .zero,collectionViewLayout: layout)       
        collectionView.register(Reusable.MessageViewCell)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.backgroundColor = .black
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
            make.bottom.equalToSuperview()
        }
    }


}

extension MessageViewController {
    
    func bind(reactor: MessageViewReactor) {
        
        
        Observable.just(Reactor.Action.fetchAlarmList(false))
            .bind(to: reactor.action)
            .disposed(by: self.rx.disposeBag)

        reactor.state
            .map{$0.alarmModels}
            .filterNil()
            .bind(to: collectionView.rx.items) { (cv, ip, model) in

                let indexPath = IndexPath.init(row: ip, section: 0)
                let cell = cv.dequeue(Reusable.MessageViewCell, for: indexPath)
                cell.titleLabel.text = model.content
                cell.timeLabel.text = model.times
                let url = URL.init(string: model.icon.or(""))
                cell.iconImageView.kf.setImage(with: url)
                return cell
            }
            .disposed(by: rx.disposeBag)
        self.rx.refresh(reactor, collectionView)
            .map{ .fetchAlarmList($0 != .header)}
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)

        self.lxf.updateEmptyDataSet(collectionView, config: EmptyConfig.noData)
    }
}


fileprivate struct EmptyConfig {
    static let normal = EmptyDataSetConfigure(tipFont: UIFont.systemFont(ofSize: 14), tipColor: UIColor.white, tipImage: UIImage(named: "LXFEmptyDataPic")!, spaceHeight: 15)
    
    static let noData = { () -> EmptyDataSetConfigure in
        var config = EmptyConfig.normal
        config.tipStr = "暂无数据"
        config.tipImage = UIImage(named: "LXFEmptyDataPic")
        config.tipColor = UIColor.white
        return config
    }()
    static let loadFaile = { () -> EmptyDataSetConfigure in
        var config = EmptyConfig.normal
        config.tipStr = "呃，页面加载失败"
        config.buttonImageBlock = { _ in
            return UIImage(named: "reloadData")
        }
        return config
    }()
}

private enum Reusable {
    
    static let MessageViewCell = ReusableCell<MessageViewCell>.init(identifier: "MessageViewCell", nibName: "MessageViewCell")
}
