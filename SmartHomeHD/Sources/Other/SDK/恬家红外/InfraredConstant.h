//
//  InfraredConstant.h
//  TiqiaaSDK
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 TianJia. All rights reserved.
//

#ifndef InfraredConstant_h
#define InfraredConstant_h

#import "icontrol_const.h"
#import "air_cond_const.h"


/**
 信号功能
 com.tiqiaa.constant.InfraredFunc
 */
typedef NS_ENUM(int, TJInfraredFunc) {
	// air mode for IRKeyType_Mode
	TJInfraredFunc_AirMode_Auto = AirMode_Auto,
	TJInfraredFunc_AirMode_Wind = AirMode_Wind,
	TJInfraredFunc_AirMode_Dry = AirMode_Dry,
	TJInfraredFunc_AirMode_Cool = AirMode_Cool,
	TJInfraredFunc_AirMode_Hot = AirMode_Hot,

	// air wind dir for IRKeyType_AirWindDir
	TJInfraredFunc_AirWindDir_Auto = AirWindDir_Auto,
	TJInfraredFunc_AirWindDir_Up = AirWindDir_Up,
	TJInfraredFunc_AirWindDir_Mid = AirWindDir_Mid,
	TJInfraredFunc_AirWindDir_Down = AirWindDir_Down,

	// air wind amount for IRKeyType_WindAmount
	TJInfraredFunc_AirWindAmount_Level1 = AirWindAmount_Level1,
	TJInfraredFunc_AirWindAmount_Level2 = AirWindAmount_Level2,
	TJInfraredFunc_AirWindAmount_Level3 = AirWindAmount_Level3,
	TJInfraredFunc_AirWindAmount_Level4 = AirWindAmount_Level4,
	TJInfraredFunc_AirWindAmount_Auto = AirWindAmount_Auto,

	// state for IRKeyType_WindHorizontal
	TJInfraredFunc_AirWindHor_Off = AirWindHor_Off,
	TJInfraredFunc_AirWindHor_On = AirWindHor_On,

	// state for IRKeyType_WindVertical
	TJInfraredFunc_AirWindVer_Off = AirWindVer_Off,
	TJInfraredFunc_AirWindVer_On = AirWindVer_On,
};


/**
 信号标记
 com.tiqiaa.constant.InfraredFuncMark
 */
typedef NS_ENUM(int, TJInfraredFuncMark) {
	// A/B
	TJInfraredFuncMark_A = 1,
	TJInfraredFuncMark_B = 2,

	// air temp: 16 ~ 31
};

#endif
