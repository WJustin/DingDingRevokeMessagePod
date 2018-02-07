//
//  DDRConfig.m
//  DingDingDylib
//
//  Created by Justin.wang on 2018/2/7.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDRConfig.h"

@implementation DDRConfig

+ (instancetype)shareConfig {
    static DDRConfig *shareConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareConfig = [[DDRConfig alloc] init];
    });
    return shareConfig;
}

@end
