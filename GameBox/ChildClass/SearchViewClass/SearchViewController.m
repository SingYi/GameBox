//
//  SearchViewController.m
//  GameBox
//
//  Created by 石燚 on 17/4/10.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchViewController.h"
#import "HeaderView.h"
#import "SearchCell.h"


#define CELLIDENTIFIER @"SearchCell"


@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


//滚动轮播视图
@property (nonatomic, strong) RollingCarouselView *rollingCarouselView;


//列表
@property (nonatomic, strong) UITableView *tableView;
//tableView的头部视图
@property (nonatomic, strong) HeaderView *headerView;


//搜索框
@property (nonatomic, strong) UISearchBar *searcBar;

//左边按钮
@property (nonatomic, strong) UIBarButtonItem *leftBtn;
//右边按钮
@property (nonatomic, strong) UIBarButtonItem *rightBtn;

//列表数据源
@property (nonatomic, strong) NSArray *showArray;

@property (nonatomic, strong) UISearchController *searchController;


@end

@implementation SearchViewController


#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self initDataSource];
    [self initUserInterface];
}

//初始化数据源
- (void)initDataSource {
    _showArray = @[@"测试1",@"测试2",@"测试3",@"测试4",@"测试5",@"测试6"];
}

//初始化用户界面
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//    [self.view addSubview:self.rollingCarouselView];
    self.navigationItem.titleView = self.searcBar;
    
//    self.leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftBtn:)];
    self.leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"左边" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftBtn:)];
    
    self.rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"右边" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftBtn:)];
    
    self.navigationItem.leftBarButtonItems = @[self.leftBtn];
    self.navigationItem.rightBarButtonItems = @[self.rightBtn];
    
    
    
    [self.view addSubview:self.tableView];
}

#pragma mark - respond
- (void)respondsToLeftBtn:(UIBarButtonItem *)sender {
//    NSLog(@"1");
}

#pragma mark - method

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectIndex = indexPath.row;
    
//    cell.textLabel.text = _showArray[indexPath.row];
    
    
    return cell;
}

#pragma mark - tableviewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
    
    label.text = @"    2017-4-11";
    label.backgroundColor = [UIColor lightGrayColor];
    
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  80;
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    
}



#pragma mark - getter
//- (RollingCarouselView *)rollingCarouselView {
//    if (!_rollingCarouselView) {
//        _rollingCarouselView = [[RollingCarouselView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) WithImageArray:@[@"1",@"2",@"3",@"4",@"5"]];
//    }
//    return _rollingCarouselView;
//}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:(UITableViewStylePlain)];
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDENTIFIER];
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
    }
    return _tableView;
}

- (HeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.4)];
    }
    return _headerView;
}

- (UISearchBar *)searcBar {
    if (!_searcBar) {
        _searcBar = [[UISearchBar alloc] init];
        _searcBar.bounds = CGRectMake(0, 0, 100, 30);
        _searcBar.layer.cornerRadius = 22;
        _searcBar.layer.masksToBounds = YES;
        _searcBar.delegate = self;
    }
    return _searcBar;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    }
    return _searchController;
}

#pragma mark - memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
