//
//  MineCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "MineCell.h"

@interface MineCell ()

@property (nonatomic, strong) UIView *background;

@end

@implementation MineCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.contentView addSubview:self.background];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.titleImageView];
    }
    return self;
}

#pragma mark - getter 
- (UIView *)background {
    if (!_background) {
        _background = [[UIView alloc]initWithFrame:CGRectMake(0.5, 0.5, self.bounds.size.width - 1, self.bounds.size.height - 1)];
        _background.backgroundColor = [UIColor whiteColor];
        [_background addSubview:self.titleLabel];
        [_background addSubview:self.titleImageView];
    }
    return _background;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 20);
        _titleLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + self.bounds.size.height * 0.1 + 15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGBCOLOR(17, 17, 17);
        if (kSCREEN_WIDTH == 320) {
            _titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (kSCREEN_WIDTH == 375) {
            _titleLabel.font = [UIFont systemFontOfSize:15];
        } else if (kSCREEN_WIDTH == 414) {
            _titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    return _titleLabel;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.bounds = CGRectMake(0, 0, self.bounds.size.height * 0.22, self.bounds.size.height * 0.22);
        _titleImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 10);
    }
    return _titleImageView;
}




@end
