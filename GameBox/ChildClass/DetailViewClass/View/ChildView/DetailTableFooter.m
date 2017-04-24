//
//  DetailTableFooter.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "DetailTableFooter.h"

@interface DetailTableFooter ()

@property (nonatomic, strong) UILabel *titleLabel;




@end

@implementation DetailTableFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.titleLabel];

}

- (void)setLikesArray:(NSArray *)likesArray {
    _likesArray = likesArray;
    
    [_likesArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        button.frame = CGRectMake(idx * kSCREEN_WIDTH / 4, 20, kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4);
        
        [button setTitle:_likesArray[idx][@"gamename"] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:button];
    }];
    
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
        _titleLabel.text = @"    猜你喜欢:";
    }
    return _titleLabel;
}

@end
