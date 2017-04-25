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
#import "RGiftBagController.h"
#import "StrategyController.h"

#import "RequestUtils.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define CELLIDENTIFIER @"SearchCell"
#define BTNTAG 1300

@interface HomeRecommentController ()<UITableViewDelegate,UITableViewDataSource,SearchCellDelelgate>

/**推荐游戏列表*/
@property (nonatomic, strong) UITableView *tableView;
/**推荐游戏数据*/
@property (nonatomic, strong) NSMutableArray *showArray;
/**轮播图*/
@property (nonatomic, strong) RecommentTableHeader *rollHeader;
/**头部视图*/
@property (nonatomic, strong) UIView *headerView;

/**开服表*/
@property (nonatomic, strong) NewServerController *rNewServerController;
/**活动*/
@property (nonatomic, strong) ActivityController *rActivityController;
/**礼包*/
@property (nonatomic, strong) RGiftBagController *rGiftBagController;
/**攻略*/
@property (nonatomic, strong) StrategyController *rStrategyController;

/**子视图数组*/
@property (nonatomic, strong) NSArray<UIViewController *> * childControllers;

/**< 总共的页数 */
@property (nonatomic, assign) NSInteger totalPage;

/**< 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation HomeRecommentController

#pragma mark - life cycle
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
    _childControllers = @[self.rNewServerController,self.rActivityController,self.rGiftBagController,self.rStrategyController];
    
    //刷新视图
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

#pragma mkar - method
/**< 根据页面数和渠道请求数据 */
- (void)getDataWithChannelID:(NSString *)channelID Page:(NSString *)page {
    [GameModel postRecommendGameListWithChannelID:channelID Page:page Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = [content[@"data"][@"gamelist"] mutableCopy];
        self.rollHeader.rollingArray = content[@"data"][@"banner"];
        [self.tableView reloadData];
    }];
}

/**刷新数据*/
- (void)refreshData {
    [GameModel postRecommendGameListWithChannelID:@"185" Page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = [content[@"data"][@"gamelist"] mutableCopy];
        self.rollHeader.rollingArray = content[@"data"][@"banner"];
        [self.tableView.mj_header endRefreshing];
        _currentPage = 1;
        [self.tableView reloadData];
    }];
}

/**< 加载更多数据 */
- (void)loadMoreData {
    _currentPage++;
    [GameModel postRecommendGameListWithChannelID:@"185" Page:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
        NSLog(@"%@",content);
        _showArray = [content[@"data"][@"gamelist"] mutableCopy];
        [self.tableView.mj_footer endRefreshing];

        [self.tableView reloadData];
    }];
    
//    [self.tableView.mj_footer endRefreshing];
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
    
    cell.selectIndex = indexPath.row;
    
    cell.delegate = self;
    
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
/**< 按钮的响应事件(推送出子视图) */
- (void)respondsToBtn:(UIButton *)sender {
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.childControllers[sender.tag - BTNTAG] animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}

#pragma mark - cellDelegete
/**< cell的代理  */
- (void)didSelectCellRowAtIndexpath:(NSInteger)idx {
    NSLog(@"下载第 %ld 游戏",idx);

}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 145) style:(UITableViewStylePlain)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
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
        
        //上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


/**< 滚动轮播图 */
- (RecommentTableHeader *)rollHeader {
    if (!_rollHeader) {
        _rollHeader = [[RecommentTableHeader alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.4)];
    }
    return _rollHeader;
}

/**< tableview的头部视图 */
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618)];
        
        //添加滚动轮播图
        [_headerView addSubview:self.rollHeader];

        //添加子视图跳转的按钮
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

/**< 新服视图 */
- (NewServerController *)rNewServerController {
    if (!_rNewServerController) {
        _rNewServerController = [NewServerController new];
    }
    return _rNewServerController;
}

/**< 活动视图 */
- (ActivityController *)rActivityController {
    if (!_rActivityController) {
        _rActivityController = [ActivityController new];
    }
    return _rActivityController;
}


/**< 礼包视图 */
- (RGiftBagController *)rGiftBagController {
    if (!_rGiftBagController) {
        _rGiftBagController = [RGiftBagController new];
    }
    return _rGiftBagController;
}

/**< 攻略视图 */
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



@end










