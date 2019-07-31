//
//  TJDataManager.h
//  tiqiaasdk
//
//  Created by apple on 15/9/24.
//  Copyright © 2015年 tiqiaa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJRemoteModel.h"
#import "TJTvModel.h"
#import "TJSQLiteDatabase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 数据管理
 tiqiaasdk.db
 save*和delete* 方法全部是在事务中执行的
 */
@interface TJDataManager : NSObject

+ (instancetype)sharedManager;

/// 数据库
@property (nonatomic, strong, readonly, nullable) TJSQLiteDatabase *db;

/// 是否已关闭
@property (nonatomic, readonly) BOOL isClosed;

/**
 程序进入后台或不使用数据库时关闭数据库
 */
- (void)close;

/**
 打开数据库
 如果数据库不在Document目录下，则从bundle中复制到Document目录
 调用 [TJDatabaseManager sharedManager] 时自动调用此函数
 */
- (BOOL)open;

@end


/**
 品牌 tb_brand
 */
@interface TJDataManager (brand)

/// 获取品牌
- (nullable TJBrand *)getBrandById:(int64_t)brandId;

/// 获取全部品牌
- (NSMutableArray<TJBrand *> *)getAllBrand;

/// 保存brand
- (BOOL)saveBrand:(TJBrand *)brand;

/// 删除未使用的品牌
- (void)deleteUnusedBrand;

/// 保存品牌列表
- (BOOL)saveBrandList:(NSArray<TJBrand *> *)brandList;
- (BOOL)saveBrandList:(NSArray<TJBrand *> *)brandList ofType:(MachineType)machineType;

/**
 获取指定电器类型品牌
 中文（简体，繁体）按拼音升序排列
 其他语言按英文（或拼音）升序排列
 */
- (NSMutableArray<TJBrand *> *)getBrandList:(MachineType)machineType;

/**
 同上，结果品牌名称包括关键词
 */
- (NSMutableArray<TJBrand *> *)getBrandList:(MachineType)machineType keyword:(nullable NSString *)keyword;

/**
 通过ID列表（逗号分隔）获取品牌列表
 */
- (NSMutableArray<TJBrand *> *)getBrandListByIdList:(NSString *)idList keyword:(nullable NSString *)keyword;

/**
 品牌排序
 中文（简体，繁体）按拼音升序排列
 其他语言按英文（或拼音）升序排列
 */
- (void)sortBrandList:(NSMutableArray<TJBrand *> *)brandList;

/// 根据城市名称获取(机顶盒)品牌
- (nullable TJBrand *)getBrandByCityName:(NSString *)cityName;

@end


/**
 遥控器数据
 tb_remote 遥控器
 tb_key 遥控器按键
 tb_infrared 遥控器按键信号
 tb_key_position 遥控器按键位置
 */
@interface TJDataManager (remote)

/// 获取全部遥控器
- (NSMutableArray<TJRemote *> *)getAllRemote;

/// 获取指定类型全部遥控器
- (NSMutableArray<TJRemote *> *)getAllRemoteOfType:(MachineType)type;

/// 获取遥控器
- (nullable TJRemote *)getRemoteById:(NSString *)remoteId;

/// 保存遥控器及相关数据
- (BOOL)saveRemote:(TJRemote *)remote;

/// 保存遥控器列表
- (BOOL)saveRemoteList:(NSArray<TJRemote *> *)remoteList;

/// 删除遥控器及对应按键，信号和位置
- (BOOL)deleteRemoteById:(NSString *)remoteId;


/// 获取遥控器按键列表
- (NSMutableArray<TJIrKey *> *)getRemoteKeyList:(NSString *)remote_id;

/// 保存按键（不包括信号和位置列表）
- (BOOL)saveRemoteKey:(TJIrKey *)key;

/// 保存按键列表（不包括信号和位置列表）
- (BOOL)saveRemoteKeyList:(NSArray<TJIrKey *> *)keyList;

/// 删除按键及对应信号和位置
- (BOOL)deleteRemoteKeyById:(int64_t)keyId;

/// 获取按键信号列表
- (NSMutableArray<TJInfrared *> *)getKeyInfraredList:(int64_t)key_id;

/// 保存信号
- (BOOL)saveKeyInfrared:(TJInfrared *)ir;

/// 保存信号列表
- (BOOL)saveKeyInfraredList:(NSArray<TJInfrared *> *)irList;

/// 删除按键信号
- (BOOL)deleteKeyInfraredById:(int64_t)irId;

/// 获取按键坐标列表
- (NSMutableArray<TJKeyPosition *> *)getKeyPositionList:(int64_t)key_id;

/// 保存按键位置
- (BOOL)saveKeyPosition:(TJKeyPosition *)pos;

/// 保存按键位置列表
- (BOOL)saveKeyPositionList:(NSArray<TJKeyPosition *> *)posList;

/// 删除按键位置
- (BOOL)deleteKeyPositionById:(int64_t)posId;

/// 获取精确匹配按键
- (NSMutableArray<TJMatchKey *> *)getMatchKey:(MachineType)type;

/// 保存精确匹配按键
- (BOOL)saveMatchKeyList:(NSArray<TJMatchKey *> *)keyList;

@end


/**
 TV 基础信息
 tb_province 省份
 tb_city 城市
 tb_tv_provider 运营商
 tb_city_provider 城市 - 运营商
 */
@interface TJDataManager (tv_base)

/// 获取全部省份信息（不包括城市信息）
- (NSMutableArray<TJProvince *> *)getAllProvince;

/// 保存省份列表
- (BOOL)saveProvinceList:(NSArray<TJProvince *> *)provinceList;

/// 获取全部城市（不包括运营商）
- (NSMutableArray<TJCity *> *)getAllCity;

/// 获取省份下的城市列表
- (NSMutableArray<TJCity *> *)getCityInProvince:(int)province_id;

/// 根据省份名称获取省份信息，名称可以带后缀（如自动定位结果）
- (nullable TJProvince *)getProvinceByName:(NSString *)provinceName;

/// 根据城市名称获取城市信息，城市名称可以带后缀（如自动定位结果）
- (nullable TJCity *)getCityByName:(NSString *)cityName;

/// 保存城市列表
- (BOOL)saveCityList:(NSArray<TJCity *> *)cityList;

/// 获取全部运营商列表
- (NSMutableArray<TJTvProvider *> *)getAllProvider;

/// 获取城市下的运营商列表
- (NSMutableArray<TJTvProvider *> *)getProviderInCity:(int)city_id;

/// 保存运营商列表
- (BOOL)saveProviderList:(NSArray<TJTvProvider *> *)providerList;

/// 获取全部 城市-运营商 关系
- (NSMutableArray<TJCityProvider *> *)getAllCityProvider;

/// 保存 城市-运营商 关系列表
- (BOOL)saveCityProviderList:(NSArray<TJCityProvider *> *)cityProviderList;

@end

NS_ASSUME_NONNULL_END
