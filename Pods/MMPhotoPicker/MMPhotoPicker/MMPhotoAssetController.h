//
//  MMPhotoAssetController.h
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  选择任一相册展示
//

#import <UIKit/UIKit.h>
#import "MMPhotoPickerController.h"

#pragma mark - ################## MMPhotoAssetController
@interface MMPhotoAssetController : UIViewController

// 说明：NOTE!!!
// 优先级 cropOption > singleOption > maxNumber
// cropOption = YES 时，不显示视频

// 所选相册
@property (nonatomic, strong) MMPhotoAlbum * photoAlbum;
// 是否显示视频 [默认NO]
@property (nonatomic, assign) BOOL showVideo;
// 是否显示原图选项[默认NO]
@property (nonatomic, assign) BOOL showOriginOption;
// 只选取一张[默认NO]
@property (nonatomic, assign) BOOL singleOption;
// 是否选取一张且需要裁剪[默认NO]
@property (nonatomic, assign) BOOL cropOption;
// 裁剪的大小[默认方形、屏幕宽度]
@property (nonatomic, assign) CGSize cropSize;
// 最大选择数目[默认9张、如果显示视频，也包括视频数量]
@property (nonatomic, assign) NSInteger maxNumber;

// 主色调[默认红色]
@property (nonatomic, strong) UIColor * mainColor;
// 选中的遮罩图片名称[默认为本控件内图片]
@property (nonatomic, copy) NSString * maskImgName;
// 原图选项选中图片名称[默认为本控件内图片]
@property (nonatomic, copy) NSString * markedImgName;

// 选择回传[isOrigin:是否回传原图[可用于控制图片压系数]]
@property (nonatomic, copy) void(^completion)(NSArray * info,BOOL isOrigin, BOOL isCancel);

@end

#pragma mark - ################## MMAssetCell

@interface MMAssetCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, copy) NSString * maskImgName;

@end
