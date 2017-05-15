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

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIButton *lastBtn;

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
    
    _buttons = [NSMutableArray arrayWithCapacity:btnNameArray.count];
    
    [_btnNameArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(idx * kSCREEN_WIDTH / _btnNameArray.count, 0, kSCREEN_WIDTH / self.btnNameArray.count, 44);
        
        [button setTitle:obj forState:(UIControlStateNormal)];
        
        button.tag = BTNTAG + idx;
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(respondstoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (idx == 0) {
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            _lastBtn = button;
        } else {
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        }
        
        [_buttons addObject:button];
        
        [self addSubview:button];
    }];
    
    [self addSubview:self.line];
    [self addSubview:self.seleView];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if (_lastBtn) {
        [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)
                                           options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;

        self.seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);
        self.seleView.center = CGPointMake(_buttons[index].center.x, 42.5);
        
        
        [_buttons[_index] setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }];
    
    _lastBtn = _buttons[_index];
}

- (void)setLineColor:(UIColor *)lineColor {
    self.line.backgroundColor = lineColor;
}

- (void)reomveLabelWithX:(CGFloat)x {
    
    self.seleView.center = CGPointMake(_buttons[0].center.x + x, 42.5);
}

#pragma mark - getter
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, kSCREEN_WIDTH, 3)];
        _line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _line;
}


- (UIView *)seleView {
    if (!_seleView) {
        _seleView = [[UIView alloc] init];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [_buttons[0].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);
        _seleView.center = CGPointMake(_buttons[0].center.x, 42.5);
        _seleView.backgroundColor = [UIColor orangeColor];
        _seleView.layer.cornerRadius = 1;
        _seleView.layer.masksToBounds = YES;
    }
    return _seleView;
}

#pragma mark - respondstoBtn
- (void)respondstoBtn:(UIButton *)sender {
    if (_isAnimation) {
        
    } else {
        self.index = sender.tag - BTNTAG;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBtnAtIndexPath:)]) {
            [self.delegate didSelectBtnAtIndexPath:sender.tag - BTNTAG];
        }
    }
    
}



@end
