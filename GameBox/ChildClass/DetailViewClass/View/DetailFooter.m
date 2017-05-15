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
    self.backgroundColor = TABBARCOLOR;
    [self addSubview:self.collectionBtn];
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.shardBtn];
}

#pragma mark - respondToButton
- (void)clickCollectButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DetailFooter:clickCollecBtn:)]) {
        [self.delegate DetailFooter:self clickCollecBtn:sender];
    }
}

- (void)clickShareButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DetailFooter:clickShareBtn:)]) {
        [self.delegate DetailFooter:self clickShareBtn:sender];
    }
}

- (void)clickDownLoadButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DetailFooter:clickDownLoadBtn:)]) {
        [self.delegate DetailFooter:self clickDownLoadBtn:sender];
    }
}

#pragma mark - setter
- (void)setIsCollection:(BOOL)isCollection {
    _isCollection = isCollection;
    if (_isCollection) {
        [self.collectionBtn setImage:[UIImage imageNamed:@"detail_collection"] forState:(UIControlStateNormal)];
    } else {
        [self.collectionBtn setImage:[UIImage imageNamed:@"detail_unCollection"] forState:(UIControlStateNormal)];
    }
}


#pragma mark - getter 
- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectionBtn.frame = CGRectMake(0, 0, 50, 50);

        [_collectionBtn setImage:[UIImage imageNamed:@"detail_collection"] forState:(UIControlStateNormal)];
        [_collectionBtn addTarget:self action:@selector(clickCollectButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collectionBtn;
}


- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.frame = CGRectMake(60, 3, kSCREEN_WIDTH - 120, 44);
        [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"gameDetail_downLoad"] forState:(UIControlStateNormal)];
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
    }
    return _downLoadBtn;
}

- (UIButton *)shardBtn {
    if (!_shardBtn) {
        _shardBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shardBtn.frame = CGRectMake(kSCREEN_WIDTH - 50, 0, 50, 50);
        [_shardBtn setImage:[UIImage imageNamed:@"detail_shard"] forState:(UIControlStateNormal)];
        [_shardBtn addTarget:self action:@selector(clickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shardBtn;
}

@end











