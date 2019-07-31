//
//  SmartControllBaseView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/31.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class SmartControllBaseView: UIView {

    var backgroundImage: UIImageView!
    var titleLabel: UILabel!
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundImage = UIImageView.init()
        backgroundImage.image = UIImage.init(named: "image_virtual_control_bg")
        self.addSubview(backgroundImage)
        
        titleLabel = UILabel.init()
        titleLabel.font = SMART_HOME_TITLE_FONT
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        contentView = UIView.init()
        self.addSubview(contentView)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.left.right.equalToSuperview()
            
        }
        
        
        
        initUI()
        
        layoutSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 初始化
    func initUI() {
        
        
    }
    
    /// 约束
    func layoutSubview() {
        
    }


}
