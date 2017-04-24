//
//  HomeRecommentController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HomeRecommentController.h"
#import "RecommentTableHeader.h"
#import "SearchCell.h"
#import "GameModel.h"
#import "ControllerManager.h"

#import "NewServerController.h"
#import "ActivityController.h"
#import "GiftBagViewController.h"
#import "StrategyController.h"

#import "RequestUtils.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define CELLIDENTIFIER @"SearchCell"
#define BTNTAG 1300

@interface HomeRecommentController ()<UITableViewDelegate,UITableViewDataSource>

/**推荐游戏列表*/
@property (nonatomic, strong) UITableView *tableView;
/**推荐游戏数据*/
@property (nonatomic, strong) NSArray *showArray;
/**轮播图*/
@property (nonatomic, strong) RecommentTableHeader *rollHeader;
/**头部视图*/
@property (nonatomic, strong) UIView *headerView;

/**开服表*/
@property (nonatomic, strong) NewServerController *rNewServerController;
/**活动*/
@property (nonatomic, strong) ActivityController *rActivityController;
/**礼包*/
@property (nonatomic, strong) GiftBagViewController *rGiftBagController;
/**攻略*/
@property (nonatomic, strong) StrategyController *rStrategyController;

/**子视图数组*/
@property (nonatomic, strong) NSArray<UIViewController *> * childControllers;




@end

@implementation HomeRecommentController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rollHeader startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rollHeader stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {

    [GameModel postRecommendGameListWithChannelID:@"185" Page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"gamelist"];
        self.rollHeader.rollingArray = content[@"data"][@"banner"];
        [self.tableView reloadData];
//        NSLog(@"首页 ============================ %@",content[@"data"][@"banner"]);
    }];

    _childControllers = @[self.rNewServerController,self.rActivityController,self.rGiftBagController,self.rStrategyController];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

#pragma mkar - method
- (void)getDataWithChannelID:(NSString *)channelID Page:(NSString *)page {
    [GameModel postRecommendGameListWithChannelID:channelID Page:page Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"gamelist"];
        self.rollHeader.rollingArray = content[@"data"][@"banner"];
        [self.tableView reloadData];
    }];
}

/**刷新数据*/
- (void)refreshData {
    [GameModel postRecommendGameListWithChannelID:@"185" Page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"gamelist"];
        self.rollHeader.rollingArray = content[@"data"][@"banner"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
//    NSLog(@"刷新数据");
}



#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.9344.net%@",_showArray[indexPath.row][@"logo"]]]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    [ControllerManager shareManager].detailView.gameID = self.showArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}

#pragma mark - respondsToBtn
- (void)respondsToBtn:(UIButton *)sender {
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.childControllers[sender.tag - BTNTAG] animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 145) style:(UITableViewStylePlain)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [UIColor blackColor];
        
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
        
        //进入刷新状态
        [_tableView.mj_header beginRefreshing];

        //上拉刷新
//        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
//        //结束头部刷新
//        [weakSelf.tableView.mj_header endRefreshing];
//        
//        //结束尾部刷新
//        [weakSelf.tableView.mj_footer endRefreshing];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



- (RecommentTableHeader *)rollHeader {
    if (!_rollHeader) {
        _rollHeader = [[RecommentTableHeader alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.4)];
    }
    return _rollHeader;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618)];
        [_headerView addSubview:self.rollHeader];

        NSArray *array = @[@"开服表",@"活动",@"礼包",@"攻略"];
        NSArray *imageArray = @[@"homePage_newServer",@"homePage_rankList",@"homePage_giftBag",@"homePage_strategy"];
        [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            button.frame = CGRectMake(kSCREEN_WIDTH / 4 * idx, kSCREEN_WIDTH * 0.4, kSCREEN_WIDTH / 4, kSCREEN_WIDTH * 0.218);
            
            [button setTitle:obj forState:(UIControlStateNormal)];
            
            [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
            
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
            
            [button setImage:[UIImage imageNamed:imageArray[idx]] forState:(UIControlStateNormal)];
            
            button.titleLabel.backgroundColor = button.backgroundColor;
            button.imageView.backgroundColor = button.backgroundColor; CGSize titleSize = button.titleLabel.bounds.size;
            CGSize imageSize = button.imageView.bounds.size;
            CGFloat interval = 1.0;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
            
            button.tag = idx + BTNTAG;
            
            [button addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [_headerView addSubview:button];
            
            
        }];
        
    }
    return _headerView;
}

- (NewServerController *)rNewServerController {
    if (!_rNewServerController) {
        _rNewServerController = [NewServerController new];
    }
    return _rNewServerController;
}

- (ActivityController *)rActivityController {
    if (!_rActivityController) {
        _rActivityController = [ActivityController new];
    }
    return _rActivityController;
}

- (GiftBagViewController *)rGiftBagController {
    if (!_rGiftBagController) {
        _rGiftBagController = [GiftBagViewController new];
    }
    return _rGiftBagController;
}

- (StrategyController *)rStrategyController {
    if (!_rStrategyController) {
        _rStrategyController = [StrategyController new];
    }
    return _rStrategyController;
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
