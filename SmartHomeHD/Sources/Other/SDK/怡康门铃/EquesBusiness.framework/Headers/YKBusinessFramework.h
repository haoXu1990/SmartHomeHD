//
//  YKBusinessFramework.h
//  EquesBusiness
//
//  Created by lijiayong on 15/7/9.
//  Copyright (c) 2015年 lijiayong. All rights reserved.
//  Version: 1.0.12

#import <Foundation/Foundation.h>

/**
 注册这个通知，接收数据
 **/
#ifndef equesOnMessageResultNotification
#define equesOnMessageResultNotification @"EQUESONMESSAGERESULT"
#endif

/**
注册此消息通知：视频拨打成功，视频帧数据就位
作用：调用者在UI层监听此消息，以便处理：视频显示之前的逻辑、视频显示之后的逻辑
 **/
#ifndef equesOnMessageVideoplayingNotification
#define equesOnMessageVideoplayingNotification @"EQUESVIDEOPLAYINGNOTIFICATION"
#endif

typedef NS_ENUM(NSInteger,DeviceType) {
    EquesC01 = 0,//远见
    EquesElse,//其它移康产品
};

typedef NS_ENUM(int,AllowResponce) {
    allowAdd = 1,//允许添加
    refuseAdd = 0,//拒绝添加
};

typedef NS_ENUM(int,deleteOption) {
    deleteSome = 0,//更具设备的bid和记录的唯一标识删除
    deleteAll = 2,//根据设备bid删除，可以用来一键删除该设备的全部消息
};

typedef NS_ENUM(int,deleteLockOption) {
    deleteLockSome = 0,//服务器将根据bid,lid和oid（或者aid）来删除
    deleteLockAll = 1,//为1时, 服务器将根据bid,lid来删除, 此时将忽略oid或者aid参数
};

typedef NS_ENUM(int,PirBell) {
    whoAreYou = 1,//你是谁呀
    beepBell = 2,//嘟嘟声
    alarmBell = 3,//报警声
    zingBell = 4,//尖啸声
    muteBell = 5,//静音
    customBellP = 6,//自定义
};

@interface YKBusinessFramework : NSObject
#pragma mark 登录
/**
 *  登录账号
 *
 *  @param url 服务器地址url
 *  @param username  用户名
 *  @param AppKey
 */
+ (void)equesSdkLoginWithUrl:(NSString *)url username:(NSString *)username appKey:(NSString *)AppKey;

#pragma mark 添加设备
/**
 *  生成二维码
 *
 *  @param WifiSsid 设备要连接的wifi名称
 *  @param wifiPw  wifi密码
 *  @param username 用户名
 *  @param role 设备类型 区分C01和其它类产品
 *  @param width 生成正方形二维码的长度。
 */
+ (UIImage *)equesCreateQRCodeWithWifiSsid:(NSString *)wifiSsid wifiPw:(NSString *)wifiPw username:(NSString *)username role:(DeviceType)role imageSize:(CGFloat)width;

/**
 *  生成二维码(增加key_id参数)
 *
 *  @param WifiSsid 设备要连接的wifi名称
 *  @param wifiPw  wifi密码
 *  @param username 用户名
 *  @param role 设备类型 区分C01和其它类产品
 *  @param width 生成正方形二维码的长度。
 *  @param keyId 第三方厂商键值
 */
+ (UIImage *)equesCreateQRCodeNewWithWifiSsid:(NSString *)wifiSsid wifiPw:(NSString *)wifiPw username:(NSString *)username keyId:(NSString *)keyId role:(DeviceType)role imageSize:(CGFloat)width;

/**
 *  确认添加该设备
 *
 *  @param requestId 会话请求的id  填入收到method值为on_addbdy_req的数据包中的reqid值
 *  @param allow allow为1时允许添加，allow为0时拒绝添加。
 */
+ (void)equesAckAddResponse:(NSString *)requestId allow:(AllowResponce)allow;

#pragma mark 删除设备
/**
 *  删除设备
 *
 *  @param bid 设备的唯一标识
 */
+ (void)equesDelDeviceWithBid:(NSString *)bid;

#pragma mark 获取设备列表
/**
 *  获取设备列表
 */
+ (void)equesGetDeviceList;

#pragma mark 获取设备详情
/**
 *  获取设备信息
 *
 *  @param uid 设备端的通信id
 */
+ (void)equesGetDeviceInfoWithUid:(NSString *)uid;

#pragma mark 设备管理接口
/**
 *  修改设备昵称
 *
 *  @param bid 设备的唯一标识
 *  @param nick 设备昵称
 */
+ (void)equesSetDeviceNickWithBid:(NSString *)bid Nick:(NSString *)nick;

/**
 *  管理设备的人体侦测功能
 *
 *  @param uid 设备端的通信id
 *  @param value 打开或者关闭pir
 */
+ (void)equesSetPirEnableWithUid:(NSString *)uid status:(BOOL)value;

/**
 *  管理设备的门铃灯开关
 *
 *  @param uid 设备端的通信id
 *  @param value 打开或者关闭门铃灯
 */
+ (void)equesSetDoorbellLightWtihUid:(NSString *)uid status:(BOOL)value;

/**
 *  设置设备门铃铃声
 *
 *  @param uid 设备端的通信id
 *  @param ring 铃声编号
 */
+ (void)equesSelectDoorbellRingtoneWithUid:(NSString *)uid ring:(int)value;

#pragma mark 获取PIR设置详情
/**
 *  获取设备人体侦测的设置信息
 *
 *  @param uid 设备端的通信id
 */
+ (void)equesGetDevicePirInfoWithUid:(NSString *)uid;

#pragma mark 设置PIR参数
/**
 *  设置PIR参数
 *
 *  @param uid 设备端的通信id
 *  @param senseTime 侦测到人体多少秒后才开始抓拍
 *  @param senseSensitivity 人体侦测灵敏度
 *  @param ringtone PIR报警铃声
 *  @param volume 设备报警铃音音量
 *  @param captureNum 单次报警抓拍图片的张数
 *  @param format 报警格式--拍照或者录像
 */
+ (void)equesSetDevicePirInfoWithUid:(NSString *)uid senseTime:(int)senseTime senseSensitivity:(int)senseSensitivity ringtone:(int)ringtone volume:(int)volume captureNum:(int)captureNum format:(int)format;

#pragma mark 获取报警消息列表
/**
 *  获取设备的未读报警消息列表
 *
 *  @param bid 设备的唯一标识
 *  @param startTime  要获取报警消息的起始时间
 *  @param endTime    要获取报警消息的截止时间
 *  @param limit 一次最多获取的消息条数(最大支持100条)
 */
+ (void)equesGetAlarmMessageList:(NSString *)bid startTime:(long long)startTime endTime:(long long)endTime limitCount:(long long)limit;

#pragma mark 获取报警消息缩略图url
/**
 *  获取报警消息缩略图url
 *
 *  @param bid 设备的唯一标识
 *  @param pvid 报警消息缩略图的唯一id
 */
+ (NSURL *)equesGetThumbUrl:(NSString *)bid pvid:(NSString *)pvid;

#pragma mark 获取报警消息文件url
/**
 *  获取报警消息文件url
 *
 *  @param bid 设备的唯一标识
 *  @param fid 报警消息文件的唯一id
 */
+ (NSURL *)equesGetAlarmfileUrl:(NSString *)bid fid:(NSString *)fid;

#pragma mark 删除报警消息接口
/**
 *  删除报警消息接口
 *
 *  @param bid 设备的唯一标识
 *  @param aid 报警消息的唯一id
 *  @param delAll 删除方式
 */
+ (void)equesDelAlarmMessageWithBid:(NSString *)bid aid:(NSArray *)aid delAll:(deleteOption)delAll;

#pragma mark 门铃来电及记录图片Url
/**
 *  门铃来电及记录图片Url
 *
 *  @param bid 设备的唯一标识
 *  @param fid 门铃图片文件的唯一id
 */
+ (NSURL *)equesGetRingPictureUrl:(NSString *)bid fid:(NSString *)fid;

#pragma mark 获取门铃记录列表
/**
 *  获取门铃记录列表
 *
 *  @param bid 设备的唯一标识
 *  @param startTime  要获取门铃记录的起始时间
 *  @param endTime    要获取门铃记录的截止时间
 *  @param limit 一次最多获取的门铃记录条数(最大支持1000条)
 */
+ (void)equesGetRingRecordList:(NSString *)bid startTime:(long long)startTime endTime:(long long)endTime limitCount:(long long)limit;

#pragma mark 删除门铃记录接口
/**
 *  删除门铃记录接口
 *
 *  @param bid 设备的唯一标识
 *  @param fid 门铃记录的唯一id
 *  @param delAll 删除方式
 */
+ (void)equesDelRingRecordWithBid:(NSString *)bid fid:(NSArray *)fid delAll:(deleteOption)delAll;

#pragma mark 远程重启
/**
 *  远程重启
 *
 *  @param uid 设备端的通信id
 */
+ (void)equesRestartDeviceWithUid:(NSString *)uid;

#pragma mark 远程升级
/**
 *  远程升级设备端的固件。
 *
 *  @param uid 设备端的通信id
 */
+ (void)equesUpgradeDeviceWithUid:(NSString *)uid;

#pragma mark 设备日志上传
/**
 *  上传设备日志
 *
 *  @param uid 设备端的通信id
 */
+ (void)equesDeviceLogUploadWithUid:(NSString *)uid;

#pragma mark 判断是否在线
/**
 *  判断是否在线
 */
+ (BOOL)equesIsLogin;

#pragma mark 退出登录
/**
 *  退出登录
 */
+ (void)equesLogout;

#pragma mark 获取当前SDK版本号
+ (NSString *)getEquesSdkVersion;

#pragma mark 视频拨打
/**
 *  主动拨打，门铃视频查看
 *
 *  @param bid 呼叫设备的唯一标识
 *  @param bVideo 视频拨打／语音拨打
 *  @param video 视频显示视图
 */
//+ (NSString*)equesOpenCall:(NSString *)bid showView:(UIView *) video enableVideo:(bool) bVideo devType:(int) type;
+ (NSString*)equesOpenCall:(NSString *)bid showView:(UIView *) video enableVideo:(bool) bVideo;

#pragma mark 视频挂断
/**
 *  视频挂断
 *  @param sid 当前会话的sid
 */
+ (void)equesCloseCall:(NSString*)sid;

#pragma mark 录音控制
/**
 *  语音对讲时录音开关
 *  @param enable ：true为打开；false为关闭
 */
+ (void)equesAudioRecordEnable:(bool)enable;

#pragma mark audio播放控制
/**
 *  声音播放开关
 *  @param enable ：true为打开；false为关闭
 */
+ (void)equesAudioPlayEnable:(bool)enable;


#pragma mark 抓拍控制
/**
 *  语音对讲时录音开关
 *  @param type:设备类型
 *  @param path:文件保存路径
 */
+ (int)equesSnapCapture:(int)type fileurl:(NSString*)path;

#pragma mark 视频录像
/**
 *  视频录像开始
 *  @param type:设备类型
 *  @param path:文件保存路径
 */
+ (int)equesVideoRecord:(int)type filepath:(NSString*)path;

#pragma mark 停止视频录像
/**
 *  视频录像结束
 */
+ (int)equesStopVideoRecord;

#pragma mark 获取锁列表
/**
 *  获取猫眼绑定的锁列表
 *
 *  @param bid 设备的唯一标识
 */
+ (void)equesGetLockListWithBid:(NSString *)bid;

#pragma mark 开锁
/**
 *  发送开锁指令
 *
 *  @param uid 设备端的通信id
 *  @param lid 锁的唯一标识，可通过获取锁列表得到
 *  @param password 开锁密码
 */
+ (void)equesOpenLockWithUid:(NSString *)uid lid:(NSString *)lid password:(NSString *)password;

#pragma mark 获取锁的开锁消息
/**
 *  获取设备的未读开锁消息列表
 *
 *  @param bid 设备的唯一标识
 *  @param lid 锁的唯一标识，可通过获取锁列表得到
 *  @param startTime  要获取报警消息的起始时间
 *  @param endTime    要获取报警消息的截止时间
 *  @param limit 一次最多获取的消息条数(最大支持100条)
 */
+ (void)equesGetLockMessage:(NSString *)bid lid:(NSString *)lid startTime:(long long)startTime endTime:(long long)endTime limitCount:(long long)limit;

#pragma mark 获取锁的告警消息
/**
 *  获取设备的未读锁告警消息列表
 *
 *  @param bid 设备的唯一标识
 *  @param lid 锁的唯一标识，可通过获取锁列表得到
 *  @param startTime  要获取报警消息的起始时间
 *  @param endTime    要获取报警消息的截止时间
 *  @param limit 一次最多获取的消息条数(最大支持100条)
 */
+ (void)equesGetLockAlarm:(NSString *)bid lid:(NSString *)lid startTime:(long long)startTime endTime:(long long)endTime limitCount:(long long)limit;

#pragma mark 删除锁的开锁消息
/**
 *  删除开锁消息接口
 *
 *  @param bid 设备的唯一标识
 *  @param lid 锁的唯一标识，可通过获取锁列表得到
 *  @param aid 开锁消息的唯一id
 *  @param delAll 删除方式
 */
+ (void)equesDeleteLockMessageWithBid:(NSString *)bid lid:(NSString *)lid oid:(NSArray *)oid delAll:(deleteLockOption)delAll;

#pragma mark 删除锁的告警消息
/**
 *  删除锁告警消息接口
 *
 *  @param bid 设备的唯一标识
 *  @param lid 锁的唯一标识，可通过获取锁列表得到
 *  @param aid 告警消息的唯一id
 *  @param delAll 删除方式
 */
+ (void)equesDeleteLockAlarmWithBid:(NSString *)bid lid:(NSString *)lid aid:(NSArray *)aid delAll:(deleteLockOption)delAll;




#pragma mark 移康私有API
+ (void)equesInit:(NSString *)url;
+ (void)equesLogin:(NSString *)url username:(NSString *)username password:(NSString *)password role:(NSString *)role;
#pragma mark 登录新接口，可支持QQ，微信登录
/**
 *  登录账号
 *
 *  @param url 服务器地址url
 *  @param nameStype  用于表明name的含义
 //  uname : name为用户注册的用户名
 //  email : name为用户注册的email
 //  phone: name为用户注册的手机号
 //  bid: name为用户或设备的32字符的bid
 //  tinyid: name为用户的短号
 //  qq: name为QQ的openid
 //  weixin: name为weixin的openid
 //  weibo: name为新浪微博的uid
 *  @param name  根据nameStype来传入对应的值
 *  @param tokenType  用于表明token的具体含义，没有可不穿
 // access_token : token为QQ/微信/微博的token
 // passwd_md5: token为用户密码的md5值, 用于移康账号登录
 *  @param token 根据tokenType来传入对应的值
 *  @param appkey  使用QQ登录时，需要传入appkey，其它登录类型可不传
 *  @param role 代表客户端类型
 *  @param distributeName 代表获取分发地址的用户名
 */
+ (void)equesSdkLoginNewWithUrl:(NSString *)url nameStype:(NSString *)nameType name:(NSString *)username tokenType:(NSString *)tokenType token:(NSString *)token appKey:(NSString *)AppKey role:(NSString *)role;
+ (void)equesSdkLoginNewWithUrl:(NSString *)url nameStype:(NSString *)nameType name:(NSString *)username tokenType:(NSString *)tokenType token:(NSString *)token appKey:(NSString *)AppKey role:(NSString *)role distributeName:(NSString *)distributeName;
+ (UIImage *)equesRegCheckcode;
+ (void)equesRegAccount:(NSString *)account password:(NSString *)password email:(NSString *)email code:(NSString *)code;
+ (void)equesEmailCheck:(NSString *)email code:(NSString *)code;
+ (void)equesGetEmailCheckcode:(NSString *)email;
+ (void)equesResetPassword:(NSString *)newPassword newPassword:(NSString *)email code:(NSString *)code;
+ (void)equesModifyPassword:(NSString *)newPassword;
+ (void)equesSendData:(NSString *)datdStr;
+ (void)equesGetAlarmMessageListLJY:(NSString *)bid startTime:(long long)startTime endTime:(long long)endTime limitCount:(long long)limit offset:(int)offset;
+ (void)equesGetRingRecordListLJY:(NSString *)bid startTime:(long long)startTime endTime:(long long)endTime limitCount:(long long)limit offset:(int)offset;

@end
