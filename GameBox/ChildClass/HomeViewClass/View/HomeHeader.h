//
//  HomeHeader.h
//  GameBox
//
//  Created by 石燚 on 2017/4/13.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeHeaderDelegate <NSObject>

- (void)didSelectBtnAtIndexPath:(NSInteger)idx;

@end

@interface HomeHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray;

@property (nonatomic, strong) NSArray *btnNameArray;

@property (nonatomic, weak) id<HomeHeaderDelegate> delegate;

/**是否在动画中*/
@property (nonatomic, assign) BOOL isAnimation;

/**移动主视图时下标的位置*/
@property (nonatomic, assign) NSInteger index;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 移动标签 */
- (void)reomveLabelWithX:(CGFloat)x;


@end
