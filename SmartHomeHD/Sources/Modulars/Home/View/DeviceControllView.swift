//
//  DeviceControllView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//  设备列表视图

import UIKit
import ReusableKit
import RxOptional

fileprivate enum CellType {
    /// defaut
    case zero
    /// 一个按键, 当前界面不够展示，还有子视图
    case One
    /// 一个Switch, 用于控制只有开关功能的设备
    case Two
    /// 三个按键, 用于控制有3个按键功能得设备
    case Three
}

class DeviceControllView: UIView {

    var tableView: UITableView!
    
    var bgImage: UIImageView!    
    
    var deviceListModel: [DeviceModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initUI()

        layoutSubView()
    }
    
    func initUI()  {
        
        bgImage = UIImageView.init(image: UIImage.init(named: "image_devicelist_bg"))
        self.addSubview(bgImage)
        
        tableView = UITableView.init()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(Reusable.baseCell)
        tableView.register(Reusable.oneCell)
        tableView.register(Reusable.twoCell)
        self.addSubview(tableView)
        
    }
    
    func layoutSubView()  {
     
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DeviceControllView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = deviceListModel[indexPath.row]
      
        switch cellFactory(typeID: Int(model.typeid!)!) {
        case .One:
            let cell = tableView.dequeue(Reusable.oneCell, for: indexPath)
            cell.titleLabel.text = String.init(format: "● %@", model.title.or(""))
            return cell
        case .Three:
            let cell = tableView.dequeue(Reusable.twoCell, for: indexPath)
            cell.titleLabel.text = String.init(format: "● %@", model.title.or(""))
            return cell
        default:
            let cell = tableView.dequeue(Reusable.baseCell, for: indexPath)
            cell.titleLabel.text = String.init(format: "● %@", model.title.or(""))
            return cell
        }
        
        
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension DeviceControllView {
    
    fileprivate func cellFactory(typeID: Int) -> CellType {
        
        guard let typeID = SmartDeviceType.init(rawValue: typeID) else {
            
            return .zero
        }
        
        switch typeID {
        case .Switch: return .Two
        case .Socket: return .Two
        case .Curtain: return .Three
        case .Feed: return .One
        case .Tv: return .One
        case .Airconditioner: return .One
        case .IR: return .One
        case .TranslucentScreen: return .Three
        case .Projector: return .Three
        case .Windowopener: return .Three
        case .Projectormachine: return .Three
        case .WaterValve: return .One
        default:
            return .zero
        }
    }
    
}



private enum Reusable {
    
    static let baseCell = ReusableCell<BaseTableViewCell>.init(identifier: "BaseTableViewCell", nib: nil)
    static let oneCell = ReusableCell<DeviceControllOneCell>.init(identifier: "DeviceControllOneCell", nib: nil)
    static let twoCell = ReusableCell<DeviceControllTwoCell>.init(identifier: "DeviceControllTwoCell", nib: nil)
}
