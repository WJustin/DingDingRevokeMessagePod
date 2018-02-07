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

@interface YYLabel

@property (nonatomic) NSString *text;
@property (nonatomic) NSAttributedString *attributedText;

@end

@interface WKBizMessage

@property(nonatomic) BOOL isMine;
@property(nonatomic) long long recallStatus;

@end

@interface DTBizMessage

@property(nonatomic) long long senderId;
@property(copy, nonatomic) NSString *localMid;
@property(nonatomic) long long mId;
@property(nonatomic) long long attachmentsType; //1
@property(nonatomic) unsigned long long sendStatus; // 0
@property(nonatomic) unsigned long long isDecrypt; // 0 正常 2废弃（你撤回了一条消息）
@property(nonatomic) long long recallStatus;
@property(nonatomic) long long createdTime;
@property(copy, nonatomic) NSString *content;
@property(nonatomic) _Bool isMine;

@end

@interface DTMessageControllerDataSource

@property (nonatomic) NSArray<DTBizMessage *> *messages;

@end

@interface DTMessagePerformBatchManager

@property (nonatomic) NSArray<DTBizMessage *> *messages;

@end

@interface DTMessageBaseViewController

@property(retain, nonatomic) DTMessageControllerDataSource *dataSource;
- (void)receivedMessageNoticeUpdateNotification:(id)arg1;
- (void)viewWillAppear:(BOOL)arg1;

@end

CHDeclareClass(DTMessageControllerDataSource)
CHDeclareClass(DTMessageBaseViewController)
CHDeclareClass(YYLabel)

CHOptimizedMethod1(self, void, DTMessageControllerDataSource, setMessages, NSArray<DTBizMessage *> *, messages) {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    __block DTBizMessage *preMessage;
    [messages enumerateObjectsUsingBlock:^(DTBizMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.recallStatus > 0) {
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
}

CHOptimizedMethod1(self, void, YYLabel, setAttributedText, NSAttributedString *, attributedText) {
    if ([attributedText.string containsString:@"撤回了一条消息"] &&
        ![attributedText.string containsString:@"已阻止"]) {
        attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"已阻止%@", attributedText.string] attributes:nil];
    }
    CHSuper1(YYLabel, setAttributedText, attributedText);
}

CHOptimizedMethod1(self, void, DTMessageBaseViewController, receivedMessageNoticeUpdateNotification, id, arg1) {
    //   NSNotification *notify = (NSNotification *)arg1;
    //   WKBizMessage *message = [notify.userInfo[@"WKUserInfoMessagesKey"] firstObject];
    //   message.recallStatus = 0;
    //   CHSuper1(DTMessageBaseViewController, receivedMessageNoticeUpdateNotification, arg1);
}

CHConstructor{
    CHLoadLateClass(YYLabel);
    CHLoadLateClass(DTMessageControllerDataSource);
    CHLoadLateClass(DTMessageBaseViewController);
    CHHook1(DTMessageBaseViewController, receivedMessageNoticeUpdateNotification);
    CHHook1(DTMessageControllerDataSource, setMessages);
    CHHook1(YYLabel, setAttributedText);
}

