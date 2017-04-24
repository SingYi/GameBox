//
//  DetialTableHeader.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "DetialTableHeader.h"
#import "CustomLayout.h"

#import <UIImageView+WebCache.h>

#define CELLIDE @"DetialTableHeaderCELL"

@interface DetialTableHeader ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) CustomLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DetialTableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.collectionView];
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self.collectionView reloadData];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDE forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.backgroundColor = [UIColor orangeColor];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.imageArray[indexPath.row]]] placeholderImage:nil];
    
    [cell.contentView addSubview:imageView];
    
    
    return cell;
}


#pragma mark - getter
- (CustomLayout *)layout {
    if (!_layout) {
        _layout = [[CustomLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _layout.itemSize = CGSizeMake(self.bounds.size.height * 0.7 , self.bounds.size.height);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLIDE];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

@end









