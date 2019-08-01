//
//  DeviceControllSection.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/1.
//  Copyright © 2019 FH. All rights reserved.
//

import RxDataSources
import UIKit
import Foundation

struct DeviceControllSection {
    
    /// 设备列表
    var items: [DeviceControllCellReactor]
}

extension DeviceControllSection: SectionModelType {
    
    //    typealias Item = DeviceModel
    init(original: DeviceControllSection, items: [DeviceControllCellReactor]) {
        self = original
        self.items = items
    }
}
