#ifndef ICONTROL_CONST_H_
#define ICONTROL_CONST_H_

/// 性别
typedef NS_ENUM(int, UserSex) {
	/// 女性 Female
	UserSex_Female = 0,
	/// 男性 Male
    UserSex_Male = 1,

};

/**
 电气类型
 com.tiqiaa.constant.ApplianceType
 */
typedef NS_ENUM(int, MachineType) {
	/// 全部电器类型 未指定电器类型
	MachineType_All = 0,
	/// 电视
	MachineType_TV = 1,
	/// 空调
	MachineType_AirCond = 2,
	/// 风扇
	MachineType_Fan = 3,
	/// 投影仪
	MachineType_Projector = 4,
	/// 机顶盒
	MachineType_STB = 5,
	/// DVD/CD/VCR/DVP/DVR/VCS
	MachineType_DVD = 6,
	/// 单反相机/数码相机
	MachineType_Camera = 7,
	/// 红外开关
	MachineType_IRSwitch = 8,
	/// 功放/AVR/SSP
	MachineType_Amplifier = 9,
	/// IPTV
	MachineType_IPTV = 10,
    /// OTT Box
	MachineType_OTTBox = 11,
	/// 热水器
	MachineType_WaterHeater = 12,
	/// 空气净化器
	MachineType_AirCleaner = 13,
	/// 其他
	MachineType_Other = -1,


	// 子类型

	/// 有屏空调
	MachineSubType_AirWithScreen = 21,
	/// 无屏空调
	MachineSubType_AirWithoutScreen = 22,
	/// CD
	MachineSubType_CD = 61,
	/// VCD
	MachineSubType_VCD = 62,
	/// DVR
	MachineSubType_DVR = 63,
	/// AVR
	MachineSubType_AVR = 64,
	/// 单反
	MachineSubType_SLR = 71,
	/// 相机
	MachineSubType_Camera = 72,
	/// DV
	MachineSubType_DV = 73,
	/// 灯
	MachineSubType_Light = 74,
	/// 开关
	MachineSubType_Switch = 75,
};

/// 电气类型模版ID
typedef NS_ENUM(int, RemoteLayoutId) {
	/// 电视
	RemoteLayoutId_TV = 10,
	/// 电视节目
	RemoteLayoutId_TVProgram = 11,
	/// 有屏空调
	RemoteLayoutId_AirCond = 20,
	/// 无屏空调
	RemoteLayoutId_AirCondWithoutScreen = 21,
	/// 风扇
	RemoteLayoutId_Fan = 30,
	/// 投影仪
	RemoteLayoutId_Projector = 40,
	/// 机顶盒
	RemoteLayoutId_STB = 50,
	/// 机顶盒节目
	RemoteLayoutId_STBProgram = 51,
	/// DVD/CD/VCR/DVP/DVR/VCS
	RemoteLayoutId_DVD = 60,
	/// 单反相机
	RemoteLayoutId_SLR = 70,
	/// 数码相机
	RemoteLayoutId_Camera = 71,
	/// 红外开关
	RemoteLayoutId_IRSwitch = 80,
	/// 功放/AVR/SSP
	RemoteLayoutId_Amplifier = 90,
	/// IPTV
	RemoteLayoutId_IPTV = 100,
	/// OTT Box
	RemoteLayoutId_OTTBox = 110,
	/// 热水器
	RemoteLayoutId_WaterHeater = 120,
	/// 空气净化器
	RemoteLayoutId_AirCleaner = 130,
	/// 其他
	RemoteLayoutId_Other = 1,
};

/**
 语言
 com.tiqiaa.constant.Language
 */
typedef NS_ENUM(int, AppLanguage) {
	/// 简体中文
	AppLanguage_SimplifiedChinese = 0, // zh-Hans
	/// 繁体中文
	AppLanguage_TraditionalChinese = 1,// zh-Hant
	/// 英语
	AppLanguage_English = 2,	// en*
	/// 韩语
	AppLanguage_Korean = 3,		// ko
	/// 日语
	AppLanguage_Japanese = 4,	// ja
	/// 意大利语
	AppLanguage_Italian = 5,	// it
	/// 德语
	AppLanguage_German = 6,		// de/Deutsch
	/// 法语
	AppLanguage_French = 7,		// fr
	/// 其他语言
	AppLanguage_Other = -1
};

/// 信号质量
typedef NS_ENUM(int, IrQuality) {
	/// 不是红外信号
	IrQuality_Fatal = -1,
	/// 信号没问题
	IrQuality_OK = 0,
	/// 信号基本没问题
	IrQuality_Warning = 1,
	/// 信号有问题
	IrQuality_Error = 2
};

/// 信号功能类型
enum {
	/// 其他
	FunctionType_Other = -9999,
};

/// 按键协议
typedef NS_ENUM(int, IRKeyProtocol) {
	/// 正常按键
	IRKeyProtocol_Normal = 0,
	/// 空调协议按键 无信号
	IRKeyProtocol_Air = 1,
};

/**
 按键类型
 com.tiqiaa.constant.KeyType
 */
typedef NS_ENUM(int, IRKeyType) {
	// 数字键

	/// 数字键0
	IRKeyType_Key0 = 0,
	/// 数字键1
	IRKeyType_Key1 = 1,
	/// 数字键2
	IRKeyType_Key2 = 2,
	/// 数字键3
	IRKeyType_Key3 = 3,
	/// 数字键4
	IRKeyType_Key4 = 4,
	/// 数字键5
	IRKeyType_Key5 = 5,
	/// 数字键6
	IRKeyType_Key6 = 6,
	/// 数字键7
	IRKeyType_Key7 = 7,
	/// 数字键8
	IRKeyType_Key8 = 8,
	/// 数字键9
	IRKeyType_Key9 = 9,

	// 其他常用键

	/// 开关 待机 开机 关机
	IRKeyType_Power = 800,
	/// 信号选择 AV/TV
	IRKeyType_Signal = 801,
	/// 信息显示
	IRKeyType_Information = 802,
	/// 回看
	IRKeyType_Recall = 803,
	/// 静音
	IRKeyType_Mute = 804,
	/// 选台 -/—
	IRKeyType_Digital = 805,
	/// 返回
	IRKeyType_Back = 806,
	/// 频道加
	IRKeyType_ChannelUp = 807,
	/// 频道减
	IRKeyType_ChannelDown = 808,
	/// 音量加
	IRKeyType_VolUp = 809,
	/// 音量减
	IRKeyType_VolDown = 810,
	/// 温度加
	IRKeyType_TempUp = 811,
	/// 温度减
	IRKeyType_TempDown = 812,
	/// 放大 画面+
	IRKeyType_DZoomUp = 813,
	/// 缩小 画面-
	IRKeyType_DZoomDown = 814,
	/// 记忆键1
	IRKeyType_MemoryKey1 = 815,
	/// 记忆键2
	IRKeyType_MemoryKey2 = 816,
	/// 确定
	IRKeyType_MenuOk = 817,
	/// 上
	IRKeyType_MenuUp = 818,
	/// 下
	IRKeyType_MenuDown = 819,
	/// 左
	IRKeyType_MenuLeft = 820,
	/// 右
	IRKeyType_MenuRight = 821,
	/// 菜单
	IRKeyType_Menu = 822,
	/// 退出
	IRKeyType_MenuExit = 823,
	/// 快进
	IRKeyType_Forward = 824,
	/// 快退
	IRKeyType_Rewind = 825,
	/// 停/放
	IRKeyType_PlayPause = 826,
	/// 停止
	IRKeyType_Stop = 827,
	/// 上页
	IRKeyType_Previous = 828,
	/// 下页
	IRKeyType_Next = 829,
	/// 到顶
	IRKeyType_Top = 830,
	/// 到底
	IRKeyType_Bottom = 831,
	/// 模式
	IRKeyType_Mode = 832,
	/// 风量
	IRKeyType_WindAmount = 833,
	/// 水平风向
	IRKeyType_WindHorizontal = 834,
	/// 垂直风向
	IRKeyType_WindVertical = 835,
	/// 摇头
	IRKeyType_HeadShaking = 836,
	/// 风类
	IRKeyType_WindClass = 837,
	/// 风速
	IRKeyType_WindVelocity = 838,
	/// 开仓 开关仓
	IRKeyType_Open = 839,
	/// 标题
	IRKeyType_Title = 840,
	/// 加十
	IRKeyType_TenPlus = 841,
	/// 语言
	IRKeyType_Language = 842,
	/// 屏显
	IRKeyType_Screen = 843,
	/// 声道
	IRKeyType_SoundChannel = 844,
	/// 制式
	IRKeyType_Standard = 845,
	/// 字幕
	IRKeyType_Subtitles = 846,
	/// 双画面
	IRKeyType_DualScreen = 847,
	/// 画面冻结
	IRKeyType_Freeze = 848,
	/// 重置
	IRKeyType_Reset = 849,
	/// 视频
	IRKeyType_Video = 850,
	/// 慢放
	IRKeyType_StepSlow = 851,
	/// 主键
	IRKeyType_Shutter1 = 852,
	/// 副键
	IRKeyType_Shutter2 = 853,

	/// 连续上
	IRKeyType_ContinuousUp = 854,
	/// 连续下
	IRKeyType_ContinuousDown = 855,
	/// 连续右
	IRKeyType_ContinuousRight = 856,
	/// 连续左
	IRKeyType_ContinuousLeft = 857,

	//新增的空调按键

	/// 风向
	IRKeyType_AirWindDir = 870,
	/// 灯光
	IRKeyType_AirLight = 871,
	/// 超强
	IRKeyType_AirSuper = 872,
	/// 睡眠
	IRKeyType_AirSleep = 873,
	/// 清新/换气
	IRKeyType_AirFreshAir = 874,
	/// 辅热
	IRKeyType_AirAidHot = 875,
	/// 定时
	IRKeyType_AirTimer = 876,
	/// 加湿
	IRKeyType_AirWet = 877,
	/// 负离子
	IRKeyType_AirAnion = 878,
	/// 节能
	IRKeyType_AirPowerSaving = 879,
	/// 舒适
	IRKeyType_AirComfort = 880,
	/// 温度显示
	IRKeyType_AirTempDisplay = 881,
	/// 一键冷
	IRKeyType_QuickCool = 882,
	/// 一键热
	IRKeyType_QuickHot = 883,

	//新增的投影仪 风扇 IPTV遥控器按键

	/// 自动
	IRKeyType_Auto = 900,
	/// 信号
	IRKeyType_PjtSignal = 901,
	/// 亮度
	IRKeyType_Brightness = 902,
	/// 电脑
	IRKeyType_PjtPC = 903,

	/// 冷风
	IRKeyType_CoolWind = 1000,
	/// 首页
	IRKeyType_Home = 1010,
	/// 设置
	IRKeyType_Settings = 1011,
    /// DVD Topup Menu
	IRKeyType_PopMenu = 1012,
    /// DVD Top Menu
	IRKeyType_TopMenu = 1013,
	/// 电源2
	IRKeyType_Power2 = 1800,

	// 热水器 净化器

	/// 中温保温
	IRKeyType_KeepWarm = 1020,
	/// 预约洗浴
	IRKeyType_OrderBath = 1021,
	/// 确认
	IRKeyType_Comfirm = 1022,

	/// 点
	IRKeyType_Dot = 1023,
	/// 连字符 - Dash
	IRKeyType_Hyphen = 1024,
	/// 电源开
	IRKeyType_PowerOn = 1025,
	/// 电源关
	IRKeyType_PowerOff = 1026,
	/// 播放
	IRKeyType_Play = 1027,
	/// 暂停
	IRKeyType_Pause = 1028,

	// UI布局按键

	/// 收藏
	IRKeyType_Favorite = 2001,
	/// 数字
	IRKeyType_Number = 2002,
	/// 自定义/扩展
	IRKeyType_Custom = 2003,

	// 自定义键

	/// 自定义(圆形)
	IRKeyType_BaseRound = -100,
	/// 自定义(椭圆)
	IRKeyType_BaseOval = -99,
	/// 自定义(正方)
	IRKeyType_BaseSquare = -98,
	/// 自定义(红)
	IRKeyType_BaseOvalRed = -97,
	/// 自定义(橙)
	IRKeyType_BaseOvalOrange = -96,
	/// 自定义(黄)
	IRKeyType_BaseOvalYellow = -95,
	/// 自定义(绿)
	IRKeyType_BaseOvalGreen = -94,
	/// 自定义(蓝)
	IRKeyType_BaseOvalBlue = -93,
	/// 自定义(青)
	IRKeyType_BaseOvalCyan = -92,
	/// 自定义(紫)
	IRKeyType_BaseOvalPurple = -91,
	/// 记忆键
	IRKeyType_MemoryKey = -90,
    
    /// 自定义的，空调温度设置按键
    IRKeyType_TempSet = 8888
};

/// 默认分页大小
enum {
    /// 搜索遥控器默认分页大小
    SearchDefaultPageSize = 30,
    /// 自动匹配默认分页大小
    MatchDefaultPageSize = 30,
};

#endif // ICONTROL_CONST_H_

