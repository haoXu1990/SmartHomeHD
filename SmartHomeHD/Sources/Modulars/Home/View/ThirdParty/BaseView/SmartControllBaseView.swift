//
//  SmartControllBaseView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/31.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class SmartControllBaseView: UIView {
    
    /// 主视图
    var mainView: UIView!
    var backgroundImage: UIImageView!
    var titleLabel: UILabel!
    var contentView: UIView!
    
    /// 扩展视图
    var extensionView: UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainView = UIView.init()
        mainView.backgroundColor = .clear
        self.addSubview(mainView)
        
        extensionView = UIView.init()
        extensionView.backgroundColor = .clear
        self.addSubview(extensionView)
        
        
        backgroundImage = UIImageView.init()
        backgroundImage.image = UIImage.init(named: "image_virtual_control_bg")
        mainView.addSubview(backgroundImage)
        
        titleLabel = UILabel.init()
        titleLabel.font = SMART_HOME_TITLE_FONT
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        mainView.addSubview(titleLabel)
        
        contentView = UIView.init()
        mainView.addSubview(contentView)
        
        mainView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(270)
        }
        
        extensionView.snp.makeConstraints { (make) in
            make.right.equalTo(mainView.snp.left)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(270)
        }
        
        
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
