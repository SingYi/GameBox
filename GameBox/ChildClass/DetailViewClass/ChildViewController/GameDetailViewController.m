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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterFace];
    _sectionTitleArray = @[@"    游戏简介:",@"    游戏特征:",@"    游戏评论:"];
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

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self.tableView reloadData];
}

- (void)setAbstract:(NSString *)abstract {
    _abstract = abstract;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)setFeature:(NSString *)feature {
    _feature = feature;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    GameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailTableCellIDE];
    
    if (indexPath.section == 0) {
        cell.detail.text = self.abstract;
    } else if (indexPath.section == 1) {
        cell.detail.text = self.feature;
    } else {
        cell.detail.text = @"";
    }

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



//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 230) style:(UITableViewStylePlain)];

        
        [_tableView registerNib:[UINib nibWithNibName:@"GameDetailTableViewCell" bundle:nil] forCellReuseIdentifier:DetailTableCellIDE];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 80;
        _tableView.autoresizesSubviews = YES;
        
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
