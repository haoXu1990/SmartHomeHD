//
//  TJStringUtil.h
//  TiqiaaSDK
//
//  Created by apple on 14-5-16.
//  Copyright (c) 2014年 TianJia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// https://en.wikipedia.org/wiki/CJK_Unified_Ideographs

/// Unicode character is CJK in BMP?
static inline int isCJKChar(unichar ch) {
	return (ch >= 0x4E00 && ch <= 0x9FFF)	// CJK Unified Ideographs
		|| (ch >= 0x3400 && ch <= 0x4DBF)	// CJK Unified Ideographs Extension A
		|| (ch >= 0xF900 && ch <= 0xFAFF)	// CJK Compatibility Ideographs
		// surrogate pair
		// 20000–2A6DF CJK Unified Ideographs Extension B
		// 2A700–2B73F CJK Unified Ideographs Extension C
		// 2B740–2B81F CJK Unified Ideographs Extension D
		// 2B820–2CEAF CJK Unified Ideographs Extension E
	;
}

@interface NSString (TJStringUtil)

/// self
- (NSString *)stringValue;

/// contains substring, like containsString: in iOS8+
- (BOOL)contains:(NSString *)str;
- (BOOL)containsAnyChar:(NSString *)chars;
/// contains CJK characters in BMP
- (BOOL)containsCJKChar;

/// concatenate items by self
- (NSString *)join:(NSArray *)items;

/// trim/strip whitespace and newline from both end
- (NSString *)trim;

/// remove entries with zero length
+ (NSArray<NSString *> *)removeEmptyEntries:(NSArray<NSString *> *)items;

/// split self by separator
- (NSArray<NSString *> *)split:(NSString *)separator;

/// split self by every char
- (NSArray<NSString *> *)splitByChars:(NSString *)chars;

/// split self by whitespace and newline
- (NSArray<NSString *> *)split;

- (NSArray<NSString *> *)arrayWithWordTokenize;
- (NSString *)separatedStringWithSeparator:(NSString *)separator;

- (NSString *)toPinyin;

@end

NS_ASSUME_NONNULL_END
