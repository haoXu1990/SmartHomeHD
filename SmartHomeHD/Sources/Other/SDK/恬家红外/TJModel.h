//
//  TJModel.h
//  TiqiaaSDK
//
//  Created by apple on 14-7-18.
//  Copyright (c) 2014年 TianJia. All rights reserved.
//

#import <Foundation/Foundation.h>


/// JSON 序列化选项
typedef NS_OPTIONS(unsigned, TJJsonWritingOptions) {
	TJJsonWritingOptionsNone = 0,
	/// 生成带空格，换行，缩进的 JSON 字符串
	TJJsonWritingPrettyPrinted = (1 << 0),
	/// 保留值为 nil 的字段
	TJJsonWritingKeepNilValueField = (1 << 1),
	/// NSNumber的objcType是\@encode(char)时，编码成 String 而不是 Number
	TJJsonWritingCharAsString = (1 << 2),
};


NS_ASSUME_NONNULL_BEGIN

@class TJSQLiteRow;

/// 基础类
@interface TJModel : NSObject

/**
 是否应当缓存 类：字段信息，默认缓存
 */
+ (BOOL)shouldCacheModelInfo;

/**
 清除缓存的 类：字段信息
 */
+ (void)clearCachedModelInfo;

/**
 由Dictionary（数据库查询，jsonDecode等）初始化对象
 */
- (instancetype)initWithDictionary:(nullable NSDictionary *)dict NS_DESIGNATED_INITIALIZER;

+ (instancetype)objectWithDictionary:(nullable NSDictionary *)dict;

/**
 由Dictionary生成对象数组
 */
+ (NSMutableArray *)objectsWithDictionaryArray:(nullable NSArray<__kindof NSDictionary *> *)dictArray;

@end


@interface TJModel (Dictionary)

/**
 对象转换为 Dictionary, 可用于添加到数据库等
 */
- (NSMutableDictionary<NSString *, id> *)toDictionary;

/**
 通字段名取值
 [obj objectForKey:@"name"]
 [obj valueForKey:@"name"]
 obj[@"name"]
 */
- (nullable id)objectForKey:(id)key;
- (nullable id)objectForKeyedSubscript:(id)key;

- (void)setObject:(nullable id)obj forKeyedSubscript:(id)key;

@end


@interface TJModel (JSON)

/**
 转换成JSON对象
 - toJsonObject: TJJsonWritingOptionsNone]
 */
- (NSMutableDictionary<NSString *, id> *)toJsonObject;
/**
 特殊转换可以在子类中override此方法
 */
- (NSMutableDictionary<NSString *, id> *)toJsonObject:(TJJsonWritingOptions)options;

/**
 将 Objective-C 对象转换为 JSON 字符串
 参数 object 可以是以下类或值:
						Top		Key		Value		JSON
 NSArray				y				y			Array
 NSDictionary			y				y			Object
 NSSet					y				y			Array
 NSOrderedSet			y				y			Array
 TJModel				y				y			Object

 NSString						y		y			String
 NSNumber						y		y			Number or String
 NSDate							y		y			String: yyyy-mm-hh HH:MM:SS
 NSURL							y		y			String
 NSUUID							y		y			String

 YES							y		y			true
 NO								y		y			false
 NSNull							y		y			null
 NSData									y			String: Base64
 */
+ (nullable NSString *)jsonEncode:(id)object;
+ (nullable NSString *)jsonEncode:(id)object withOptions:(TJJsonWritingOptions)options;

/**
 JSON解析，参数不是NSString或NSData时原样返回
 */
+ (nullable id)jsonDecode:(nullable id)jsonString;

@end


@interface TJModel (Database)

- (instancetype)initWithSQLiteRow:(nullable TJSQLiteRow *)row;

+ (instancetype)objectWithSQLiteRow:(nullable TJSQLiteRow *)row;

+ (NSMutableArray *)objectsWithSQLiteRowArray:(nullable NSArray<TJSQLiteRow *> *)rowArray;

/// 数据库表名
+ (nullable NSString *)getTableName;

/// 全部字段名（包括表中没有的字段）
+ (NSMutableArray<NSString *> *)getFieldName;

@end


/**
 Entity has unique INT id
 */
@interface TJIntIdModel : TJModel
@property (nonatomic) int _id;

@end


/**
 Entity has unique BIGINT id
 */
@interface TJLongIdModel : TJModel
@property (nonatomic) int64_t _id;

@end


/**
 Entity has unique case insensitive CHAR, VARCHAR id
 */
@interface TJStringIdModel : TJModel
@property (nonatomic, strong) NSString *_id;

@end


/**
 Entity has unique case sensitive String id
 */
@interface TJCaseStringIdModel : TJModel
@property (nonatomic, strong) NSString *_id;

@end


NS_ASSUME_NONNULL_END
