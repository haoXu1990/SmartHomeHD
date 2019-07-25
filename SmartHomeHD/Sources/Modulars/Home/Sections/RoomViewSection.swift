//
//  RoomViewSection.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/25.
//  Copyright © 2019 FH. All rights reserved.
//

import RxDataSources
import UIKit
import Foundation

struct RoomViewSection {
    
    /// 设备列表
    var items: [Item]
}

extension RoomViewSection: SectionModelType {
    
    typealias Item = DeviceModel
    init(original: RoomViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
