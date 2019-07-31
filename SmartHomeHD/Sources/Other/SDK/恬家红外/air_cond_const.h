
/// 空调温度最低16摄氏度
#define kMinAirTemperature	16
/// 空调温度最高31摄氏度
#define kMaxAirTemperature	31

/// 空调风向键
typedef NS_OPTIONS(int, AirWindMask) {
	AirWindMask_None = 0,
	/// 风向键 IRKeyType_AirWindDir
	AirWindMask_Dir = (1 << 0),
	/// 水平/左右扫风键 IRKeyType_WindHorizontal
	AirWindMask_Hor = (1 << 1),
	/// 上下/垂直扫风键 IRKeyType_WindVertical
	AirWindMask_Ver = (1 << 2),
};

/// 空调开关状态
typedef NS_ENUM(int, AirPower) {
	AirPower_Off = 0,
	AirPower_On = 1,
	/// Power Work 空调
	AirPower_Work = 2,
};
/// 空调模式
typedef NS_ENUM(int, AirMode) {
	/// 自动
	AirMode_Auto = 0,
	/// 送风
	AirMode_Wind = 1,
	/// 抽湿
	AirMode_Dry = 2,
	/// 取暖
	AirMode_Hot = 3,
	/// 制冷
	AirMode_Cool = 4,
};
/// 风量
typedef NS_ENUM(int, AirWindAmount) {
	/// 风量1
	AirWindAmount_Level1 = 0,
	/// 风量2
	AirWindAmount_Level2 = 1,
	/// 风量3
	AirWindAmount_Level3 = 2,
	/// 风量4
	AirWindAmount_Level4 = 3,
	/// 自动
	AirWindAmount_Auto = 4,
};
/// 风向
typedef NS_ENUM(int, AirWindDir) {
	/// 自动
	AirWindDir_Auto = 0,
	/// 上
	AirWindDir_Up = 1,
	/// 中
	AirWindDir_Mid = 2,
	/// 下
	AirWindDir_Down = 3,
};
/// 水平风向/左右扫风
typedef NS_ENUM(int, AirWindHor) {
	AirWindHor_Off = 0,
	AirWindHor_On = 1,
};
/// 垂直风向/上下扫风
typedef NS_ENUM(int, AirWindVer) {
	AirWindVer_Off = 0,
	AirWindVer_On = 1,
};
/// 超强/强力
typedef NS_ENUM(int, AirSuper) {
	AirSuper_Off = 0,
	AirSuper_On = 1,
};
/// 睡眠状态
typedef NS_ENUM(int, AirSleep) {
	AirSleep_Off = 0,
	AirSleep_On = 1,
};
/// 干燥+辅热状态
typedef NS_ENUM(int, AirAidHot) {
	AirAidHot_Off = 0,
	AirAidHot_On = 1,
};
/// 空调定时
typedef NS_ENUM(int, AirTimer) {
	AirTimer_Off = 0,
	AirTimer_On = 1,
};
/// 温度显示
typedef NS_ENUM(int, AirTempDisplay) {
	/// 外箱
	AirTempDisplay_Outdoor = 0,
	/// 内箱
	AirTempDisplay_Indoor = 1,
	/// 目标
	AirTempDisplay_Target = 2,
    /// 无
	AirTempDisplay_None = 3,
};
/// 空调节能
typedef NS_ENUM(int, AirPowerSaving) {
	AirPowerSaving_Off = 0,
	AirPowerSaving_On = 1,
};
/// 空调负离子
typedef NS_ENUM(int, AirAnion) {
	AirAnion_Off = 0,
	AirAnion_On = 1,
};
/// 空调舒适
typedef NS_ENUM(int, AirComfort) {
	AirComfort_Off = 0,
	AirComfort_On = 1,
};
/// 空调换气
typedef NS_ENUM(int, AirFreshAir) {
	AirFreshAir_Off = 0,
	AirFreshAir_On = 1,
};
/// 空调灯光
typedef NS_ENUM(int, AirLight) {
	AirLight_Off = 0,
	AirLight_On = 1,
};
/// 空调加湿
typedef NS_ENUM(int, AirWet) {
	AirWet_Off = 0,
	AirWet_On = 1,
};
/// 空调静音
typedef NS_ENUM(int, AirMute) {
	AirMute_Off = 0,
	AirMute_On = 1,
};
