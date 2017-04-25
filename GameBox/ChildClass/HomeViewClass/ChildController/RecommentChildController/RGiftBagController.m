//
//  RGiftBagController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/25.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RGiftBagController.h"
#import "GiftBagCell.h"
#import "GiftBagModel.h"
#import "RecommentTableHeader.h" //滚动轮播图
#import "ControllerManager.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDE @"GiftBagCell"

@interface RGiftBagController ()<UITableViewDataSource,UITableViewDelegate,GiftBagCellDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>

/**< 列表 */
@property (nonatomic, strong) UITableView *tableView;

/**< 显示数据的数组 */
@property (nonatomic, strong) NSMutableArray * showArray;

/**< 滚动轮播图 */
@property (nonatomic, strong) RecommentTableHeader *rollingHeader;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation RGiftBagController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rollingHeader startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.rollingHeader stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
    [GiftBagModel postGiftRollingViewWithChannelID:@"185" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            self.rollingHeader.rollingArray = content[@"data"];
        } else {
            
        }
    }];
}

- (void)initUserInterface {
    self.navigationItem.title = @"礼包";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的礼包" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMineGiftBag)];
}

#pragma mark - search updateing 
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - searchBar delegate
//即将开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //开始搜索
    searchBar.showsCancelButton = YES;
    return YES;
}

//开始搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing");
}

//即将结束搜索
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarShouldEndEditing");
    return YES;
}

//结束搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

//文本已经改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
}

//文编即将改变
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"shouldChangeTextInRange");
    return YES;
}

//点击cancel按钮的响应事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //点击cancel按钮
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
}

#pragma mark - method
- (void)refreshData {
    [GiftBagModel postGiftBagListWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = [content[@"data"][@"list"] mutableCopy];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)clickMineGiftBag {
    NSString *uid = GETUSERID;
    
    if (uid) {
        [self.navigationController pushViewController:[ControllerManager shareManager].myGiftBagView animated:YES];
    } else {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[ControllerManager shareManager].loginViewController animated:YES];
    }
    
}

#pragma mark - cell delelgate
/**< 点击cell的领取按钮的响应事件 */
- (void)getGiftBagCellAtIndex:(NSInteger)idx {
    NSString *str = _showArray[idx][@"card"];

    if ([str isKindOfClass:[NSNull class]]) {
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
        
        if (!uid) {
            uid = @"0";
        }
        
        //领取礼包
        [GiftBagModel postGiftBagWithBagID:_showArray[idx][@"id"] Uid:@"0" Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success) {
                NSMutableDictionary *dict = [_showArray[idx] mutableCopy];
                [dict setObject:content[@"data"] forKey:@"card"];
                [_showArray replaceObjectAtIndex:idx withObject:dict];
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                
                [GiftBagModel showAlertWithMessage:@"已领取礼包兑换码" dismiss:^{
                    
                }];
            }
        }];
        
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = str;
        
        [GiftBagModel showAlertWithMessage:@"已复制礼包兑换码" dismiss:^{
            
        }];
    }
}

#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GiftBagCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.currentIdx = indexPath.row;
    
    cell.name.text = _showArray[indexPath.row][@"pack_name"];
    cell.packCounts.text = _showArray[indexPath.row][@"pack_counts"];
    [cell.packLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"pack_logo"]]] placeholderImage:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *total = _showArray[indexPath.row][@"pack_counts"];
    NSString *current = _showArray[indexPath.row][@"pack_used_counts"];
    CGFloat tc = current.floatValue / total.floatValue;
    
    NSString *tcStr = [NSString stringWithFormat:@"%.0lf%%",(100 - tc * 100)];
    
    cell.titlelabel.text = tcStr;
    
    CGRect rect = cell.packProgress.bounds;
    
    cell.progressView.frame = CGRectMake(0, 0, rect.size.width * tc, rect.size.height);
    
    NSString *str = _showArray[indexPath.row][@"card"];

    if ([str isKindOfClass:[NSNull class]]) {
        [cell.getBtn setTitle:@"领取" forState:(UIControlStateNormal)];
        [cell.getBtn setBackgroundColor:[UIColor orangeColor]];
        [cell.getBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    } else {
        [cell.getBtn setTitle:@"复制" forState:(UIControlStateNormal)];
        [cell.getBtn setBackgroundColor:[UIColor grayColor]];
        [cell.getBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    
    
    
    return cell;
    
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSCREEN_WIDTH * 0.4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBar;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
       [_tableView registerNib:[UINib nibWithNibName:@"GiftBagCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        
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
        
//        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.tableFooterView = [UIView new];
        
    

    }
    return _tableView;
}

- (RecommentTableHeader *)rollingHeader {
    if (!_rollingHeader) {
        _rollingHeader = [[RecommentTableHeader alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.4)];
    }
    return _rollingHeader;
}

/**< 搜索控制器 */
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        
        _searchController.dimsBackgroundDuringPresentation = false;
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.backgroundColor = [UIColor clearColor];
        _searchController.searchBar.placeholder= @"搜索礼包";
        _searchController.searchBar.barStyle = UISearchBarStyleDefault;
        
        //隐藏导航栏
//        _searchController.hidesNavigationBarDuringPresentation = NO;
    }
    return _searchController;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
        
        _searchBar.delegate = self;
    }
    return _searchBar;
}


@end







