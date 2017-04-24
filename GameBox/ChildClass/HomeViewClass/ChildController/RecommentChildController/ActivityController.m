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

#define CELLIDE @"ActivityCell"

@interface ActivityController ()

@property (nonatomic, strong) NSArray *showArray;

@end

@implementation ActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [ActivityModel postWithType:ActivityList Page:@"1" ChannelId:@"185" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        _showArray = content[@"data"][@"list"];
        [self.tableView reloadData];
//        NSLog(@"%@",content);
    }];
}

- (void)initUserInterface {
    self.navigationItem.title = @"活动";
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDE];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ControllerManager shareManager].webController.webURL = _showArray[indexPath.row][@"info_url"];
    NSLog(@"%@",_showArray[indexPath.row][@"info_url"]);
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
