//
//  SearchResultViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/26.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ControllerManager.h"

#import "SearchCell.h"

#import "GameRequest.h"

#import <UIImageView+WebCache.h>

#define CELLIDE @"SearchCell"

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,SearchCellDelelgate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;


@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - settter
- (void)setKeyword:(NSString *)keyword {
    if (keyword && ![keyword isEqualToString:_keyword]) {
        _showArray = nil;
        _keyword = keyword;
        [GameRequest searchGameWithKeyword:_keyword Completion:^(NSDictionary * _Nullable content, BOOL success) {
            if (success) {
                _showArray = content[@"data"];
                [self.tableView reloadData];
                if (_showArray && _showArray.count > 0) {
                    
                } else {
                    [GameRequest showAlertWithMessage:@"未找到相关信息" dismiss:nil];
                }
            } else {
                [GameRequest showAlertWithMessage:REQUESTMSG dismiss:nil];
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.delegate = self;
    
    cell.dict = _showArray[indexPath.row];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    
    [ControllerManager shareManager].detailView.gameID = _showArray[indexPath.row][@"id"];
    
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [ControllerManager shareManager].detailView.gameLogo = cell.gameLogo.image;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[ControllerManager shareManager].detailView animated:YES];
}

#pragma mark - cellDelegate
- (void)didSelectCellRowAtIndexpath:(NSDictionary *)dict {
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.tableFooterView = [UIView new];
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return _tableView;
}

@end


