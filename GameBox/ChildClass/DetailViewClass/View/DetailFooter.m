//
//  DetailFooter.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "DetailFooter.h"

@interface DetailFooter ()


/**收藏按钮*/
@property (nonatomic, strong) UIButton *collectionBtn;

/**下载按钮*/
@property (nonatomic, strong) UIButton *downLoadBtn;

/**分享按钮*/
@property (nonatomic, strong) UIButton *shardBtn;

@end

@implementation DetailFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionBtn];
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.shardBtn];
}


#pragma mark - getter 
- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectionBtn.frame = CGRectMake(0, 0, 50, 50);
//        [_collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
        [_collectionBtn setImage:[UIImage imageNamed:@"detail_collection"] forState:(UIControlStateNormal)];
        [_collectionBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    }
    return _collectionBtn;
}


- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.frame = CGRectMake(60, 3, kSCREEN_WIDTH - 120, 44);
    
        
//        初始化CAGradientlayer对象，使它的大小为UIView的大小
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _downLoadBtn.bounds;
        
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [_downLoadBtn.layer addSublayer:gradientLayer];
        
        //设置渐变区域的起始和终止位置（范围为0-1）
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        
        //设置颜色数组
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:226/255.0 green:174/255.0 blue:62/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:226/255.0 green:144/255.0 blue:39/255.0 alpha:1].CGColor];
        
        _downLoadBtn.layer.cornerRadius = 4;
        _downLoadBtn.layer.masksToBounds = YES;
        
        //设置颜色分割点（范围：0-1）
        gradientLayer.locations = @[@(0.5f), @(1.0f)];
        
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
        [_downLoadBtn setBackgroundColor:[UIColor orangeColor]];
    }
    return _downLoadBtn;
}

- (UIButton *)shardBtn {
    if (!_shardBtn) {
        _shardBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shardBtn.frame = CGRectMake(kSCREEN_WIDTH - 50, 0, 50, 50);
//        [_shardBtn setTitle:@"分享" forState:(UIControlStateNormal)];
        [_shardBtn setImage:[UIImage imageNamed:@"detail_shard"] forState:(UIControlStateNormal)];
        [_shardBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        
    }
    return _shardBtn;
}

@end











