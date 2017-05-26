//
//  MNCommentController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MNCommentController.h"
#import "GDCommentTableViewCell.h"

#import "ChangyanSDK.h"
#import <MJRefresh.h>


#define CELLIDE @"GDCommentTableViewCell"

@interface MNCommentController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showarray;

/** 当前评论数 */
@property (nonatomic, assign) NSInteger currentComments;

/** 当前评论数 */
@property (nonatomic, assign) NSInteger currentPage;

/** 加载全部 */
@property (nonatomic, assign) BOOL isAll;


@property (nonatomic, strong) NSString *userid;

@end

@implementation MNCommentController

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
//    [ChangyanSDK getUserNewReply:@"" pageNo:@"" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
//        if (statusCode == 0) {
//            NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//            
//            _showarray = dic[@"replies"];
////            syLog(@"%@",dic);
////            self.userid = dic[@"user_id"];
//            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
//        }
//    }];
    
    [ChangyanSDK getUserInfo:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode == 0) {
            NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            
            self.userid = dic[@"user_id"];
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

/** 加载更多数据 */
- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    if (_isAll) {
    } else {
        _currentPage++;
//        [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:[NSString stringWithFormat:@"game_%@",_gameID] pageSize:[NSString stringWithFormat:@"%ld",_currentPage * 30] hotSize:nil orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
//            
//            if (statusCode == 0) {
//                
//                NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//                _showarray = dic[@"comments"];
//                _currentComments = _showarray.count;
//                
//                if (_currentComments < _currentPage * 30) {
//                    _isAll = YES;
//                } else {
//                    _isAll = NO;
//                }
//                
//                [self.tableView reloadData];
//                [self.tableView.mj_footer endRefreshing];
//                
//            } else {
//                _isAll = YES;
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }];
    }
    
}

- (void)setUserid:(NSString *)userid {
    _userid = userid;
    
    
    [ChangyanSDK getUserComments:[NSString stringWithFormat:@"%@",_userid] pageSize:@"30" pageNumber:@"1" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        
        
        if (statusCode == 0) {
            NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            self.showarray = dic[@"comments"];
            [self.tableView reloadData];
//            syLog(@"%@",dic);
            self.tableView.backgroundView = nil;
            if (_showarray) {
                self.tableView.backgroundView = nil;
            } else {
                
                self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noComments"]];
            }
            
            
        } else {
            if (_showarray) {
                self.tableView.backgroundView = nil;
            } else {
                
                self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
            }
        }
        [self.tableView.mj_header endRefreshing];
        
    }];
}


#pragma mark - tableView Deleage
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
    cell.userNick = _showarray[indexPath.row][@"passport"][@"nickname"];
    
    cell.contentStr = _showarray[indexPath.row][@"content"];
    
    NSMutableString *time = [NSMutableString stringWithFormat:@"%@",_showarray[indexPath.row][@"create_time"]];
    
    time = [[time substringToIndex:time.length - 3] mutableCopy];
    
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YY-MM-dd hh:mm";
    cell.time = [formatter stringFromDate:creatDate];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109) style:(UITableViewStylePlain)];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"GDCommentTableViewCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
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
        
        //上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}







@end
