//
//  DeviceControllOneCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//  设备控制卡片， 适用于单个按钮、需要加载更多视图的设备: 摄像头, 投食器, 电视, 猫眼, IR, 空调 等类是设备

import UIKit

class DeviceControllOneCell: BaseTableViewCell {

    var bgView: UIView!
    var deviceIcon: UIImageView!
    var moreIcon: UIImageView!
    var deviceTitleLabel: UILabel!
   
    
    override func initialize() {
        
        bgView = UIView.init()
        bgView.layer.cornerRadius = 15
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .black
        controllView.addSubview(bgView)
        
        deviceIcon = UIImageView.init()
        bgView.addSubview(deviceIcon)
        
        deviceTitleLabel = UILabel.init()
        deviceTitleLabel.textColor = .white
        deviceTitleLabel.font = .systemFont(ofSize: 13)
        bgView.addSubview(deviceTitleLabel)
        
        moreIcon = UIImageView.init()
        bgView.addSubview(deviceIcon)
        
    }
    
    
    override func layoutSubView() {
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        deviceIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        moreIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(15)
        }
        
        deviceTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(deviceIcon.snp.right).offset(10)
            make.right.equalTo(moreIcon.snp.right).offset(-10)
        }
        
    }
}
