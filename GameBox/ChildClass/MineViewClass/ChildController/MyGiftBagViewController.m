//
//  MyGiftBagViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyGiftBagViewController.h"
#import "GiftBagCell.h"

#import "GiftRequest.h"
#import "UserModel.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#define CELLIDE @"GiftBagCell"

@interface MyGiftBagViewController ()<UITableViewDelegate,UITableViewDataSource,GiftBagCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

@end

@implementation MyGiftBagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    
    [GiftRequest userGiftListWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            _showArray = [content[@"data"][@"list"] mutableCopy];
            [self.tableView reloadData];
        } else {
            
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的礼包";
    [self.view addSubview:self.tableView];
}


#pragma mark - cellDelegate
/**< 点击cell的领取按钮的响应事件 */
- (void)getGiftBagCellAtIndex:(NSInteger)idx {
    NSString *str = _showArray[idx][@"card"];
    
    if ([str isKindOfClass:[NSNull class]]) {
        
        
        
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = str;
        
        [GiftRequest showAlertWithMessage:@"已复制礼包兑换码" dismiss:nil];
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
    
    GiftBagCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    cell.currentIdx = indexPath.row;
    
    //礼包logo
    [cell.packLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"pack_logo"]]] placeholderImage:nil];
    
    cell.dict = _showArray[indexPath.row];
    
    
    return cell;
}

#pragma mark - tableVeiwDeleagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"GiftBagCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
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
        
        
        
        
        
        
        
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
