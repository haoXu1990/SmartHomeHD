//
//  Tool.m
//  SmartHomeHD
//
//  Created by XuHao on 2019/7/31.
//  Copyright © 2019 FH. All rights reserved.
//

#import "Tool.h"
#import "tiqiaasdk.h"
static const uint8_t appKey[] ={166, 104, 15, 170, 181, 183, 224, 169, 33, 45, 89, 227, 36, 203, 213, 216,125, 191, 106, 241, 130, 42, 107, 178, 28, 185, 0, 19, 78, 154, 209, 147,5, 189, 127, 39, 209, 72, 13, 188, 95, 77, 16, 192, 32, 57, 219, 30,46, 18, 138, 250, 50, 243, 239, 24, 157, 48, 19, 135, 38, 138, 188, 147,201, 157, 206, 63, 156, 213, 183, 253, 79, 49, 233, 250, 86, 86, 46, 143,140, 135, 178, 124, 94, 82, 144, 239, 187, 187, 117, 233, 11, 83, 224, 2,142, 226, 169, 187, 65, 132, 33, 119, 193, 4, 251, 109, 30, 209, 198, 42,172, 31, 20, 114, 165, 211, 142, 127, 231, 252, 58, 168, 222, 23, 34, 133,61, 63, 19, 70, 114, 66, 134, 12, 124, 17, 78, 46, 145, 180, 81, 82};


@implementation Tool

+ (void)initTQSDK {
    [TJRemoteClient setAppKey:appKey length:sizeof(appKey)];
    
}

+ (NSString *)dataToHexStringWithData:(NSData *)data {
    NSUInteger          len = [data length];
    char *              chars = (char *)[data bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}

@end
