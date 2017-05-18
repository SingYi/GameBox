//
//  MNNtificationController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MNNtificationController.h"
#import "NewServerTableViewCell.h"
#import "GameRequest.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#define CELLIDE @"NewServerTableViewCell"

@interface MNNtificationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

/** 清除所有通知 */
@property (nonatomic, strong) UIBarButtonItem *clearButton;


@end

@implementation MNNtificationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = self.clearButton;
    _showArray = [[GameRequest notificationRecord] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    [self.view addSubview:self.tableView];
}

/**刷新数据*/
- (void)refreshData {
    _showArray = [[GameRequest notificationRecord] mutableCopy];

    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

/** 加载更多数据 */
- (void)loadMoreData {
    
}

#pragma mark - responds
- (void)respondsToClearButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除所有提醒吗" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [GameRequest deleteAllNotificationRecord];
        [self.tableView.mj_header beginRefreshing];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];
    

    

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - tableView datasource
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

#pragma mark - tabieview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
        {
            
        }
            break;
        case UITableViewCellEditingStyleDelete:
        {
            //修改数据源，在刷新 tableView
            [_showArray removeObjectAtIndex:indexPath.row];
            
            //让表视图删除对应的行
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [GameRequest deleteNotificationRecordWith:indexPath.row];
        }
            break;
        case UITableViewCellEditingStyleInsert:
        {

        }
            break;
            
        default:
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109) style:(UITableViewStylePlain)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"NewServerTableViewCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
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
        
        _tableView.mj_header = customRef;
//        
//        //上拉刷新
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIBarButtonItem *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIBarButtonItem alloc] initWithTitle:@"清除所有记录" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToClearButton)];
    }
    return _clearButton;
}


@end










