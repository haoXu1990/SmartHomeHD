//
//  CubeViewLayout.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class CubeViewLayout: UICollectionViewLayout {
    
    /// 内容区域大小, 不是可见区域
    override var collectionViewContentSize: CGSize {

//        let width = collectionView!.bounds.self.width - collectionView!.contentInset.left - collectionView!.contentInset.right
//
//        let height = CGFloat(collectionView!.numberOfItems(inSection: 0) + 500)
//
        return  CGSize.init(width: self.collectionView!.frame.width, height: 100*15)//self.collectionView!.bounds.size
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        /// 每个 Cell 的属性
        
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

        let width:CGFloat = collectionView!.frame.size.width
        let height:CGFloat = collectionView!.frame.size.height
        attribute.frame = CGRect.init(x: 0, y: CGFloat(indexPath.row ) * height , width: width, height: height)
        
        return attribute
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let resultArray = super.layoutAttributesForElements(in: rect)
//
//        if resultArray?.count ?? 0 > 0 { return resultArray}
        if let collectionView = self.collectionView {
            var attributes:[UICollectionViewLayoutAttributes] = []
            let count = collectionView.numberOfItems(inSection: 0)
            
            for i in 0..<count {
                let indexPath = NSIndexPath.init(item: i, section: 0)
                
                attributes.append(layoutAttributesForItem(at: indexPath as IndexPath)!)
            }
            
            return attributes
        }
        return []
    }
}
