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
    [self addSubview:self.collectionBtn];
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.shardBtn];
}


#pragma mark - getter 
- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectionBtn.frame = CGRectMake(0, 0, 50, 50);
        [_collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
        [_collectionBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    }
    return _collectionBtn;
}


- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.frame = CGRectMake(50, 0, kSCREEN_WIDTH - 100, 50);
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
        [_downLoadBtn setBackgroundColor:[UIColor orangeColor]];
    }
    return _downLoadBtn;
}

- (UIButton *)shardBtn {
    if (!_shardBtn) {
        _shardBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shardBtn.frame = CGRectMake(kSCREEN_WIDTH - 50, 0, 50, 50);
        [_shardBtn setTitle:@"分享" forState:(UIControlStateNormal)];
        [_shardBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        
    }
    return _shardBtn;
}

@end











