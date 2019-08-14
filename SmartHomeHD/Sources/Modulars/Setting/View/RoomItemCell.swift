//
//  RoomItemCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/12.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

enum RoomItemType: NSInteger {
    case add
    case normal
}

class RoomItemCell: UICollectionViewCell {
    
    var backgroundImageView: UIImageView!
    var titleLabel: UILabel!
    var deleteBtn: UIButton!
    
    var addImageView: UIImageView!
    var cellType: RoomItemType! { willSet {
        
            setUI(type: newValue)
        }}
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension RoomItemCell {
    
    func initUI() {
        
        titleLabel = UILabel.init()
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        backgroundImageView = UIImageView.init()
        backgroundImageView.backgroundColor = .black
        backgroundImageView.layer.cornerRadius = 5
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.isUserInteractionEnabled = true
        contentView.addSubview(backgroundImageView)
        
        addImageView = UIImageView.init()
        addImageView.image = UIImage.init(named: "house_floor_add")
        contentView.addSubview(addImageView)
        
        
        deleteBtn = UIButton.init()
        deleteBtn.setBackgroundImage(UIImage.init(named: "house_delete"), for: .normal)
        backgroundImageView.addSubview(deleteBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize.init(width: 80, height: 60))
        }
        
        addImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-1)
          
        }
        
    }
    
    
    func setUI(type: RoomItemType) {
        
        if type == .add {
            addImageView.isHidden = false
            backgroundImageView.isHidden = true
            titleLabel.text = "添加房间"
        }
        else {            
            backgroundImageView.isHidden = false
            addImageView.isHidden = true
        }
    }
    
}
