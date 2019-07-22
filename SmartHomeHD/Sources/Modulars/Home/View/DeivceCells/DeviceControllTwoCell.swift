//
//  DeviceControllTwoCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class DeviceControllTwoCell: BaseTableViewCell {

    var leftBtn: UIButton!
    
    var middleBtn: UIButton!
    
    var rightBtn: UIButton!
    
    
    override func initialize() {
        
        leftBtn = UIButton.init()
        controllView.addSubview(leftBtn)
        
        middleBtn = UIButton.init()
        controllView.addSubview(leftBtn)
        
        rightBtn = UIButton.init()
        controllView.addSubview(leftBtn)
    }
    
    
    override func layoutSubView() {
        
        middleBtn.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(middleBtn.snp.centerY)
            make.right.equalTo(middleBtn.snp.left).offset(-20)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(middleBtn.snp.centerY)
            make.left.equalTo(middleBtn.snp.right).offset(20)
        }
        
    }

}
