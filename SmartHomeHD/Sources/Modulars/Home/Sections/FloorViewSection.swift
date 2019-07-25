//
//  FloorViewSection.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/25.
//  Copyright © 2019 FH. All rights reserved.
//
import RxDataSources
import UIKit
import Foundation

struct FloorViewSection {
    
    /// 房间模型
    var items: [Item]
    
    /// 所有设备列表
    var deviceListModel: [DeviceModel]
}

extension FloorViewSection: SectionModelType {
    
    typealias Item = RoomMoel
    init(original: FloorViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
