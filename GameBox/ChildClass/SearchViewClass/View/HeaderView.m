//
//  HeaderView.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "HeaderView.h"


@interface HeaderView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons1;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons2;

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {

    
    NSArray *btnTitles = @[@"开服表",@"排行榜",@"礼包",@"攻略"];
    _buttons1 = [NSMutableArray arrayWithCapacity:btnTitles.count];
    
    [btnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        button.frame = CGRectMake((kSCREEN_WIDTH - 240) / 5 + idx * (60 + (kSCREEN_WIDTH - 240) / 5), kSCREEN_HEIGHT * 0.4 - 44, 60, 44);
//        button.center = CGPointMake(kSCREEN_WIDTH / 20 + (idx + 1) * (60 + kSCREEN_WIDTH / 20), kSCREEN_HEIGHT * 0.4 - 22);
        
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:btnTitles[idx] forState:(UIControlStateNormal)];
        
        button.tag = 10086 + idx;
        [_buttons1 addObject:button];

        [self addSubview:button];
        
    }];
    
    
    btnTitles = @[@"推荐",@"新游",@"热门",@"分类"];
    _buttons2 = [NSMutableArray arrayWithCapacity:btnTitles.count];
    
    [btnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        button.frame = CGRectMake(kSCREEN_WIDTH / 4 * idx, 0, kSCREEN_WIDTH / 4, 44);
        //        button.center = CGPointMake(kSCREEN_WIDTH / 20 + (idx + 1) * (60 + kSCREEN_WIDTH / 20), kSCREEN_HEIGHT * 0.4 - 22);
        
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:btnTitles[idx] forState:(UIControlStateNormal)];
        
        button.tag = 20086 + idx;
        [button setBackgroundColor:[self randomColor]];
        
        [_buttons2 addObject:button];
        
        [self addSubview:button];
        
    }];
    
}
#pragma mark - setter
- (void)setImageArray:(NSMutableArray *)imageArray {
//    self.rollingCarouselView.imageArray = imageArray;
}


#pragma mark - getter
//- (RollingCarouselView *)rollingCarouselView {
//    if (!_rollingCarouselView) {
//        _rollingCarouselView = [[RollingCarouselView alloc]initWithFrame:CGRectMake(0, 44, kSCREEN_WIDTH, kSCREEN_HEIGHT / 4) WithImageArray:@[@"1",@"2",@"3",@"4"]];
//        _rollingCarouselView.pageControl.center = CGPointMake(kSCREEN_WIDTH / 2, 22 + kSCREEN_HEIGHT / 4);
//        [self addSubview:_rollingCarouselView.pageControl];
//    }
//    return _rollingCarouselView;
//}


- (UIColor *)randomColor {
    UIColor *color = [UIColor colorWithRed:(arc4random() % 254) / 255.0 green:(arc4random() % 254) / 255.0 blue:(arc4random() % 254) / 255.0 alpha:1];
    return color;
}




@end
