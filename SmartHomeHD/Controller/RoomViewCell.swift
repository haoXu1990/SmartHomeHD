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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgImageView = UIImageView.init()
        self.addSubview(bgImageView)
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
