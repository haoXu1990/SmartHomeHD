//
//  TJTvModel.h
//  tiqiaasdk
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 tiqiaa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJRemoteModel.h"

NS_ASSUME_NONNULL_BEGIN

enum {
	kTJTvEmptyProviderID = 0xffffff,
	kTJTvOttProviderID = 0xeeeeee,
	kTJTvCustomProviderID = -1,
};

/**
 运菅商 tb_tv_provider
 com.tiqiaa.tv.entity.TvProvider
 */
@interface TJTvProvider : TJIntIdModel
/// 名称
@property (nonatomic, strong) NSString *name;
/// 是否是自定义运营商
@property (nonatomic) bool custom;

@end


/**
 城市 tb_city
 com.tiqiaa.tv.entity.City
 */
@interface TJCity : TJIntIdModel
/// 城市ID
@property (nonatomic) int city_id;
/// 城市名称
@property (nonatomic, strong) NSString *city_name;
/// 所属省份ID
@property (nonatomic) int province_id;


/// 城市所有的电视节目运营商列表，延迟加载
@property (nonatomic, strong, nullable) NSMutableArray<TJTvProvider *> *providers;

@end


/**
 省份 tb_province
 com.tiqiaa.tv.entity.Province
 */
@interface TJProvince : TJIntIdModel
/// 省份ID
@property (nonatomic) int province_id;
/// 省份名称
@property (nonatomic, strong) NSString *province_name;


/// 城市列表，延迟加载
@property (nonatomic, strong, nullable) NSMutableArray<TJCity *> *cities;

@end


/**
 城市 - 运营商 tb_city_provider
 com.tiqiaa.tv.entity.CityProvider
 */
@interface TJCityProvider : TJIntIdModel
/// 城市ID
@property (nonatomic) int city_id;
/// 运营商ID
@property (nonatomic) int provider_id;

@end


/**
 推荐遥控器
 com.tiqiaa.tv.entity.CityProviderRemote
 */
@interface TJCityProviderRemote : TJStringIdModel
/// 遥控器名称
@property (nonatomic, strong) NSString *name;
/// 遥控器
@property (nonatomic) int times;

@end


NS_ASSUME_NONNULL_END
