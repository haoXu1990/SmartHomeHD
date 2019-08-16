//
//  SmartDoorbell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/16.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class SmartDoorbell: UIView {

    var contentView: UIView!
    
    var titleLabel: UILabel!
    
    var playerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        contentView = UIView.init()
        self.addSubview(contentView)
        
        playerView = UIView.init()
        contentView.addSubview(playerView)
        
    }
    
    override func layoutSubviews() {
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 400, height: 450))
        }
        
        playerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(200)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
        }
    }
}
