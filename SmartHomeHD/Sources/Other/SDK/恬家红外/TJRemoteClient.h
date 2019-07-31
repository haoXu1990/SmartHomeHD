//
//  TJRemoteClient.h
//  irdnasdk
//
//  Created by apple on 15/5/18.
//  Copyright (c) 2015年 tiqiqq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TJRemoteModel.h"
#import "TJWebErrorCode.h"

NS_ASSUME_NONNULL_BEGIN


/// 获取遥控器电器品牌Flag
typedef NS_ENUM(int, TJFetchRemoteBrandFlag) {
	/// 全部
	TJFetchRemoteBrandFlag_AllBrand = 0,
	/// 只获取有数据的品牌
	TJFetchRemoteBrandFlag_OnlyBrandHasRemote = 1,
	/// 只获取遥控器有型号的品牌
	TJFetchRemoteBrandFlag_OnlyBrandHasRemoteModel = 2,
};


@interface TJRemoteClient : NSObject

+ (instancetype)sharedClient;

/**
 [TJRemoteClient setAppKey:sdkKey length:sizeof(sdkKey)];
 */
+ (void)setAppKey:(const uint8_t*)key length:(size_t)length;

/**
 获取默认的匹配按键列表
 */
- (void)getMatchKey:(MachineType)applianceType callback:(void (^)(NSMutableArray<TJMatchKey *> *keys))onMatchKeyLoaded;

/**
 精确匹配遥控器（包括电源键）
 */
- (void)exactMatchRemote:(TJRemoteMatchPage *)page callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes))onMatchDone;

/**
 精确匹配遥控器
 @param matchPower 是否需要匹配电源键
 */
- (void)exactMatchRemote:(TJRemoteMatchPage *)page matchPower:(BOOL)matchPower callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes))onMatchDone;

/// 自动匹配遥控器
- (void)autoMatchRemote:(TJRemotePage *)page callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes))onAutoMatchDone;


/**
 搜索DIY遥控器
 */
- (void)searchDiy:(TJRemotePage *)page callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes))onSearchDone;

/**
 搜索官库遥控器
 */
- (void)searchOfficial:(TJRemotePage *)page callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes))onSearchDone;

/// 搜索空调遥控器
- (void)searchAirRemote:(TJRemotePage *)page callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes))onSearchDone;


/**
 下载遥控器
 */
- (void)downloadRemote:(NSString *)remoteId callback:(void (^)(TJWebErrorCode errcode, TJRemote *remote))onRemoteDownloaded;

/**
 获取空调虚拟机码
 @param remoteId 遥控器ID
 @param endian 设备运行endian，0为小端Little，1为大端Big
 @param version 空调虚拟机版本
 */
- (void)getAirVMCode:(NSString *)remoteId endian:(int)endian version:(int)version
			callback:(void (^)(TJWebErrorCode errcode, int protocol, NSData *data))callback;

/**
 加载品牌列表
 */
- (void)loadBrand:(void (^)(TJWebErrorCode errcode, NSMutableArray<TJBrand *> *brands))onBrandLoaded;

/**
 获取指定电器类型品牌
 中文（简体，繁体）按拼音升序排列
 其他语言按英文（或拼音）升序排列
 */
- (void)getBrandList:(MachineType)machineType callback:(void (^)(NSMutableArray<TJBrand *> *brands))onBrandLoaded;

/**
 同上，结果品牌名称包括关键词
 */
- (void)getBrandList:(MachineType)machineType keyword:(nullable NSString *)keyword callback:(void (^)(NSMutableArray<TJBrand *> *))onBrandLoaded;

/**
 获取指定电器类型品牌
 */
- (void)fetchBrandList:(MachineType)machineType flag:(TJFetchRemoteBrandFlag)flag callback:(void (^)(NSMutableArray<TJBrand *> *brands))onBrandLoaded;

/**
 同上，结果品牌名称包括关键词
 */
- (void)fetchBrandList:(MachineType)machineType flag:(TJFetchRemoteBrandFlag)flag keyword:(nullable NSString *)keyword callback:(void (^)(NSMutableArray<TJBrand *> *))onBrandLoaded;

/**
 反馈未找到的型号
 */
- (void)missModel:(MachineType)type brandId:(int64_t)brandId model:(NSString *)model;

/**
 信号匹配
 普通遥控器，无屏空调
 */
- (void)irMatch:(TJIrMatchPageInfo *)page callback:(void (^)(TJWebErrorCode errcode, int total, NSMutableArray<NSString *> *idList))onRemoteMatched;

/**
 有屏空调信号匹配
 无屏空调信号匹配（当成电源键）
 */
- (void)airIrMatch:(NSData *)data brandId:(int64_t)brandId callback:(void (^)(TJWebErrorCode errcode, NSMutableArray<NSString *> *idList))onRemoteMatched;

@end

NS_ASSUME_NONNULL_END
