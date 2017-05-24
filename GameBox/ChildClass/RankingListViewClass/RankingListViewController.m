//
//  RankingListViewController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RankingListViewController.h"
#import "SearchCell.h"
#import "GameRequest.h"
#import "ControllerManager.h"
#import "SearchModel.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDENTIFIER @"SearchCell"

@interface RankingListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SearchCellDelelgate>


/**列表文件*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数据的数组*/
@property (nonatomic, strong) NSMutableArray *showArray;

/** 搜索框 */
@property (nonatomic, strong) UISearchBar *searchBar;

/** 应用按钮(左边按钮) */
@property (nonatomic, strong) UIBarButtonItem *downLoadBtn;

/** 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;

/** 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;

/** 是否加载了全部 */
@property (nonatomic, assign) BOOL isAll;


@property (nonatomic, strong) UISearchController *searchController;



@end

@implementation RankingListViewController


#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.searchBar;
    
    if ( [ControllerManager shareManager].searchViewController.currentParentController != 2) {
        self.navigationItem.rightBarButtonItem = self.messageBtn;
        self.navigationItem.leftBarButtonItem = self.downLoadBtn;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.titleView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSourece];
    [self initUserinterface];
    
    syLog(@"%@",[GameRequest gameWithGameID:@"86"]);

}

/**初始化数据*/
- (void)initDataSourece {
    _currentPage = 1;
    _isAll = NO;
    [self.tableView.mj_header beginRefreshing];

}


/**初始化用户界面*/
- (void)initUserinterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = self.downLoadBtn;
    self.navigationItem.rightBarButtonItem = self.messageBtn;
}

#pragma mark - responsd
/**刷新数据*/
- (void)refreshData {
    [GameRequest rankGameWithhPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            _showArray = [content[@"data"] mutableCopy];
            [self checkLocalGamesWith:_showArray];
            _currentPage = 1;
            _isAll = NO;
            [self.tableView reloadData];
        } else {
//            [GameRequest showAlertWithMessage:@"网络不知道飞到哪里去了" dismiss:nil];
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
        [GameRequest rankGameWithhPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSMutableArray *array = [content[@"data"] mutableCopy];
                if (array.count == 0) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    }];
                    [_showArray addObjectsFromArray:array];
                    [self checkLocalGamesWith:_showArray];
//                    [self.tableView reloadData];
//                    [self.tableView.mj_footer endRefreshing];
                }

            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }
}


- (void)checkLocalGamesWith:(NSMutableArray *)array {
    [AppModel getLocalGamesWithBlock:^(NSArray * _Nullable games, BOOL success) {
        NSArray *localArray = nil;
        if (success) {
            localArray = games;
            for (NSInteger i = 0; i < array.count; i++) {
                for (NSInteger j = 0; j < localArray.count; j++) {
                    if ([array[i][@"ios_pack"] isEqualToString:localArray[j][@"bundleID"]]) {
                        NSMutableDictionary *dict = [array[i] mutableCopy];
                        [dict setObject:@"1" forKey:@"isLocal"];
                        [array replaceObjectAtIndex:i withObject:dict];
                    }
                }
            }
            
        } else {
            localArray = nil;
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - cellDeleagte
- (void)didSelectCellRowAtIndexpath:(NSDictionary *)dict {
    NSString *isLocal = dict[@"isLocal"];
    if ([isLocal isEqualToString:@"1"]) {
        [AppModel openAPPWithIde:dict[@"ios_pack"]];
    } else {
        NSString *url = dict[@"ios_url"];
        
        [GameRequest downLoadAppWithURL:url];
    }
}

/** 我的应用 */
- (void)clickDownloadBtn {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].myAppViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/** 我的消息 */
- (void)clickMessageBtn {
    self.hidesBottomBarWhenPushed = YES;
    if ([UserModel CurrentUser]) {
        [self.navigationController pushViewController:[ControllerManager shareManager].myNewsViewController animated:YES];
    } else {
        [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (void)clickCancelBtn {
    [self.searchBar resignFirstResponder];
    
    self.searchBar.text = @"";
    
    [[ControllerManager shareManager].searchViewController.view removeFromSuperview];
    
    self.navigationItem.rightBarButtonItem = self.messageBtn;
    self.navigationItem.leftBarButtonItem = self.downLoadBtn;
}


#pragma mark - searchDeleagete
//即将开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    self.navigationItem.rightBarButtonItem = self.cancelBtn;
    self.navigationItem.leftBarButtonItem = nil;
    
    [ControllerManager shareManager].searchViewController.currentParentController = 2;
    
    [[ControllerManager shareManager].searchViewController removeFromParentViewController];
    [self.view addSubview:[ControllerManager shareManager].searchViewController.view];
    [self addChildViewController:[ControllerManager shareManager].searchViewController];
    
    
//    [self.view addSubview:[ControllerManager shareManager].searchResultController.view];
    
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

    return YES;
}

//点击cancel按钮的响应事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //点击cancel按钮
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (![searchBar.text isEqualToString:@""]) {
        [SearchModel addSearchHistoryWithKeyword:searchBar.text];
        [ControllerManager shareManager].searchResultController.keyword = searchBar.text;
        [self.navigationController pushViewController:[ControllerManager shareManager].searchResultController animated:YES];
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
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
    
    
    return cell;
}

//返回的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 3)];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    return titleLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [ControllerManager shareManager].detailView.gameID = _showArray[indexPath.row][@"id"];
    
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [ControllerManager shareManager].detailView.gameLogo = cell.gameLogo.image;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 113) style:(UITableViewStylePlain)];
        
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
        
        
        //上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        
        _tableView.tableFooterView = [UIView new];
        
        
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
        _searchBar.backgroundColor = [UIColor clearColor];
        
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        
        _searchBar.tintColor = [UIColor blueColor];
        
        _searchBar.placeholder = @"搜索游戏";
        
        _searchBar.delegate = self;
    }
    return _searchBar;
}


- (UIBarButtonItem *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_download"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickDownloadBtn)];
    }
    return _downLoadBtn;
}

- (UIBarButtonItem *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_message"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMessageBtn)];
    }
    return _messageBtn;
}

- (UIBarButtonItem *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickCancelBtn)];
    }
    return _cancelBtn;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end








