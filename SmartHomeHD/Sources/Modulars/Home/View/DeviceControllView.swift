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
        
        let cell = tableView.dequeue(Reusable.baseCell, for: indexPath)
//        cell.titleLabel.text = "● 客厅开关"
        let model = deviceListModel[indexPath.row]
        cell.titleLabel.text = String.init(format: "● %@", model.title.or(""))
        return cell
        
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

private enum Reusable {
    
    static let baseCell = ReusableCell<BaseTableViewCell>.init(identifier: "BaseTableViewCell", nib: nil)
        //UITableViewCell<BaseTableViewCell>
    
}
