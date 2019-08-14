//
//  AlarmModel.swift
//  SmartHomeHD
//
//  Created by XuHao on 2019/8/9.
//  Copyright © 2019 FH. All rights reserved.
//


import ObjectMapper

///  报警记录模型
struct AlarmModel: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        typeid <- map["typeid"]
        content <- map["content"]
        times <- map["times"]
        title <- map["title"]
        eqmsn <- map["eqmsn"]
        alarmid <- map["alarmid"]
        tmptimes <- map["tmptimes"]
        icon <- map["icon"]
    }
    
    /**
     typeid = "1";
     content = "大门门磁  打开";
     times = "20:48";
     title = "大门门磁";
     eqmsn = "5CCF7F1B9B63";
     alarmid = "3378244";
     tmptimes = "1565268530";
     icon = "http://sz.wisdudu.com/icon/notice/1@3x.png"
     */
    var typeid: String?
    var content: String?
    var times: String?
    var title: String?
    var eqmsn: String?
    var alarmid: String?
    var tmptimes: String?
    var icon: String?
    
}
