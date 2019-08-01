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


//struct HomeViewSection {
//
//    /// 楼层模型，Section 中 cell 得模型数据
//    var items: [HomeViewSectionItem]
//
//}
//
//enum HomeViewSectionItem {
//    case floor(HomeSectionReactor.SectionItem)
//}
//
//extension HomeViewSection: SectionModelType {
//
//    init(original: HomeViewSection, items: [HomeViewSectionItem]) {
//        self = original
//        self.items = items
//    }
//}



struct HomeViewSection {

    /// 楼层模型，Section 中 cell 得模型数据
    var items: [FloorViewReactor]

//    /// 房间模型, 服务器返回的是在一起得
//    var roomModels: [RoomMoel]
//
//    /// 设备列表模型, 服务器返回的是在一起得
//    var deviceListModel: [DeviceModel]
}

extension HomeViewSection: SectionModelType {

//    typealias Item = FloorViewReactor
    init(original: HomeViewSection, items: [FloorViewReactor]) {
        self = original
        self.items = items
    }
}
