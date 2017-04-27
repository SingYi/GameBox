//
//  DetailHeader.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "DetailHeader.h"
#import "HomeHeader.h"

@interface DetailHeader ()<HomeHeaderDelegate>



/**下载按钮*/
@property (nonatomic, strong) UIButton *downLoadBtn;

/**分割线*/
@property (nonatomic, strong) UIView *lineView;

/**选择标签*/
@property (nonatomic, strong) HomeHeader *selectView;

@end

@implementation DetailHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.selectView];
    [self addSubview:self.lineView];
    [self addSubview:self.imageView];
    [self addSubview:self.gameNameLabel];
    [self addSubview:self.downLoadNumber];
    [self addSubview:self.downLoadBtn];
}

#pragma mark - homeHeaderDelegate
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    if (self.detailHeaderDelegate && [self.detailHeaderDelegate respondsToSelector:@selector(didselectBtnAtIndex:)]) {
        [self.detailHeaderDelegate didselectBtnAtIndex:idx];
    }
}

#pragma mark - setter 
- (void)setBtnArray:(NSArray *)btnArray {
    _selectView.btnNameArray = btnArray;
}

- (void)setIndex:(NSInteger)index {
    self.selectView.index = index;
}

#pragma mark - getter
- (HomeHeader *)selectView {
    if (!_selectView) {
        _selectView = [[HomeHeader alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 32)];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _lineView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.bounds = CGRectMake(0, 0, 60, 60);
        _imageView.center = CGPointMake(50, 40);
        _imageView.backgroundColor = [UIColor whiteColor];
        
    }
    return _imageView;
}

- (UILabel *)gameNameLabel {
    if (!_gameNameLabel) {
        _gameNameLabel = [[UILabel alloc]init];
        _gameNameLabel.bounds = CGRectMake(0, 0, 100, 20);
        _gameNameLabel.center = CGPointMake(140, 20);
        _gameNameLabel.text = @"游戏名称";
    }
    return _gameNameLabel;
}

- (UILabel *)downLoadNumber {
    if (!_downLoadNumber) {
        _downLoadNumber = [[UILabel alloc]init];
        _downLoadNumber.bounds = CGRectMake(0, 0, 100, 20);
        _downLoadNumber.center = CGPointMake(140, 60);
        _downLoadNumber.text = @"200亿+ 下载";
    }
    return _downLoadNumber;
}

- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.bounds = CGRectMake(0, 0, 50, 30);
        _downLoadBtn.center = CGPointMake(kSCREEN_WIDTH - 50, 40);
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
        [_downLoadBtn setBackgroundColor:[UIColor orangeColor]];
    }
    return _downLoadBtn;
}


@end
