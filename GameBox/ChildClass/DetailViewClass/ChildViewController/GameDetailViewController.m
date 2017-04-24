//
//  GameDetailViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameDetailViewController.h"
#import "DetailTableCell.h"
#import "DetialTableHeader.h"
#import "DetailTableFooter.h"
#import "GameDetailTableViewCell.h"

#define DetailTableCellIDE @"GameDetailTableViewCell"

@interface GameDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

/**头部视图*/
@property (nonatomic, strong) DetialTableHeader *headerView;

/**尾部视图*/
@property (nonatomic, strong) DetailTableFooter *footerView;

/**游戏内容和评论*/
@property (nonatomic, strong) UITableView *tableView;

/**用于显示的数组*/
@property (nonatomic, strong) NSArray *showArray;

/**section显示的数组*/
@property (nonatomic, strong) NSArray * sectionTitleArray;

@end

@implementation GameDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"GameDetailViewController == viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"GameDetailViewController == viewDidAppear");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterFace];
    _sectionTitleArray = @[@"    游戏简介:",@"    猜你喜欢:",@"    游戏评论:"];
}


- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - setter
- (void)setImagasArray:(NSArray *)imagasArray {
    _imagasArray = imagasArray;
    self.headerView.imageArray = imagasArray;
}

- (void)setLikes:(NSArray *)likes {
    self.footerView.likesArray = likes;
}

- (void)setAboutString:(NSString *)aboutString {
    _aboutString = aboutString;
    [self.tableView reloadData];
}

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        GameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailTableCellIDE];
//        cell.textLabel.text = [NSString stringWithFormat:@"游戏简介: \n%@",self.aboutString];
//        return cell;
//    } else if (indexPath.section == 1) {
//        UITableViewCell *cell = nil;
//        
//        return cell;
//    } else if (indexPath.section == 2) {
//        UITableViewCell *cell = nil;
//        return cell;
//    }
    
    GameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailTableCellIDE];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.aboutString];

    return cell;
}

#pragma mark - tableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    
    label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    label.text = self.sectionTitleArray[section];
    
    
    return label;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230) style:(UITableViewStylePlain)];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DetailTableCellIDE];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
    }
    
    return _tableView;
}


- (DetialTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [[DetialTableHeader alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    }
    return _headerView;
}

- (DetailTableFooter *)footerView {
    if (!_footerView) {
        _footerView = [[DetailTableFooter alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20 + (kSCREEN_WIDTH / 4))];
    }
    return _footerView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
