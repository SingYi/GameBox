//
//  MyAttentionView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/12.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyAttentionView.h"
#import "SearchCell.h"
#import "GameRequest.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#define CELLIDENTIFIER @"SearchCell"

@interface MyAttentionView ()<UITableViewDataSource,UITableViewDelegate,SearchCellDelelgate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;

/** 当前页数 */
@property (nonatomic, assign) NSInteger currentPage;

/** 是否加载了全部 */
@property (nonatomic, assign) BOOL isAll;


@end

@implementation MyAttentionView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterFace];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
    [self.view addSubview:self.tableView];
}

- (void)refreshData {
    [GameRequest myCollectionGameWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            self.tableView.backgroundView = nil;
            _showArray = [content[@"data"] mutableCopy];
            [self checkLocalGamesWith:_showArray];
            _currentPage = 1;
            _isAll = NO;
            [self.tableView reloadData];
            
            if (_showArray) {
                self.tableView.backgroundView = nil;
            } else {
                
                self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noCollection"]];
            }
            
            //noCollection
        } else {
            _currentPage = 0;
            if (_showArray) {
                self.tableView.backgroundView = nil;
            } else {
                
                self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    if (_isAll || _currentPage == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
        [GameRequest myCollectionGameWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSMutableArray *array = [content[@"data"] mutableCopy];
                if (array.count == 0) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {

                    [self checkLocalGamesWith:array];
                    [_showArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                }
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}

- (void)checkLocalGamesWith:(NSMutableArray *)array {
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dictLocal = [GameRequest gameLocalWithGameID:array[i][@"id"]];
        if (dictLocal && dictLocal.count > 0) {
            NSMutableDictionary *dict = [array[i] mutableCopy];
            [dict setObject:@"1" forKey:@"isLocal"];
            [array replaceObjectAtIndex:i withObject:dict];
        }
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
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    cell.delegate = self;
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];

    
    return cell;
    
}


#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        
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
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
