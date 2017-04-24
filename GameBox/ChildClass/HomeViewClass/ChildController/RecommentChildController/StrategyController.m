//
//  StrategyController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "StrategyController.h"
#import "StrategyCell.h"
#import "ActivityModel.h"

#define CELLIDE @"StrategyCell"

@interface StrategyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;

@property (nonatomic, strong) UISearchController *searchBar;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation StrategyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [ActivityModel postWithType:StrategList Page:@"1" ChannelId:@"185" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"list"];
        NSLog(@"%@",content);
        [self.tableView reloadData];

    }];

}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"攻略";

    [self.view addSubview:self.tableView];

}

#pragma mark - method
- (void)refresh {
    if (self.refreshControl.isRefreshing){
//        [self.modelArray removeAllObjects];//清除旧数据，每次都加载最新的数据
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];


        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDE];
        [_tableView registerNib:[UINib nibWithNibName:@"StrategyCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        
//        _tableView.refreshControl = self.refreshControl;
    }
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl= [[UIRefreshControl alloc]init];
        _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新数据"];
        [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//        [_refreshControl beginRefreshing];
    }
    return _refreshControl;
}

- (UISearchController *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchController alloc] initWithSearchResultsController:self];
        
        
    }
    return _searchBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
