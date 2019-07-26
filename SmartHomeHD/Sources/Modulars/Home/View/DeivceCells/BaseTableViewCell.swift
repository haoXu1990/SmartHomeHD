//
//  BaseTableViewCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/22.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    var titleLabel: UILabel!
    
    var titleImage: UIImageView!
    
    /// 控制视图
    var controllView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        initUI()
        
        initialize()
        
        layoutSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        titleImage = UIImageView.init()
        titleImage.image = UIImage.init(named: "image_device_cell_titlebg")
        contentView.addSubview(titleImage)
        
        titleLabel = UILabel.init()
        titleLabel.font = SMART_HOME_TITLE_FONT
        titleLabel.textColor = SMART_HOME_TITLE_COLOR
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        controllView = UIView.init()
        controllView.backgroundColor = .clear
        contentView.addSubview(controllView)
        
        titleImage.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleImage)
            make.left.equalTo(titleImage).offset(10)
        }
        
        controllView.snp.makeConstraints { (make) in
            make.top.equalTo(titleImage.snp.bottom).offset(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    func initialize() {
        // 添加视图
    }
    
    func layoutSubView() {
        // 添加约束
    }
    
}
