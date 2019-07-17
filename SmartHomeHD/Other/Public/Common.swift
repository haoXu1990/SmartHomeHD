//
//  MainViewController.swift
//  RXSwiftXMLY
//
//  Created by XuHao on 2018/5/2.
//  Copyright © 2018年 XuHao. All rights reserved.
//

import UIKit

// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width

//适配iPhoneX
let isIPhoneX = (kScreenW == 375.0 && kScreenH == 812.0 ? true : false)
let kNavibarH: CGFloat = isIPhoneX ? 88.0 : 64.0
let kTabbarH: CGFloat = isIPhoneX ? 49.0 + 34.0 : 49.0
let kStatusbarH: CGFloat = isIPhoneX ? 44.0 : 20.0
let iPhoneXBottomH: CGFloat = 34.0
let iPhoneXTopH: CGFloat = 24.0

// MARK:- 常量
struct MetricGlobal {
    static let padding: CGFloat = 10.0
    static let margin: CGFloat = 10.0
}

// MARK:- 颜色方法
func kRGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat = 1.0) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

/// RGB
func RGB(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    
    return RGBA(r, g, b, 1.0)
}

/// RGBA
func RGBA(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

let BaiYueTitleColor:UIColor = RGB(74, 74, 74)
let BaiYueSubTitleColor:UIColor = RGB(153, 153, 153)


// MARK:- 自定义打印方法
func DLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
     #if DEBUG
        let fileName = (file as NSString).lastPathComponent
    
        print("\(fileName):(\(lineNum))-\(message)")
    #else
    #endif
}



