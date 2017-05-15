//
//  RecommentTableHeader.m
//  GameBox
//
//  Created by 石燚 on 2017/4/21.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RecommentTableHeader.h"
#import <UIImageView+WebCache.h>

#define CELLIDE @"collectionViewcell"

@interface RecommentTableHeader ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

/**滚动视图*/
@property (nonatomic, strong) UICollectionView * collectionView;

/**分页控制器*/
@property (nonatomic, strong) UIPageControl * pageControl;

/**计时器*/
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation RecommentTableHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

#pragma mark - setter
- (void)setRollingArray:(NSArray *)rollingArray {
    
    
    if (rollingArray.count != 0) {
        _rollingArray = [rollingArray mutableCopy];
        [_rollingArray insertObject:rollingArray[_rollingArray.count - 1] atIndex:0];
        [_rollingArray addObject:rollingArray[0]];
    }

    
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0)];
    
    
    self.pageControl.numberOfPages = rollingArray.count;
    
    self.pageControl.center = CGPointMake(kSCREEN_WIDTH / 2, self.bounds.size.height - 20);
}

#pragma mark - 自动转换视图
//定时器的监听
- (void)autoImage {
    CGFloat offset = self.collectionView.contentOffset.x;
    
    [self.collectionView setContentOffset:CGPointMake(offset + kSCREEN_WIDTH, 0) animated:YES];

}

// 开启定时器
- (void)startTimer {
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(autoImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

// 停止定时器
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

//滚动结束时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (offset > kSCREEN_WIDTH * (self.rollingArray.count - 2)) {
        scrollView.contentOffset = CGPointMake(kSCREEN_WIDTH, 0);
    }
    if (offset < kSCREEN_WIDTH) {
        scrollView.contentOffset = CGPointMake(kSCREEN_WIDTH * (self.rollingArray.count - 2), 0);
    }
}

// 动画时候调用的代理方法(结束滚动时候调用)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - 当手动拖拽的时候
// 手动即将拖拽的时候停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

// 手动拖拽结束的时候开启计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - 滚动中监听方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得当前偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 转换成页数
    NSInteger pageNum = offsetX / kSCREEN_WIDTH + 0.5;
    // 设置分页器的当前页数
    self.pageControl.currentPage = pageNum - 1;
}



#pragma mark - collectionviewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rollingArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDE forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    
    imageView.backgroundColor = [UIColor orangeColor];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.rollingArray[indexPath.row][@"slide_pic"]]] placeholderImage:[UIImage imageNamed:@"homePage_bannerDownloading"]];
    
    [cell addSubview:imageView];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.RecommentTableHeaderDelegate && [self.RecommentTableHeaderDelegate respondsToSelector:@selector(RecommentTableHeader:didSelectImageWithInfo:)]) {
        
        [self.RecommentTableHeaderDelegate RecommentTableHeader:self didSelectImageWithInfo:_rollingArray[indexPath.item]];
    }
    
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLIDE];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.pagingEnabled = YES;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.bounces = NO;
        
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.bounds = CGRectMake(0, 0, 100, 20);
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}


@end










