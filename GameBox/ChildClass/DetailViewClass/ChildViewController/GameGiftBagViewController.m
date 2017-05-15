//
//  GameGiftBagViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameGiftBagViewController.h"
#import "GiftBagCell.h"
#import "GiftBagModel.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDE @"GiftBagCell"

@interface GameGiftBagViewController ()<UITableViewDelegate,UITableViewDataSource>

/**礼包列表视图*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数据的数组*/
@property (nonatomic, strong) NSArray *showArray;

@end

@implementation GameGiftBagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - mmethod
- (void)reloadData {
    [GiftBagModel postGiftBagWithGameID:_gameID Order:nil OrderType:nil page:@"1" Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            _showArray = content[@"data"][@"list"];

            [self.tableView reloadData];
        }
    }];
}


#pragma makr - setter
- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self reloadData];
}



#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GiftBagCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    
    [cell.packLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"pack_logo"]]] placeholderImage:nil];
    
    cell.packCounts.text = _showArray[indexPath.row][@"pack_counts"];
    
    cell.name.text = _showArray[indexPath.row][@"pack_name"];
    
    NSString *total = _showArray[indexPath.row][@"pack_counts"];
    NSString *current = _showArray[indexPath.row][@"pack_used_counts"];
    CGFloat tc = current.floatValue / total.floatValue;
    
    NSString *tcStr = [NSString stringWithFormat:@"%.0lf%%",(100 - tc * 100)];
    
    cell.titlelabel.text = tcStr;
    
    CGRect rect = cell.packProgress.bounds;
    
//    cell.progressView.frame = CGRectMake(0, 0, rect.size.width * tc, rect.size.height);
    
    return cell;
}

#pragma mark - tableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 245) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GiftBagCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
