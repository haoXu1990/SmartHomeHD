//
//  RoomDeviceMangerCellCollectionViewCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/13.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class RoomDeviceMangerCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    
    var iconImageView: UIImageView!
    
    var bgView: UIView!
    
    var selectionImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoomDeviceMangerCell {
    
    func initUI() {
        
        
        bgView = UIView.init()
        bgView.backgroundColor = UIColor.hexColor(0xF2F2F2)
        bgView.circular(radius: 5)
        contentView.addSubview(bgView)
    
        iconImageView = UIImageView.init()
        bgView.addSubview(iconImageView)
        
        selectionImage = UIImageView.init()
        bgView.addSubview(selectionImage)
        
        titleLabel = UILabel.init()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-5)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        
        selectionImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.size.equalTo(CGSize.init(width: 17, height: 17))
        }
    }
    
    
}
