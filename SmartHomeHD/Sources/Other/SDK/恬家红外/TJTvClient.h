//
//  TJTvClient.h
//  tiqiaasdk
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 tiqiaa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJWebErrorCode.h"
#import "TJTvModel.h"

@interface TJTvClient : NSObject

+ (instancetype)sharedClient;

/**
 加载全部省份信息（省份不包含城市列表）
 */
- (void)getAllProvince:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJProvince *> *provinces))onProvinceLoaded;

/**
 加载全部城市列表
 */
- (void)getAllCity:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJCity *> *cities))onCityLoaded;

/**
 获取省份下的城市
 */
- (void)getCityInProvince:(int)province_id callback:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJCity *> *cities))onCityLoaded;

/**
 加载全部运营商
 */
- (void)getAllProvider:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJTvProvider *> *providers))onProviderLoaded;

/**
 获取城市下大运营商
 */
- (void)getProviderInCity:(int)city_id callback:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJTvProvider *> *providers))onProviderLoaded;

/**
 加载城市 - 运营商关联数据
 */
- (void)loadCityProvider:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJCityProvider *> *cityProviders))onCityProviderLoaded;

/**
 获取运营商推荐遥控器
 */
- (void)loadProviderRemoteByCity:(int)city_id provider:(int)provider_id
						 callback:(void(^)(TJWebErrorCode errcode, NSMutableArray<TJCityProviderRemote *> *remotes))onLoaded;

@end
