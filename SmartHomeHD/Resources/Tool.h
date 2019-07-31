//
//  Tool.h
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/31.
//  Copyright © 2019 FH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject
+ (void)initTQSDK;

+ (NSString *)dataToHexStringWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
