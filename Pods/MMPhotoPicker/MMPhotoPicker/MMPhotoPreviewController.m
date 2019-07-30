//
//  MMPhotoPreviewController.m
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMPhotoPreviewController.h"
#import "MMPhotoPickerMacros.h"

@interface MMPhotoPreviewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) NSMutableArray * playerArray;
@property (nonatomic, strong) MMAVPlayer * curPlayer;
@property (nonatomic, strong) UIImageView * videoOverLay;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) id timeObserver;

@end

@implementation MMPhotoPreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.isHidden = NO;
    [self configUI];
    [self configAsset];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - 设置UI
- (void)configUI
{
    // 滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_scrollView];

    CGFloat top = kStatusHeight;
    CGFloat topH = kTopHeight;
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, topH)];
    _titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:_titleView];
    
    // 返回按钮
    UIImage * image = [UIImage imageNamed:@"mmphoto_back"];
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, top, kNavHeight, kNavHeight)];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake((kNavHeight-image.size.height)/2, 0, (kNavHeight-image.size.height)/2, 0)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:backBtn];
    
    // 顺序Label
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake((_titleView.width-200)/2, top, 200, kNavHeight)];
    _titleLab.font = [UIFont boldSystemFontOfSize:19.0];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.text = [NSString stringWithFormat:@"1/%d",(int)[self.assetArray count]];
    [_titleView addSubview:_titleLab];
    
    // 删除按钮
    image = [UIImage imageNamed:@"mmphoto_delete"];
    UIButton * delBtn = [[UIButton alloc]initWithFrame:CGRectMake(_titleView.width-kNavHeight, top, kNavHeight, kNavHeight)];
    [delBtn setImage:image forState:UIControlStateNormal];
    [delBtn setImageEdgeInsets:UIEdgeInsetsMake((kNavHeight-image.size.height)/2, 0, (kNavHeight-image.size.height)/2, 0)];
    [delBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:delBtn];
    
    // 双击
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCallback:)];
    doubleTap.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:doubleTap];
   
    // 单击
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [_scrollView addGestureRecognizer:singleTap];
}

#pragma mark - 手势处理
- (void)doubleTapGestureCallback:(UITapGestureRecognizer *)gesture
{
    [self resetIndex];
    UIScrollView *scrollView = [_scrollView viewWithTag:100+_index];
    CGFloat zoomScale = scrollView.zoomScale;
    if (zoomScale == scrollView.maximumZoomScale) {
        zoomScale = 0;
    } else {
        zoomScale = scrollView.maximumZoomScale;
    }
    [UIView animateWithDuration:0.35 animations:^{
        scrollView.zoomScale = zoomScale;
    }];
}

- (void)singleTapGestureCallback:(UITapGestureRecognizer *)gesture
{
    if (self.curPlayer) { // 控制播放
        BOOL isPlaying = self.curPlayer.isPlaying;
        [self avplayControl:isPlaying];
        if (!isPlaying) { // 暂停 -> 播放
            // 监听播放进度
            WS(wSelf);
            _timeObserver = [self.curPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                if (time.value == self.curPlayer.duration.value) { // 播放完成
                    [wSelf avplayControl:YES]; // 暂停
                    [wSelf.curPlayer seekToTime:kCMTimeZero];
                    if (wSelf.timeObserver) {
                        [wSelf.curPlayer removeTimeObserver:wSelf.timeObserver];
                        wSelf.timeObserver = nil;
                    }
                    [UIView animateWithDuration:0.5 animations:^{
                        wSelf.titleView.hidden = wSelf.isHidden;
                    }];
                }
            }];
        }
    } else {
        self.isHidden = !self.isHidden;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.titleView.hidden = self.isHidden;
    }];
}

- (void)avplayControl:(BOOL)isPlaying
{
    if (isPlaying) { // 播放 -> 暂停
        [self.curPlayer pause];
        self.curPlayer.isPlaying = NO;
        self.videoOverLay.hidden = NO;
        self.isHidden = NO;
    } else { // 暂停 -> 播放
        [self.curPlayer play];
        self.curPlayer.isPlaying = YES;
        self.videoOverLay.hidden = YES;
        self.isHidden = YES;
    }
}

#pragma mark - 删除处理
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteAction
{
    // 移除视图
    PHAsset * asset = [self.assetArray objectAtIndex:_index];
    [self deleteAsset];
    [self.assetArray removeObjectAtIndex:_index];
    [self.playerArray removeObjectAtIndex:_index];
    // 更新索引
    [self resetIndex];
    _titleLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)_index+1,(long)[self.assetArray count]];
    // block
    if (self.assetDeleteHandler) {
        self.assetDeleteHandler(asset);
    }
    // 返回
    if (![self.assetArray count]) {
        [self backAction];
    }
}

#pragma mark - 图像加载|移除
- (void)configAsset
{
    NSInteger count = [self.assetArray count];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width * count, _scrollView.height)];
    self.curPlayer = nil;
    self.playerArray = [[NSMutableArray alloc] initWithCapacity:count];
    // 添加图片|视频
    [self loadAsset:0 totalNum:count];
}

- (void)loadAsset:(NSInteger)assetIndex totalNum:(NSInteger)count
{
    PHAsset * asset = [self.assetArray objectAtIndex:assetIndex];
    // asset --> 图片|视频
    [MMPhotoUtil getInfoWithAsset:asset completion:^(NSDictionary *info) {
        
        GCD_MAIN(^{   // 主线程
            
            // 用于图片的捏合缩放
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_scrollView.width * assetIndex, 0, _scrollView.width, _scrollView.height)];
            scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height);
            scrollView.minimumZoomScale = 1.0;
            scrollView.delegate = self;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.tag = 100 + assetIndex;
            
            // == 图片
            if (asset.mediaType == PHAssetMediaTypeImage)
            {
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
                imageView.image = [info objectForKey:MMPhotoOriginalImage];
                imageView.clipsToBounds  = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.tag = 1000;
                [scrollView addSubview:imageView];
                
                CGSize imgSize = [imageView.image size];
                CGFloat scaleX = self.view.width/imgSize.width;
                CGFloat scaleY = self.view.height/imgSize.height;
                if (scaleX > scaleY) {
                    CGFloat imgViewWidth = imgSize.width * scaleY;
                    scrollView.maximumZoomScale = self.view.width/imgViewWidth;
                } else {
                    CGFloat imgViewHeight = imgSize.height * scaleX;
                    scrollView.maximumZoomScale = self.view.height/imgViewHeight;
                }
                [self.playerArray addObject:@"占位"];
            }
            else // == 视频
            {
                NSURL * videoURL = [info objectForKey:MMPhotoVideoURL];
                AVPlayerItem * playerItem  = [[AVPlayerItem alloc] initWithURL:videoURL];
                MMAVPlayer * player = [[MMAVPlayer alloc] initWithPlayerItem:playerItem];
                player.isPlaying = NO;
                player.duration = playerItem.asset.duration;
                AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
                playerLayer.frame = scrollView.bounds;
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [scrollView.layer addSublayer:playerLayer];
                
                UIImageView * videoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmphoto_video"]];
                videoImgV.tag = 2000;
                videoImgV.center = CGPointMake(scrollView.width/2.0, scrollView.height/2.0);
                [scrollView addSubview:videoImgV];
                scrollView.maximumZoomScale = 1.0; // 不可缩放
                [self.playerArray addObject:player];
                
                if (assetIndex == 0) {
                    self.curPlayer = player;
                    self.videoOverLay = videoImgV;
                }
            }
            [_scrollView addSubview:scrollView];
            // 处理下一个
            if (assetIndex != count - 1) {
                [self loadAsset:assetIndex + 1 totalNum:count];
            }
        });
    }];
}

- (void)deleteAsset
{
    // 移除当前视图
    NSInteger tag = 100 + _index;
    UIScrollView * scrollView = [_scrollView viewWithTag:tag];
    [scrollView removeFromSuperview];
    // 更新后面视图的Frame和TAG(箭头内的执行过程)
    // ↓↓↓
    NSInteger count = [self.assetArray count];
    UIScrollView * sv = nil;
    // 记录上一个的信息
    CGRect setRect = scrollView.frame;
    NSInteger setTag = tag;
    // 临时数据存储变量
    CGRect tempRect;
    NSInteger tempTag;
    for (NSInteger i = 1; i < count-_index; i ++) {
        tag ++;
        sv = [_scrollView viewWithTag:tag];
        // 临时存储
        tempRect = sv.frame;
        tempTag = sv.tag;
        // 将上一个数据赋值给sv
        sv.frame = setRect;
        sv.tag = setTag;
        // 将临时存储赋值
        setRect = tempRect;
        setTag = tempTag;
    }
    // ↑↑↑
    // 更新主滚动视图
    [_scrollView setContentSize:CGSizeMake(_scrollView.width * (count-1), _scrollView.height)];
}

- (void)resetIndex
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    _index = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:1000];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetIndex];
    _titleLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)_index + 1,(long)[self.assetArray count]];

    // 将上一个暂停，记录当前
    if (self.curPlayer) {
        [self.curPlayer pause];
        [self.curPlayer seekToTime:kCMTimeZero];
        if (self.timeObserver) {
            [self.curPlayer removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }
        self.videoOverLay.hidden = NO;
    }
    NSObject * obj = [self.playerArray objectAtIndex:_index];
    if ([obj isKindOfClass:[MMAVPlayer class]]) {
        UIScrollView * scrollView = [_scrollView viewWithTag:100+_index];
        self.videoOverLay = [scrollView viewWithTag:2000];
        self.videoOverLay.hidden = NO;
        self.curPlayer = (MMAVPlayer *)obj;
        self.curPlayer.isPlaying = NO;
    } else {
        self.curPlayer = nil;
        self.videoOverLay = nil;
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@implementation MMAVPlayer

@end
