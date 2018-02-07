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
#import <objc/runtime.h>
#import "DDRWindow.h"
#import "DDRConfig.h"

@interface YYLabel

@property (nonatomic) NSAttributedString *attributedText;

@end

@interface DTBizMessage

@property(nonatomic) long long senderId;
@property(copy, nonatomic) NSString *localMid;
@property(nonatomic) long long mId;
@property(nonatomic) long long attachmentsType; //1
@property(nonatomic) long long recallStatus;
@property(copy, nonatomic) NSString *content;
@property(nonatomic) _Bool isMine;

@end

@interface DTMessageControllerDataSource

@property (nonatomic) NSArray<DTBizMessage *> *messages;

@end

@interface DTMessageBaseViewController

@property(retain, nonatomic) DTMessageControllerDataSource *dataSource;
- (void)receivedMessageNoticeUpdateNotification:(id)arg1;

@end

CHDeclareClass(YYLabel)
CHDeclareClass(DTMessageControllerDataSource)
CHDeclareClass(UITabBarController);
CHDeclareClass(DTMessageBaseViewController)

CHOptimizedMethod0(self, void, UITabBarController, viewDidLoad) {
    CHSuper0(UITabBarController, viewDidLoad);
    [DDRWindow shareWindow];
}

CHOptimizedMethod1(self, void, DTMessageControllerDataSource, setMessages, NSArray<DTBizMessage *> *, messages) {
    if ([DDRConfig shareConfig].canRevokeMsg) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        __block DTBizMessage *preMessage;
        [messages enumerateObjectsUsingBlock:^(DTBizMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.recallStatus > 0 && !obj.isMine) {
                obj.recallStatus = 0;
                DTBizMessage *bizMessage = [[objc_getClass("DTBizMessage") alloc] init];
                bizMessage.senderId = obj.senderId;
                bizMessage.mId = obj.mId;
                bizMessage.isMine = obj.isMine;
                bizMessage.attachmentsType = obj.attachmentsType;
                bizMessage.content = obj.content;
                bizMessage.recallStatus = 1;
                if (preMessage.mId > 0 && preMessage.mId != obj.mId) {
                    [mutableArray addObject:obj];
                }
                [mutableArray addObject:bizMessage];
            } else {
                [mutableArray addObject:obj];
            }
            preMessage = obj;
        }];
        CHSuper1(DTMessageControllerDataSource, setMessages, mutableArray);
    } else {
        CHSuper1(DTMessageControllerDataSource, setMessages, messages);
    }
}

CHOptimizedMethod1(self, void, YYLabel, setAttributedText, NSAttributedString *, attributedText) {
    if ([DDRConfig shareConfig].canRevokeMsg) {
        if ([attributedText.string containsString:@"撤回了一条消息"] &&
            ![attributedText.string containsString:@"已阻止"] &&
            ![attributedText.string containsString:@"你"]) {
            NSString *string = [NSString stringWithFormat:@"已阻止%@", attributedText.string];
            string =  [string stringByReplacingOccurrencesOfString:@"了一条" withString:@""];
            attributedText = [[NSAttributedString alloc] initWithString:string attributes:nil];
        }
    }
    CHSuper1(YYLabel, setAttributedText, attributedText);
}

CHOptimizedMethod1(self, void, DTMessageBaseViewController, receivedMessageNoticeUpdateNotification, id, arg1) {
    if ([DDRConfig shareConfig].canRevokeMsg) {
        return;
    }
    CHSuper1(DTMessageBaseViewController, receivedMessageNoticeUpdateNotification, arg1);
    
}

CHConstructor{
    CHLoadLateClass(YYLabel);
    CHLoadLateClass(DTMessageControllerDataSource);
    CHLoadLateClass(UITabBarController);
    CHLoadLateClass(DTMessageBaseViewController);
    
    CHHook1(YYLabel, setAttributedText);
    CHHook1(DTMessageControllerDataSource, setMessages);
    CHHook0(UITabBarController, viewDidLoad);
    CHHook1(DTMessageBaseViewController, receivedMessageNoticeUpdateNotification);
}
