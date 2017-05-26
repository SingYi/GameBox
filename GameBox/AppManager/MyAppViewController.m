//
//  MyAppViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MyAppViewController.h"
#import "AppModel.h"
#import "MyGamesCell.h"
#import "GameRequest.h"
#import <UIImageView+WebCache.h>


#define CELLIDE @"MyGamesCell"

@interface MyAppViewController ()<UITableViewDelegate,UITableViewDataSource,MygamesCellDelegate>

/** 游戏列表 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MyAppViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initDataSource {
 
    NSArray<GameLocal *> *array = [GameRequest getAllLocalGame];

    if (array && array.count) {
        _showArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(GameLocal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GameNet *game = [GameRequest gameNetWithGameID:obj.gameID];
            [_showArray addObject:game];
        }];
        [self.tableView reloadData];
    }
}

- (void)refreshData {
    NSArray *array = [GameRequest getAllLocalGame];
    if (array && array.count) {
        _showArray = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(GameLocal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GameNet *game = [GameRequest gameNetWithGameID:obj.gameID];
            [_showArray addObject:game];
        }];
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    //多线程加载数据(请求所有游戏的详细信息,保存在本地)
    [GameRequest allGameWithType:AllBackage Completion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success && REQUESTSUCCESS) {
            NSArray *array = content[@"data"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //请求每个游戏信息
                    [GameRequest gameInfoWithGameID:obj[@"id"] Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
                        if (success && REQUESTSUCCESS) {
                            //请求道的游戏信息保存到数据库
                            [GameRequest saveGameAtLocalWithDictionary:content[@"data"][@"gameinfo"]];
                            //所有游戏本地保存完毕,获取本地所有应用,比对,获取到本地的游戏
                            if (idx == array.count - 1) {
                                [GameRequest saveLocalGameAtLocal];
                            }
                        }
                    }];
                }];
            });
        }
    }];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的游戏";
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    GameNet *game = _showArray[indexPath.row];
    
    UIImage *image = [UIImage imageWithData:[GameRequest getGameLogoDataWithGameID:game.gameID]];
    if (image) {
        cell.gameLogo.image = image;
    } else {
        [cell.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,game.logoUrl]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
    }
    
    cell.gameNameText = game.gameName;
    cell.gameVersionText = game.gameVsersion;
    cell.gameSizeText = [NSString stringWithFormat:@"%@ M",game.size];
    
    cell.index = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - cell delegate
- (void)myGameCellClickOpenBtnWithIndex:(NSInteger)idx {
    //打开app
    GameNet *game = _showArray[idx];
    [AppModel openAPPWithIde:game.bundleID];
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyGamesCell" bundle:nil] forCellReuseIdentifier:CELLIDE];
        
        _tableView.tableFooterView = [UIView new];
        
        //下拉刷新
        MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        
        [customRef setTitle:@"数据已加载" forState:MJRefreshStateIdle];
        [customRef setTitle:@"刷新数据" forState:MJRefreshStatePulling];
        [customRef setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        [customRef setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
        [customRef setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
        
        
        //自动更改透明度
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        
        _tableView.mj_header = customRef;

    }
    
    return _tableView;
}







@end









