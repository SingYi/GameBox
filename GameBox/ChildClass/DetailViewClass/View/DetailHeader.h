//
//  DetailHeader.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeader.h"

@protocol DetailHeaderDelegate <NSObject>

- (void)didselectBtnAtIndex:(NSInteger)index;

@end

@interface DetailHeader : UIView

/**游戏图标*/
@property (nonatomic, strong) UIImageView *imageView;

/**游戏名称标签*/
@property (nonatomic, strong) UILabel *gameNameLabel;

/**下载次数标签*/
@property (nonatomic, strong) UILabel *downLoadNumber;

/**delegate*/
@property (nonatomic, weak) id<DetailHeaderDelegate> detailHeaderDelegate;

/**按钮数组*/
@property (nonatomic, strong) NSArray *btnArray;

/** 选择的下标 */
@property (nonatomic, assign) NSInteger index;

/** 游戏评分 */
@property (nonatomic, assign) CGFloat source;

/** 游戏标签 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *typeLabels;

/** 游戏大小 */
@property (nonatomic, strong) UILabel *sizeLabel;

/**选择标签*/
@property (nonatomic, strong) HomeHeader *selectView;

@end






