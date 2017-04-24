//
//  HomeHeader.m
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HomeHeader.h"

#define BTNTAG 1400

@interface HomeHeader ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic, strong) UIView *seleView;

@end

@implementation HomeHeader

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnNameArray = btnNameArray;
        _isAnimation = NO;
    }
    return self;
}


- (void)setBtnNameArray:(NSArray *)btnNameArray {
    _btnNameArray = btnNameArray;
    
    [_btnNameArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(idx * kSCREEN_WIDTH / _btnNameArray.count, 0, kSCREEN_WIDTH / self.btnNameArray.count, 30);
        
        [button setTitle:obj forState:(UIControlStateNormal)];
        
        button.tag = BTNTAG + idx;
        
        [button addTarget:self action:@selector(respondstoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [self addSubview:button];
    }];
    [self addSubview:self.seleView];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [UIView animateWithDuration:0.3 animations:^{
        self.seleView.frame = CGRectMake(index * kSCREEN_WIDTH / self.btnNameArray.count, 29, kSCREEN_WIDTH / self.btnNameArray.count, 3);
    }];
}



- (UIView *)seleView {
    if (!_seleView) {
        _seleView = [[UIView alloc] init];
        _seleView.frame = CGRectMake(0, 29, kSCREEN_WIDTH / self.btnNameArray.count, 3);
        _seleView.backgroundColor = [UIColor orangeColor];
    }
    return _seleView;
}

#pragma mark - respondstoBtn
- (void)respondstoBtn:(UIButton *)sender {
    if (_isAnimation) {
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.seleView.frame = CGRectMake((sender.tag - BTNTAG) * kSCREEN_WIDTH / self.btnNameArray.count, 29, kSCREEN_WIDTH / self.btnNameArray.count, 3);
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBtnAtIndexPath:)]) {
            [self.delegate didSelectBtnAtIndexPath:sender.tag - BTNTAG];
        }
    }
    
}



@end
