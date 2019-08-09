//
//  HomeSectionReactor.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/1.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import SectionReactor

final class HomeSectionReactor: SectionReactor {
    
    enum SectionItem {
        case floorCell(FloorViewReactor)
    }
    
    enum Action {}
    
    enum Mutation {}
    
    struct State: SectionReactorState {
        var sectionItems: [SectionItem]
    }
    
    let initialState: State
    
    init(rooms:[RoomMoel], deviceListModel: [DeviceModel]) {
        defer { _ = self.state }
        
        var sectionItems: [SectionItem] = []
        
//        for i in rooms {
//
//            sectionItems.append(.floorCell(FloorViewReactor.init(floors: rooms, devicelist: deviceListModel)))
//        }


        self.initialState = State.init(sectionItems: sectionItems)
    }
    
    
}

