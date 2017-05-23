//
//  NSTodayServerController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/15.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "NSTodayServerController.h"
#import "NewServerTableViewCell.h"
#import "ControllerManager.h"

#import "GameRequest.h"
#import <MJRefresh.h>

#define CELLIDE @"NewServerTableViewCell"

@interface NSTodayServerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isAll;

@end

@implementation NSTodayServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - method
- (void)refreshData {
    [GameRequest todayServerOpenWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
//        syLog(@"%@",content);
        if (success && REQUESTSUCCESS) {
            _showArray = [content[@"data"] mutableCopy];
            _currentPage = 1;
            _isAll = NO;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
            _currentPage = 0;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    if (_isAll || _currentPage == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
        [GameRequest todayServerOpenWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSArray *array = content[@"data"];
                if (array.count == 0 || array == nil) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_showArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
            } else {
                _isAll = YES;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.showArray[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    
    cell.dict = self.showArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    
    [ControllerManager shareManager].detailView.gameID = self.showArray[indexPath.row][@"id"];
    
    NewServerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [ControllerManager shareManager].detailView.gameLogo = cell.gameLogo.image;
    
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
//    self.parentViewController.hidesBottomBarWhenPushed = NO;

    
}


#pragma makr - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"NewServerTableViewCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
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
