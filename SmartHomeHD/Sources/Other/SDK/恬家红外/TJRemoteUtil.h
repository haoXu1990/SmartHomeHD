//
//  TJRemoteUtil.h
//  TiqiaaSDK
//
//  Created by apple on 14-7-19.
//  Copyright (c) 2014年 TianJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJRemoteModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 红外信号
 */
@interface TJIrData : NSObject
@property (nonatomic) int freq;
@property (nonatomic) IrQuality quality;
@property (nonatomic, strong) NSData *data;

@end

@interface TJRemoteHelper : NSObject

+ (instancetype)sharedInstance;

#pragma mark - IrDnaSdkHelper

/// SDK信号转换，用于发送信号
+ (nullable NSData *)getIrCode:(int)freq data:(NSData *)data;

/// 学习信号转换，将学习到信号数据转换为SDK信号
+ (nullable TJIrData *)convertIrCode:(int)freq data:(NSData *)data;

/// 学习信号转换，将学习到信号数据转换为SDK信号
+ (nullable TJIrData *)buildIrCode:(int)freq pattern:(const int*)pattern length:(size_t)length;

/// App当前使用语言
+ (NSString *)deviceLanguage;
/// App当前使用语言
+ (AppLanguage)fetchCurrentLang;


#pragma mark - InfraredFetcher

/**
 * 获取普通遥控器按键信号
 * @param remote 遥控器
 * @param key 触发按键
 * @return 信号列表
 */
- (nullable NSArray<TJInfrared *> *)fetchRemoteInfrared:(TJRemote *)remote key:(TJIrKey *)key;

/**
 * 获取空调遥控器按键信号
 * @param remote 遥控器
 * @param key 触发按键
 * @param state 当前空调状态
 * @return 信号列表
 */
- (nullable NSArray<TJInfrared *> *)fetchAirRemoteInfrared:(TJRemote *)remote key:(TJIrKey *)key state:(TJAirRemoteState *)state;

/**
 * 获取空调遥控器定时按键信号
 * @param key 触发按键
 * @param state 当前空调状态
 * @return 信号列表
 */
- (nullable NSArray<TJInfrared *> *)fetchAirTimerInfrared:(TJIrKey *)key state:(TJAirRemoteState *)state time:(int)timerValue;

/**
 * 获取高级空调遥控器信号
 * @param remote 遥控器
 * @param state 当前空调状态
 * @param param 高级空调参数
 * @return 信号列表
 */
- (nullable NSArray<TJInfrared *> *)fetchAirRemoteInfrared:(TJRemote *)remote state:(TJAirRemoteState *)state param:(TJAdvancedAirRemoteParam *)param;

/**
 获取协议空调当前状态信号
 @param state 空调状态
 */
- (nullable NSArray<TJInfrared *> *)loadAirCodes:(TJAirRemoteState *)state;

/**
 * 获取遥控器测试按键信号（精确匹配、搜索、自动匹配、辅助匹配）
 * @param remote 遥控器
 * @param key 触发按键
 * @return 信号列表
 */
- (nullable NSArray<TJInfrared *> *)fetchRemoteTestInfrared:(TJRemote *)remote key:(TJIrKey *)key;

/**
 * 获取测试空调的状态
 * @param remoteId 遥控器ID
 * @return 空调状态
 */
- (nullable TJAirRemoteState *)fetchTestAirRemoteState:(NSString *)remoteId;

@end


@interface TJRemoteUtil : NSObject

+ (TJInfrared *)buildAirRemoteDefaultInfrared:(int64_t)key_id keyType:(IRKeyType)keyType;

/// 是否是组合状态空调遥控器
+ (BOOL)isMultiAirRemote:(TJRemote *)remote;
/// 是否是协议空调
+ (BOOL)isProtocolAirRemote:(TJRemote *)remote;
/// 是否是无屏空调
+ (BOOL)isNoScreenAirRemote:(TJRemote *)remote;

+ (BOOL)isAirRemoteHasScreen:(TJRemote *)remote;

/**
 本地化按键类型名称
 */
+ (NSString *)localeKeyTypeName:(IRKeyType)type;

/*!
 本地化电器类型名称
 @param type 电器类型
 @param subType 子类型
 @param layoutId 模板ID
 @param typeName 自定义电器类型名称
 */
+ (NSString *)localeMachineTypeName:(MachineType)type subType:(MachineType)subType layoutId:(RemoteLayoutId)layoutId typeName:(nullable NSString *)typeName;

/// 根据遥控器语言生成遥控器名称
+ (void)generateRemoteName:(TJRemote *)remote;

/*!
 电器类型 品牌备注中的简称
 */
+ (NSString *)getMachineTag:(MachineType)type;

/**
 过滤按键
 返回 标准键 + 自定义按键
 layoutKeys 为布局按键和宏键
 */
+ (NSMutableArray<TJIrKey *> *)filterKeys:(NSArray<TJIrKey *> *)keys layoutKeys:(nullable NSMutableArray<TJIrKey *> *)layoutKeys;

@end

NS_ASSUME_NONNULL_END
