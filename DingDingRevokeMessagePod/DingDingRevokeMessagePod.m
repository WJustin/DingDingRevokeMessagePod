//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  DingDingRevokeMessagePod.m
//  DingDingRevokeMessagePod
//
//  Created by Justin.wang on 2018/2/7.
//  Copyright (c) 2018年 Justin.wang. All rights reserved.
//

#import "DingDingRevokeMessagePod.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>

CHDeclareClass(CustomViewController)

CHOptimizedMethod(0, self, NSString*, CustomViewController,getMyName){
    return @"MonkeyDevPod";
}

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook(0, CustomViewController, getMyName);
}
