//
//  HCDetailController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HCDetailController.h"
#import "SearchCell.h"
#import "GameRequest.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define CELLIDENTIFIER @"SearchCell"

@interface HCDetailController ()<UITableViewDataSource,UITableViewDelegate,SearchCellDelelgate>

@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, strong) UITableView *tableView;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isAll;

@end

@implementation HCDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    _showArray = nil;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - method
- (void)refreshData {
    [GameRequest ClassifyWithID:_dict[@"id"] Page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            _showArray = [content[@"data"] mutableCopy];
            _currentPage = 1;
            _isAll = NO;
            [self.tableView reloadData];
            
        } else {
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    if (_isAll) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
        [GameRequest ClassifyWithID:_dict[@"id"] Page:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSArray *array = content[@"data"];
                if (array == nil || array.count == 0) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_showArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
 
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}

#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    
    cell.delegate = self;
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [ControllerManager shareManager].detailView.gameID = _showArray[indexPath.row][@"id"];
    
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [ControllerManager shareManager].detailView.gameLogo = cell.gameLogo.image;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - cellDelegate
- (void)didSelectCellRowAtIndexpath:(NSDictionary *)dict {
    
    
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    if (dict != nil && ![dict[@"id"] isEqualToString:_dict[@"id"]]) {
        _showArray = nil;
        _dict = dict;
        self.navigationItem.title = dict[@"name"];
        [self.tableView.mj_header beginRefreshing];
    } else {
        
    }
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 113) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
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
        
        _tableView.mj_header = customRef;
        
        //上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}

@end








