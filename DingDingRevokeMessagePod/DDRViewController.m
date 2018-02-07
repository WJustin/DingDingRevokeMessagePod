//
//  DDRViewController.m
//  DingDingDylib
//
//  Created by Justin.wang on 2018/2/7.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDRViewController.h"
#import "DDRConfig.h"

static NSString * const DDRTableViewCellId = @"DDRTableViewCell";

@interface DDRTableViewCell : UITableViewCell

@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, copy) void (^didSwitchBlock)(void);

@end

@implementation DDRTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.switchButton.center = CGPointMake(self.frame.size.width - 40, self.contentView.center.y);
    self.switchButton.bounds = CGRectMake(0, 0, 60, 30);
}

- (void)didSwitch {
    if (self.didSwitchBlock) {
        self.didSwitchBlock();
    }
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchButton addTarget:self
                          action:@selector(didSwitch)
                forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchButton];
    }
    return _switchButton;
}

@end

static NSString * const UITableViewCellId = @"UITableViewCell";

@interface DDRViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DDRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"设置";
    UIBarButtonItem *close= [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]
                         forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = close;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DDRTableViewCell class] forCellReuseIdentifier:DDRTableViewCellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDRTableViewCellId];
    cell.textLabel.text = @"防撤回";
    [cell.switchButton setOn:[DDRConfig shareConfig].canRevokeMsg];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDidSwitchBlock:^{
        [DDRConfig shareConfig].canRevokeMsg = ![DDRConfig shareConfig].canRevokeMsg;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
