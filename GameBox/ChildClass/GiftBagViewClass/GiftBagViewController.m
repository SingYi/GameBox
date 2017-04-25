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

@interface GiftBagViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

/**列表*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数组*/
@property (nonatomic, strong) NSArray *showArray;

/**我的礼包按钮*/
@property (nonatomic, strong) UIBarButtonItem *rightBtn;


@end

@implementation GiftBagViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

/**初始化数据*/
- (void)initDataSource {
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    [GiftBagModel postGiftRollingViewWithChannelID:@"185" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        NSLog(@"%@",content);
    }];

}


/**初始化用户界面*/
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"我的礼包" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightBtn:)];
    
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - respond
/**我的礼包按钮响应事件*/
- (void)respondsToRightBtn:(UITabBarItem *)sender {
    [self.navigationController pushViewController:[ControllerManager shareManager].myGiftBagView animated:YES];
}

/**刷新数据*/
- (void)refreshData {
    [GiftBagModel postGiftBagListWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"list"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
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
    

    
    cell.name.text = _showArray[indexPath.row][@"pack_name"];
    cell.packCounts.text = _showArray[indexPath.row][@"pack_counts"];
    [cell.packLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"pack_logo"]]] placeholderImage:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80;
}

#pragma mark - tableViewDeleagate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    searchBar.delegate = self;
    
    return searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
//    NSLog( @"%@",searchBar.text);
    
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
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
        
        
    }
    return _tableView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
