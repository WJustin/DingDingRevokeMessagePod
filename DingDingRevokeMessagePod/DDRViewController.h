//
//  DDRViewController.h
//  DingDingDylib
//
//  Created by Justin.wang on 2018/2/7.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRViewController : UIViewController

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
