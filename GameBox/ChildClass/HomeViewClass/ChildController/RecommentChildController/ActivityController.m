//
//  ActivityController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "ActivityController.h"
#import "ActivityCell.h"
#import "ActivityModel.h"

#import "ControllerManager.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDE @"ActivityCell"

@interface ActivityController ()

@property (nonatomic, strong) NSArray *showArray;

@end

@implementation ActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUserInterface {
    self.navigationItem.title = @"活动";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
    
    //设置刷新
    //下拉刷新
    MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    [customRef setTitle:@"数据已加载" forState:MJRefreshStateIdle];
    [customRef setTitle:@"刷新数据" forState:MJRefreshStatePulling];
    [customRef setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [customRef setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
    [customRef setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
    
    
    //自动更改透明度
    self.tableView.mj_header = customRef;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //下拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    self.tableView.tableFooterView = [UIView new];
    [self initDataSource];
}

#pragma mark - refresh
/**< 刷新数据 */
- (void)refreshData {
    [ActivityModel postWithType:ActivityList Page:@"1" ChannelId:@"185" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"list"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

/**< 加载数据 */
- (void)loadMoreData {
    
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

    cell.activityName.text = _showArray[indexPath.row][@"title"];
    cell.activityTime.text = _showArray[indexPath.row][@"release_time"];
    cell.activitySummary.text = _showArray[indexPath.row][@"abstract"];
    
    [cell.activityLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
