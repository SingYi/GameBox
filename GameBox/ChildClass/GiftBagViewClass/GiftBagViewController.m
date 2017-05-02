//
//  GiftBagViewController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GiftBagViewController.h"
#import "ControllerManager.h"
#import "GiftBagCell.h"
#import "GiftBagModel.h"
#import "RequestUtils.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>


#define CELLIDENTIFIER @"GiftBagCell"

@interface GiftBagViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GiftBagCellDelegate>

/**列表*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数组*/
@property (nonatomic, strong) NSMutableArray *showArray;

/**我的礼包按钮*/
@property (nonatomic, strong) UIBarButtonItem *rightBtn;

/**< 搜索 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**< 应用按钮(左边按钮) */
@property (nonatomic, strong) UIBarButtonItem *downLoadBtn;

/**< 消息按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *messageBtn;

/**< 取消按钮(右边按钮) */
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;


@end

@implementation GiftBagViewController

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.searchBar;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.titleView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

/**初始化数据*/
- (void)initDataSource {
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    

}


/**初始化用户界面*/
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.navigationItem.leftBarButtonItem = self.downLoadBtn;
    self.navigationItem.rightBarButtonItem = self.messageBtn;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - respond
- (void)clickDownloadBtn {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].myAppViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)clickMessageBtn {
    
}

- (void)clickCancelBtn {
    
}


/**刷新数据*/
- (void)refreshData {
    [GiftBagModel postGiftBagListWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = [content[@"data"][@"list"] mutableCopy];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}


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





#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GiftBagCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    

    cell.delegate = self;
    cell.currentIdx = indexPath.row;
    
    //礼包名称
    cell.name.text = _showArray[indexPath.row][@"pack_name"];
    //礼包数量
    cell.packCounts.text = _showArray[indexPath.row][@"pack_counts"];
    //礼包logo
    [cell.packLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"pack_logo"]]] placeholderImage:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *total = _showArray[indexPath.row][@"pack_counts"];
    NSString *current = _showArray[indexPath.row][@"pack_used_counts"];
    CGFloat tc = current.floatValue / total.floatValue;
    

    NSString *tcStr = [NSString stringWithFormat:@"%.02f%%",(100.f - tc * 100.f)];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80;
}

#pragma mark - tableViewDeleagate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
////    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
//    searchBar.delegate = self;
//    
//    return searchBar;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 44;
//}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
//    NSLog( @"%@",searchBar.text);
    
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GiftBagCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
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
        
        _tableView.tableFooterView = [UIView new];
        
        
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
        //        [_searchBar sizeToFit];
        
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        
        //        _searchBar.backgroundColor = [UIColor blackColor];
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
