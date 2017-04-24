//
//  GameStrategyViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameStrategyViewController.h"
#import "StrategyCell.h"


#define CELLIDE @"StrategyCell"

@interface GameStrategyViewController ()<UITableViewDataSource,UITableViewDelegate>

/**攻略列表*/
@property (nonatomic, strong) UITableView *tableView;

/**显示数据的数组*/
@property (nonatomic, strong) NSArray *showArray;



@end

@implementation GameStrategyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"GameStrategyViewController == viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"GameStrategyViewController == viewDidAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserinterFace];
    _showArray = @[@"",@"",@"",@"",@"",@""];
}

- (void)initUserinterFace {
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE forIndexPath:indexPath];
    
    
    
    
    return cell;
}

#pragma mark - tableViewDeleagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"StrategyCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
