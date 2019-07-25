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
        guard let collectionView = self.collectionView, collectionView.numberOfSections > 0 else {
            return CGSize.zero
        }
        
        let width = collectionView.frame.size.width * CGFloat((collectionView.numberOfItems(inSection: 0) + 2))
        
        let height = collectionView.frame.height
        return CGSize.init(width: width, height: height)

    }
    

//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
//
//        if let collection = self.collectionView {
//
//
//            let width:CGFloat = collection.frame.size.width
//            let height:CGFloat = collection.frame.size.height
//            let x:CGFloat = collection.contentOffset.x
//            /// 弧度
//            let arc:CGFloat = .pi * CGFloat(2.0)
//
////            let screenW = UIScreen.main.bounds.width
//            // 这里只取 Section 0
//            let numberOfVisibleItems:Float = 5 // Float(collection.numberOfItems(inSection: 0))
//
//            attributes.center = CGPoint.init(x: x + width / 2, y: height * 0.5)
//            attributes.size = CGSize.init(width: width - 300, height: height )
//            DLog("collection.contentOffset.x = \(collection.contentOffset.x)")
//
//            /** 基础思路
//                1. 先做形变
//                2. 在形变的基础上向 Z 轴平移
//             注意:
//                1. 这里是对整个Cell 做变换, 内容大小会超过 Cell
//             */
//            /// 3D 动画
//            var transform = CATransform3DIdentity
//            transform.m34 = -1.0 / 58000
//
//            let radius:CGFloat = attributes.size.width / 2 / CGFloat(tanf(Float(arc / 2 / CGFloat(numberOfVisibleItems))))
//
//            let angle:CGFloat = (CGFloat(indexPath.row) - x / width + 1) / CGFloat(numberOfVisibleItems) * arc
//
//            //实现以一个已经存在的形变为基准,在x轴,y轴,z轴方向上逆时针旋转angle弧度(弧度=π/180×角度,M_PI弧度代表180角度),x,y,z三个参数只分是否为0。
//            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
//
//            // 实现以一个已经存在的形变为基准,在x轴方向上平移x单位,在y轴方向上平移y单位,在z轴方向上平移z单位。
//            /** 显示视图最终宽高变大就是 radius 影响了 */
//            transform = CATransform3DTranslate(transform, 0, 0, radius)
//
//
//            transform = CATransform3DScale(transform, 1, 1, 5)
//            attributes.transform3D = transform
//
//            return attributes
//
//        }
//
//
//        return attributes
//
//    }
    
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
            let numberOfVisibleItems:Float = 5 // Float(collection.numberOfItems(inSection: 0))

            attributes.center = CGPoint.init(x: x + screenW / 2, y: height * 0.5)
            attributes.size = CGSize.init(width: width - 300, height: height )
            DLog("collection.contentOffset.x = \(collection.contentOffset.x)")
            
            /// 3D 动画
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 5800 //5800

            let radius:CGFloat = attributes.size.width / 2 / CGFloat(tanf(Float(arc / 2 / CGFloat(numberOfVisibleItems))))

            let angle:CGFloat = (CGFloat(indexPath.row) - x / width + 1) / CGFloat(numberOfVisibleItems) * arc

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
        
        guard let collectionView = self.collectionView, collectionView.numberOfSections > 0 else {
            return resultArray
        }
        
        var attributes:[UICollectionViewLayoutAttributes] = []
        let count = collectionView.numberOfItems(inSection: 0)
        
        for i in 0..<count {
            let indexPath = NSIndexPath.init(item: i, section: 0)
            
            attributes.append(layoutAttributesForItem(at: indexPath as IndexPath)!)
        }
        
        return attributes
    }
}
