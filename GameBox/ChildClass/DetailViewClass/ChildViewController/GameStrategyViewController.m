//
//  GameStrategyViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameStrategyViewController.h"
#import "StrategyCell.h"

#import "GameModel.h"

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
    
    [GameModel postStrategyWithGameID:_gameID Page:@"1" ChannelID:nil Completion:^(NSDictionary * _Nullable content, BOOL success) {
        
        if ([content[@"data"][@"list"] isKindOfClass:[NSNull class]]) {
            _showArray = nil;
        } else {
            _showArray = content[@"data"][@"list"];
        }
        

        [self.tableView reloadData];
    }];
}


#pragma makr - setter
- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self reloadData];
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

    cell.strategyName.text = _showArray[indexPath.row][@"title"];
    cell.gameName.text = _showArray[indexPath.row][@"gamename"];
    cell.strategyTime.text = _showArray[indexPath.row][@"release_time"];
    cell.strategyAuthor.text = _showArray[indexPath.row][@"author"];

    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"StrategyCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        
    }
    return _tableView;
}







@end
