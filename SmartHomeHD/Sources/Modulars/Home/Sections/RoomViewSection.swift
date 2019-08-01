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
    var items: [DeviceControllCellReactor]
}

extension RoomViewSection: SectionModelType {
    
//    typealias Item = DeviceModel
    init(original: RoomViewSection, items: [DeviceControllCellReactor]) {
        self = original
        self.items = items
    }
}
