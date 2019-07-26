//
//  DeviceModel.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/24.
//  Copyright © 2019 FH. All rights reserved.
//  设备模型

import Foundation
import ObjectMapper


/// 设备模型
struct DeviceModel: ModelType {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        actime <- map["actime"]
        barcode <- map["barcode"]
        boxsn <- map["boxsn"]
        channel <- map["channel"]
        controlsn <- map["controlsn"]
        eqmid <- map["eqmid"]
        eqmsn <- map["eqmsn"]
        houseid <- map["houseid"]
        icon <- map["icon"]
        is_reset <- map["is_reset"]
        ishw <- map["ishw"]
        maxchannel <- map["maxchannel"]
        orderby <- map["orderby"]
        ptype <- map["ptype"]
        remark <- map["remark"]
        rowcount <- map["rowcount"]
        rtitle <- map["rtitle"]
        status <- map["status"]
        title <- map["title"]
        typeid <- map["typeid"]
        usb <- map["usb"]
        userid <- map["userid"]
        venderid <- map["venderid"]
        visible <- map["visible"]
        roomid <- map["roomid"]
//        floor_id <- map["floor_id"]
    }
    
    
    enum Event {
        
    }
    
    var actime: Int?
    var barcode: String?
    var boxsn: String?
    var channel: String?
    var controlsn: String?
    var eqmid: String!
    var eqmsn: String!    
    var icon: String?
    var is_reset: Bool?
    var ishw: Bool?
    var maxchannel: Int?
    var orderby: Int?
    var ptype: String?
    var remark: String?
    var rowcount: String?
    var rtitle: String?
    var status: String?
    var title: String?
    var typeid: String?
    var usb: String?
    var userid: String?
    var venderid: String?
    var visible: String?
    
    var roomid: Int?
    
//    var floor_id: Int?
    
    var houseid: Int?
}
/// 楼层模型
struct FloorMoel: ModelType {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        floor_id <- map["floor_id"]
        title <- map["title"]
        houseid <- map["houseid"]
        imageurl <- map["imageurl"]
        createtime <- map["createtime"]
        userid <- map["userid"]
    }
    
    
    enum Event {
        
    }
    
    var floor_id: Int?
    var title: String?
    var houseid: Int?
    var imageurl: String?
    var createtime: Int?
    var userid: String!
    
}


/// 房间模型
struct RoomMoel: ModelType {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        roomid <- map["roomid"]
        houseid <- map["houseid"]
        floor_id <- map["floor_id"]
        userid <- map["userid"]
        title <- map["title"]
        imageurl <- map["channel"]
        groupid <- map["groupid"]
        desc <- map["desc"]
        updatetime <- map["controlsn"]
    }
    
    
    enum Event {
        
    }
    
    var roomid: Int?
    var houseid: Int?
    var floor_id: Int?
    var userid: String!
    var title: String?
    var imageurl: String?
    var groupid: String?
    var desc: String?
    var updatetime: UInt32?
}


/// 房间模型
struct HomeDeviceModel: ModelType {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        list <- map["list"]
        roomlist <- map["roomlist"]
        floorlist <- map["floorlist"]        
    }
    
    
    enum Event {
        
    }
    
    var list: [DeviceModel]?
    var roomlist: [RoomMoel]?
    var floorlist: [FloorMoel]?
  
}
