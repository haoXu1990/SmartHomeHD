//
//  ScenViewCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/9.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class ScenViewCell: UICollectionViewCell {

    var imageView: UIImageView!
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }    
    
    func initUI() {
        imageView = UIImageView.init()
        imageView.circular()
        contentView.addSubview(imageView)
        
        titleLabel = UILabel.init()
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.backgroundColor = .black
        titleLabel.textColor = .white
        titleLabel.alpha = 0.65
        titleLabel.textAlignment = .center
        imageView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
    }
}

