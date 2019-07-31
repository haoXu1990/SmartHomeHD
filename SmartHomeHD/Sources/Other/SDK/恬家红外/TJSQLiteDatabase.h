//
//  TJSQLiteDatabase.h
//  tiqiaasdk
//
//  Created by apple on 15/9/23.
//  Copyright © 2015年 tiqiaa.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 SQLite
 https://sqlite.org/docs.html

 1. 数据库类型和值
 https://sqlite.org/datatype3.html
 Objective-C		SQLite
 
 NSString			TEXT
 int32_t/int64_t	INTEGER
 float/double		FLOAT
 NSData				BLOB
 
 YES				1
 NO					0
 NSNull				NULL
 
 NSURL				TEXT
 NSUUID				TEXT
 NSDate				TEXT: yyyy-MM-dd HH:mm:ss

 */


NS_ASSUME_NONNULL_BEGIN

@class TJModel;
@class TJSQLiteTableInfo;

/**
 查询结果
 */
@interface TJSQLiteRow : NSObject

/// 列个数
@property (nonatomic, readonly) NSUInteger count;

/// 列名
@property (nonatomic, strong, readonly) NSArray<NSString *> *columns;

/// 列名 - 值
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *values;

/**
 通过下标取值
 [row objectAtIndex:index]
 row[index]
 */
- (nullable id)objectAtIndex:(NSUInteger)index;
- (nullable id)objectAtIndexedSubscript:(NSUInteger)index;

/**
 通过列名取值
 [row objectForKey:@"key"]
 [row valueForKey:@"key"]
 row[@"key"]
 */
- (nullable id)objectForKey:(id)key;
- (nullable id)objectForKeyedSubscript:(id)key;

/**
 各列的值（按列顺序）
 */
- (NSMutableArray *)asArray;

@end


/**
 sqlite3_stmt 封装
 https://sqlite.org/c3ref/stmt.html
 */
@interface TJSQLiteStatement : NSObject

/// 是否已关闭
@property (nonatomic, readonly) BOOL isClosed;

/// 对应SQL语句
@property (nonatomic, strong, readonly, nullable) NSString *query;

/// 参数个数
@property (nonatomic, readonly) int paramCount;

/// 结果列数目
@property (nonatomic, readonly) int columnCount;


- (void)close;
- (void)reset;

#pragma mark - execute

- (BOOL)execute;
- (BOOL)executeInTransaction;

#pragma mark - query

/// 获取单个值，错误或结果为空返回nil
- (nullable id)fetchScalar;

/// 获取一行，错误或结果为空返回nil
- (nullable TJSQLiteRow *)fetchOne;

/// 获取全部行，错误返回nil, 结果为空返回空数组
- (nullable NSMutableArray<TJSQLiteRow *> *)fetchAll;

/// 获取全部结果的第一列，错误返回nil, 结果为空返回空数组；数组对象为id
- (nullable NSMutableArray *)fetchArray;

@end


/**
 bind
 https://sqlite.org/lang_expr.html#varparam

 index 从1开始, 到paramCount
 参数名称使用 @AAAA 形式
 bind TEXT和BLOB时使用SQLITE_TRANSIENT
 */
@interface TJSQLiteStatement (Binding)

/// clear bindings
- (void)clearBindings;
/// reset and clear bindings
- (void)fullReset;

/// 获取参数index
- (int)paramIndex:(NSString *)param;

/// 获取参数名称
- (nullable NSString *)paramName:(int)index;

- (BOOL)bindInt:(int)value At:(int)index;
- (BOOL)bindLong:(int64_t)value At:(int)index;
- (BOOL)bindDouble:(double)value At:(int)index;

- (BOOL)bindNullAt:(int)index;
- (BOOL)bindZeroBlob:(int)length At:(int)index;
- (BOOL)bindValue:(nullable id)value At:(int)index;

- (BOOL)bindInt:(int)value For:(NSString *)param;
- (BOOL)bindLong:(int64_t)value For:(NSString *)param;
- (BOOL)bindDouble:(double)value For:(NSString *)param;

- (BOOL)bindNullFor:(NSString *)param;
- (BOOL)bindZeroBlob:(int)length For:(NSString *)param;
- (BOOL)bindValue:(nullable id)value For:(NSString *)param;

/**
 依次bind values 中的每个值到对应的 index + 1上
 */
- (BOOL)bindValues:(NSArray *)values;

/**
 依次bind dict的value到对应key上，使用参数\@key, 如果\@key不在param中则忽略
 */
- (BOOL)bindDict:(NSDictionary<NSString *, id> *)dict;

@end


/**
 bind TEXT和BLOB时使用SQLITE_STATIC，而不是 SQLITE_TRANSIENT（SQLite makes its own private copy）
 bind*方法内部生成的临时字符串（如转换NSDate）依然使用SQLITE_TRANSIENT
 TJSQLiteDatabase 中的insert, withArgs, withDict 方法均使用SQLITE_STATIC（bind的值是参数）
 @note
 需要确保bind的value 在执行 execute*, fetch* 时依然是有效的
 */
@interface TJSQLiteStatement (StaticBinding)

- (BOOL)bindValue:(nullable id)value At:(int)index staticBind:(BOOL)staticBind;;
- (BOOL)bindValue:(nullable id)value For:(NSString *)param staticBind:(BOOL)staticBind;;

- (BOOL)bindValues:(NSArray *)values staticBind:(BOOL)staticBind;
- (BOOL)bindDict:(NSDictionary<NSString *, id> *)dict staticBind:(BOOL)staticBind;

@end


/**
 sqlite3 封装
 https://sqlite.org/c3ref/sqlite3.html
 */
@interface TJSQLiteDatabase : NSObject

/// 是否已关闭
@property (nonatomic, readonly) BOOL isClosed;

/// 数据库路径
@property (nonatomic, strong, readonly) NSString *path;

/// 数据库版本
@property (nonatomic, readonly) int userVersion;
@property (nonatomic, readonly) int schemaVersion;

/**
 最后的错误码
 https://sqlite.org/rescode.html
 可以在语句执行前将其设置为0(SQLITE_OK)，然后判断语句执行后的值
 */
@property (nonatomic) int lastErrorCode;

/// 最后的错误消息
@property (nonatomic, strong, readonly, nullable) NSString *lastErrorMsg;

/// 最后插入行ID
@property (nonatomic, readonly) int64_t lastInsertRowId;

/// 打开数据库(使用完整路径或者使用 :memory: , 如果之前已打开则先关闭)
- (BOOL)open:(NSString *)path;
- (BOOL)open:(NSString *)path withFlags:(int)flags;

/// 打开Document目录下指定文件的数据库
- (BOOL)openDatabase:(NSString *)name;

/// 关闭数据库
- (BOOL)close;

/// 设置数据库版本
- (BOOL)setUserVersion:(int)userVersion;

- (BOOL)beginTransaction;
- (BOOL)commit;
- (BOOL)rollback;

/**
 return a prepared statement or nil if failed
 */
- (nullable TJSQLiteStatement *)prepare:(NSString *)query;

/**
 return cached table info
 */
- (nullable TJSQLiteTableInfo *)getTableInfo:(NSString *)table;

@end


@interface TJSQLiteDatabase (QueryBuildUtil)

/**
 escape single quote
 ' --> ''
 */
- (NSString *)escape:(NSString *)str;

/**
 escape %(zero or more characters) and _(signle character) in LIKE pattern use '\'.
 NOTE: single quote is NOT escaped (so the escaped pattern can be used in binding).
 https://sqlite.org/c3ref/lang_expr.html#like
 https://sqlite.org/c3ref/lang_corefunc.html#like
 somethng LIKE '%pattern%'
 should write as
 something LIKE '%escaped-pattern%' ESCAPE '\'
 */
- (NSString *)escapeLike:(NSString *)pattern;

/**
 unquote table, column name:
 "name"  --> name
 [name]  --> name
 `name`  --> name
 */
+ (NSString *)unquote:(NSString *)name;
- (NSString *)unquote:(NSString *)name;

/**
 format query use sqlite3_mprintf()
 https://sqlite.org/c3ref/mprintf.html
 NSString argument should use %q or %Q, and passed as [str UTF8String]
 */
- (nullable NSString *)mprintf:(const char *)query, ... __attribute__((__format__(printf, 1, 2)));

/**
 build INSERT command like:
 INSERT INTO table (col1, ...) VALUES (@col1, ...);
 https://sqlite.org/lang_insert.html
 cmd:
 INSERT
 REPLACE
 INSERT OR REPLACE
 INSERT OR IGNORE
 INSERT OR ROLLBACK
 INSERT OR ABORT
 INSERT OR FAIL
 */
- (NSString *)buildInsert:(NSString *)cmd into:(NSString *)table forColumns:(NSArray<NSString *> *)columns;

/**
 build UPDATE command like:
 UPDATE table SET col1=@col1, ...
 https://sqlite.org/lang_update.html
 cmd:
 UPDATE
 UPDATE OR REPLACE
 UPDATE OR IGNORE
 UPDATE OR ROLLBACK
 UPDATE OR ABORT
 UPDATE OR FAIL
 */
- (NSMutableString *)buildUpdate:(NSString *)cmd table:(NSString *)table forColumns:(NSArray<NSString *> *)columns;

@end


/**
 执行SQL语句
 withDict: 和 withValues: 的值不需转义(LIKE 除外 escapeLike:)，其他情况字符串需要手动转义(escape:)
 @code
 [db execute:@"UPDATE dummy SET c1='c%1', c2='c''2'"]; // 转义
 [db execute:@"UPDATE dummy SET c1=@c1, c2=@c2" withDict:@{@"c1": @"c%1", @"c2": @"c'2"}]; // 不转义
 [db execute:@"UPDATE dummy SET c1=?, c2=?" withValues:@[@"c%1", @"c'2"]; // 不转义
 // LIKE
 [db execute:@"DELETE FROM dummy WHERE c1 LIKE '%\\%''%' ESCAPE '\\'"]; // 删除 c1 包含 "%'" 的行
 [db execute:@"DELETE FROM dummy WHERE c1 LIKE ? ESCAPE '\\'" withValues@[@"%\\%'%"]]; // 删除 c1 包含 "%'" 的行
 */
@interface TJSQLiteDatabase (Execute)

/**
 执行SQL语句
 */
- (BOOL)execute:(NSString *)query;
- (BOOL)execute:(NSString *)query withArgs:(NSArray *)args;
- (BOOL)execute:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

/**
 在事务中执行SQL语句
 */
- (BOOL)executeInTransaction:(NSString *)query;
- (BOOL)executeInTransaction:(NSString *)query withArgs:(NSArray *)args;
- (BOOL)executeInTransaction:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

/**
 在事务中执行block
 block 返回YES 执行commit, 否则执行rollback
 */
- (BOOL)executeBlockInTransaction:(BOOL (^)(TJSQLiteDatabase *db))block;

@end


@interface TJSQLiteDatabase (Insert)

/**
 返回在columns中，并且在数据库表table字段中的名称
 */
- (NSMutableArray<NSString *> *)filterColumnName:(NSArray<NSString *> *)columns forTable:(NSString *)table;

/**
 在table中插入一行，使用dict的key为列名
 @see -buildInsert:into:withColumns:
 @see -execute:withDict:
 */
- (BOOL)insert:(NSDictionary<NSString *, id> *)dict into:(NSString *)table useCommand:(NSString *)command;

/**
 在table中插入一行
 obj需要实现 -valueForKey: (如NSDictionary, TJModel, TJSQLiteRow等)
 */
- (BOOL)insert:(id)obj into:(NSString *)table forColumns:(NSArray<NSString *> *)columns useCommand:(NSString *)command;

/**
 在table中插入多行，返回插入成功的行数
 objList 中的对象需要实现 -valueForKey: (如NSDictionary, TJModel, TJSQLiteRow等)
 */
- (NSUInteger)insertMany:(NSArray *)objList into:(NSString *)table forColumns:(NSArray<NSString *> *)columns useCommand:(NSString *)command;

/**
 在 [model getTableName]表中插入
 */
- (NSUInteger)insertMany:(NSArray *)items useCommand:(NSString *)command withModel:(Class)model;

/**
 在 [model getTableName]表中插入，忽略自增长的id字段
 */
- (NSUInteger)insertManyWithoutId:(NSArray *)items useCommand:(NSString *)command withModel:(Class)model;

/**
 使用事务 REPLACE [model getTableName]表中数据
 */
- (BOOL)replaceAll:(NSArray *)items withModel:(Class)model;
- (BOOL)replaceAllWithoutId:(NSArray *)items withModel:(Class)model;

/**
 使用事务 INSERT OR IGNORE [model getTableName]表中数据
 */
- (BOOL)ignoreAll:(NSArray *)items withModel:(Class)model;
- (BOOL)ignoreAllWithoutId:(NSArray *)items withModel:(Class)model;

@end


/**
 执行查询
 */
@interface TJSQLiteDatabase (Query)

/**
 获取单个值, 错误或者结果为空返回nil
 */
- (nullable id)fetchScalar:(NSString *)query;
- (nullable id)fetchScalar:(NSString *)query withArgs:(NSArray *)args;
- (nullable id)fetchScalar:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

/**
 获取一行, 错误或者结果为空返回nil
 @code
 TJSQLiteRow *row = [db fetchOne:@"SELECT * FROM tb_brand"];
 TJBrand *brand = [TJBrand objectWithSQLiteRow:row];
 */
- (nullable TJSQLiteRow *)fetchOne:(NSString *)query;
- (nullable TJSQLiteRow *)fetchOne:(NSString *)query withArgs:(NSArray *)args;
- (nullable TJSQLiteRow *)fetchOne:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

/**
 获取全部行, 错误返回nil, 结果为空返回空数组
 @code
 NSArray *rows = [db fetchAll:@"SELECT * FROM tb_brand"];
 NSArray *brands = [TJBrand objectsWithSQLiteRowArray:rows];
 */
- (nullable NSMutableArray<TJSQLiteRow *> *)fetchAll:(NSString *)query;
- (nullable NSMutableArray<TJSQLiteRow *> *)fetchAll:(NSString *)query withArgs:(NSArray *)args;
- (nullable NSMutableArray<TJSQLiteRow *> *)fetchAll:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

/// 获取全部结果的第一列，错误返回nil, 结果为空返回空数组；数组对象为id
- (nullable NSMutableArray *)fetchArray:(NSString *)query;
- (nullable NSMutableArray *)fetchArray:(NSString *)query withArgs:(NSArray *)args;
- (nullable NSMutableArray *)fetchArray:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

/**
 获取 [model getTableName]表中所有行
 */
- (NSMutableArray *)fetchAllModel:(Class)model;

@end


/**
 wrappr for fetchScalar:
 */
@interface TJSQLiteDatabase (QueryWrapper)

- (int)getInt:(NSString *)query;
- (int)getInt:(NSString *)query withArgs:(NSArray *)args;
- (int)getInt:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

- (int64_t)getLong:(NSString *)query;
- (int64_t)getLong:(NSString *)query withArgs:(NSArray *)args;
- (int64_t)getLong:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

- (double)getDouble:(NSString *)query;
- (double)getDouble:(NSString *)query withArgs:(NSArray *)args;
- (double)getDouble:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

- (nullable NSString *)getString:(NSString *)query;
- (nullable NSString *)getString:(NSString *)query withArgs:(NSArray *)args;
- (nullable NSString *)getString:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

- (nullable NSData *)getBlob:(NSString *)query;
- (nullable NSData *)getBlob:(NSString *)query withArgs:(NSArray *)args;
- (nullable NSData *)getBlob:(NSString *)query withDict:(NSDictionary<NSString *, id> *)dict;

@end


@interface TJSQLiteDatabase (Util)

/// SQLite 版本
+ (NSString *)sqliteLibVersion;

/// 获取表/视图行数
- (int64_t)getRowCount:(NSString *)table;

/**
 暂停执行 sqlite3_sleep()
 https://sqlite.org/c3ref/sleep.html
 */
- (void)sleep:(int)milliseconds;

/**
 执行VACUUM命令重构数据库
 https://sqlite.org/lang_vacuum.html
 */
- (BOOL)vacuum;

/**
 设置外键检测
 https://sqlite.org/pragma.html#pragma_foreign_keys
 */
- (BOOL)setForeignKeyCheck:(BOOL)enable;

/// 删除表
- (BOOL)dropTable:(NSString *)tableName;

/// 删除视图
- (BOOL)dropView:(NSString *)viewName;

/// 删除索引
- (BOOL)dropIndex:(NSString *)indexName;

/// 删除触发器
- (BOOL)dropTrigger:(NSString *)triggerName;

/**
 清除表数据
 重置auto increment值
 */
- (BOOL)truncateTable:(NSString *)tableName;

/**
 判断表table是否存在
 */
- (BOOL)hasTable:(NSString *)table;

/**
 判断表table中是否有列column
 */
- (BOOL)didTable:(NSString *)table hasColumn:(NSString *)column;

/**
 在表中添加列
 https://sqlite.org/lang_altertable.html
 */
- (BOOL)addColumn:(NSString *)columnDef toTable:(NSString *)table;

@end

NS_ASSUME_NONNULL_END
