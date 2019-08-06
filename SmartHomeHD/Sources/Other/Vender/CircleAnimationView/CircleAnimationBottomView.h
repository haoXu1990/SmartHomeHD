//
//  CircleAnimationBottomView.h
//  CircleAnimationUserInteractionDemo
//
//  Created by Amale on 16/2/29.
//  Copyright © 2016年 Amale. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CircleAnimationBottomView : UIView


@property(nonatomic,assign) CGFloat temperInter ;   //温度

@property (nonatomic, strong) UIImage *bgImage;     // 背景图片

@property (nonatomic, strong) NSString *text;       // 文字

@property (nonatomic, copy) NSString * typeImgName ;

@property (nonatomic, strong) UILabel *modelTypeLabel; // 模式
@property (nonatomic, strong) UILabel *temperLabel; // 温度


@property(nonatomic,copy) void (^didTouchBlock) (NSInteger temp);

@end
