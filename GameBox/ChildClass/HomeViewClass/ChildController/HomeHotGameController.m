//
//  HomeHotGameController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HomeHotGameController.h"
#import "SearchCell.h"

#import "GameRequest.h"

#import "ControllerManager.h"

#define CELLIDENTIFIER @"SearchCell"

@interface HomeHotGameController ()<UITableViewDataSource,UITableViewDelegate,SearchCellDelelgate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isAll;

@end

@implementation HomeHotGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initUserInterface];
}


- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    [self.view addSubview:self.tableView];
}

#pragma mark - method
- (void)refreshData {
    [GameRequest hotGameWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && !((NSString *)content[@"status"]).boolValue) {
            _showArray = [content[@"data"] mutableCopy];
            [self checkLocalGamesWith:_showArray];
            _currentPage = 1;
            _isAll = NO;

            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreData {
    if (_isAll) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
        
        [GameRequest newGameWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && !((NSString *)content[@"status"]).boolValue) {
                NSArray *array = content[@"data"];
                if (array.count == 0) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_showArray addObjectsFromArray:array];
                    [self checkLocalGamesWith:_showArray];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}



#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
    
    cell.dict = (NSDictionary *)_showArray[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - tableViewDelegate
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
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - cellDelegate
- (void)didSelectCellRowAtIndexpath:(NSDictionary *)dict {
    NSString *isLocal = dict[@"isLocal"];
    if ([isLocal isEqualToString:@"1"]) {
        [AppModel openAPPWithIde:dict[@"ios_pack"]];
        
    } else {
        NSString *url = dict[@"ios_url"];
        
        [GameRequest downLoadAppWithURL:url];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 157) style:(UITableViewStylePlain)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
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
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
