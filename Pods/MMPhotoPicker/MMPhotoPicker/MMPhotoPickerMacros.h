//
//  MMPhotoPickerMacros.h
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UIView+Geometry.h"
#import "PHAsset+Category.h"
#import "MMPhotoUtil.h"


// iPhone6p
#define kIPhone6p               CGSizeEqualToSize(CGSizeMake(1242,2208), [[[UIScreen mainScreen] currentMode] size])
// iPhoneXS Max
#define kIPhoneXM               CGSizeEqualToSize(CGSizeMake(1242,2688), [[[UIScreen mainScreen] currentMode] size])

// iPhone X系列
#define k_iPhoneX               (kDeviceHeight >= 812.0f)
// 图片边距
#define kMargin                 4.0f
// 底部菜单高度
#define kTabHeight              (k_iPhoneX ? 84.0f : 50.0f)

// 顶部整体高度
#define kTopHeight              (kStatusHeight + kNavHeight)
// 状态栏高度
#define kStatusHeight           [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define kNavHeight              self.navigationController.navigationBar.height

// 屏幕高度
#define kDeviceHeight           [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define kDeviceWidth            [UIScreen mainScreen].bounds.size.width

// RGB颜色
#define RGBColor(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
// 主颜色
#define kMainColor              RGBColor(211.0, 58.0, 49.0, 1.0)
// 弱引用
#define WS(wSelf)               __weak typeof(self) wSelf = self

// 资源类型 PHAssetMediaType
#define MMPhotoMediaType        @"mediaType"
// 图片地理位置
#define MMPhotoLocation         @"location"
// 图片方向
#define MMPhotoOrientation      @"orientation"
// 原始图片
#define MMPhotoOriginalImage    @"originalImage"
// 视频路径
#define MMPhotoVideoURL         @"videoURL"
