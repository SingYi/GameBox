//
//  NewServerController.m
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "NewServerController.h"
#import "HomeHeader.h"
#import "NewServerCell.h"
#import "GameModel.h"


#define CELLIDE @"NewServerCell"

@interface NewServerController ()<HomeHeaderDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NewServerCellDelegate>

/**选择按钮*/
@property (nonatomic, strong) HomeHeader *headerView;

/**开服视图*/
@property (nonatomic, strong) UICollectionView *collectionView;

/**显示数据*/
@property (nonatomic, strong) NSArray *showArray;

/**数据数组*/
@property (nonatomic, strong) NSMutableDictionary * dataDict;


@end

@implementation NewServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInteraface];
}

//**初始化数据*/
- (void)initDataSource {
    _showArray = @[@"",@"",@""];
    _dataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    for (NSInteger i = 1; i <= 3; i++) {
        [self postCellDataWithIndex:i];
    }
}

/**初始化用户界面*/
- (void)initUserInteraface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"开服表";
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];

}

#pragma mark - method
/**请求数据*/
- (void)postCellDataWithIndex:(NSInteger)idx {
    [GameModel postServerListWithType:(ServiceType)(idx) ChannelID:@"185" Page:@"1" Comoletion:^(NSDictionary * _Nullable content, BOOL success) {
        if (success) {
            [_dataDict setObject:content[@"data"] forKey:[NSString stringWithFormat:@"%ld",idx - 1]];
        
            
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx - 1 inSection:0]]];
        }
    }];
}

#pragma mark - cellDelegate
- (void)newServerCellRefreshDataWithIndex:(NSInteger)index {
    [self postCellDataWithIndex:index + 1];
    CLog(@"刷新数据");
    
    NewServerCell *cell = (NewServerCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    [cell endAnimation];
    
}

- (void)didselectRowAtIndexpath:(NSIndexPath *)index {
    
}


#pragma mark - headerDelegate
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    [self.collectionView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:YES];
}

#pragma mark - collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewServerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDE forIndexPath:indexPath];
    
    cell.DataArray = _dataDict[[NSString stringWithFormat:@"%ld",indexPath.item]];
    
    cell.idx = indexPath.item;
    
    cell.serverCellDelegate = self;
    
    
    return cell;
}

#pragma mark - getter
- (HomeHeader *)headerView {
    if (!_headerView) {
        _headerView = [[HomeHeader alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 32) WithBtnArray:@[@"今日开服",@"即将开服",@"已经开服"]];
        
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(kSCREEN_WIDTH, (kSCREEN_HEIGHT - 96));
        
        layout.minimumInteritemSpacing = 0;
        
        layout.minimumLineSpacing = 0;
        
        //横向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 96, kSCREEN_WIDTH, kSCREEN_HEIGHT - 96) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[NewServerCell class] forCellWithReuseIdentifier:CELLIDE];

        
        _collectionView.pagingEnabled = YES;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
