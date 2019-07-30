//
//  MMPhotoAssetController.m
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMPhotoAssetController.h"
#import "MMPhotoPreviewController.h"
#import "MMPhotoCropController.h"

#pragma mark - ################## MMPhotoAssetController
static NSString * const CellIdentifier = @"MMAssetCell";

@interface MMPhotoAssetController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray<PHAsset *> * assetArray;
@property (nonatomic, strong) NSMutableArray * selectedArray;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * previewBtn;
@property (nonatomic, strong) UIButton * originBtn;
@property (nonatomic, strong) UIButton * finishBtn;
@property (nonatomic, strong) UILabel * numberLab;

// 是否回传原图[可用于控制图片压系数]
@property (nonatomic, assign) BOOL isOrigin;

@end

@implementation MMPhotoAssetController

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isOrigin = NO;
        _cropOption = NO;
        _singleOption = NO;
        _showVideo = NO;
        _showOriginOption = NO;
        _maxNumber = 9;
        _maskImgName = @"mmphoto_overlay";
        _markedImgName = @"mmphoto_marked";
        _mainColor = kMainColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.photoAlbum.name;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction)];
    
    // 初始化
    _isOrigin = NO;
    if (_maxNumber == 0) {
        _maxNumber = 9;
    }
    [self.view addSubview:self.collectionView];
    if (!_cropOption && !_singleOption) {
        self.collectionView.height = self.view.height - kTopHeight - kTabHeight;
        // 是否显示原图选项
        _originBtn.hidden = !self.showOriginOption;
        [self.view addSubview:self.bottomView];
    }
    // 获取指定相册所有照片
    self.assetArray = [[NSMutableArray alloc] init];
    self.selectedArray = [[NSMutableArray alloc] init];
    
    PHFetchOptions * option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult * result = [PHAsset fetchAssetsInAssetCollection:self.photoAlbum.collection options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset * asset = (PHAsset *)obj;
        asset.selected = NO;
        if (!self.showVideo) { // 不显示视频
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [self.assetArray addObject:asset];
            }
        } else {
            [self.assetArray addObject:asset];
        }
    }];
}

// 更新UI
- (void)updateUI
{
    if (![self.selectedArray count]) {
        self.bottomView.alpha = 0.5;
        self.numberLab.hidden = YES;
        self.bottomView.userInteractionEnabled = NO;
    } else {
        self.bottomView.alpha = 1.0;
        self.numberLab.hidden = NO;
        self.numberLab.text = [NSString stringWithFormat:@"%d",(int)[self.selectedArray count]];
        self.bottomView.userInteractionEnabled = YES;
    }
}

#pragma mark - 事件处理
// 取消
- (void)rightBarItemAction
{
    if (self.completion) {
        self.completion(nil, _isOrigin, YES);
    }
}

// 确定|原图|预览
- (void)buttonAction:(UIButton *)btn
{
    if (btn.tag == 102) { // 确定选择
        if (!self.completion) {
            NSLog(@"警告:未设置block!!!");
            return;
        }
        NSInteger count = [self.selectedArray count];
        [self transformAsset:0 totalNum:count];
    } else if (btn.tag == 101) {  // 原图
        _isOrigin = !_isOrigin;
        _originBtn.selected = _isOrigin;
    } else {  // 预览
        MMPhotoPreviewController * controller = [[MMPhotoPreviewController alloc] init];
        controller.assetArray = self.selectedArray;
        [controller setAssetDeleteHandler:^(PHAsset *asset) {
            asset.selected = NO;
            [self.collectionView reloadData];
            [self updateUI];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// asset -> info
- (void)transformAsset:(NSInteger)assetIndex totalNum:(NSInteger)count
{
    PHAsset * asset = [self.selectedArray objectAtIndex:assetIndex];
    [MMPhotoUtil getInfoWithAsset:asset completion:^(NSDictionary *info) {
        // info替换asset
        [self.selectedArray replaceObjectAtIndex:assetIndex withObject:info];
        // 处理下一个
        if (assetIndex != count - 1) {
            [self transformAsset:assetIndex + 1 totalNum:count];
        } else { // 全部转换后回传
            self.completion(self.selectedArray, _isOrigin, NO);
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset * asset = [self.assetArray objectAtIndex:indexPath.row];
    MMAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.asset = asset;
    cell.maskImgName = self.maskImgName;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PHAsset * asset = [self.assetArray objectAtIndex:indexPath.row];
    // 图片裁剪(选择单个)
    if (_cropOption)
    {
        // 获取图片
        [MMPhotoUtil getInfoWithAsset:asset completion:^(NSDictionary *info) {
            MMPhotoCropController * controller = [[MMPhotoCropController alloc] init];
            controller.originalImage = [info objectForKey:MMPhotoOriginalImage];
            controller.cropSize = self.cropSize;
            [controller setImageCropBlock:^(UIImage *cropImage){
                if (!self.completion) {
                    NSLog(@"警告:未设置block!!!");
                    return;
                }
                // 更新为裁剪后的Image
                NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:info];
                [dictionary setObject:cropImage forKey:MMPhotoOriginalImage];
                self.completion(@[dictionary], _isOrigin, NO);
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        return;
    }
    
    // 选择一个-->直接返回
    if (_singleOption)
    {
        if (!self.completion) {
            NSLog(@"警告:未设置block!!!");
            return;
        }
        [MMPhotoUtil getInfoWithAsset:asset completion:^(NSDictionary *info) {
            self.completion(@[info], _isOrigin, NO);
        }];
        return;
    }
    
    // 提醒
    if (([self.selectedArray count] == _maxNumber) && !asset.selected) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多可以添加%ld张图片",(long)_maxNumber] message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    asset.selected = !asset.selected;
    [self.collectionView reloadData];
    
    if (asset.selected) {
        [self.selectedArray addObject:asset];
    } else {
        [self.selectedArray removeObject:asset];
    }
    [self updateUI];
}

#pragma mark - lazy load
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        NSInteger numInLine = (kIPhone6p || kIPhoneXM) ? 5 : 4;
        CGFloat itemWidth = (self.view.width - (numInLine + 1) * kMargin) / numInLine;
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        flowLayout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
        flowLayout.minimumLineSpacing = kMargin;
        flowLayout.minimumInteritemSpacing = 0.f;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - kTopHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[MMAssetCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, self.view.width, kTabHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.userInteractionEnabled = NO;
        _bottomView.alpha = 0.5;
        
        CGFloat btHeight = 50.0f;
        // 上边框
        CALayer * layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, _bottomView.width, 0.5);
        layer.backgroundColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor];
        [_bottomView.layer addSublayer:layer];
        // 预览
        _previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, btHeight)];
        _previewBtn.tag = 100;
        [_previewBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_previewBtn];
        // 原图
        _originBtn = [[UIButton alloc] initWithFrame:CGRectMake(_previewBtn.right+10, 0, 90, btHeight)];
        _originBtn.tag = 101;
        [_originBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_originBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_originBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_originBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_originBtn setImage:[UIImage imageNamed:@"mmphoto_mark"] forState:UIControlStateNormal];
        [_originBtn setImage:[UIImage imageNamed:_markedImgName] forState:UIControlStateSelected];
        [_originBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_originBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_originBtn];
        // 选取的数量
        _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-70, (btHeight-20)/2, 20, 20)];
        _numberLab.backgroundColor = _mainColor;
        _numberLab.layer.cornerRadius = _numberLab.frame.size.height/2;
        _numberLab.layer.masksToBounds = YES;
        _numberLab.textColor = [UIColor whiteColor];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = [UIFont boldSystemFontOfSize:13.0];
        _numberLab.adjustsFontSizeToFitWidth = YES;
        [_bottomView addSubview:_numberLab];
        _numberLab.hidden = YES;
        // 完成
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, 0, 60, btHeight)];
        _finishBtn.tag = 102;
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:_mainColor forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_finishBtn];
    }
    return _bottomView;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
 

#pragma mark - ################## MMAssetCell
@interface MMAssetCell ()

@property (nonatomic, strong) UIImageView * imageView; // 显示图片
@property (nonatomic, strong) UIImageView * overLay; // 显示已选择蒙版
@property (nonatomic, strong) UIImageView * videoOverLay; // 视频标识
@property (nonatomic, strong) UILabel * durationLabel; // 时长

@end

@implementation MMAssetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
        [self addSubview:_imageView];
        
        UIImage * image = [UIImage imageNamed:@"mmphoto_video_icon"];
        _videoOverLay = [[UIImageView alloc] initWithImage:image];
        _videoOverLay.origin = CGPointMake(8, _imageView.height - image.size.height - 5);
        [self addSubview:_videoOverLay];
        _videoOverLay.hidden = YES;
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_videoOverLay.right + 8, _videoOverLay.top, _imageView.width - (_videoOverLay.right + 16), _videoOverLay.height)];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont boldSystemFontOfSize:12.0];
        [self addSubview:_durationLabel];
        _durationLabel.hidden = YES;

        _overLay = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_overLay];
        _overLay.hidden = YES;
    }
    return self;
}

#pragma mark - setter
- (void)setMaskImgName:(NSString *)maskImgName
{
    self.overLay.image = [UIImage imageNamed:maskImgName];
}

- (void)setAsset:(PHAsset *)asset
{
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        self.videoOverLay.hidden = NO;
        self.durationLabel.hidden = NO;
        self.durationLabel.text = [MMPhotoUtil getDurationFormat:asset.duration];
    } else {
        self.videoOverLay.hidden = YES;
        self.durationLabel.hidden = YES;
        self.durationLabel.text = nil;
    }
    self.overLay.hidden = !asset.selected;
    [MMPhotoUtil getImageWithAsset:asset imageSize:self.imageView.size completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

@end
