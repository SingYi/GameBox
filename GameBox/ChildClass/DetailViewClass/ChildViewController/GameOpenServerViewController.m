//
//  GameOpenServerViewController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/20.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GameOpenServerViewController.h"
#import "NewServerTableViewCell.h"
#import "GameRequest.h"

#define DTServicerCELL @"NewServerTableViewCell"



@interface GameOpenServerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *showArray;

@end

@implementation GameOpenServerViewController

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

#pragma mark - method
- (void)getOpenServerData {
    
    [GameRequest gameServerOpenWithGameID:_gameID Comoletion:^(NSDictionary * _Nullable content, BOOL scccess) {
//        syLog(@"%@",content);
        if (scccess && REQUESTSUCCESS) {
            _showArray = content[@"data"];
            [self.tableView reloadData];
        } else {
            _showArray = nil;
        }
        
    }];
}

- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self getOpenServerData];
}

- (void)setGamename:(NSString *)gamename {
    _gamename = gamename;
}

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DTServicerCELL];
    
    NSMutableDictionary *dict = [_showArray[indexPath.row] mutableCopy];
    [dict setObject:_gamename forKey:@"gamename"];
    
    GameNet *game = [GameRequest gameNetWithGameID:_gameID];
    
    [dict setObject:game.logoUrl forKey:@"logo"];
    
    syLog(@"%@",dict);
    
    cell.dict = dict;
    
    cell.gameLogo.image = self.logoImage;
    
    return cell;
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 245) style:(UITableViewStylePlain)];
        
        [_tableView registerNib:[UINib nibWithNibName:@"NewServerTableViewCell" bundle:nil] forCellReuseIdentifier:DTServicerCELL];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
