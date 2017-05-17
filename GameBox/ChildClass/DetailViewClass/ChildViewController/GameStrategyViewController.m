//
//  GameStrategyViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameStrategyViewController.h"
#import "StrategyCell.h"
#import "GameRequest.h"

#import <MJRefresh.h>

#define CELLIDE @"StrategyCell"

@interface GameStrategyViewController ()<UITableViewDataSource,UITableViewDelegate>

/**攻略列表*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数据的数组*/
@property (nonatomic, strong) NSArray *showArray;



@end

@implementation GameStrategyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserinterFace];
}

- (void)initUserinterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - setter
- (void)reloadData {
    _showArray = nil;
    [GameRequest setrategyWIthGameID:_gameID Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            if ([content[@"data"][@"list"] isKindOfClass:[NSNull class]]) {
                _showArray = nil;
            } else {
                _showArray = content[@"data"][@"list"];
            }
        } else {
            _showArray = nil;
        }
        [self.tableView reloadData];
        
    }];
}


#pragma makr - setter
- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self reloadData];
}

- (void)setGameLogo:(UIImage *)gameLogo {
    _gameLogo = gameLogo;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
//    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
    cell.gameLogo.image = _gameLogo;
    
    cell.dict = _showArray[indexPath.row];
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //info_url
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [ControllerManager shareManager].webController.webURL = _showArray[indexPath.row][@"info_url"];
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].webController animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 245) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"StrategyCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}







@end
