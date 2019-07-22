//
//  CollectionTmpcell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//  单个房间视图

import UIKit


class RoomViewCell: UICollectionViewCell {
 
  
    open var bgImageView: UIImageView!
    
    var devicesView: DeviceControllView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgImageView = UIImageView.init()
        self.contentView.addSubview(bgImageView)
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        devicesView = DeviceControllView.init()
        self.contentView.addSubview(devicesView)
        devicesView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(200)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
