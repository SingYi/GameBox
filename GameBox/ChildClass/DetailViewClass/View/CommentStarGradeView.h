//
//  CommentStarGradeView.h
//  GameBox
//
//  Created by 石燚 on 2017/5/17.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentStarGradeDeleagete <NSObject>

- (void)numberOfSorce:(CGFloat)Sorce;

@end

@interface CommentStarGradeView : UIView

@property (nonatomic, weak) id<CommentStarGradeDeleagete> starDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) CGFloat starGrade;

@end
