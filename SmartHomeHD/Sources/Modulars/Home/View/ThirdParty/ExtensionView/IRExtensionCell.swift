//
//  IRExtensionCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/7.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class IRExtensionCell: UICollectionViewCell {
    
    var btn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        btn = UIButton.init()
        btn.backgroundColor = .black
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        contentView.addSubview(btn)
        
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: 40))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
