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
#import "GameRequest.h"

#import "NSTodayServerController.h"
#import "NSCommingServerController.h"
#import "NSAlredayServerController.h"

#define CELLIDE @"NewServerCell"

@interface NewServerController ()<HomeHeaderDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

/**选择按钮*/
@property (nonatomic, strong) HomeHeader *headerView;

/**开服视图*/
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTodayServerController *todayServerController;
@property (nonatomic, strong) NSCommingServerController *commingServerController;
@property (nonatomic, strong) NSAlredayServerController *alredayServerController;


/**显示数据*/
@property (nonatomic, strong) NSArray<UIViewController *> *showArray;

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
    self.showArray = @[self.todayServerController,self.commingServerController,self.alredayServerController];
    [self addChildViewController:self.todayServerController];
    [self addChildViewController:self.commingServerController];
    [self addChildViewController:self.alredayServerController];
}

/**初始化用户界面*/
- (void)initUserInteraface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"开服表";
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];

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
    
    [cell.contentView addSubview:self.showArray[indexPath.row].view];
    
    
    return cell;
}

#pragma mark - srcrllerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGSize rect = scrollView.contentSize;
    CGFloat x1 = x / rect.width;
    x = x1 * kSCREEN_WIDTH;
    
    [self.headerView reomveLabelWithX:x];
    
    
//    syLog(@"%lf",scrollView.contentOffset.x);
}

#pragma mark - getter
- (HomeHeader *)headerView {
    if (!_headerView) {
        _headerView = [[HomeHeader alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 44) WithBtnArray:@[@"今日开服",@"即将开服",@"已经开服"]];
        
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(kSCREEN_WIDTH, (kSCREEN_HEIGHT - 108));
        
        layout.minimumInteritemSpacing = 0;
        
        layout.minimumLineSpacing = 0;
        
        //横向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 108, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[NewServerCell class] forCellWithReuseIdentifier:CELLIDE];

        
        _collectionView.pagingEnabled = YES;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = YES;
        
    }
    return _collectionView;
}

- (NSTodayServerController *)todayServerController {
    if (!_todayServerController) {
        _todayServerController = [[NSTodayServerController alloc] init];
        _todayServerController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108);
    }
    return _todayServerController;
}

- (NSCommingServerController *)commingServerController {
    if (!_commingServerController) {
        _commingServerController = [[NSCommingServerController alloc] init];
        _commingServerController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108);
    }
    return _commingServerController;
}

-(NSAlredayServerController *)alredayServerController {
    if (!_alredayServerController) {
        _alredayServerController = [[NSAlredayServerController alloc] init];
        _alredayServerController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108);
    }
    return _alredayServerController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
