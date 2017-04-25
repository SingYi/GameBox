//
//  GiftBagCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GiftBagCell.h"

@interface GiftBagCell ()



@end

@implementation GiftBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.font = [UIFont systemFontOfSize:16];
    self.packProgress.layer.cornerRadius = 4;
    self.packProgress.layer.masksToBounds = YES;
    [self.packProgress addSubview:self.progressView];
    [self.packProgress addSubview:self.titlelabel];
    [self.getBtn addTarget:self action:@selector(clickGetBtn) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)clickGetBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getGiftBagCellAtIndex:)]) {
        [self.delegate getGiftBagCellAtIndex:_currentIdx];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - label
- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] initWithFrame:self.packProgress.bounds];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.font = [UIFont systemFontOfSize:14];
    }
    return _titlelabel;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor orangeColor];
    }
    return _progressView;
}

@end
