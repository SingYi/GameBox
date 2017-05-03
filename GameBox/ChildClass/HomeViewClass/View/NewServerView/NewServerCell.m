//
//  NewServerCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "NewServerCell.h"
#import "NewServerTableViewCell.h"

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#define CELLIDE @"NewServerTableViewCell"

@interface NewServerCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;

@end

@implementation NewServerCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUsreInterface];
    }
    return self;
}

#pragma mark - setter
- (void)setDataArray:(NSArray *)DataArray {
    _DataArray = DataArray;
    _showArray = _DataArray;
    [self.tableView reloadData];
}

/**初始化用户界面*/
- (void)initUsreInterface {
    [self.contentView addSubview:self.tableView];
}

#pragma mark - method
- (void)refreshData {
    if (self.serverCellDelegate && [self.serverCellDelegate respondsToSelector:@selector(newServerCellRefreshDataWithIndex:)]) {
        [self.serverCellDelegate newServerCellRefreshDataWithIndex:_idx];
    }
}

- (void)endAnimation {
    [self.tableView.mj_header endRefreshing];
}

#pragma makr - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    
    [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_showArray[indexPath.row][@"logo"]]] placeholderImage:nil];
    
    cell.gameName.text = _showArray[indexPath.row][@"gamename"];
    
    NSString *timeStr = _showArray[indexPath.row][@"start_time"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日 HH:mm";
    
    cell.startTime.text = [formatter stringFromDate:date];
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.newServerCellDelegate && [self.newServerCellDelegate respondsToSelector:@selector(didselectRowAtIndexpath:)]) {
//        [self.newServerCellDelegate didselectRowAtIndexpath:indexPath];
//    }
}

#pragma makr - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        

        [_tableView registerNib:[UINib nibWithNibName:@"NewServerTableViewCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //下拉刷新
        MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        [customRef setTitle:@"数据已加载" forState:MJRefreshStateIdle];
        [customRef setTitle:@"刷新数据" forState:MJRefreshStatePulling];
        [customRef setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        [customRef setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
        [customRef setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
        
        
        //自动更改透明度
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        
        [customRef.lastUpdatedTimeLabel setText:@"0"];
        
        _tableView.mj_header = customRef;
        
    }
    return _tableView;
}


@end
