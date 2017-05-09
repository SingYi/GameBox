//
//  SettingView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SettingView.h"
#import "UserModel.h"

#define CELLIDE @"SettingCell"

@interface SettingView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSArray *> *showArray;

/** 退出登录 */
@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation SettingView

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserModel CurrentUser]) {
        self.tableView.tableFooterView = self.logoutBtn;
    } else {
        self.tableView.tableFooterView = [UIView new];
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
- (void)respondsToLogoutBtn {
    [UserModel logOut];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
    cell.textLabel.text = self.showArray[indexPath.section][indexPath.row];
    
    cell.accessoryView = [[UISwitch alloc]init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

#pragma mark - tableViewDeleagte
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 20)];
    
    label.backgroundColor = [UIColor orangeColor];
    
    label.font = [UIFont systemFontOfSize:12];
    
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
        _showArray = @[@[@"仅使用WiFi下载",
                         @"清空缓存"],
                       @[@"开启消息通知"],
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
