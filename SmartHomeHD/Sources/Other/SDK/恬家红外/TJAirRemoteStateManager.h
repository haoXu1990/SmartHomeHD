//
//  TJAirRemoteStateManager.h
//  tiqiaasdk
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 tiqiaa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJRemoteModel.h"

@interface TJAirRemoteStateManager : NSObject

+ (instancetype)sharedManager;

- (TJAirRemoteState *)getAirRemoteState:(NSString *)remoteId;

- (void)setAirRemoteState:(NSString *)remoteId state:(TJAirRemoteState *)state;

- (void)removeAirRemoteState:(NSString *)remoteId;

- (void)synchronize;

@end
