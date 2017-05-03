//
//  GiftBagCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GiftBagCell.h"

@interface GiftBagCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout;

@end

@implementation GiftBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.packProgress.layer.cornerRadius = 4;
    self.packProgress.layer.masksToBounds = YES;
    self.packProgress.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    [self.packProgress addSubview:self.progressView];
    [self.packProgress addSubview:self.titlelabel];
    [self.getBtn addTarget:self action:@selector(clickGetBtn) forControlEvents:(UIControlEventTouchUpInside)];
    
    if (kSCREEN_WIDTH == 320) {
        _leftLayout.constant = 8;
        _rightLayout.constant = 8;
        self.name.font = [UIFont systemFontOfSize:13];
    } else if (kSCREEN_WIDTH == 375) {
        _leftLayout.constant = 20;
        _rightLayout.constant = 20;
        self.name.font = [UIFont systemFontOfSize:14];
    } else if (kSCREEN_WIDTH == 414) {
        _leftLayout.constant = 30;
        _rightLayout.constant = 30;
        self.name.font = [UIFont systemFontOfSize:16];
    }
    
    
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

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    //礼包名称
    self.name.text = _dict[@"pack_name"];
    //礼包数量
    self.packCounts.text = _dict[@"pack_counts"];

    NSString *total = _dict[@"pack_counts"];
    NSString *current = _dict[@"pack_used_counts"];
    CGFloat tc = current.floatValue / total.floatValue;
    
    
    NSString *tcStr = [NSString stringWithFormat:@"%.02f%%",(100.f - tc * 100.f)];
    
    self.titlelabel.text = tcStr;
    
    CGRect rect = self.packProgress.bounds;
    
    self.progressView.frame = CGRectMake(0, 0, rect.size.width * tc, rect.size.height);
    
    NSString *str = _dict[@"card"];
//    CLog(@"%@",_dict);
    if ([str isKindOfClass:[NSNull class]]) {
        [self.getBtn setBackgroundImage:[UIImage imageNamed:@"button_circle"] forState:(UIControlStateNormal)];
        [self.getBtn setTitle:@"领取" forState:(UIControlStateNormal)];
        [self.getBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    } else {
        [self.getBtn setBackgroundImage:[UIImage imageNamed:@"downLoadButton"] forState:(UIControlStateNormal)];
        [self.getBtn setTitle:@"复制" forState:(UIControlStateNormal)];
        [self.getBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
}

#pragma mark - label
- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] initWithFrame:self.packProgress.bounds];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.font = [UIFont systemFontOfSize:13];
        _titlelabel.textColor = [UIColor grayColor];
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
