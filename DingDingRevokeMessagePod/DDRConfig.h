//
//  DDRConfig.h
//  DingDingDylib
//
//  Created by Justin.wang on 2018/2/7.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDRConfig : NSObject

@property (nonatomic, assign) BOOL canRevokeMsg;

+ (instancetype)shareConfig;

@end
