//
//  SettingView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SettingView.h"
#import "UserModel.h"
#import "GameRequest.h"
#import <SDWebImageManager.h>
#import <SDImageCache.h>


#define CELLIDE @"SettingCell"

@interface SettingView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSArray *> *showArray;

/** 退出登录 */
@property (nonatomic, strong) UIButton *logoutBtn;

/** 是否打开通知 */
@property (nonatomic, assign) BOOL isOpenNotifi;

/** 缓存大小 */
@property (nonatomic, assign) CGFloat cache;



@end

@implementation SettingView

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //检查是否已经登录
    if ([UserModel CurrentUser]) {
        self.tableView.tableFooterView = self.logoutBtn;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    
    //检查消息通知是否打开
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0f) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (UIUserNotificationTypeNone == setting.types) {
            _isOpenNotifi = NO;
        } else {
            _isOpenNotifi = YES;
        }
    }

    //检查缓存
    _cache = [self folderSizeAtPath:@""];
    
    [self.tableView reloadData];
}

//计算文件大小
- (long long)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            long long size= [self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

//清楚缓存
-(void)clearCache:(NSString *)path {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    cachePath = [cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachePath];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
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
        
    } else {
        [GameRequest showAlertWithMessage:@"仅用WIFI下载已关闭" dismiss:nil];
    }
    SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:sender.on], WIFIDOWNLOAD);
    SAVEOBJECT;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.showArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELLIDE];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = self.showArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UISwitch *wifiSwitch = [[UISwitch alloc] init];
            [wifiSwitch addTarget:self action:@selector(respondsToWifiSwitch:) forControlEvents:(UIControlEventValueChanged)];
            
            NSNumber *isOpen = OBJECT_FOR_USERDEFAULTS(WIFIDOWNLOAD);

            wifiSwitch.on = isOpen.boolValue;
            
            
            cell.accessoryView = wifiSwitch;
            cell.detailTextLabel.text = @"";
        } else if (indexPath.row == 1) {
            cell.accessoryView = nil;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2lfM",_cache];
        }
        
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        if (_isOpenNotifi) {
            cell.detailTextLabel.text = @"已打开";
        } else {
            cell.detailTextLabel.text = @"已关闭";
        }
        cell.accessoryView = nil;
    } else if (indexPath.section == 2) {
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本:%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
        cell.accessoryView = nil;
    }
    
    
    
    return cell;
}

#pragma mark - tableViewDeleagte
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
            label.text = @"    消息通知 : 请在 系统设置 -> 通知 中进行相关设置";
            break;
        case 2:
            label.text = @"    版本";
            break;
        default:
            break;
    }
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self clearCache:@""];
        [self viewWillAppear:YES];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self cheackVersion];
    }
}

//检查版本更新
- (void)cheackVersion {
    [GameRequest chechBoxVersionCompletion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            NSString *update = content[@"data"];
            if ([update isKindOfClass:[NSNull class]]) {
                [GameRequest showAlertWithMessage:@"当前为最新版本" dismiss:nil];
            } else {
                [GameRequest boxUpdateWithUrl:content[@"data"]];
            }
        }
    }];
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
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDE];
        
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
        _showArray = @[@[@"仅使用WiFi下载",
                           @"清空缓存"],
                         @[@"消息通知"],
                         @[@"检测更新"]];
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
