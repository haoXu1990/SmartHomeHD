//
//  CubeViewCell.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//  房间控制器, 管理一层房屋中所有的房间视图


import UIKit
import ReusableKit


class RoomControllerViewCell: UICollectionViewCell {
    
    /// 这个 collectionView 里面的 Cell 存放的是最终需要展示的页面
    var collectionView: UICollectionView!
    
    /// 普通流式布局
    var flowLayout: UICollectionViewFlowLayout!
    
    /// 3D布局
    var circle3DLayout: Circle3DLayout!
    
    var layoutStyel:RoomControllViewLayoutStyle = .cirle3D
    override init(frame: CGRect) {
        super.init(frame: frame)

        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUI() {
        
        /// 流布局
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: self.contentView.frame.width / 4, height: 100)
        
        /// 3D布局
        circle3DLayout = Circle3DLayout.init()
        
        collectionView = UICollectionView.init(frame: self.contentView.frame, collectionViewLayout: circle3DLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Reusable.RoomViewCell)
        contentView.addSubview(collectionView)
        
    }
    
    open func reloadData(flowStyle: RoomControllViewLayoutStyle) {
        
        layoutStyel = flowStyle
        let layout = flowStyle == .cirle3D ? circle3DLayout : flowLayout

        collectionView.setCollectionViewLayout(layout!, animated: true)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}


extension RoomControllerViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 这里返回的 Cell 应该是最终展示的 视图, 这里最好用 dataSource 的方式获取到数据
        let cell = collectionView.dequeue(Reusable.RoomViewCell, for: indexPath)
       
        cell.bgImageView.image = UIImage.init(named: "image_home_room_bg_1")
      
        return cell        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if layoutStyel == .cirle3D {
            
            let targetX = scrollView.contentOffset.x
            scrollView.isPagingEnabled = true
            let numCount:CGFloat = CGFloat(self.collectionView.numberOfItems(inSection: 0))
            let itemWidth = scrollView.frame.size.width
            
            if numCount >= 3 {
                
                if targetX < itemWidth / 2 {
                    scrollView.setContentOffset(CGPoint.init(x: targetX+itemWidth*numCount, y: 0), animated: false)
                }
                else if targetX > itemWidth / 2 + itemWidth * numCount {
                    scrollView.setContentOffset(CGPoint.init(x: targetX-itemWidth*numCount, y: 0), animated: false)
                }
            }
        }
    }
    
    
}



private enum Reusable {
    
    static let RoomViewCell = ReusableCell<RoomViewCell>.init(identifier: "RoomViewCell", nib: nil)
}

