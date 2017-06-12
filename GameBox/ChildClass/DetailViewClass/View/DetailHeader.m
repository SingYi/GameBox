//
//  DetailHeader.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "DetailHeader.h"

@interface DetailHeader ()<HomeHeaderDelegate>


/**下载按钮*/
@property (nonatomic, strong) UIButton *downLoadBtn;

/**分割线*/
@property (nonatomic, strong) UIView *lineView;

/** QQ群按钮 */
@property (nonatomic, strong) UIButton *qqGroupBtn;
/** QQ 群标签 */
@property (nonatomic, strong) UILabel *qqGroupLabel;

/** 评分星级 */
@property (nonatomic, strong) NSMutableArray<UIImageView *> *stars;



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
    self.backgroundColor = [UIColor whiteColor];

    //选择控制器
    [self addSubview:self.selectView];
    //分割线
    [self addSubview:self.lineView];
    //logo
    [self addSubview:self.imageView];
    //游戏名称
    [self addSubview:self.gameNameLabel];
    //下载次数
    [self addSubview:self.downLoadNumber];
    //游戏大小
    [self addSubview:self.sizeLabel];
    //设置星级
    [self setStarsArray];
    //设置游戏标签
    [self setTypeLabelsArray];

}

#pragma mark - homeHeaderDelegate
- (void)didSelectBtnAtIndexPath:(NSInteger)idx {
    if (self.detailHeaderDelegate && [self.detailHeaderDelegate respondsToSelector:@selector(didselectBtnAtIndex:)]) {
        [self.detailHeaderDelegate didselectBtnAtIndex:idx];
    }
}

#pragma mark - method
- (void)clickQQGroupBtn {
    if (_qqGroup && _qqGroup.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_qqGroup]];
    }
}

#pragma mark - setter 
/** 选择标签 */
- (void)setBtnArray:(NSArray *)btnArray {
    _selectView.btnNameArray = btnArray;
}

/** 选择下标 */
- (void)setIndex:(NSInteger)index {
    self.selectView.index = index;
}

/** 游戏评分 */
- (void)setSource:(CGFloat)source {
    _source = source;
    
    for (NSInteger i = 0; i < 5; i++) {
        if (_source <= 0) {
            self.stars[i].image = [UIImage imageNamed:@"star_dark"];
        } else if (_source > 0 && _source <= 0.5) {
            self.stars[i].image = [UIImage imageNamed:@"star_half"];
        } else if (_source > 0.5) {
            self.stars[i].image = [UIImage imageNamed:@"star_bright"];
        }
        _source--;
    }
}

- (void)setQqGroup:(NSString *)qqGroup {
    if (qqGroup && qqGroup.length != 0) {
        _qqGroup = qqGroup;
        [self addSubview:self.qqGroupBtn];
        [self addSubview:self.qqGroupLabel];
    } else {
        _qqGroup = nil;
        [self.qqGroupLabel removeFromSuperview];
        [self.qqGroupBtn removeFromSuperview];
    }
}


#pragma mark - getter
- (HomeHeader *)selectView {
    if (!_selectView) {
        _selectView = [[HomeHeader alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 44)];
        _selectView.lineColor = [UIColor whiteColor];
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
        _gameNameLabel.frame = CGRectMake((CGRectGetMaxX(self.imageView.frame) + 8), (CGRectGetMinY(self.imageView.frame)), kSCREEN_WIDTH * 0.3, 20);

        _gameNameLabel.font = [UIFont systemFontOfSize:16];
        _gameNameLabel.text = @"游戏名称";
        
    }
    return _gameNameLabel;
}

- (UILabel *)downLoadNumber {
    if (!_downLoadNumber) {
        _downLoadNumber = [[UILabel alloc]init];
        _downLoadNumber.frame = CGRectMake((CGRectGetMaxX(self.imageView.frame) + 8), (CGRectGetMaxY(self.gameNameLabel.frame) + 20), kSCREEN_WIDTH * 0.3, 20);
        _downLoadNumber.font = [UIFont systemFontOfSize:14];
        _downLoadNumber.textColor = [UIColor lightGrayColor];
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

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.frame = CGRectMake((CGRectGetMaxX(self.downLoadNumber.frame) + 8), (CGRectGetMaxY(self.gameNameLabel.frame) + 20), 50, 20);
        _sizeLabel.font = [UIFont systemFontOfSize:14];
        _sizeLabel.textColor = [UIColor lightGrayColor];
    }
    return _sizeLabel;
}

/** 设置评分星级数组 */
- (void)setStarsArray {
    _stars = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starView = [[UIImageView alloc] init];
        starView.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 8 + (i * 10), CGRectGetMaxY(self.gameNameLabel.frame) + 5, 10, 10);
        starView.image = [UIImage imageNamed:@"star_bright"];
        [_stars addObject:starView];
        [self addSubview:starView];
    }
}

/** 设置游戏类型标签 */
- (void)setTypeLabelsArray {
    _typeLabels = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {
        
        UILabel *label = [[UILabel alloc] init];
    
    
        label.font = [UIFont systemFontOfSize:12];
        label.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
        label.layer.borderWidth = 1;
        label.textColor = RGBCOLOR(197, 188, 100);
        label.text = @"";
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        [label sizeToFit];
        
        [_typeLabels addObject:label];
        [self addSubview:label];
    }
}

- (UILabel *)qqGroupLabel {
    if (!_qqGroupLabel) {
        _qqGroupLabel = [[UILabel alloc] init];
        _qqGroupLabel.textAlignment = NSTextAlignmentCenter;
        _qqGroupLabel.frame = CGRectMake((CGRectGetMaxX(self.sizeLabel.frame) + 8), (CGRectGetMaxY(self.gameNameLabel.frame) + 20), (kSCREEN_WIDTH - CGRectGetMaxX(self.sizeLabel.frame)  - 8), 20);
        _qqGroupLabel.font = [UIFont systemFontOfSize:14];
        _qqGroupLabel.text = @"玩家QQ群";
    }
    return _qqGroupLabel;
}

- (UIButton *)qqGroupBtn {
    if (!_qqGroupBtn) {
        _qqGroupBtn = [[UIButton alloc] init];
        _qqGroupBtn.bounds = CGRectMake(0, 0, 30, 30);
        _qqGroupBtn.center = CGPointMake(self.qqGroupLabel.center.x, 35);
        [_qqGroupBtn setImage:[UIImage imageNamed:@"detail_qqGroup"] forState:(UIControlStateNormal)];
        [_qqGroupBtn addTarget:self action:@selector(clickQQGroupBtn) forControlEvents:(UIControlEventTouchUpInside)];
        
//        _qqGroupBtn.backgroundColor = [UIColor blackColor];
        
    }
    return _qqGroupBtn;
}








@end













