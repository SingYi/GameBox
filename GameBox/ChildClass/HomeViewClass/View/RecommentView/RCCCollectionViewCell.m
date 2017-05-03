//
//  RCCCollectionViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/5/3.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "RCCCollectionViewCell.h"

@implementation RCCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.titleImage];
    }
    return self;
}



#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 20);
        _titleLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGBCOLOR(17, 17, 17);
        _titleLabel.font = [UIFont systemFontOfSize:13];

    }
    return _titleLabel;
}

- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] init];
        _titleImage.bounds = CGRectMake(0, 0, self.bounds.size.height * 0.6, self.bounds.size.height * 0.6);
        _titleImage.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 10);
    }
    return _titleImage;
}


@end






