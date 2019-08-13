//
//  RoomDeviceMangerView.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/13.
//  Copyright © 2019 FH. All rights reserved.
//  房间设备管理视图

import UIKit
import RxSwift
import NSObject_Rx
import ReusableKit
import Kingfisher

class RoomDeviceMangerView: UIView {

    var contentView: UIView!
    
    var lineImageView: UIImageView!
    
    var titleLabel: UILabel!
    var collectionView: UICollectionView!
    
    var saveBtn: UIButton!
    var closeBtn: UIButton!
    
    var devices: [DeviceModel]!
    var didSelect: ((_ device: [DeviceModel]) -> ())?
    var selectionDevices: [DeviceModel] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        action()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoomDeviceMangerView {
    
    func initUI() {
        self.isOpaque = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        contentView = UIView.init()
        contentView.backgroundColor = .black
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.hexColor(0xF2F2F2).cgColor
        contentView.layer.cornerRadius = 5
        
        self.addSubview(contentView)
        
        titleLabel = UILabel.init()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.text = "房间设备管理"
        contentView.addSubview(titleLabel)
        
        lineImageView = UIImageView.init()
        lineImageView.image = UIImage.init(named: "device_alarm_line")
        contentView.addSubview(lineImageView)
        
        saveBtn = UIButton.init()
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(UIColor.black, for: .normal)
        saveBtn.setBackgroundImage(UIImage.init(named: "house_room_qr_bg"), for: .normal)
        contentView.addSubview(saveBtn)
        
        closeBtn = UIButton.init()     
        closeBtn.setImage(UIImage.init(named: "house_delete"), for: .normal)
        contentView.addSubview(closeBtn)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width:(kScreenW - 80) / 7, height: 100)
        layout.minimumLineSpacing = 30 // 横向
        layout.minimumInteritemSpacing = 20  //纵向
        collectionView = UICollectionView.init(frame: CGRect.zero,collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Reusable.RoomDeviceMangerCell)
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)

    }
    
    override func layoutSubviews() {
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-60)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        lineImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(lineImageView.snp.bottom).offset(5)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(saveBtn.snp.top).offset(-15)
        }
    }
    
    func action() {
        closeBtn.rx.tap.subscribe(onNext: ({ [weak self](_) in
            guard let self = self else { return }
            
            self.dismiss()
        })).disposed(by: rx.disposeBag)
        
        saveBtn.rx.tap.subscribe(onNext: ({ [weak self](_) in
            guard let self = self else { return }
            self.dismiss()
            
            if let select = self.didSelect {
                select(self.selectionDevices)
            }
        })).disposed(by: rx.disposeBag)
    }
    
    func show() {
        collectionView.reloadData()
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(self)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    
}


extension RoomDeviceMangerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(Reusable.RoomDeviceMangerCell, for: indexPath)
        
        let model = devices[indexPath.row]
        cell.titleLabel.text = model.title
        let url = URL.init(string: model.icon.or(""))
        cell.iconImageView.kf.setImage(with: url)
        
        if selectionDevices.contains(model) {
            cell.selectionImage.image = UIImage.init(named: "setting_device_selected")
        }
        else {
            cell.selectionImage.image = UIImage.init(named: "setting_device_unselected")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = devices[indexPath.row]
        
        if selectionDevices.contains(model) {
            
            selectionDevices = selectionDevices.filter({ (tmpModel) -> Bool in
                return model.eqmid != tmpModel.eqmid
            })
        }
        else {
            selectionDevices.append(model)
        }
        
        collectionView.reloadData()
    }
}
private enum Reusable {
    
    static let RoomDeviceMangerCell = ReusableCell<RoomDeviceMangerCell>.init(identifier: "RoomDeviceMangerCell", nib: nil)
}
