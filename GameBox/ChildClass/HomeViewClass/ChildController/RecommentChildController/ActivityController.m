//
//  ActivityController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ActivityController.h"
#import "ActivityCell.h"
#import "GameRequest.h"

#import "ControllerManager.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDE @"ActivityCell"

@interface ActivityController ()

@property (nonatomic, strong) NSMutableArray *showArray;

/** 当前下载页 */
@property (nonatomic, assign) NSInteger currentPage;

/** 是否下载全部 */
@property (nonatomic, assign) BOOL isAll;

@end

@implementation ActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}


- (void)initUserInterface {
    self.navigationItem.title = @"活动";
    //注册CELL
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:CELLIDE];

    //设置刷新
    MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    [customRef setTitle:@"数据已加载" forState:MJRefreshStateIdle];
    [customRef setTitle:@"刷新数据" forState:MJRefreshStatePulling];
    [customRef setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [customRef setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
    [customRef setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_header = customRef;
    
    //自动更改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //下拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.tableFooterView = [UIView new];
    
}

#pragma mark - refresh
/** 刷新数据 */
- (void)refreshData {
    [GameRequest activityWithPage:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            _currentPage = 1;
            _isAll = NO;
            _showArray = [content[@"data"][@"list"] mutableCopy];
//            syLog(@"%@",content[@"data"][@"list"]);
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
            _currentPage = 0;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 加载数据 */
- (void)loadMoreData {
    if (_isAll || _currentPage == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
        [GameRequest activityWithPage:[NSString stringWithFormat:@"%ld",_currentPage] Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success && REQUESTSUCCESS) {
                NSArray *array = content[@"data"][@"list"];
                if (array.count == 0) {
                    _isAll = YES;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_showArray addObjectsFromArray:array];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView reloadData];
                }
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.activityLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ControllerManager shareManager].webController.webURL = _showArray[indexPath.row][@"info_url"];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].webController animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
