//
//  Circle3DLayout.swift
//  SmartHomeHD
//  
//  Created by XuHao on 2019/7/15.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit

class Circle3DLayout: UICollectionViewLayout {
//    override init() {
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 内容区域总大小, 不是可见区域
    override var collectionViewContentSize: CGSize {
        if let collectionView = self.collectionView {
            let width = collectionView.frame.size.width * CGFloat((collectionView.numberOfItems(inSection: 0) + 2))

            let height = collectionView.frame.height
            return CGSize.init(width: width, height: height)
        }

        return CGSize.zero
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        if let collection = self.collectionView {
            
            let width:CGFloat = collection.frame.size.width
            let height:CGFloat = collection.frame.size.height
            let x:CGFloat = collection.contentOffset.x
            /// 弧度
            let arc:CGFloat = .pi * CGFloat(2.0)
            let screenW = UIScreen.main.bounds.width
            // 这里只取 Section 0
            let numberOfVisibleItems:Float =  6 //collection.numberOfItems(inSection: 0)
            
            attributes.center = CGPoint.init(x: x + screenW / 2, y: height * 0.5)
            attributes.size = CGSize.init(width: width - 300, height: height)
            
            NSLog("center = \(attributes.center)")
            /// 3D 动画
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 5800 //5800
            let radius:CGFloat = attributes.size.width / 2 / CGFloat(tanf(Float(arc / 2 / CGFloat(numberOfVisibleItems))))
            let angle:CGFloat = (CGFloat(indexPath.row) - x / width + 1) / CGFloat(numberOfVisibleItems) * arc
//            angle = angle > 1 ? angle + 0.5 : angle
//            NSLog("x = \(x) radius = \(radius), angle = \(angle), row = \(indexPath.row), numberofVisible = \(numberOfVisibleItems)")
            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, radius )
            
            attributes.transform3D = transform
            
            return attributes
            
        }
        
        
        return attributes
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let resultArray = super.layoutAttributesForElements(in: rect)
        
        if resultArray?.count ?? 0 > 0 { return resultArray}
        if let collectionView = self.collectionView {
            var attributes:[UICollectionViewLayoutAttributes] = []
            let count = collectionView.numberOfItems(inSection: 0)
            
            for i in 0..<count {
                let indexPath = NSIndexPath.init(item: i, section: 0)
                
                attributes.append(layoutAttributesForItem(at: indexPath as IndexPath)!)
            }
            
            return attributes
        }
        return resultArray
    }
}
