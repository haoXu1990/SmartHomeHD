# MMPhotoPicker

[![CocoaPods](http://img.shields.io/cocoapods/v/MMPhotoPicker.svg?style=flat)](http://cocoapods.org/pods/MMPhotoPicker)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208.0%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/MMPhotoPicker.svg?style=flat)](http://cocoapods.org/pods/MMPhotoPicker)&nbsp;
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ChellyLau/MMPhotoPicker/master/LICENSE)&nbsp;


`MMPhotoPicker`基于`Photos`框架，集成了视频、图片选择器（支持多选、单选、对图片进行裁剪、选择原图、视频图片预览）以及创建自定义相册，并保存视频、图片到自定义相册。基于`AssetsLibrary`框架的图片选择器，可以参考[MMImagePicker](https://github.com/ChellyLau/MMImagePicker)。


## Photos框架简述

![MMPhotoPicker](Photos.png)

## 属性

```objc
MMPhotoPickerController属性介绍：
   
// 说明：NOTE!!!
// 优先级 cropOption > singleOption > maxNumber
// cropOption = YES 时，不显示视频

// 是否回传原图 [可用于控制图片压系数]
@property (nonatomic, assign) BOOL isOrigin;
// 是否显示空相册 [默认NO]
@property (nonatomic, assign) BOOL showEmptyAlbum;
// 是否显示视频 [默认NO]
@property (nonatomic, assign) BOOL showVideo;
// 是否显示原图选项 [默认NO]
@property (nonatomic, assign) BOOL showOriginOption;
// 是否只选取一张 [默认NO]
@property (nonatomic, assign) BOOL singleOption;
// 是否选取一张且需要裁剪 [默认NO]
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
// 代理
@property (nonatomic, assign) id<MMPhotoPickerDelegate> delegate;

```

## 代理

```objc
@protocol MMPhotoPickerDelegate <NSObject>

@optional

/**
 info释义:
 返回的媒体数据是数组，数组单元为字典，字典中包含以下数据：

 资源类型 MMPhotoMediaType
 地理位置 MMPhotoLocation
 图片方向 MMPhotoOrientation
 原始图片 MMPhotoOriginalImage
 视频路径 MMPhotoVideoURL
 */
- (void)mmPhotoPickerController:(MMPhotoPickerController *)picker didFinishPickingMediaWithInfo:(NSArray<NSDictionary *> *)info;
- (void)mmPhotoPickerControllerDidCancel:(MMPhotoPickerController *)picker;

@end

```
  
## 使用

1. `pod "MMPhotoPicker"` ;
2. `pod install` / `pod update`;
3. `#import <MMPhotoPicker/MMPhotoPickerController.h>`.

```objc
MMPhotoPickerController * controller = [[MMPhotoPickerController alloc] init];
controller.delegate = self;
controller.showEmptyAlbum = YES;
controller.showVideo = YES;
controller.cropOption = NO;
controller.singleOption = NO;
controller.maxNumber = 6;
 
UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:controller];
[self.navigationController presentViewController:navigation animated:YES completion:nil];
```

```objc
#pragma mark - MMPhotoPickerDelegate
- (void)mmPhotoPickerController:(MMPhotoPickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
     NSLog(@"%@",info);
}

- (void)mmPhotoPickerControllerDidCancel:(MMPhotoPickerController *)picker
{
     NSLog(@"Cancel");
}
```

## 保存视频/图片到自定义相册

```objc
MMPhotoUtil类中：

// 保存图片
+ (void)saveImage:(UIImage *)image completion:(void(^)(BOOL success))completion;
// 保存视频
+ (void)saveVideo:(NSURL *)videoURL completion:(void(^)(BOOL success))completion;

```

## 注意

1. 需要在Info.plist中添加隐私授权：`Privacy - Photo Library Usage Description`；
2. 如果相册名称需要根据手机语言环境显示相应语言，需要在Info.plist中设置`Localized resources can be mixed` 为 `YES`。

## 效果图

![MMPhotoPicker](Screenshot.png)

## 后记

不定时更新，如有问题欢迎给我[留言](https://github.com/ChellyLau/MMPhotoPicker/issues)，我会及时回复。如果这个工具对你有一些帮助，请给我一个star，谢谢🌹🌹。



