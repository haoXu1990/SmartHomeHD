//
//  SettingViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//  天天催得紧，so, 设置功能中的所有页面都写得很烂，有时间我会改，如果没时间。。。。

import UIKit
import ReusableKit
import ReactorKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxOptional
import SwiftyUserDefaults
import SCLAlertView

class SettingViewController: UIViewController, View {
    var disposeBag: DisposeBag = DisposeBag.init()
    var titleLabel: UILabel!
    var titlelineImageView: UIImageView!
    var backgroundImageView: UIImageView!
    
    var bottomImageView: UIImageView!
    
    var tableView: UITableView!
    
    var addBtn: UIButton!
    
    var exitBtn: UIButton!
    
    init(reactor: HomeViewReactor) {
        
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        
        initTableFooterView()
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func initTableFooterView() {
        
        bottomImageView = UIImageView.init(frame: CGRect.init(x: 15, y: 0, width: kScreenW - 75, height: 105))
        bottomImageView.image = UIImage.init(named: "house_floor_bg")
        bottomImageView.isUserInteractionEnabled = true
        let addBtnW:CGFloat = 170.0
        let addBtnH:CGFloat = CGFloat(35)
        addBtn = UIButton.init(frame: CGRect.init(x: bottomImageView.frame.width * 0.5 - addBtnW * 0.5, y: 55 - addBtnH * 0.5, width: addBtnW, height: addBtnH))
        
        addBtn.setTitle("添加楼层", for: .normal)
        addBtn.setBackgroundImage(UIImage.init(named: "house_add_bg"), for: .normal)
        bottomImageView.addSubview(addBtn)
    }
    func initUI() {
        backgroundImageView = UIImageView.init()
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.image = UIImage.init(named: "house_set_bg")
        view.addSubview(backgroundImageView)
        
        titleLabel = UILabel.init()
        titleLabel.text = "楼层设置"
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        backgroundImageView.addSubview(titleLabel)
        titlelineImageView = UIImageView.init()
        titlelineImageView.image = UIImage.init(named: "device_alarm_line")
        backgroundImageView.addSubview(titlelineImageView)
       
        
        
        tableView = UITableView.init()      
        tableView.backgroundColor = .clear
        tableView.tableFooterView = bottomImageView
        tableView.register(Reusable.SettingViewCell)
        backgroundImageView.addSubview(tableView)
        
        exitBtn = UIButton.init()
        exitBtn.titleLabel?.textColor = .white
        exitBtn.titleLabel?.textAlignment = .center
        exitBtn.layer.borderWidth = 1
        exitBtn.layer.borderColor = UIColor.white.cgColor
        exitBtn.layer.cornerRadius = 10
        
        exitBtn.setTitle("退出登录", for: .normal)
        backgroundImageView.addSubview(exitBtn)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        titlelineImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-100)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        exitBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(150)
        }
        
    }
    
}

extension SettingViewController {
    func bind(reactor: HomeViewReactor) {
        
        reactor.state.map {$0.floors}
            .bind(to: tableView.rx.items) { (cv, ip, model) in
                
                let indexPath = IndexPath.init(row: ip, section: 0)
                let cell = cv.dequeue(Reusable.SettingViewCell, for: indexPath)
                cell.titleLable.text = model.title
                
                let rooms = reactor.currentState.rooms.filter({ (roomModel) -> Bool in
                    return model.floor_id == roomModel.floor_id
                })
                
                cell.reactor = SettingViewCellReactor.init(rooms: rooms, devices: reactor.currentState.devices, floorID: model.floor_id!)
                
                
                cell.deleteBtn.rx.tap.subscribe(onNext: { (_) in             
                    Observable.just(Reactor.Action.deletedfloor(model.floor_id!))
                        .bind(to: reactor.action)
                        .disposed(by: self.rx.disposeBag)
                }).disposed(by: self.rx.disposeBag)
                
                cell.relaodData = { () in
                    Observable.just(Reactor.Action.fetchUserInfo)
                        .bind(to: reactor.action)
                        .disposed(by: self.rx.disposeBag)
                }
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        exitBtn.rx.tap.subscribe(onNext: { (_) in         
            NotificationCenter.default.post(name: .pubExitAPP, object: nil)
        }).disposed(by: rx.disposeBag)
        
        addBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            
            let alert = SCLAlertView.init()
            let textField = alert.addTextField("楼层名称")
            alert.addButton("确定", action: {
                log.debug(textField.text as Any)
                
                Observable.just(Reactor.Action.addfloor(textField.text!))
                    .bind(to: reactor.action)
                    .disposed(by: self.rx.disposeBag)
            })
            alert.showEdit("创建楼层", subTitle: "请输入楼层名称", closeButtonTitle: "取消")
            
        }).disposed(by: rx.disposeBag)
    }
}

//extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(Reusable.SettingViewCell, for: indexPath)
//        cell.titleLable.text = "一楼"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let margin = 40
//        return CGFloat(105 + margin)
//    }
    
    
//}

private enum Reusable {
    
    static let SettingViewCell = ReusableCell<SettingViewCell>.init(identifier: "SettingViewCell", nib: nil)
}
