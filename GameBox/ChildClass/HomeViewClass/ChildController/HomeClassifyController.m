//
//  HomeClassifyController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HomeClassifyController.h"
#import "GDLikesTableViewCell.h"
#import "HCDetailController.h"

#import "GameRequest.h"

#import <SDWebImageDownloader.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "ControllerManager.h"

#import <MJRefresh.h>

#define CellIDE @"GDLikesTableViewCell"

#define BTNTAG 1700
#define SECTIONTAG 2700


@interface HomeClassifyController ()<UITableViewDelegate,UITableViewDataSource,GDLikesTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 分类详情 */
@property (nonatomic, strong) HCDetailController *detailController;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *showArray;

/** 分类数组 */
@property (nonatomic, strong) NSMutableArray *classifyArray;

/** 头部视图 */
@property (nonatomic, strong) UIView *headerView;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isAll;

@end

@implementation HomeClassifyController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    [self.view addSubview:self.tableView];
}

#pragma mark - method
- (void)refreshData {
    WeakSelf;
    [GameRequest gameClassifyWithPage:@"1" Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            self.classifyArray = [content[@"data"][@"class"] mutableCopy];
            NSArray *array = content[@"data"][@"classData"];
            _showArray = [NSMutableArray array];
            
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *list = obj[@"list"];
                if (list.count == 0 || list == nil) {
                    
                } else {
                    [_showArray addObject:obj];
                }
            }];

            [self.tableView reloadData];
        } else {
            self.classifyArray = nil;
            _showArray = nil;
        }
        
        if (_showArray && _showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }
        
        
        if (weakSelf.classifyArray.count > 0) {
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        } else {
            weakSelf.tableView.tableHeaderView = nil;
        }

        [self.tableView.mj_header endRefreshing];
    }];
}



#pragma makr - setter
- (void)setClassifyArray:(NSMutableArray *)classifyArray {
    
    if (classifyArray) {
        _classifyArray = classifyArray;
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_classifyArray.count];
        
        [_classifyArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *string = obj[@"name"];
            [titleArray addObject:string];
        }];
        
        CGFloat height = titleArray.count / 4.f;
        NSInteger height1 = height;
        
        if (height > height1) {
            height1++;
        }
        
        self.headerView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH / 4 * height1);
        
        self.headerView.backgroundColor = RGBCOLOR(247, 247, 247);
        
        [_classifyArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *title = obj[@"name"];
            
//            背景视图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 4 * (idx % 4), kSCREEN_WIDTH / 4 * (idx / 4), kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4 )];
            view.backgroundColor = RGBCOLOR(247, 247, 247);
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 8);
            button.center = CGPointMake(kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 9);

            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,obj[@"logo"]]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"image_downloading"]];
            
            button.tag = idx + BTNTAG;
            
            [button addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 20);
            label.center = CGPointMake(kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 24 * 5);

            label.text = title;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:button];
            [view addSubview:label];
            [self.headerView addSubview:view];
        }];
    } else {
        self.headerView = nil;
    }
    
}

/** 按钮响应事件 */
- (void)respondsToBtn:(UIButton *)sender {
    
    self.detailController.dict = self.classifyArray[sender.tag - BTNTAG];
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.detailController animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = NO;
    
}

/** section按钮点击事件 */
- (void)respondstoSectionBtn:(UIButton *)button {
    NSString *classifyId = _showArray[button.tag - SECTIONTAG][@"list"][0][@"tid"];
    NSDictionary *dict = @{@"id":classifyId,@"name":_showArray[button.tag - SECTIONTAG][@"className"]};
    
    self.detailController.dict = dict;
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.detailController animated:YES];
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GDLikesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDE];
    
    cell.delegate = self;
    cell.array = _showArray[indexPath.section][@"list"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, 26)];
    label.backgroundColor = RGBCOLOR(247, 247, 247);
    NSString *string = _showArray[section][@"className"];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame  = CGRectMake(kSCREEN_WIDTH - 75, 5, 60, 20);
    [button setTitle:@"更多>" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = SECTIONTAG + section;
    [button addTarget:self action:@selector(respondstoSectionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    label.text = [NSString stringWithFormat:@"     %@",string];
    
    [view addSubview:label];
    [view addSubview:button];
    return view;
}


#pragma mark - cellDelegate
- (void)GDLikesTableViewCell:(GDLikesTableViewCell *)cell clickGame:(NSDictionary *)dict {
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    
    [ControllerManager shareManager].detailView.gameID = dict[@"id"];
    
    [ControllerManager shareManager].detailView.gameLogo = dict[@"gameLogo"];
    
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
    
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}

#pragma makr - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 158) style:(UITableViewStylePlain)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"GDLikesTableViewCell" bundle:nil] forCellReuseIdentifier:CellIDE];
        
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
        
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);

    }
    return _headerView;
}

- (HCDetailController *)detailController {
    if (!_detailController) {
        _detailController = [[HCDetailController alloc] init];
    }
    return _detailController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
