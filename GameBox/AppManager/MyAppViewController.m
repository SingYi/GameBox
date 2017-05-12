//
//  MyAppViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyAppViewController.h"
#import "AppModel.h"
#import "MyGamesCell.h"

#define CELLIDE @"MyGamesCell"

@interface MyAppViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 游戏列表 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MyAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initDataSource {
    
    [AppModel getLocalGamesWithBlock:^(NSArray * _Nullable games, BOOL success) {
//        syLog(@"%@",games);
        if (success) {
            _showArray = games;
        } else {
            _showArray = nil;
        }
        [self.tableView reloadData];
    }];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的游戏";
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    

    NSDictionary *dict = _showArray[indexPath.row];
    
    cell.gameLogoImage = dict[@"appIcon"];
    cell.gameVersionText = dict[@"shortVersionString"];
    cell.gameNameText = dict[@"localizedName"];
    NSNumber *size = dict[@"size"];
    cell.gameSizeText = [NSString stringWithFormat:@"%.2fM",size.floatValue / 1024 / 1024];
//    NSLog(@"%@",dict);
    
    NSProgress *progress = dict[@"installProgress"];
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",progress.localizedDescription];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //打开app
    [AppModel openAPPWithIde:_showArray[indexPath.row][@"bundleID"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - cell delegeta
- (void)didSelectCellRowAtIndexpath:(NSDictionary *)dict {
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyGamesCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}







@end









