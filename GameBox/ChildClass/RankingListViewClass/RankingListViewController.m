//
//  RankingListViewController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RankingListViewController.h"
#import "SearchCell.h"
#import "GameModel.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDENTIFIER @"SearchCell"

@interface RankingListViewController ()<UITableViewDelegate,UITableViewDataSource>


/**列表文件*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数据的数组*/
@property (nonatomic, strong) NSArray *showArray;


@end

@implementation RankingListViewController


#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSourece];
    [self initUserinterface];
}

/**初始化数据*/
- (void)initDataSourece {
    
    [self.tableView.mj_header beginRefreshing];

}


/**初始化用户界面*/
- (void)initUserinterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"排行榜";
    [self.view addSubview:self.tableView];
}
#pragma mark - responsd
/**刷新数据*/
- (void)refreshData {
    [GameModel postGameListWithType:RankingGame ChannelID:@"185" Page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
    
    
    return cell;
}

//返回的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        //下拉刷新
        MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        [customRef setTitle:@"数据已加载" forState:MJRefreshStateIdle];
        [customRef setTitle:@"刷新数据" forState:MJRefreshStatePulling];
        [customRef setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        [customRef setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
        [customRef setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
        
        
        //自动更改透明度
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        
        [customRef.lastUpdatedTimeLabel setText:@"0"];
        
        _tableView.mj_header = customRef;
        
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
