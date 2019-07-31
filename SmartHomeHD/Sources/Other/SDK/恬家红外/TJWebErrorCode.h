//
//  TJWebErrorCode.h
//  tiqiaasdk
//
//  Created by apple on 15/8/9.
//  Copyright (c) 2015年 tiqiaa.com. All rights reserved.
//

#ifndef TJWebErrorCode_h
#define TJWebErrorCode_h

typedef NS_ENUM(int, TJWebErrorCode) {
	/// 成功
	TJWebErrorCode_Success = 0,
	/// 失败
	TJWebErrorCode_Failure = 1,
	/// 没有网络
	TJWebErrorCode_NoNet = 2,
	/// 无请求Token
	TJWebErrorCode_NoToken = 3,
	/// 授权验证失败
	TJWebErrorCode_AuthFailed = 4,
	/// 请求参数错误
	TJWebErrorCode_ParamError = 5,
	/// 拒绝
	TJWebErrorCode_Denied = 6,

	/// 精确匹配完成
	TJWebErrorCode_MatchCompleted = 6001,
	/// 遥控器没找到
	TJWebErrorCode_RemoteNotFound = 7001,
	/// 未登录
	TJWebErrorCode_NotLogin = 8001,

	/// 本地数据是最新的，无需重新从网上加载
	TJWebErrorCode_LocalDataUpdateToDate,
};

#endif
