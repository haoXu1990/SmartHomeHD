//
//  TJRemoteModel.h
//  irdnasdk
//
//  Created by apple on 15/5/18.
//  Copyright (c) 2015年 tiqiqq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InfraredConstant.h"
#import "TJModel.h"

/// 特殊品牌id
enum {
	/// 全部
	TJBrand_ID_All = 0,
	/// 其他
	TJBrand_ID_Other = -1,
};

NS_ASSUME_NONNULL_BEGIN

/// SDK本地化字符串
#define TJSdkLocalizedString(key, comment)	NSLocalizedStringFromTable(key, @"tiqiaasdk", comment)

/**
 用户
 com.tiqiaa.remote.entity.User
 */
@interface TJUser : TJLongIdModel
/// 手机号
@property (nonatomic, strong, nullable) NSString *phone;
/// 邮件
@property (nonatomic, strong, nullable) NSString *email;
/// 密码
@property (nonatomic, strong, nullable) NSString *password;
/// 用户名
@property (nonatomic, strong) NSString *name;
/// 生日
@property (nonatomic, strong, nullable) NSString *birthday;
/// 性别
@property (nonatomic) UserSex sex;

@end


/**
 电气品牌
 com.tiqiaa.remote.entity.Brand
 */
@interface TJBrand : TJLongIdModel
/// 品牌中文名
@property (nonatomic, strong, nullable) NSString *brand_cn;
/// 品牌繁体名
@property (nonatomic, strong, nullable) NSString *brand_tw;
/// 品牌英文名
@property (nonatomic, strong, nullable) NSString *brand_en;
/// 品牌日文名
@property (nonatomic, strong, nullable) NSString *brand_ja;
/// 品牌其他语言名
@property (nonatomic, strong, nullable) NSString *brand_other;
/// 品牌全拼
@property (nonatomic, strong, nullable) NSString *pinyin;
/// 品牌首字母拼音
@property (nonatomic, strong, nullable) NSString *py;
/// 电器类型
@property (nonatomic, strong, nullable) NSString *remarks;

/// 本地化名称
- (NSString *)getLocaleName:(AppLanguage)lang;
/// 本地化名称
- (NSString *)localeName;

@end


/**
 红外信号
 com.tiqiaa.remote.entity.Infrared
 */
@interface TJInfrared : TJLongIdModel
/// 信号所属按键id
@property (nonatomic) int64_t key_id;
/// 按键类型
@property (nonatomic) IRKeyType key_type;
/// TJInfraredFunc
@property (nonatomic) int func;
/// 红外码值
@property (nonatomic, strong, nullable) NSData *data;
/// 频率
@property (nonatomic) int freq;
/// TJInfraredFuncMark
@property (nonatomic) int mark;
/// 信号标记
@property (nonatomic) int ir_mark;
@property (nonatomic) IrQuality quality;
/// 信号发送优先级
@property (nonatomic) int priority;

@end


/**
 按键位置
 com.tiqiaa.remote.entity
 */
@interface TJKeyPosition : TJLongIdModel
/// 坐标所属的key id*
@property (nonatomic) int64_t key_id;
/// 第几屏
@property (nonatomic) int screen_num;
/// 横竖屏: 1 水平
@property (nonatomic) int orientation;
/// 按钮大小
@property (nonatomic) int key_size;

/// Android 坐标的行
@property (nonatomic) int row DEPRECATED_MSG_ATTRIBUTE("used on Android, iOS use irow");
/// Android 坐标的列
@property (nonatomic) int column DEPRECATED_MSG_ATTRIBUTE("used on Android, iOS use icol");

/// iOS 坐标的行
@property (nonatomic) int irow;
/// iOS 坐标的列
@property (nonatomic) int icol;


@end


/**
 按键
 com.tiqiaa.remote.entity.Key
 */
@interface TJIrKey : TJLongIdModel
/// 按键名称
@property (nonatomic, strong, nullable) NSString *name;
/// 按键类型
@property (nonatomic) IRKeyType type;
/// 所属遥控器id
@property (nonatomic, strong) NSString *remote_id;
/// 按键协议
@property (nonatomic) int protocol;
/// 按键备注
@property (nonatomic, strong, nullable) NSString *remarks;

/// 信号列表，延迟加载
@property (nonatomic, strong, nullable) NSMutableArray<TJInfrared *> *infrareds;
/// 按键位置列表，延迟加载
@property (nonatomic, strong, nullable) NSMutableArray<TJKeyPosition *> *positions;

/// 布局按键 记忆键
+ (BOOL)isLayoutKey:(IRKeyType)keyType;
/// 自定义按键
+ (BOOL)isCustomKey:(IRKeyType)keyType;;

/// 布局按键 记忆键
- (BOOL)isLayoutKey;
/// 自定义按键
- (BOOL)isCustomKey;

/// 本地化名称
- (NSString *)localeName;

@end


/**
 根据按键类型,按键名称对按键列表升序排序
 [keys sortUsingFunction:funcSortIrKeysByKeyType context:nil];
 [keys sortedArrayUsingFunction:funcSortIrKeysByKeyType context:nil];
 */
static inline NSInteger funcSortIrKeysByKeyType(TJIrKey *key1, TJIrKey *key2, __unused void *context) {
	return key1.type - key2.type ?: [key1.localeName compare:key2.localeName];
}


/**
 遥控器
 com.tiqiaa.remote.entity.Remote
 */
@interface TJRemote : TJStringIdModel
/// 电器类型
@property (nonatomic) MachineType type;
/// 子类型
@property (nonatomic) MachineType sub_type;
/// 自定义的类型名
@property (nonatomic, strong, nullable) NSString *type_name;
/// 遥控器名称: 需要临时生成
@property (nonatomic, strong, nullable) NSString *name;
/// 遥控器名称拼音
@property (nonatomic, strong, nullable) NSString *pinyin;
/// 品牌id
@property (nonatomic) int64_t brand_id;
/// 遥控器型号
@property (nonatomic, strong) NSString *model;
/// 作者id
@property (nonatomic) int64_t author_id;
/// 模板id
@property (nonatomic) RemoteLayoutId layout_id;
/// app版本号
@property (nonatomic, strong) NSString *app_ver;
/// 设备类型
@property (nonatomic) int diy_device;
/// 系统语言
@property (nonatomic) AppLanguage lang;
/// 设备分辨率
@property (nonatomic, strong, nullable) NSString *dpi;
/// 创建时间
@property (nonatomic, strong) NSString *create_time;
/// 编辑者id
@property (nonatomic) int64_t modifier_id;
/// 最后编辑时间
@property (nonatomic, strong, nullable) NSString *modified_time;
/// 下载次数
@property (nonatomic) int download_count;
/// 好评次数
@property (nonatomic) int up_count;
/// 差评次数
@property (nonatomic) int down_count;
/// 删除
@property (nonatomic) bool deleted;
/// 备注信息
@property (nonatomic, strong, nullable) NSString *remarks;

/// 最后使用的时间
@property (nonatomic, strong) NSString *last_use_time;

/// 作者，延迟加载
@property (nonatomic, strong, nullable) TJUser *author;
/// 品牌，延迟加载
@property (nonatomic, strong, nullable) TJBrand *brand;
/// 按键列表，延迟加载
@property (nonatomic, strong, nullable) NSMutableArray<TJIrKey *> *keys;

/// 本地化电器类型名称
- (NSString *)localeTypeName;

/// 本地化名称
- (NSString *)localeName;

@end

typedef uint8_t air_state_buffer[12];

/**
 空调状态
 com.tiqiaa.remote.entity.AirRemoteState
 */
@interface TJAirRemoteState: TJModel
/// 遥控器ID
@property (nonatomic, strong) NSString *remote_id;
/// 风向
@property (nonatomic) AirWindMask wind_mask;
/// 协议
@property (nonatomic) int protocol;
/// 触发按键
@property (nonatomic) IRKeyType current_key;
///
@property (nonatomic) IRKeyType last_key;
/// 第几次点击按键
@property (nonatomic) int click_count;
/// 定时时间（分钟）
@property (nonatomic) int timer_value;

// 状态

/// 开/关
@property (nonatomic) AirPower power;
/// 模式
@property (nonatomic) AirMode mode;
/// 温度 16-31
@property (nonatomic) int temp;
/// 风量
@property (nonatomic) AirWindAmount wind_amount;

/// 风向
@property (nonatomic) AirWindDir wind_dir;
/// 水平风向
@property (nonatomic) AirWindHor wind_hor;
/// 垂直风向
@property (nonatomic) AirWindVer wind_ver;
/// 强力
@property (nonatomic) AirSuper super_mode;
/// 睡眠
@property (nonatomic) AirSleep sleep;
/// 干燥+辅热
@property (nonatomic) AirAidHot aid_hot;
/// 定时
@property (nonatomic) AirTimer timer;
/// 温度显示
@property (nonatomic) AirTempDisplay temp_disp;
/// 节能模式
@property (nonatomic) AirPowerSaving power_saving;
/// 负离子
@property (nonatomic) AirAnion anion;
/// 舒适
@property (nonatomic) AirComfort comfort;
/// 清新/换气
@property (nonatomic) AirFreshAir fresh_air;
/// 灯光
@property (nonatomic) AirLight light;
/// 加湿
@property (nonatomic) AirWet wet;
/// 静音
@property (nonatomic) AirMute mute;


/// 初始化
- (instancetype)initWithRemote:(TJRemote *)remote;

- (void)pack:(nonnull air_state_buffer)buf;

+ (nullable instancetype)unpack:(const _Nullable air_state_buffer)buf;

@end


/// 高级空调参数
@interface TJAdvancedAirRemoteParam : TJModel
/// 开/关 默认是开
@property (nonatomic) AirPower power;
/// 模式
@property (nonatomic) AirMode mode;
/// 温度 16-31
@property (nonatomic) int temp;
/// 风量
@property (nonatomic) AirWindAmount wind_amount;

/// 初始化 复制空调状态
- (instancetype)initWithAirRemoteState:(TJAirRemoteState *)state;

@end


/**
 信号特征
 com.tiqiaa.remote.entity.MatchPage.IRMark
 */
@interface TJIrMark : TJModel
/// 按键类型
@property (nonatomic) IRKeyType key_type;
/// 信号标记
@property (nonatomic) int ir_mark;

@end


/**
 匹配按键
 com.tiqiaa.remote.entity.MatchKey
 */
@interface TJMatchKey : TJIntIdModel
/// 电器类型
@property (nonatomic) MachineType appliance_type;
/// 按键类型
@property (nonatomic) IRKeyType key_type;
/// 匹配优先级
@property (nonatomic) int seq;

@end


/**
 精确匹配分页
 com.tiqiaa.remote.MatchPage
 */
@interface TJRemoteMatchPage : TJModel
/// 电器类型
@property(nonatomic) MachineType appliance_type;
/// 电器子类型
@property(nonatomic) MachineType appliance_sub_type;
/// 品牌id
@property(nonatomic) int64_t brand_id;
/// 按键
@property(nonatomic) IRKeyType next_key;
/// 语言
@property(nonatomic) AppLanguage lang;

/// 已匹配成功的信号标记, TJIrMark
@property(nonatomic, strong, nullable) NSMutableSet<TJIrMark *> *okMarks;
/// 已认定不成功的信号标记, TJIrMark
@property(nonatomic, strong, nullable) NSMutableSet<TJIrMark *> *wrongMarks;
/// 已匹配失败的按键, IRKeyType
@property(nonatomic, strong, nullable) NSMutableSet<NSNumber *> *failedKeys;

@end


/**
 自动匹配/搜索分页
 com.tiqiaa.remote.Page
 */
@interface TJRemotePage : TJModel
/// 电器类型
@property(nonatomic) MachineType appliance_type;
/// 电器子类型
@property(nonatomic) MachineType appliance_sub_type;
/// 品牌id
@property(nonatomic) int64_t brand_id;
/// 关键词
@property(nonatomic, strong, nullable) NSString *keyword;
/// 页码
@property(nonatomic) int page;
/// 语言
@property(nonatomic) AppLanguage lang;

@end


/**
 信号匹配 信号标记
 com.tiqiaa.remote.entity.IrMatchMark
*/
@interface TJIrMatchMark : TJModel
/// 按键类型
@property (nonatomic) IRKeyType key_type;
/// 学习信号
@property (nonatomic, strong) NSData *data;

@end


/**
 信号匹配信息
 com.tiqiaa.remote.entity.IrMatchPageInfo
*/
@interface TJIrMatchPageInfo : TJModel
/// 品牌
@property (nonatomic) int64_t brand_id;
/// 电器类型
@property (nonatomic) MachineType appliance_type;
/// 语言
@property (nonatomic) AppLanguage langue;
/// 信号标记
@property (nonatomic, strong) NSMutableSet<TJIrMatchMark *> *marks;

@end

NS_ASSUME_NONNULL_END
