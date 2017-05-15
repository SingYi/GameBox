//
//  StrategyController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "StrategyController.h"
#import "StrategyCell.h"
#import "GDLikesTableViewCell.h"
#import "GameRequest.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDE @"StrategyCell"
#define HOTCELLIDE @"GDLikesTableViewCell"

@interface StrategyController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

/** 搜索结果数组 */
@property (nonatomic, strong) NSMutableArray *resultArray;
/** 请求数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 热门游戏数组 */
@property (nonatomic, strong) NSArray *hotGameArray;

/** 取消搜索按钮 */
@property (nonatomic, strong) UIBarButtonItem *cancelSearchBtn;

/** 当前下载页 */
@property (nonatomic, assign) NSInteger currentPage;

/** 是否下载全部 */
@property (nonatomic, assign) BOOL isAll;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation StrategyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"攻略";

    [self.view addSubview:self.tableView];

}

#pragma mark - method
/** 刷新数据 */
- (void)refreshData {
    [GameRequest setrategyWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        syLog(@"%@",content);
        if (success && REQUESTSUCCESS) {
            _currentPage = 1;
            _isAll = NO;
            _dataArray = [content[@"data"][@"list"] mutableCopy];
            _showArray = _dataArray;
            _hotGameArray = content[@"data"][@"hot_game"];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
            _currentPage = 0;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 加载数据 */
- (void)loadMoreData {
    if (_isAll || _currentPage == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
        [GameRequest setrategyWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSArray *array = content[@"data"][@"list"];
                if (array.count == 0) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_showArray addObjectsFromArray:array];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.showArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            GDLikesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HOTCELLIDE];
            
            cell.array = self.hotGameArray;
            
            return cell;
        }
        
        case 1: {
            StrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
        
            [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
            
            cell.dict = _showArray[indexPath.row];
            
            return cell;
            
        }
        default:
            return  nil;
    }
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 100;
        default:
            return 150;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, 40)];
    
    label.backgroundColor = [UIColor whiteColor];
    switch (section) {
        case 0: {
            label.text = @"    热门游戏圈";
            break;
        }
            
        case 1: {
            label.text = @"    游戏攻略";
            break;
        }
            
        default:
            break;
    }
    
    
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [ControllerManager shareManager].webController.webURL = _showArray[indexPath.row][@"info_url"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].webController animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - searchBar delegate
//即将开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //开始搜索
    
    self.navigationItem.rightBarButtonItem = self.cancelSearchBtn;

    self.tableView.mj_footer = nil;
    self.tableView.mj_header = nil;
    
    
    return YES;
}

//开始搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

//即将结束搜索
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

//结束搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

//文本已经改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

//文编即将改变
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    NSLog(@"shouldChangeTextInRange");
    return YES;
}

//点击cancel按钮的响应事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //点击cancel按钮
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
//        [self clickCancelSearchBtn];
        searchBar.returnKeyType = UIReturnKeyContinue;
    }
    
    [GameRequest searchStrategyWithKeyword:searchBar.text Page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            _resultArray = content[@"data"][@"list"];
            
            if (_resultArray.count != 0) {
                _showArray = [_resultArray mutableCopy];
                [self.tableView reloadData];
            } else {
                [GameRequest showAlertWithMessage:@"未查询到相关资讯" dismiss:nil];
            }
        } else {
            [GameRequest showAlertWithMessage:@"网络不知道飞到哪里去了" dismiss:nil];
        }
    }];

    [searchBar resignFirstResponder];
}


- (void)clickCancelSearchBtn {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    _showArray = [_dataArray mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"StrategyCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GDLikesTableViewCell" bundle:nil] forCellReuseIdentifier:HOTCELLIDE];
        
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
        
        _tableView.tableHeaderView = self.searchBar;
        _tableView.tableFooterView = [UIView new];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;

    }
    return _tableView;
}


- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        _searchBar.placeholder = @"搜索攻略";
        
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            
            searchField.layer.masksToBounds = YES;
        }
        
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIBarButtonItem *)cancelSearchBtn {
    if (!_cancelSearchBtn) {
        _cancelSearchBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消搜索" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickCancelSearchBtn)];
    }
    return _cancelSearchBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
