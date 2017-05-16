//
//  SearchGiftController.m
//  GameBox
//
//  Created by 石燚 on 2017/5/16.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchGiftController.h"
#import "SearchModel.h"
#import "SearchGiftResultController.h"

@interface SearchGiftController ()<UITableViewDelegate,UITableViewDataSource>


//列表
@property (nonatomic, strong) UITableView *tableView;

//列表数据源
@property (nonatomic, strong) NSArray *showArray;

/** 热门游戏 */
@property (nonatomic, strong) NSArray *hotArray;

/** 清除历史记录 */
@property (nonatomic, strong) UIButton *clearHistoryBtn;


@end

@implementation SearchGiftController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _showArray = [SearchModel getGiftSearchHistory];
    if (_showArray) {
        self.tableView.tableFooterView = self.clearHistoryBtn;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self initDataSource];
    [self initUserInterface];
}

//初始化数据源
- (void)initDataSource {

}

//初始化用户界面
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - respond
- (void)clickClearHistoryBtn {
    if (self.showArray) {
        
        [SearchModel clearGiftSearchHistory];
        self.showArray = nil;
        
        self.tableView.tableFooterView = [UIView new];
        
        [self.tableView reloadData];
    }
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
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rrrrr"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"rrrrr"];
    }
            
    cell.imageView.image = [UIImage imageNamed:@"search_history"];
    cell.textLabel.text = _showArray[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];

    return cell;
}

#pragma mark - tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_showArray.count != 0) {
        
        NSString *keyword = _showArray[indexPath.row];
        
        self.parentViewController.hidesBottomBarWhenPushed = YES;
        SearchGiftResultController *search = [SearchGiftResultController new];
        search.keyword = keyword;
        [self.navigationController pushViewController:search animated:YES];
        
        self.parentViewController.hidesBottomBarWhenPushed = NO;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, kSCREEN_WIDTH, 40)];
    
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"    搜索历史";

    [view addSubview:label];
    
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 49) style:(UITableViewStylePlain)];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableFooterView = self.clearHistoryBtn;
        
    }
    return _tableView;
}

- (UIButton *)clearHistoryBtn {
    if (!_clearHistoryBtn) {
        _clearHistoryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _clearHistoryBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH , 44);
        [_clearHistoryBtn setTitle:@"清除历史记录" forState:(UIControlStateNormal)];
        [_clearHistoryBtn addTarget:self action:@selector(clickClearHistoryBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_clearHistoryBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_clearHistoryBtn setBackgroundColor:RGBCOLOR(247, 247, 247)];
        
    }
    return _clearHistoryBtn;
}


@end
