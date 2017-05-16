//
//  SettingView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SettingView.h"
#import "UserModel.h"
#import <UserNotifications/UserNotifications.h>
#define CELLIDE @"SettingCell"

@interface SettingView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSArray *> *showArray;

/** 退出登录 */
@property (nonatomic, strong) UIButton *logoutBtn;

/** 是否打开通知 */
@property (nonatomic, assign) BOOL isOpenNotifi;

@end

@implementation SettingView

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserModel CurrentUser]) {
        self.tableView.tableFooterView = self.logoutBtn;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0f) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (UIUserNotificationTypeNone == setting.types) {
            _isOpenNotifi = NO;
            syLog(@"1");
        } else {
            _isOpenNotifi = YES;
                     syLog(@"2");
        }
        [self.tableView reloadData];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterFace];
    
}

- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    
    [self.view addSubview:self.tableView];
}

#pragma mark - responds
/** 退出登录 */
- (void)respondsToLogoutBtn {
    [UserModel logOut];
    self.tableView.tableFooterView = [UIView new];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [UserModel showAlertWithMessage:@"退出登录" dismiss:nil];
}

- (void)respondsToWifiSwitch:(UISwitch *)sender {
    if (sender.on) {
        syLog(@"wifi打开");
    } else {
        syLog(@"wifi关闭");
    }
}

- (void)respondsToNotificationSwitch:(UISwitch *)sender {
    if (sender.on) {
        syLog(@"消息打开");
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == YES) {
                SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:granted], NOTIFICATIONSETTING);
            } else {
                SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], NOTIFICATIONSETTING);
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
    } else {
        syLog(@"消息关闭");
    }
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray[_isOpenNotifi].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.showArray[_isOpenNotifi][section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber *number = OBJECT_FOR_USERDEFAULTS(NOTIFICATIONSETTING);
    
    cell.textLabel.text = self.showArray[number.integerValue][indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UISwitch *wifiSwitch = [[UISwitch alloc] init];
        [wifiSwitch addTarget:self action:@selector(respondsToWifiSwitch:) forControlEvents:(UIControlEventValueChanged)];
        cell.accessoryView = wifiSwitch;
        cell.detailTextLabel.text = @"";
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        UISwitch *wifiSwitch = [[UISwitch alloc] init];
        [wifiSwitch addTarget:self action:@selector(respondsToNotificationSwitch:) forControlEvents:(UIControlEventValueChanged)];
        
        if (_isOpenNotifi) {
            wifiSwitch.on = YES;
        } else {
            wifiSwitch.on = NO;
        }
        cell.accessoryView = wifiSwitch;
        cell.detailTextLabel.text = @"";
    } else {
        
        cell.accessoryView = nil;
    }
    
    
    
    return cell;
}

#pragma mark - tableViewDeleagte
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 30)];
    
    label.backgroundColor = [UIColor lightGrayColor];
    
    label.font = [UIFont systemFontOfSize:13];
    
    switch (section) {
        case 0:
            label.text = @"    通用";
            break;
        case 1:
            label.text = @"    消息管理";
            break;
        case 2:
            label.text = @"    版本";
            break;
        default:
            break;
    }
    return label;
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDE];
        
        _tableView.tableFooterView = [UIView new];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        

    }
    return _tableView;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _logoutBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        _logoutBtn.backgroundColor = RGBCOLOR(247, 247, 247);
        [_logoutBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [_logoutBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        [_logoutBtn addTarget:self action:@selector(respondsToLogoutBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _logoutBtn;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@[@[@"仅使用WiFi下载",
                           @"清空缓存"],
                         @[@"开启消息通知"],
                         @[@"检测更新"]],
                       @[@[@"仅使用WiFi下载",
                           @"清空缓存"],
                         @[@"开启消息通知",@"声音",@"震动"],
                         @[@"检测更新"]]];
    }
    return _showArray;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
