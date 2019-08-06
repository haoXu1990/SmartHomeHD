//
//  CircleAnimationBottomView.m
//  CircleAnimationUserInteractionDemo
//
//  Created by Amale on 16/2/29.
//  Copyright © 2016年 Amale. All rights reserved.
//  网上随便找得一个改得, 只适用于红外空调控制使用，并且没有做适配

#import "CircleAnimationBottomView.h"

#import "UIColor+Extensions.h"
#import "UIView+Extensions.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
static const CGFloat kMarkerRadius = 10.f; // 光标直径
static const CGFloat kAnimationTime = 0.5;


@interface CircleAnimationBottomView ()

@property (nonatomic, strong) CAShapeLayer *bottomLayer; // 进度条底色
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变进度条
@property (nonatomic, strong) UIImageView *markerImageView; // 光标
@property (nonatomic, strong) UIImageView *bgImageView; // 背景图片

@property (nonatomic, assign) CGFloat circelRadius; //圆直径
@property (nonatomic, assign) CGFloat lineWidth; // 弧线宽度
@property (nonatomic, assign) CGFloat stareAngle; // 开始角度
@property (nonatomic, assign) CGFloat endAngle; // 结束角度

@property (nonatomic, assign) CGFloat oldEndAngle; // 记录的旧的结束角度

@property (nonatomic, assign) CGFloat percent; // 百分比 0 - 100

@property (nonatomic, strong) UIImageView *typeImageView; // 模式图片


@end

@implementation CircleAnimationBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.image = [UIImage imageNamed:@"image_virtual_control_round"];
        self.circelRadius = self.frame.size.width - 10.f;
        self.lineWidth = 10.f;
        self.stareAngle = -195.0f;//-225.f;
        self.endAngle = 15.f;
        
        // 尺寸需根据图片进行调整
        self.bgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.bgImageView];
        
        CGFloat viewW = 60;
        CGFloat viewX = self.frame.size.width * 0.5 - viewW * 0.5;
        CGFloat viewY = self.frame.size.height * 0.5 - 25;
        
        
//        self.modelTypeLabel.bounds = CGRectMake(0, 0, 100, 30);
        self.modelTypeLabel.text = @"";
        self.modelTypeLabel.frame = CGRectMake(viewX, viewY, viewW, 30);
        
//        self.temperLabel.bounds = CGRectMake(0, 0, 100, 30);
        self.temperLabel.text = @"";
        self.temperLabel.frame = CGRectMake(viewX, viewY + 25, viewW, 30);
        [self addSubview:self.modelTypeLabel];
        [self addSubview:self.temperLabel];
//        self.commentLabel.frame = CGRectMake(self.center.x-self.circelRadius/4, self.center.y-self.circelRadius/6, self.circelRadius / 2, self.circelRadius / 3);
//
//        [self addSubview:self.commentLabel];
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    self.userInteractionEnabled = YES ;
    UIPanGestureRecognizer *tapGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [self addGestureRecognizer:tap];
    
    // 圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2)
                                                        radius:(self.circelRadius - self.lineWidth) / 3.5
                                                    startAngle:degreesToRadians(self.stareAngle)
                                                      endAngle:degreesToRadians(self.endAngle)
                                                     clockwise:YES];
    CGRect rect = self.bounds;
    
    // 底色
    self.bottomLayer = [CAShapeLayer layer];
//    self.bottomLayer.frame = rect;
//    self.bottomLayer.fillColor = [[UIColor clearColor] CGColor];
//    self.bottomLayer.strokeColor = [[UIColor  colorWithRed:206.f / 256.f green:241.f / 256.f blue:227.f alpha:1.f] CGColor];
//    self.bottomLayer.opacity = 0.5;
//    self.bottomLayer.lineCap = kCALineCapRound;
//    self.bottomLayer.lineWidth = self.lineWidth;
//    self.bottomLayer.path = [path CGPath];
//    [self.layer addSublayer:self.bottomLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = rect;
    self.progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    self.progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineWidth = self.lineWidth;
    self.progressLayer.path = [path CGPath];
    self.progressLayer.strokeEnd = 0;
    [self.bottomLayer setMask:self.progressLayer];
    
    
    
    
    
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = rect;
    [self.gradientLayer setColors:[NSArray arrayWithObjects:
                                   (id)[[UIColor colorWithHex:0xa3faff] CGColor],
                                   [(id)[UIColor colorWithHex:0x009cff] CGColor],
                                   (id)[[UIColor colorWithHex:0xffea00] CGColor],
                                   (id)[[UIColor colorWithHex:0xff1e00] CGColor],
                                   nil]];
    [self.gradientLayer setLocations:@[@0, @0.3, @0.6, @1]];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer setMask:self.progressLayer];
    [self.layer addSublayer:self.gradientLayer];
    
    
    // 240 是用整个弧度的角度之和 |-200| + 20 = 270
    [self createAnimationWithStartAngle:degreesToRadians(self.stareAngle)
                               endAngle:degreesToRadians(self.stareAngle + 270 * 0)];
    
    
}

#pragma mark - Animation

- (void)createAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle { // 光标动画
    
    //    // 设置动画属性
    //    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    pathAnimation.calculationMode = kCAAnimationPaced;
    //
    //    pathAnimation.fillMode = kCAFillModeForwards;
    //    pathAnimation.removedOnCompletion = NO;
    //    pathAnimation.duration = kAnimationTime;
    //    pathAnimation.repeatCount = 1;
    
    // 设置动画路径
    //    CGMutablePathRef path = CGPathCreateMutable();
    ////
    //    int a = 0 ;
    //
    //    if (self.oldEndAngle) {
    //
    //        if (startAngle>endAngle) {
    //
    //            a = 1 ;
    //
    //        }
    //
    //    }
    //
    //    CGPathAddArc(path, NULL, self.width / 2, self.height / 2, (self.circelRadius - kMarkerRadius / 2) / 2, startAngle, endAngle, a);
    //    pathAnimation.path = path;
    //    CGPathRelease(path);
    //
    //    self.markerImageView.frame = CGRectMake(-100, self.height, kMarkerRadius, kMarkerRadius);
    //    self.markerImageView.layer.cornerRadius = self.markerImageView.frame.size.height / 2;
    //    [self addSubview:self.markerImageView];
    //
    //
    //    [self.markerImageView.layer addAnimation:pathAnimation forKey:@"moveMarker"];
    //
    
    
}

- (void)circleAnimation { // 弧形动画
    
    //    [CATransaction begin];
    //    [CATransaction setDisableActions:NO];
    //    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    //    [CATransaction setAnimationDuration:0];
    //    self.progressLayer.strokeEnd = 0;
    //    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:kAnimationTime];
    self.progressLayer.strokeEnd = _percent / 100.0;
    [CATransaction commit];
    
    
}

#pragma mark - Setters / Getters

- (void)setPercent:(CGFloat)percent {
    
    
    
    [self setPercent:percent animated:YES];
    
    
}

- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {
    
    _percent = percent;
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(circleAnimation) userInfo:nil repeats:NO];
    
    if (!self.oldEndAngle) {
        
        
        [self createAnimationWithStartAngle:degreesToRadians(self.stareAngle)
                                   endAngle:degreesToRadians(self.stareAngle + 210 * percent / 100)];
    }else{
        [self createAnimationWithStartAngle:self.oldEndAngle
                                   endAngle:degreesToRadians(self.stareAngle + 210 * percent / 100)];
        
    }
    
    self.oldEndAngle = degreesToRadians(self.stareAngle + 210 * percent / 100) ;
    
}

- (void)setBgImage:(UIImage *)bgImage {
    
    _bgImage = bgImage;
    self.bgImageView.image = bgImage;
}

- (void)setText:(NSString *)text {
    
    _text = text;
    
//    self.commentLabel.text = text;
    
}

-(void)setTemperInter:(CGFloat)temperInter{
    
    
    if (temperInter>=16&& temperInter<=30) {
        
        _temperInter = temperInter;        
        self.percent = ((temperInter-16)/2/7)*100;
    }
    else {
        _temperInter = temperInter;
        self.percent = 0;
    }
    
}

-(void)setTypeImgName:(NSString *)typeImgName{
   
    if (typeImgName) {
        
         self.typeImageView.image = [UIImage imageNamed:typeImgName] ;
    }
    
}


- (UIImageView *)markerImageView {
    
    if (nil == _markerImageView) {
        _markerImageView = [[UIImageView alloc] init];
        _markerImageView.backgroundColor = [UIColor colorWithHex:0x20B2AA];
        _markerImageView.alpha = 0.7;
        _markerImageView.layer.shadowColor = [UIColor colorWithHex:0x20B2AA].CGColor;
        _markerImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _markerImageView.layer.shadowRadius = 3.f;
        _markerImageView.layer.shadowOpacity = 1;
    }
    return _markerImageView;
}

- (UIImageView *)bgImageView {
    
    if (nil == _bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        
        
        _bgImageView.userInteractionEnabled = NO ;
    }
    return _bgImageView;
}

-(UIImageView *)typeImageView{
    
    if (!_typeImageView) {
        
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.circelRadius/2-25, self.height-100, 50, 50)];
        
//        [self addSubview:_typeImageView];
        
        //_typeImageView.backgroundColor = [UIColor redColor];
    }
    
    return _typeImageView ;
}

- (UILabel *)modelTypeLabel {
//    #19E1EC
    if (nil == _modelTypeLabel) {
        _modelTypeLabel = [[UILabel alloc] init];
        _modelTypeLabel.font = [UIFont systemFontOfSize:18.f];
        _modelTypeLabel.textColor = [UIColor colorWithHex:0x19E1EC];
        _modelTypeLabel.textAlignment = NSTextAlignmentCenter;
        _modelTypeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _modelTypeLabel.numberOfLines = 0;
    }
    return _modelTypeLabel;
}
-(UILabel *)temperLabel {
    if (nil == _temperLabel) {
        _temperLabel = [[UILabel alloc] init];
        _temperLabel.font = [UIFont systemFontOfSize:16.f];
        _temperLabel.textColor = [UIColor colorWithHex:0x19E1EC];
        _temperLabel.textAlignment = NSTextAlignmentCenter;
        _temperLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _temperLabel.numberOfLines = 0;
    }
    return _temperLabel;
}
- (void)handlePanGesture:(UIGestureRecognizer *)recognizer{
    
    CGPoint point = [recognizer locationInView:self];
    
    CGFloat  tapfloat = [self angleFromStartToPoint:point];
    
    if (tapfloat>=degreesToRadians(75)&&tapfloat<=degreesToRadians(285)) {
        
        CGFloat floata = tapfloat-degreesToRadians(75) ;
        
        CGFloat floatb =  degreesToRadians(285)-degreesToRadians(75) ;
        
        
        
        NSLog(@"点击了正确范围 大概是多少的百分比 %f  %f  %f",floata,floatb,floata/floatb);
        
        NSString * choose = [self decimalwithFormat:@"0" floatV:floata/floatb*7];
        
        NSLog(@"选择得角度:%@, 重新计算后的 角度 %f",choose, [choose floatValue]/7*100);
        
        CGFloat tmp = [choose floatValue]/7*100;
        
        [self setPercent:tmp == 0 ? 1 : tmp];
        
//        [self setTemperInter:[choose floatValue]+16];
        
        //  1/12 为 18
//        [self ChooseWithPresent:floata/floatb];
        
        if (self.didTouchBlock) {
            
            NSInteger result = 16 + choose.intValue * 2;
            
            self.didTouchBlock(result);
        }
        
    }
    
    
}

//-(void)ChooseWithPresent:(CGFloat)persent{
//
//    float a   = persent*12;
//
//    NSString * choose = [self decimalwithFormat:@"0" floatV:a] ;
//
//    NSLog(@"**  %@",choose);
//
//    self.commentLabel.text = [NSString stringWithFormat:@"%d ℃",18+[choose intValue]];
//}

#pragma mark - 四舍五入
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (CGFloat)angleFromStartToPoint:(CGPoint)point{
    
    CGFloat angle = [self angleBetweenLinesWithLine1Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                 Line1End:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2 - 5)
                                               Line2Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                     
                                                 Line2End:point];
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)), point)) {
        
        //以上段为起点
        //angle = 2 * M_PI - angle;
        
        angle =  M_PI - angle;
        NSLog(@" angle = %f",angle);
    }else{
        
        angle =  M_PI + angle;
        NSLog(@"else  angle = %f",angle);
    }
    return angle;
}

//calculate angle between 2 lines
- (CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start
                                  Line1End:(CGPoint)line1End
                                Line2Start:(CGPoint)line2Start
                                  Line2End:(CGPoint)line2End{
    
//    NSLog(@"line1Start = %@, line1End = %@",line1Start, line1End);
//    NSLog(@"line2Start = %@, line2End = %@",line2Start, line2End);

    
   
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:line1Start];
//    [path addLineToPoint:line1End];
//
//    CAShapeLayer *line1Layer = [CAShapeLayer layer];
//    line1Layer.lineWidth = 3;
//    line1Layer.strokeColor = [UIColor yellowColor].CGColor;
//    line1Layer.path = path.CGPath;
//    line1Layer.fillColor = nil;
//    [self.layer addSublayer:line1Layer];
//
//
//
//
//    UIBezierPath *path1 = [UIBezierPath bezierPath];
//    [path1 moveToPoint:line2Start];
//    [path1 addLineToPoint:line2End];
//
//    CAShapeLayer *line2Layer = [CAShapeLayer layer];
//    line2Layer.lineWidth = 3;
//    line2Layer.strokeColor = [UIColor redColor].CGColor;
//    line2Layer.path = path1.CGPath;
//    line2Layer.fillColor = nil;
//    [self.layer addSublayer:line2Layer];
    
    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    return acos(((a * c) + (b * d)) / ((sqrt(a * a + b * b)) * (sqrt(c * c + d * d))));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
