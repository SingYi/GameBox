//
//  RecommentTableHeader.h
//  GameBox
//
//  Created by 石燚 on 2017/4/21.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommentTableHeader;

@protocol  RecommentTableHeaderDeleagte <NSObject>

- (void)RecommentTableHeader:(RecommentTableHeader *)header didSelectImageWithInfo:(NSDictionary *)info;

@end

@interface RecommentTableHeader : UIView

/**轮播视图数组*/
@property (nonatomic, strong) NSMutableArray * rollingArray;

/** delegate */
@property (nonatomic, weak) id<RecommentTableHeaderDeleagte> RecommentTableHeaderDelegate;

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

/**停止定时器*/
- (void)stopTimer;

/**启动定时器*/
- (void)startTimer;

@end
