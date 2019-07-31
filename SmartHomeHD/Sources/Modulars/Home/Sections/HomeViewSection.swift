//
//  HomeViewSection.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//

import RxDataSources
import UIKit
import Foundation

struct HomeViewSection {
    
    /// 楼层模型，
    var items: [Item]
    
    /// 房间模型
    var roomModels: [RoomMoel]
    
    /// 设备列表模型
    var deviceListModel: [DeviceModel]
    
//    var reactor: [HomeViewReactor]
}

extension HomeViewSection: SectionModelType {

    typealias Item = FloorMoel
    init(original: HomeViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
