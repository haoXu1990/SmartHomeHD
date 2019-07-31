//
//  CollectionTmpcell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//  单个房间视图, 这个视图会比较复杂，考虑下怎么分解

import UIKit
import ReusableKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxOptional
import ReactorKit

fileprivate enum CellType {
    /// defaut
    case zero
    /// 一个按键, 当前界面不够展示，还有子视图
    case More
    /// 一个开关按键, 用于控制只有开关功能的设备
    case OneSwitch
    /// 三个按键, 用于控制有3个按键功能得设备
    case ThreeButton
}

class RoomViewCell: UICollectionViewCell, View {
    
    var disposeBag: DisposeBag = DisposeBag.init()
    
    /// 房间背景图片
    open var roomBackgroundImageView: UIImageView!
    
    /// 设备列表背景图片
    var deviceListBackgroundImageView: UIImageView!
    
    /// 设备列表视图
    var tableView: UITableView!
    
    /// 更多视图
    var moreView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    func initUI() {
        
        roomBackgroundImageView = UIImageView.init()
        self.contentView.addSubview(roomBackgroundImageView)
        
        deviceListBackgroundImageView = UIImageView.init(image: UIImage.init(named: "image_devicelist_bg"))
        self.contentView.addSubview(deviceListBackgroundImageView)
        
        tableView = UITableView.init()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(Reusable.baseCell)
        tableView.register(Reusable.oneCell)
        tableView.register(Reusable.twoCell)
        tableView.register(Reusable.switchCell)
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        self.addSubview(tableView)
        
        moreView = UIView.init()
        moreView.backgroundColor = .clear
        self.addSubview(moreView)

    }
    
    override func layoutSubviews() {
        
        roomBackgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
       
        deviceListBackgroundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(200)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(deviceListBackgroundImageView)
        }
        
        
        moreView.snp.makeConstraints { (make) in
            make.top.equalTo(deviceListBackgroundImageView)
            make.right.equalTo(deviceListBackgroundImageView.snp.left)
            make.width.equalTo(270)
            make.bottom.equalTo(deviceListBackgroundImageView)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// UI init
extension RoomViewCell {
    
    func showMoreUI(model: DeviceModel)  {
        
        initCameraView(model: model)
    }
    
    
    /// 删除更多视图中的所有子视图
    func removeAllSubView() {
        for view in moreView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func initProjectorView(model: DeviceModel) {
        /// 删除创建得视图
        
        let cameraView = SmartProjectorView.init()
        cameraView.reactor = InfraredControlReactor.init(deviceModel: model)
        moreView.addSubview(cameraView)
        cameraView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func initCameraView(model: DeviceModel) {
        
        let cameraView = SmartCameraView.loadFromNib()
        cameraView.reactor = SmartCameraViewReactor.init(deviceModel: model)
        moreView.addSubview(cameraView)
        
        cameraView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}



extension RoomViewCell {
    
    func bind(reactor: RoomViewReactor) {
        
        
        
        reactor.state.map { $0.deviceModels }
            .bind(to: tableView.rx.items) { (tableView, ip, model) in
                
                switch self.cellFactory(typeID: Int(model.typeid!)!) {
                case .More:
                    let cell = tableView.dequeue(Reusable.oneCell)!                  
                    cell.reactor = DeviceControllCellReactor.init(deviceModel: model)
                    return cell
                case .ThreeButton:
                    let cell = tableView.dequeue(Reusable.twoCell)!                  
                    cell.reactor = DeviceControllCellReactor.init(deviceModel: model)
                    return cell
                case .OneSwitch:
                    let cell = tableView.dequeue(Reusable.switchCell)!
                    cell.reactor = DeviceControllCellReactor.init(deviceModel: model)
                    return cell
                default:
                    let cell = tableView.dequeue(Reusable.baseCell)!
                    cell.titleLabel.text = String.init(format: "● %@", model.title.or(""))
                    return cell
                }
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(DeviceModel.self).subscribe(onNext: { [weak self] (model) in
            
            guard let self = self else { return }
            let typeID = Int(model.typeid!)!
            let type = self.cellFactory(typeID: typeID)
        
            /// 删除已有得视图
            self.removeAllSubView()
            
            if type == .More {
                log.debug("显示更多视图")
                
                if typeID == SmartDeviceType.YSCamera.rawValue {
                    self.initCameraView(model: model)
                }
                else if typeID == SmartDeviceType.Projector.rawValue {
                    self.initProjectorView(model: model)
                }
                
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
}


extension RoomViewCell: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension RoomViewCell {
    
    fileprivate func cellFactory(typeID: Int) -> CellType {
        
        guard let typeID = SmartDeviceType.init(rawValue: typeID) else {
            
            return .zero
        }
        
        switch typeID {
        case .Switch: return .OneSwitch
        case .SwitchTouch: return .OneSwitch
        case .SwitchDOUBLE: return .OneSwitch
        case .Socket: return .OneSwitch
        case .Curtain: return .ThreeButton
        case .Feed: return .OneSwitch
        case .Tv: return .More
        case .Airconditioner: return .More
        case .IR: return .More
        case .TranslucentScreen: return .ThreeButton
        case .Projector: return .More
        case .Windowopener: return .ThreeButton
        case .Projectormachine: return .ThreeButton
        case .WaterValve: return .OneSwitch
        case .YSCamera: return .More
        
        default:
            return .zero
        }
    }
    
}


private enum Reusable {
    
    static let baseCell = ReusableCell<BaseTableViewCell>.init(identifier: "BaseTableViewCell", nib: nil)
    
    static let oneCell = ReusableCell<DeviceControllOneCell>.init(identifier: "DeviceControllOneCell", nib: nil)
    static let twoCell = ReusableCell<DeviceControllTwoCell>.init(identifier: "DeviceControllTwoCell", nib: nil)
    
     static let switchCell = ReusableCell<DeviceControllSwitchCell>.init(identifier: "DeviceControllSwitchCell", nib: nil)
}
