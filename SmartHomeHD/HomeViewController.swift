//
//  HomeViewController.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/17.
//  Copyright © 2019 FH. All rights reserved.
//  首页控制器, 管理  房间、房子

import UIKit
import ReusableKit

class HomeViewController: UIViewController {

    var collectionView: UICollectionView!
    
    fileprivate var collectionViewFrame:CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    init(frame:CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        collectionViewFrame = frame
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = collectionViewFrame
    }
    func initUI()  {
        
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: collectionViewFrame.width, height: collectionViewFrame.height)
        
        collectionView = UICollectionView.init(frame:CGRect.init(x: 0, y: 0, width: collectionViewFrame.width, height: collectionViewFrame.height),collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        collectionView.register(Reusable.RoomControllerViewCell)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        view.backgroundColor = .black       
   
    }

}


extension HomeViewController:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(Reusable.RoomControllerViewCell, for: indexPath)
        
        return cell
    }
    
}


private enum Reusable {
   
    static let RoomControllerViewCell = ReusableCell<RoomControllerViewCell>.init(identifier: "RoomControllerViewCell", nib: nil)
}
